import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Models/Admin model.dart';

class EmployeeProvider with ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('employees');
  List<EmployeeModel> _employees = [];

  List<EmployeeModel> get employees => _employees;

  // Fetch employees with a specific role
  Future<void> fetchEmployeesWithRole(String role) async {
    try {
      final snapshot = await _dbRef.orderByChild('role').equalTo(role).get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        _employees = []; // Clear previous data

        data.forEach((key, value) {
          _employees.add(EmployeeModel.fromMap(value, ));
        });
        notifyListeners(); // Notify listeners to update UI
      } else {
        _employees = []; // No employees found
        notifyListeners();
      }
    } catch (error) {
      print("Error fetching employees: $error");
      throw error; // Optionally handle errors
    }
  }
}
