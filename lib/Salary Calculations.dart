import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class SalaryCalculations extends StatefulWidget {
  const SalaryCalculations({super.key});

  @override
  State<SalaryCalculations> createState() => _SalaryCalculationsState();
}

class _SalaryCalculationsState extends State<SalaryCalculations> {
  String selectedRole = 'Silai';
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref().child('orders');
  List<dynamic> orderData = [];
  String statusField = 'silaiStatus';

  DateTime? startDate;
  DateTime? endDate;
  bool _isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      statusField = selectedRole == 'Silai' ? 'silaiStatus' : 'kataiStatus';
    });

    _ordersRef
        .orderByChild(statusField)
        .equalTo('completed')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      setState(() {
        orderData = data != null ? data.values.toList() : [];
      });
    });
  }

  void showSuitsCountDialog() {
    // Initialize counts for each measurement type
    Map<String, int> measurementCounts = {
      'ShalwarQameez': 0,
      'Coat': 0,
      'Waskit': 0,
      'Sherwani': 0,
      'Pants': 0,
    };

    // Calculate suits count for each measurement type where search query matches the name field
    final nameField = selectedRole == 'Silai' ? 'SilaiName' : 'KataiName';
    for (var order in orderData) {
      if (searchQuery.isNotEmpty &&
          order[nameField] != null &&
          order[nameField].toString().toLowerCase().contains(searchQuery.toLowerCase()) &&
          order['measurementType'] != null &&
          order['suitsCount'] != null) {
        String measurementType = order['measurementType'];
        int suitsCount = order['suitsCount'];
        if (measurementCounts.containsKey(measurementType)) {
          measurementCounts[measurementType] = measurementCounts[measurementType]! + suitsCount;
        }
      }
    }

    // Show dialog with counts
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Suits Count for $selectedRole for $searchQuery"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: measurementCounts.entries.map((entry) {
                  return Text("${entry.key}: ${entry.value}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void filterData() {
    if (startDate != null && endDate != null && endDate!.isAfter(startDate!) && endDate!.isBefore(DateTime.now())) {
      setState(() {
        _isLoading = true;
      });
      _ordersRef
          .orderByChild('orderDate')
          .startAt(startDate!.toIso8601String())
          .endAt(endDate!.toIso8601String())
          .onValue
          .listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        setState(() {
          orderData = data != null ? data.values.toList() : [];
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Fetched Successfully')));
        });
      });
      setState(() {
        _isLoading = false;
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date and not after today')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void searchData(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? initialDate, DateTime firstDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    return picked;
  }

  Widget customButton(String label, VoidCallback onPressed) {
    return Card(
      child: InkWell(
        onTap: !_isLoading? onPressed:(){},
        child: Container(
          width: 300.0,
          height: 50.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: !_isLoading? Text(
              label,
              style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            ): CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Calculations', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedRole,
              items: const [
                DropdownMenuItem(value: 'Silai', child: Text('Silai')),
                DropdownMenuItem(value: 'Katai', child: Text('Katai')),
              ],
              onChanged: (newRole) {
                setState(() {
                  selectedRole = newRole!;

                });
                fetchData();
              },
              decoration: const InputDecoration(
                labelText: "Select Role",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    'Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'Not selected'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await _selectDate(context, startDate, DateTime(2000));
                    if (pickedDate != null && (endDate == null || pickedDate.isBefore(endDate!))) {
                      setState(() {
                        startDate = pickedDate;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Start date cannot be after end date')),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    'End Date: ${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'Not selected'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await _selectDate(context, endDate, DateTime(2000));
                    if (pickedDate != null && (startDate == null || pickedDate.isAfter(startDate!))) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('End date cannot be before start date')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          customButton(
            'Filter',
            filterData,
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchData,
              decoration: InputDecoration(
                labelText: 'Search by ${selectedRole} Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if(searchQuery.isNotEmpty)...[
            customButton(
              'Show Suits Count',
              showSuitsCountDialog, // Call the suits count dialog function
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: orderData.length,
              itemBuilder: (context, index) {
                final order = orderData[index];
                final nameField = selectedRole == 'Silai' ? 'SilaiName' : 'KataiName';
                if (order[nameField] != null && !order[nameField].toString().toLowerCase().contains(searchQuery.toLowerCase())) {
                  return Container();
                }
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightBlueAccent.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ID: ${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("$selectedRole Name: ${order[nameField]}", style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                      Text("Suits Type: ${order['measurementType']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Text("Suits Count: ${order['suitsCount']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Text("Status: ${order[statusField]}"),
                      Text("Order Date: ${order['orderDate']}"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
