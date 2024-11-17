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

class SilaiOrders extends StatefulWidget {
  const SilaiOrders({super.key});

  @override
  State<SilaiOrders> createState() => _SilaiOrdersState();
}

class _SilaiOrdersState extends State<SilaiOrders> {
  String searchQuery = ''; // Variable to hold the search query

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Silai Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query on text change
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by Serial Number or Mobile No or Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: orderProvider.silaiOrders(uid!), // Fetch orders
              builder: (context, snapshot) {
                // Handle loading state
                if (snapshot.connectionState == ConnectionState.active) {
                  return Center(child: CircularProgressIndicator());
                }

                // Handle errors if any
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 18)));
                }

                // If there are no orders
                if (orderProvider.orders.isEmpty) {
                  return Center(child: Text('No orders found.', style: TextStyle(fontSize: 18)));
                }

                // Filter orders based on the search query
                final filteredOrders = orderProvider.orders.where((order) {
                  return order.serial.toLowerCase().contains(searchQuery.toLowerCase())||order.custPhone.toLowerCase().contains(searchQuery)||order.invoiceNumber.toString().contains(searchQuery)||order.custName.toLowerCase().contains(searchQuery);
                }).toList();

                // If no orders match the search query
                if (filteredOrders.isEmpty) {
                  return Center(child: Text('No matching orders found.', style: TextStyle(fontSize: 18)));
                }

                // Display filtered orders
                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return _buildOrderCard(order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
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
            Text('Serial: ${order.serial}', style: TextStyle(fontSize: 16)),
            Text('Invoice Number: ${order.invoiceNumber}', style: TextStyle(fontSize: 16)),
            Text('customer Name: ${order.custName}', style: TextStyle(fontSize: 16)),
            Text('customer Mobile no: ${order.custPhone}', style: TextStyle(fontSize: 16)),
            Text('Suits Count: ${order.suitsCount}', style: TextStyle(fontSize: 16)),
            Text('Total Payment: ${order.paymentAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            Text('Advance Payment: ${order.advanceAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            Text('Remaining Payment: ${order.remainingPayment}', style: TextStyle(fontSize: 16)),
            Text('Order Date: ${order.orderDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16)),
            Text('Completion Date: ${order.completionDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                    String? uid = FirebaseAuth.instance.currentUser?.uid;

                    // Update order status
                    await orderProvider.silaiStatusUpdate(order.id, uid!).then((_) {
                      // Show a message or perform another action after the status is updated
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Order status updated to completed.')),
                      );
                    });
                  },
                  child: Text('silai Completed', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
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
