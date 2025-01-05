import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String? firstName;
  final String? lastName;

  const HomePage({super.key, this.firstName, this.lastName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red.shade900,
          title: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: const Text(
              'Your Guide Through War.',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 29,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 21.0, right: 5.0),
              child: IconButton(
                icon: const Icon(
                  Icons.info,
                  size: 25,
                  color: Colors.black,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'About the app',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'This app serves as your trusted guide during times of war.\n*Helping you find hospitals and pharmacies near you.\n*Giving you fast access to emergency contacts.\n*Providing safe navigation tools to help you stay informed and protected while traveling.',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Got it',
                            style: TextStyle(fontSize: 22, color: Colors.red.shade900, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Image.asset(
                      'assets/guide.png',
                      fit: BoxFit.fitHeight,
                      width: 50,
                      height: 220,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${widget.firstName} ${widget.lastName}!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Colors.red.shade900,
                        thickness: 4,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Let us guide you with our services and be your companion in crisis.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: const Text(
                  'Find the help you need, \nwhen you need it most:',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    _buildPictureWithButton(context, 'Hospitals', '/hospitals', Icons.local_hospital),
                    SizedBox(height: 16),
                    _buildPictureWithButton(context, 'Pharmacies', '/pharmacies', Icons.local_pharmacy),
                    SizedBox(height: 16),
                    _buildPictureWithButton(context, 'Emergency Contacts', '/contacts', Icons.contact_phone),
                    SizedBox(height: 16),
                    _buildPictureWithButton(context, 'Locations', '/locations', Icons.map),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPictureWithButton(BuildContext context, String title, String route, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.red.shade900,
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, route),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              minimumSize: Size(220, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
