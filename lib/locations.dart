import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationsPage extends StatefulWidget {
  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  List<String> locations = [];
  String? startLocation;
  String? endLocation;

  String? distance;
  String? time;
  String? safetyLevel;

  Map<String, Map<String, Map<String, String>>> routeData = {};

  Future<void> _fetchLocations() async {
    final response = await http.get(Uri.parse('http://localhost/warguideapp/get_locations.php'));

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);

        if (data['locations'] is List) {
          setState(() {
            locations = List<String>.from(data['locations']);
          });
        }

        if (data['routes'] is Map<String, dynamic>) {
          Map<String, Map<String, Map<String, String>>> tempRoutes = {};
          data['routes'].forEach((key, value) {
            Map<String, Map<String, String>> tempValue = {};
            value.forEach((k, v) {
              Map<String, String> tempInnerValue = {};
              v.forEach((kk, vv) {
                tempInnerValue[kk] = vv;
              });
              tempValue[k] = tempInnerValue;
            });
            tempRoutes[key] = tempValue;
          });

          setState(() {
            routeData = tempRoutes;
          });
        }
      } catch (e) {
        print("Error parsing data: $e");
      }
    } else {
      print('Failed to load locations and route data');
    }
  }

  void _calculateRoute() {
    if (startLocation != null && endLocation != null && startLocation != endLocation) {
      final data = routeData[startLocation!]?[endLocation!];
      if (data != null) {
        setState(() {
          distance = data['distance'] ?? "N/A";
          time = data['time'] ?? "N/A";
          safetyLevel = data['safety'] ?? "N/A";
        });
      } else {
        setState(() {
          distance = "N/A";
          time = "N/A";
          safetyLevel = "N/A";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
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
              'Navigate Locations',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red.shade900),
                        const SizedBox(width: 8),
                        Text(
                          'Danger Zones',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...['Dahye            Nabatieh', 'Bekaa            Tripoli', 'Saida             South border']
                        .map((zone) => Text(
                      zone,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade900),
                        const SizedBox(width: 8),
                        Text(
                          'Safe Zones',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...['Beirut             Aley', 'Byblos            Batroun', 'Jounieh          Broumana']
                        .map((zone) => Text(
                      zone,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20),
                child: SizedBox(
                  width: 330,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Start Location',
                      labelStyle: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    items: locations
                        .map((location) => DropdownMenuItem(
                      value: location,
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                        .toList(),
                    value: startLocation,
                    onChanged: (value) {
                      setState(() {
                        startLocation = value;
                      });
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 20, left: 20),
                child: SizedBox(
                  width: 330,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Destination Location',
                      labelStyle: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    items: locations
                        .map((location) => DropdownMenuItem(
                      value: location,
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                        .toList(),
                    value: endLocation,
                    onChanged: (value) {
                      setState(() {
                        endLocation = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _calculateRoute,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 60),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    'Calculate Route',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              if (distance != null && time != null && safetyLevel != null)
                Center(
                  child: Card(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Distance: $distance',
                              style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
                          Text('Time: $time',
                              style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
                          Text('Safety Level: $safetyLevel',
                              style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
