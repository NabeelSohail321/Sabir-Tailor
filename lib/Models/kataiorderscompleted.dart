// lib/Models/OrderModel.dart

class kataiOrder {
  final String id; // Unique identifier for the order
  final String measurementType; // Type of measurement for the order
  final String serial; // Serial number of the order
  final int suitsCount; // Number of suits in the order
  final double paymentAmount; // Payment amount for the order
  final DateTime orderDate; // Date when the order was placed
  final DateTime completionDate; // Date when the order was completed
  final String invoiceNumber;
  String? employeeName; // Name of the employee handling the order
  String? employeeId; // ID of the employee handling the order
  // Add any additional fields you need here

  // Constructor
  kataiOrder({
    required this.id,
    required this.measurementType,
    required this.serial,
    required this.suitsCount,
    required this.paymentAmount,
    required this.orderDate,
    required this.completionDate,
    required this.invoiceNumber,
    this.employeeName,
    this.employeeId,
  });

  // Factory method to create an Order from a Map (e.g., from Firebase)
  factory kataiOrder.fromMap(Map<dynamic, dynamic> map) {
    return kataiOrder(
      id: map['id'] ?? '', // Replace with the actual key in your database
      measurementType: map['measurementType'] ?? '',
      serial: map['serial'] ?? '',
      suitsCount: map['suitsCount'] ?? 0,
      paymentAmount: map['paymentAmount']?.toDouble() ?? 0.0,
      orderDate: DateTime.parse(map['orderDate']),
      completionDate: DateTime.parse(map['completionDate']),
      employeeName: map['employeeName'], // Optional field
      employeeId: map['kataiId'], // Optional field
      invoiceNumber: map['invoiceNumber'].toString() ?? ''
    );
  }

  // Method to convert the Order object back to a Map for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'measurementType': measurementType,
      'serial': serial,
      'suitsCount': suitsCount,
      'paymentAmount': paymentAmount,
      'orderDate': orderDate.toIso8601String(),
      'completionDate': completionDate.toIso8601String(),
      'employeeName': employeeName,
      'employeeId': employeeId,
      'invoiceNumber':invoiceNumber
    };
  }
}


// lib/Models/OrderModel.dart

// lib/Models/OrderModel.dart

class silaiOrder {
  final String id;
  final String measurementType;
  final String serial;
  final int suitsCount;
  final double paymentAmount;
  final DateTime orderDate;
  final DateTime completionDate;
  final String invoiceNumber; // Add invoiceNumber field
  String? employeeName;
  String? employeeId;

  silaiOrder({
    required this.id,
    required this.measurementType,
    required this.serial,
    required this.suitsCount,
    required this.paymentAmount,
    required this.orderDate,
    required this.completionDate,
    required this.invoiceNumber, // Include invoiceNumber in the constructor
    this.employeeName,
    this.employeeId,
  });

  factory silaiOrder.fromMap(Map<dynamic, dynamic> map) {
    print('Invoice Number: ${map['invoiceNumber']}');
    return silaiOrder(
      id: map['id'] ?? '',
      measurementType: map['measurementType'] ?? '',
      serial: map['serial'] ?? '',
      suitsCount: map['suitsCount'] ?? 0,
      paymentAmount: map['paymentAmount']?.toDouble() ?? 0.0,
      orderDate: DateTime.parse(map['orderDate']),
      completionDate: DateTime.parse(map['completionDate']),
      invoiceNumber: map['invoiceNumber'].toString() ?? '', // Parse invoiceNumber
      employeeName: map['employeeName'],
      employeeId: map['silaiId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'measurementType': measurementType,
      'serial': serial,
      'suitsCount': suitsCount,
      'paymentAmount': paymentAmount,
      'orderDate': orderDate.toIso8601String(),
      'completionDate': completionDate.toIso8601String(),
      'invoiceNumber': invoiceNumber, // Include in map for saving to Firebase
      'employeeName': employeeName,
      'employeeId': employeeId,
    };
  }
}
