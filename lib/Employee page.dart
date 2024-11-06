import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayEmployeesPage extends StatefulWidget {
  const DisplayEmployeesPage({Key? key}) : super(key: key);

  @override
  State<DisplayEmployeesPage> createState() => _DisplayEmployeesPageState();
}

class _DisplayEmployeesPageState extends State<DisplayEmployeesPage> {
  final DatabaseReference dref = FirebaseDatabase.instance.ref().child('employee');
  List<Map<dynamic, dynamic>> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      DatabaseEvent event = await dref.once();
      Map<dynamic, dynamic>? employeeData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (employeeData != null) {
        employees = employeeData.values.cast<Map<dynamic, dynamic>>().toList();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching employees: $error")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      await dref.child(employeeId).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee deleted successfully")),
      );
      fetchEmployees(); // Refresh list after deletion
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting employee: $error")),
      );
    }
  }

  void showConfirmationDialog(String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Employee"),
        content: const Text("Are you sure you want to delete this employee?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteEmployee(employeeId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Sabir Tailor", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'lora', color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : employees.isEmpty
          ? const Center(child: Text("No employees found"))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          final employeeId = employee['employeeId'] ?? '';

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.lightBlueAccent.shade700),
                      const SizedBox(width: 8),
                      Text(
                        employee['name'] ?? 'No Name',
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // color: Colors.lightBlueAccent.shade700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showConfirmationDialog(employeeId),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.lightBlueAccent.shade700),
                      const SizedBox(width: 8),
                      Text(
                        "Email: ${employee['email'] ?? 'No Email'}",
                        style: TextStyle(fontSize: 16, ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.lightBlueAccent.shade700),
                      const SizedBox(width: 8),
                      Text(
                        "Phone: ${employee['phone'] ?? 'No Phone'}",
                        style: TextStyle(fontSize: 16, ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.badge, color: Colors.lightBlueAccent.shade700),
                      const SizedBox(width: 8),
                      Text(
                        "Role: ${employee['role'] == '1' ? 'Silai' : 'Katai'}",
                        style: TextStyle(fontSize: 16, ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
