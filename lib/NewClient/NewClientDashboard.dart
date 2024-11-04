import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sabir_tailors/NewClient/pants.dart';
import 'package:sabir_tailors/NewClient/sherwani.dart';

import '../Login.dart';
import 'Coat.dart';
import 'ShalwarQamiz.dart';
import 'Waskit.dart';

class NewClientDashboard extends StatefulWidget {
  const NewClientDashboard({super.key});

  @override
  State<NewClientDashboard> createState() => _NewClientDashboardState();
}

class _NewClientDashboardState extends State<NewClientDashboard> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Widget _buildGridView(double screenWidth) {
    int crossAxisCount;

    // Determine the number of columns based on screen width
    if (screenWidth < 600) {
      crossAxisCount = 2; // Mobile screens
    } else if (screenWidth < 1200) {
      crossAxisCount = 3; // Tablet screens
    } else {
      crossAxisCount = 5; // Large screens (laptops, desktops)
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20.0,
      mainAxisSpacing: 20.0,
      padding: const EdgeInsets.all(16.0),
      // Add padding if necessary
      children: [
        DashboardItem(
          icon: Icons.local_mall,
          label: 'Shalwar Qameez',
          onButtonPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ShalwarQameezMeasurementForm();
              },
            ));
            // Add navigation logic for Shalwar Qameez
          },
        ),
        DashboardItem(
          icon: Icons.checkroom,
          label: 'Coat',
          onButtonPressed: () {
            Navigator.push(context,  MaterialPageRoute(builder: (context) {
              return CoatMeasurementForm();
            },));
            // Add navigation logic for Coat
          },
        ),
        DashboardItem(
          icon: Icons.boy,
          label: 'Waskit',
          onButtonPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WaskitMeasurementForm();
            },));
            // Add navigation logic for Waskit
          },
        ),
        DashboardItem(
          icon: Icons.accessibility,
          label: 'Paint',
          onButtonPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PantsMeasurementForm();
            },));
            // Add navigation logic for Paint
          },
        ),
        DashboardItem(
          icon: Icons.event,
          label: 'Sherwani',
          onButtonPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SherwaniMeasurementForm();
            },));
            // Add navigation logic for Sherwani
          },
        ),
        // Add more dashboard items as needed
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 400 ? 18 : 24;

    return Scaffold(
      appBar: AppBar(
        title: Text("New Client Dashboard", style: GoogleFonts.lora()),
        titleTextStyle: TextStyle(
          fontSize: titleFontSize as double, // Responsive font size for title
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: _buildGridView(screenWidth), // Grid view without drawer
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logout();
        },
        child: const Icon(Icons.logout, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onButtonPressed;

  const DashboardItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.teal,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.black87,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
