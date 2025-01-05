import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({super.key});

  @override
  _PharmaciesPageState createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  Map<String, List<dynamic>> locationToPharmaciesMap = {};

  @override
  void initState() {
    super.initState();
    fetchPharmacies();
  }

  Future<void> fetchPharmacies() async {
    final response = await http.get(Uri.parse('http://localhost/warguideapp/get_pharmacies.php'));

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);

        if (data['pharmacies'] != null) {
          locationToPharmaciesMap.clear();

          (data['pharmacies'] as Map<String, dynamic>).forEach((city, pharmaciesList) {
            locationToPharmaciesMap[city] = [];

            for (var pharmacy in pharmaciesList) {
              final name = pharmacy['name'] ?? 'Unnamed Pharmacy';
              final street = pharmacy['street'] ?? 'Unknown street';
              final phone = pharmacy['phone'] ?? 'No phone available';
              final safetyLevel = pharmacy['safety_level'] ?? 'Not rated';
              final openingHours = pharmacy['opening_hours'] ?? 'Unknown hours';
              final rating = pharmacy['rating'] ?? 'No rating';

              locationToPharmaciesMap[city]!.add({
                'name': name,
                'street': street,
                'phone': phone,
                'safety_level': safetyLevel,
                'opening_hours': openingHours,
                'rating': rating,
              });
            }
          });
        }
      });
    } else {
      throw Exception('Failed to load pharmacies');
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
              'Pharmacies Near You',
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
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'Quickly locate pharmacies in your area for immediate medical needs.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      'assets/aid.png',
                      fit: BoxFit.fitHeight,
                      width: 180,
                      height: 180,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 350,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Divider(
                  color: Colors.red.shade900,
                  thickness: 6,
                ),
              ),
            ),
            locationToPharmaciesMap.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: locationToPharmaciesMap.entries.map((entry) {
                return ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  children: entry.value.map<Widget>((pharmacy) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      child: ListTile(
                        title: Text(
                          pharmacy['name'],
                          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Street: ${pharmacy['street']}',
                              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Phone: ${pharmacy['phone']}',
                              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Safety Level: ${pharmacy['safety_level']}',
                              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Hours: ${pharmacy['opening_hours']}',
                              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rating: ${pharmacy['rating']} ⭐',
                              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.local_pharmacy, color: Colors.red.shade900),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
