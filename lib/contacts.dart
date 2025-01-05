import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Map<String, Map<String, List<Map<String, String>>>> categorizedContacts = {};
  String searchQuery = '';

  Future<void> fetchContacts() async {
    final response = await http.get(Uri.parse('http://localhost/warguideapp/get_contacts.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final Map<String, Map<String, List<Map<String, String>>>> formattedContacts = {};

      data.forEach((category, contacts) {
        formattedContacts[category] = {};

        contacts.forEach((contact) {
          final String contactName = contact['name'];
          final String contactPhone = contact['phone'];
          final String contactAvailability = contact['availability'];

          if (!formattedContacts[category]!.containsKey(contactName)) {
            formattedContacts[category]![contactName] = [];
          }

          formattedContacts[category]![contactName]!.add({
            'phone': contactPhone,
            'availability': contactAvailability
          });
        });
      });

      setState(() {
        categorizedContacts = formattedContacts;
      });
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContacts();
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
              'Emergency Contacts!',
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
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.0, left: 20, right: 20, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'In case of injury, stay calm and call for help!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.warning,
                  size: 100.0,
                  color: Colors.red.shade900,
                ),
                Text(
                  '!!',
                  style: TextStyle(
                    fontSize: 100.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1.3,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Availability',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
                hintText: 'Enter 24/7 or 12/7',
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
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          ...categorizedContacts.entries.map((category) {
            return ExpansionTile(
              title: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  category.key,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              children: category.value.entries.map((subcategory) {
                final filteredContacts = subcategory.value.where((contact) {
                  final contactAvailability = contact['availability']?.toLowerCase() ?? '';
                  return contactAvailability.contains(searchQuery);
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredContacts.map((contact) {
                    final contactName = subcategory.key;
                    final contactPhone = contact['phone'];
                    final contactAvailability = contact['availability'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$contactName:",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "$contactPhone",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "$contactAvailability",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }
}
