// lib/models/order_model.dart
class Order {
  final String id;
  final String measurementType;
  final String serial;
  final int suitsCount;
  final double paymentAmount;
  final DateTime orderDate;
  final DateTime completionDate;
  final String status;
  final int invoiceNumber;

  Order({
    required this.id,
    required this.measurementType,
    required this.serial,
    required this.suitsCount,
    required this.paymentAmount,
    required this.orderDate,
    required this.completionDate,
    required this.status,
    required this.invoiceNumber
  });

  factory Order.fromMap(Map<dynamic, dynamic> data) {
    return Order(
      id: data['id'] ?? '',
      measurementType: data['measurementType'] ?? '',
      serial: data['serial'] ?? '',
      suitsCount: data['suitsCount'] ?? 0,
      paymentAmount: data['paymentAmount'] ?? 0.0,
      orderDate: DateTime.parse(data['orderDate'] ?? DateTime.now().toString()),
      completionDate: DateTime.parse(data['completionDate'] ?? DateTime.now().toString()),
      status:  data['status'] ?? 'N/A',
      invoiceNumber: data['invoiceNumber']
    );
  }
}
