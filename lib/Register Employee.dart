import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'Models/Admin model.dart';

class RegisterEmployeePage extends StatefulWidget {
  const RegisterEmployeePage({super.key});

  @override
  State<RegisterEmployeePage> createState() => _RegisterEmployeePageState();
}

class _RegisterEmployeePageState extends State<RegisterEmployeePage> {
  final nc = TextEditingController();
  final ec = TextEditingController();
  final phonec = TextEditingController();
  final pass = TextEditingController();
  final DatabaseReference dref = FirebaseDatabase.instance.ref();

  bool isRegistering = false;
  String selectedRole = '1'; // Default role to 'Silai'

  void registerEmployee() async {
    setState(() {
      isRegistering = true;
    });
    try {
      final DatabaseReference employeeRef = dref.child('employee');
      String uid = employeeRef.push().key!;

      EmployeeModel employeeModel = EmployeeModel(
        employeeId: uid,
        name: nc.text.trim(),
        email: ec.text.trim(),
        phone: phonec.text.trim(),
        role: selectedRole,
      );

      await employeeRef.child(uid).set(employeeModel.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee registered successfully")),
      );

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    } finally {
      setState(() {
        isRegistering = false;
      });
    }
  }

  String? validatePhoneNumber(String? value) {
    final RegExp phonePattern = RegExp(r'^(03[0-9]{9}|(\+92)[0-9]{10})$');
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!phonePattern.hasMatch(value)) {
      return 'Please enter a valid phone number (03XXXXXXXXX or +92XXXXXXXXXX)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset("assets/images/logo.png"),
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nc,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Name",
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: ec,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Email Address",
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phonec,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Phone No",
                          labelText: "Phone No",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        validator: validatePhoneNumber,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedRole,
                        items: [
                          DropdownMenuItem(value: '1', child: Text('Silai')),
                          DropdownMenuItem(value: '2', child: Text('Katai')),
                        ],
                        onChanged: (newRole) {
                          setState(() {
                            selectedRole = newRole!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Select Role",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: InkWell(
                        onTap: isRegistering ? null : registerEmployee,
                        child: Container(
                          width: 200.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.blueAccent,
                              Colors.greenAccent
                            ]),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              isRegistering ? "Registering..." : "Register",
                              style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
