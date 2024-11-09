// lib/providers/order_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/Admin model.dart';
import '../Models/OrderModel.dart';
import '../Models/kataiorderscompleted.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<EmployeeModel> _employees = [];
  List<kataiOrder> _completedOrders = []; // List to hold completed orders
  List<silaiOrder> _completedOrders1 = [];
  List<kataiOrder> get completedOrders => _completedOrders;
  List<silaiOrder> get completedOrders1 => _completedOrders1;
  bool _isLoading =false;

  bool get isLoading => _isLoading;
  List<Order> get orders => _orders;
  List<EmployeeModel> get employees => _employees;

  Future<void> fetchOrders() async {
    final DatabaseReference orderRef = FirebaseDatabase.instance.ref('orders');
    DataSnapshot snapshot = await orderRef.get();

    if (snapshot.exists) {
      _orders = [];
      snapshot.children.forEach((child) {
        final map = child.value as Map<dynamic, dynamic>;
        if (map.containsKey('kataiId') || map.containsKey('silaiId')) {
          // Skip if it's a katai or silai order
        } else {
          final order = Order.fromMap(child.value as Map<dynamic, dynamic>);
          _orders.add(order);
        }
      });
      notifyListeners(); // Notify listeners after fetching orders
    }
  }
  Future<void> fetchEmployeesforSilai() async {
    final employeeRef = FirebaseDatabase.instance.ref('employee');
    final snapshot = await employeeRef.orderByChild('role').equalTo('1').get();
    if (snapshot.exists) {
      _employees.clear();
      snapshot.children.forEach((element) {
        final employee = EmployeeModel.fromMap(element.value as Map<dynamic, dynamic>);
        _employees.add(employee);
      });
      notifyListeners(); // Notify listeners after fetching employees
    }
  }

  Future<void> fetchEmployeesforKatai() async {
    final employeeRef = FirebaseDatabase.instance.ref('employee');
    final snapshot = await employeeRef.orderByChild('role').equalTo('2').get();
    if (snapshot.exists) {
      _employees.clear();
      snapshot.children.forEach((element) {
        final employee = EmployeeModel.fromMap(element.value as Map<dynamic, dynamic>);
        _employees.add(employee);
      });
      notifyListeners(); // Notify listeners after fetching employees
    }
  }

  Future<void> kataiOrders(String uid) async {
    final DatabaseReference orderRef = FirebaseDatabase.instance.ref('orders');
    final snapshot = await orderRef.get();

    if (snapshot.exists) {
      _orders.clear();
      snapshot.children.forEach((child) {
        // Convert the snapshot child to a map
        final map = child.value as Map<dynamic, dynamic>;

        // Check if the kataiStatus is "pending"
        if (map['kataiStatus'] == 'pending') {
          final order = Order.fromMap(map);
          _orders.add(order);
        }
      });
      notifyListeners(); // Notify listeners after fetching katai orders
    }
  }
  Future<void> silaiOrders(String uid) async {
    final DatabaseReference orderRef = FirebaseDatabase.instance.ref('orders');
    final snapshot = await orderRef.get();

    if (snapshot.exists) {
      _orders.clear();
      snapshot.children.forEach((child) {
        // Convert the snapshot child to a map
        final map = child.value as Map<dynamic, dynamic>;

        // Check if the kataiStatus is "pending"
        if (map['silaiStatus'] == 'pending') {
          final order = Order.fromMap(map);
          _orders.add(order);
        }
      });
      notifyListeners(); // Notify listeners after fetching katai orders
    }
  }

  Future<void> KataiCompletedOrders() async {
    final DatabaseReference orderRef = FirebaseDatabase.instance.ref('orders');
    final DatabaseReference employeeRef = FirebaseDatabase.instance.ref('employee');

    // Fetch completed orders
    DataSnapshot snapshot = await orderRef.orderByChild('kataiStatus').equalTo('completed').get();

    if (snapshot.exists) {
      _isLoading= true;
      notifyListeners();
      _completedOrders.clear(); // Clear existing orders
      for (var child in snapshot.children) {
        final map = child.value as Map<dynamic, dynamic>;

        // Check if the order is a katai order
        if (map.containsKey('silaiId')) {
          continue; // Skip silai orders
        }

        // Create the order object
        final order = kataiOrder.fromMap(map);

        // Fetch employee details using employeeId
        if (order.employeeId != null) {
          DataSnapshot employeeSnapshot = await employeeRef.child(order.employeeId!).get();
          if (employeeSnapshot.exists) {
            final employeeData = employeeSnapshot.value as Map<dynamic, dynamic>;
            order.employeeName = employeeData['name']; // Assuming 'name' is the field in employee data
            // You can add more employee data as needed
          }
        }

        _completedOrders.add(order); // Add the order to the list
      }
      notifyListeners(); // Notify listeners after fetching completed orders
    }
    _isLoading=false;
    notifyListeners();
  }
  Future<void> SilaiCompletedOrders() async {
    _isLoading = true; // Set loading to true at the beginning
    notifyListeners(); // Notify listeners that loading has started

    try {
      final DatabaseReference orderRef = FirebaseDatabase.instance.ref('orders');
      final DatabaseReference employeeRef = FirebaseDatabase.instance.ref('employee');

      // Fetch completed orders
      DataSnapshot snapshot = await orderRef.orderByChild('silaiStatus').equalTo('completed').get();

      if (snapshot.exists) {
        _completedOrders1.clear(); // Clear existing orders
        for (var child in snapshot.children) {
          final map = child.value as Map<dynamic, dynamic>;

          // Create the order object
          final order = silaiOrder.fromMap(map);

          // Fetch employee details using employeeId
          if (order.employeeId != null) {
            DataSnapshot employeeSnapshot = await employeeRef.child(order.employeeId!).get();
            if (employeeSnapshot.exists) {
              final employeeData = employeeSnapshot.value as Map<dynamic, dynamic>;
              order.employeeName = employeeData['name'];
            }
          }

          print(order);
          _completedOrders1.add(order);
        }
      }
    } catch (error) {
      print("Error fetching completed orders: $error");
    } finally {
      _isLoading = false; // Always set loading to false in the end
      notifyListeners();
    }
  }


  Future<void> updateOrderStatus(String orderId, String employeeId, String Employeename) {
    // Update logic here, for example:
    return FirebaseDatabase.instance.ref('orders/$orderId').update({
      'kataiId': employeeId,
      'kataiStatus': 'pending',
      'KataiName':Employeename
    });
  }
  Future<void> updateOrderStatusforSilai(String orderId, String employeeId, String name) async {
    // Update logic here, for example:
     FirebaseDatabase.instance.ref('orders/$orderId').update({
      'silaiId': employeeId,
      'silaiStatus': 'pending',
       'SilaiName': name
    });
    KataiCompletedOrders();
  }

  Future<void> kataiStatusUpdate(String orderId, String uid) async {
    await FirebaseDatabase.instance.ref('orders/$orderId').update({
      'kataiStatus': 'completed'
    });
    await kataiOrders(uid); // Fetch updated orders
    // No need to call notifyListeners() here since kataiOrders already does
  }
  Future<void> silaiStatusUpdate(String orderId, String uid) async {
    await FirebaseDatabase.instance.ref('orders/$orderId').update({
      'silaiStatus': 'completed'
    });
    await silaiOrders(uid); // Fetch updated orders
    // No need to call notifyListeners() here since kataiOrders already does
  }
}
