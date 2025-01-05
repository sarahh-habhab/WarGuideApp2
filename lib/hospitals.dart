import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  _HospitalsPageState createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  List<Map<String, dynamic>> _hospitals = [];
  String? selectedLocation;
  Map<String, dynamic>? selectedHospital;
  String safetyLevelSearch = '';

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  Future<void> _fetchHospitals() async {
    final url = 'http://localhost/warguideapp/get_hospitals.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> hospitalsData = json.decode(response.body);

      setState(() {
        _hospitals = hospitalsData.map((hospital) => hospital as Map<String, dynamic>).toList();
      });
    } else {
      print("Failed to load hospitals");
    }
  }

  List<String> _getLocations() {
    return _hospitals.map((hospital) => hospital['location'].toString()).toSet().toList();
  }

  List<Map<String, dynamic>> _getHospitalsForLocation(String? location) {
    return _hospitals.where((hospital) => hospital['location'] == location).toList();
  }

  List<Map<String, dynamic>> _getFilteredHospitals() {
    if (safetyLevelSearch.isEmpty) {
      return _hospitals;
    } else {
      return _hospitals.where((hospital) {
        String safetyLevel = hospital['safetyLevel']?.toString() ?? '';
        if (safetyLevelSearch == 'High') {
          return safetyLevel == 'High';
        } else if (safetyLevelSearch == 'Moderate') {
          return safetyLevel == 'Moderate';
        } else if (safetyLevelSearch == 'Low') {
          return safetyLevel == 'Low';
        } else {
          return false;
        }
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red.shade900,
          title: const Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Text(
              'Hospitals in your area',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 40, right: 30, top: 10),
              child: Center(
                child: Text(
                  '\nCheck safety level of the hospital\'s route before heading there!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Image.asset(
                  'assets/hospital.png',
                  fit: BoxFit.fitWidth,
                  width: 400,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: const SizedBox(height: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search by Safety Level',
                  labelStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  hintText: 'High-Moderate-Low',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade600,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red.shade900,
                      width: 4.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
                onChanged: (value) {
                  setState(() {
                    safetyLevelSearch = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
              child: DropdownButton<String>(
                value: selectedLocation,
                hint: const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                isExpanded: true,
                items: _getLocations().map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(
                      location,
                      style: const TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                    selectedHospital = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            if (selectedLocation != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: DropdownButton<Map<String, dynamic>>(
                  value: selectedHospital,
                  hint: const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Select Hospital',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  items: _getFilteredHospitals().where((hospital) {
                    return hospital['location'] == selectedLocation;
                  }).map((hospital) {
                    return DropdownMenuItem(
                      value: hospital,
                      child: Text(
                        hospital['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedHospital = value;
                    });
                  },
                ),
              ),
            if (selectedHospital != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedHospital!['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Street: ${selectedHospital!['street']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Phone: ${selectedHospital!['phone']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Safety Level: ${selectedHospital!['safetyLevel']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Rating: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (selectedHospital!['review'] != null) ...[
                              for (int i = 0; i < double.tryParse(selectedHospital!['review'].toString())!.floor(); i++)
                                const Icon(Icons.star, color: Colors.amber, size: 30),
                              if (double.tryParse(selectedHospital!['review'].toString())! % 1 != 0)
                                const Icon(Icons.star_half, color: Colors.amber, size: 30),
                            ] else
                              const Text(
                                'No rating available',
                                style: TextStyle(fontSize: 20),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
