import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sabir_tailors/Login.dart';
import 'package:sabir_tailors/providers/EmployeeProvider.dart';
import 'package:sabir_tailors/providers/MeasurementProvider.dart';
import 'package:sabir_tailors/providers/OrderProvider.dart';
import 'package:sabir_tailors/providers/admin%20provider.dart';
import 'package:sabir_tailors/providers/loginProvider.dart';

import 'firebase_options.dart';
import 'Dashboard.dart'; // Import the Dashboard page
import 'KataiPages/kataiDashboard.dart'; // Import the Katai Dashboard page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => Measurementprovider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthStateHandler(),  // Use AuthStateHandler to manage navigation
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),  // Listen to the auth state
      builder: (context, snapshot) {
        // Check if the connection is established and the user is authenticated
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data; // Get the current user

          // If the user is logged in, check their role
          if (user != null) {
            // Check user role from both nodes in the LoginProvider
            Provider.of<LoginProvider>(context, listen: false).checkUserRoleAndNavigate(user.uid, context);
            return const Center(child: CircularProgressIndicator()); // Show loading while checking role
          } else {
            // If the user is not logged in, navigate to the login page
            return const LoginPage();
          }
        }

        // While checking the authentication state, show a loading indicator
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}