import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'hospitals.dart';
import 'pharmacies.dart';
import 'contacts.dart';
import 'locations.dart';

void main() {
  runApp(WarGuideApp());
}

class WarGuideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'War Guide App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/hospitals': (context) => HospitalsPage(),
        '/pharmacies': (context) => PharmaciesPage(),
        '/contacts': (context) => ContactsPage(),
        '/locations': (context) => LocationsPage(),
      },
    );
  }
}
