import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/Admin model.dart';
import '../Models/OrderModel.dart';
import '../existingclients/ShowClientInfoInCurrentMeasurement/CoatMeasurementShowPage.dart';
import '../existingclients/ShowClientInfoInCurrentMeasurement/PantMeasurementShowPage.dart';
import '../existingclients/ShowClientInfoInCurrentMeasurement/ShalwarQameezMeasurementShowPage.dart';
import '../existingclients/ShowClientInfoInCurrentMeasurement/SherwaniMeasurementShowPage.dart';
import '../existingclients/ShowClientInfoInCurrentMeasurement/WaskitMeasurementShowPage.dart';
import '../providers/MeasurementProvider.dart';
import '../providers/OrderProvider.dart';
import 'Models/kataiorderscompleted.dart';

class SilaiCompletedOrders extends StatefulWidget {
  const SilaiCompletedOrders({super.key});

  @override
  State<SilaiCompletedOrders> createState() => _SilaiCompletedOrdersState();
}

class _SilaiCompletedOrdersState extends State<SilaiCompletedOrders> {
  EmployeeModel? selectedEmployee;
  TextEditingController searchController = TextEditingController(); // Added search controller
  List<silaiOrder> filteredOrders = []; // List to hold filtered orders

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.SilaiCompletedOrders(); // Fetch orders initially
    filteredOrders = orderProvider.completedOrders1; // Initialize filtered orders with all orders
    searchController.addListener(_filterOrders); // Listen for changes in the search field
  }

  void _filterOrders() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    String query = searchController.text;

    // Filter orders based on either the serial number or invoice number
    if (query.isNotEmpty) {
      setState(() {
        filteredOrders = orderProvider.completedOrders1.where((order) {
          return order.serial.contains(query) ||
              order.invoiceNumber.toString().contains(query);
        }).toList();
      });
    } else {
      setState(() {
        filteredOrders = orderProvider.completedOrders1; // Reset to all orders
      });
    }
  }


  @override
  void dispose() {
    searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Silai Completed Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column( // Use Column to layout search field and ListView
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by Serial Number',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded( // Make sure the ListView takes the remaining space
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                // Handle loading state
                if (orderProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                // Handle errors if any
                if (filteredOrders.isEmpty) {
                  return Center(child: Text('No orders found.', style: TextStyle(fontSize: 18)));
                }

                // Display orders
                return ListView.builder(
                  itemCount: filteredOrders.length, // Use filteredOrders for the count
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index]; // Use filteredOrders for the order
                    return _buildOrderCard(order, orderProvider.employees);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget method to build individual order card (remains unchanged)
  Widget _buildOrderCard(silaiOrder order, List<EmployeeModel> employeesforSilai) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.measurementType,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text('Invoice No: ${order.invoiceNumber}', style: TextStyle(fontSize: 16)),
            Text('Serial: ${order.serial}', style: TextStyle(fontSize: 16)),
            Text('Suits Count: ${order.suitsCount}', style: TextStyle(fontSize: 16)),
            Text('Payment: \$${order.paymentAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            Text('Order Date: ${order.orderDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16)),
            Text('Completion Date: ${order.completionDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16)),
            if (order.employeeName != null)
              Text('Employee: ${order.employeeName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Logic for updating order status
                  },
                  child: Text('Completed', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async {
                    final measurementProvider = Provider.of<Measurementprovider>(context, listen: false);
                    measurementProvider.FetchMeausurements(order.measurementType);
                    if (order.measurementType == 'ShalwarQameez') {
                      await measurementProvider.FetchMeausurements('ShalwarQameez');
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShalwarQameezMeasurementPage(serialNo: order.serial.toString())),
                      );
                    } else if (order.measurementType == 'Coat') {
                      await measurementProvider.FetchMeausurements('Coat');
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CoatMeasurementPage(serialNo: order.serial.toString())),
                      );
                    } else if (order.measurementType == 'Pants') {
                      await measurementProvider.FetchMeausurements('Pants');
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantMeasurementShowPage(serialNo: order.serial.toString())),
                      );
                    } else if (order.measurementType == 'Sherwani') {
                      await measurementProvider.FetchMeausurements('Sherwani');
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SherwaniMeasurementShowPage(serialNo: order.serial.toString())),
                      );
                    } else if (order.measurementType == 'Waskit') {
                      await measurementProvider.FetchMeausurements('Waskit');
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WaskitMeasurementPage(serialNo: order.serial.toString())),
                      );
                    }
                  },
                  child: Text('Show Measurements', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
