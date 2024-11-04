import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sabir_tailors/Models/Admin model.dart';
import 'package:sabir_tailors/providers/MeasurementProvider.dart';
import 'package:sabir_tailors/providers/OrderProvider.dart';
import 'Models/OrderModel.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/CoatMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/PantMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/ShalwarQameezMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/SherwaniMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/WaskitMeasurementShowPage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  EmployeeModel? selectedEmployee;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  Map? measurement;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchEmployeesforKatai();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    List<EmployeeModel> employeesforKatai = orderProvider.employees;

    return Scaffold(
      appBar: AppBar(
        title: Text('Fresh Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Serial Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: orderProvider.fetchOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return Center(child: CircularProgressIndicator());
                }
                if (orderProvider.orders.isEmpty) {
                  return Center(child: Text('No orders found.', style: TextStyle(fontSize: 18)));
                }

                // Filter orders based on search query
                List<Order> filteredOrders = orderProvider.orders.where((order) {
                  return order.serial.toLowerCase().contains(searchQuery);
                }).toList();

                if (filteredOrders.isEmpty) {
                  return Center(child: Text('No orders found for this serial.', style: TextStyle(fontSize: 18)));
                }

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return _buildOrderCard(order, employeesforKatai);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, List<EmployeeModel> employeesforKatai) {
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
            Text('Suits Count: ${order.suitsCount}', style: TextStyle(fontSize: 16)),
            Text('Payment: \$${order.paymentAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            Text('Order Date: ${order.orderDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16)),
            Text('Completion Date: ${order.completionDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showEmployeeSelectionDialog(employeesforKatai, order.id.toString(), order.measurementType, order.serial);
                  },
                  child: Text('send to katai', style: TextStyle(color: Colors.white)),
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

  void _showEmployeeSelectionDialog(List<EmployeeModel> employees, String orderId, String MeasurementType, String SerialNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Select Person for Katai"),
              content: DropdownButton<EmployeeModel>(
                isExpanded: true,
                value: selectedEmployee != null && employees.contains(selectedEmployee) ? selectedEmployee : null,
                hint: Text("Select Employee"),
                onChanged: (EmployeeModel? newValue) {
                  setState(() {
                    selectedEmployee = newValue;
                  });
                },
                items: employees.map<DropdownMenuItem<EmployeeModel>>((EmployeeModel employee) {
                  return DropdownMenuItem<EmployeeModel>(
                    value: employee,
                    child: Text(employee.name), // assuming EmployeeModel has a 'name' property
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: !isLoading? () async {
                    if (selectedEmployee != null) {
                      setState(() {
                        isLoading=true;
                      });
                      String selectedEmployeeId = selectedEmployee!.employeeId;
                      print("Selected Employee ID: $selectedEmployeeId");
                      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                      await _generateAndDownloadPDF(orderId, MeasurementType,SerialNo, selectedEmployee!.name, selectedEmployee!.employeeId); // Generate and download PDF after updating order status
                      await orderProvider.updateOrderStatus(orderId, selectedEmployeeId);
                      setState(() {
                        isLoading=false;
                      });
                      Navigator.of(context).pop();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('select employee first')));
                      setState(() {
                        isLoading=false;
                      });
                    }
                     // Dismiss the dialog after confirming
                  }: (){},
                  child: !isLoading? Text("OK"): CircularProgressIndicator(),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> _generateAndDownloadPDF(
      String orderId,
      String MeasureMentType,
      String SerialNo,
      String EmployeeName,
      String EmployeeId,
      ) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final order = orderProvider.orders.firstWhere((order) => order.id.toString() == orderId);
    final measurementProvider = Provider.of<Measurementprovider>(context, listen: false);
    await measurementProvider.FetchMeausurements(MeasureMentType.toString());

    // Create PDF document
    final logoBytes = await _getCompanyLogoBytes();

    final pdf = pw.Document();
    dynamic measurement;

    pw.Widget _buildHeader() {
      return pw.Column(
        children: [
          pw.Center(
            child: pw.Image(
              pw.MemoryImage(logoBytes),
              width: 100,
              height: 100,
            ), // Add your logo here
          ),
          pw.Center(
            child: pw.Text('Sabir Taylors', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Center(
            child: pw.Text('Suits for Katai', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Divider(thickness: 2),
        ],
      );
    }
    // Function to build measurement row
    pw.Widget _buildMeasurementRow(String title, dynamic value) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 18)),
          pw.Text(value?.toString() ?? "N/A", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        ],
      );
    }

    // Function to build checkbox
    pw.Widget _buildCheckbox(String title, bool? value) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(width: 10),
          pw.Text(value == true ? 'Selected' : 'N/A', style: pw.TextStyle(fontSize: 18,fontWeight:  pw.FontWeight.bold)),
        ],
      );
    }

    // Function to build radio group
    pw.Widget _buildRadioGroup(String title, List<String> options, String groupValue) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ...options.map((option) {
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(option, style: pw.TextStyle(fontSize: 16)),
                if (option == groupValue) ...[
                  pw.Text(' (Selected)', style: pw.TextStyle(fontSize: 16)),
                ],
              ],
            );
          }).toList(),
        ],
      );
    }

    // Switch case for different measurement types
    switch (MeasureMentType) {
      case 'ShalwarQameez':
        measurement = measurementProvider.shalwarQameez.firstWhere((m) => m['serialNo'] == SerialNo, orElse: () => {});
        // Add pages and content specific to Shalwar Qameez
        pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.Text('Employee Name: $EmployeeName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Employee ID: $EmployeeId', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Shalwar Qameez Measurements', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Measurements for Order ${order.invoiceNumber}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Suits Count ${order.suitsCount}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              _buildMeasurementRow("Serial No: ${measurement!['serialNo']}", measurement!['serialNo']),
              _buildMeasurementRow("Name: ${measurement!['name']}", measurement!['name']),
              _buildMeasurementRow("Address: ${measurement!['address']}", measurement!['address']),
              _buildMeasurementRow("Mobile No: ${measurement!['mobileNo']}", measurement!['mobileNo']),
              pw.SizedBox(height: 20),
              pw.Text('Qameez Measurements', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildMeasurementRow('Lambai', measurement!['qameezLambai']),
              _buildMeasurementRow('Chaati', measurement!['chaati']),
              _buildMeasurementRow('Kamar', measurement!['kamar']),
              _buildMeasurementRow('Daman', measurement!['daman']),
              _buildMeasurementRow('Bazu', measurement!['bazu']),
              _buildMeasurementRow('Teera', measurement!['teera']),
              _buildMeasurementRow('Gala', measurement!['gala']),
              _buildCheckbox('Kaff', measurement!['kaff']),
              _buildCheckbox('Shalwar Pocket', measurement!['shalwarPocket']),
              _buildCheckbox('Front Pocket', measurement!['frontPocket']),
              _buildCheckbox('Side Pocket', measurement!['sidePocket']),
              _buildRadioGroup('Kalar or Been', ['Kalar', 'Been'], measurement!['selectedKalarOrBeen']),
              _buildRadioGroup('Daman Style', ['Gool', 'Choras'], measurement!['selectedDamanStyle']),
              _buildRadioGroup('Silai Type', ['Double Silai', 'Triple Silai'], measurement!['selectedSilaiType']),
              _buildMeasurementRow("Note", measurement!['QameezNote']),
            ],
          ),
        ));
        pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.Text('Bottom Measurements', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildRadioGroup('Bottom Type', ['Shalwar', 'Trouser'], measurement!['selectedBottomType']),
              if (measurement!['selectedBottomType'] == 'Shalwar') ...[
                _buildMeasurementRow("Shalwar Lambai", measurement!['shalwarLambai']),
                _buildMeasurementRow("Pauncha", measurement!['pauncha']),
                _buildMeasurementRow("Shalwar Gheera", measurement!['gheera']),
              ] else ...[
                _buildMeasurementRow("Trouser Lambai", measurement!['trouserLambai']),
                _buildMeasurementRow("Pauncha", measurement!['pauncha']),
                _buildMeasurementRow("Hip", measurement!['hip']),
              ],
              _buildCheckbox('Trouser Pocket', measurement!['trouserPocket']),
              _buildCheckbox('Elastic + Doori', measurement!['elasticDoori']),
              _buildMeasurementRow("Note", measurement!['ShalwarNote']),
            ]
          )
        ));

        break;

      case 'Coat':
        measurement = measurementProvider.coat.firstWhere((m) => m['serialNo'] == SerialNo, orElse: () => {});
        pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.Text('Employee Name: $EmployeeName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Employee ID: $EmployeeId', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Measurements for Order ${order.invoiceNumber}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Suits Count ${order.suitsCount}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Coat Measurements', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Measurements for Order ${order.invoiceNumber}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildMeasurementRow("Serial No", measurement!['serialNo']),
              _buildMeasurementRow("Name", measurement!['name']),
              _buildMeasurementRow("Address", measurement!['address']),
              _buildMeasurementRow("Mobile No", measurement!['mobileNo']),
              pw.SizedBox(height: 20),
              pw.Text("Measurements", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildMeasurementRow("Lambai", measurement!['lambai']),
              _buildMeasurementRow("Chaati", measurement!['chaati']),
              _buildMeasurementRow("Kamar", measurement!['kamar']),
              _buildMeasurementRow("Hip", measurement!['hip']),
              _buildMeasurementRow("Baazu", measurement!['bazu']),
              _buildMeasurementRow("Teera", measurement!['teera']),
              _buildMeasurementRow("Gala", measurement!['gala']),
              _buildMeasurementRow("Cross Back", measurement!['crossBack']),
              _buildCheckbox("2 Buttons", measurement!['twoButtons']),
              _buildCheckbox("Side Jak", measurement!['sideJak']),
              _buildCheckbox("Fancy Button", measurement!['fancyButton']),
              _buildMeasurementRow("Note", measurement!['note']),
            ],
          ),
        ));

        break;

      case 'Pants':
        measurement = measurementProvider.pants.firstWhere((m) => m['serialNo'] == SerialNo, orElse: () => {});
        pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Employee Name: $EmployeeName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Employee ID: $EmployeeId', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Measurements for Order ${order.invoiceNumber}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Suits Count ${order.suitsCount}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Pants Measurements', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildMeasurementRow("Serial No", measurement!['serialNo']),
              _buildMeasurementRow("Name", measurement!['name']),
              _buildMeasurementRow("Address", measurement!['address']),
              _buildMeasurementRow("Mobile No", measurement!['mobileNo']),
              pw.SizedBox(height: 20),
              pw.Text("Measurements", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildMeasurementRow("Lambai", measurement!['lambai']),
              _buildMeasurementRow("Kamar", measurement!['kamar']),
              _buildMeasurementRow("Hip", measurement!['hip']),
              _buildMeasurementRow("Pauncha", measurement!['pauncha']),
              _buildCheckbox("SmartFitting", measurement!['smartFitting']),
              _buildMeasurementRow("Thai", measurement!['thai']),
              _buildMeasurementRow("Pocket", measurement!['pocket']),
              _buildMeasurementRow("Note", measurement!['note']),
            ],
          ),
        ));
        break;
      case 'Sherwani':
        measurement = measurementProvider.sherwani.firstWhere((m) => m['serialNo'] == SerialNo, orElse: () => {});
        pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.Text('Employee Name: $EmployeeName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Employee ID: $EmployeeId', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Measurements for Order ${order.invoiceNumber}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Suits Count ${order.suitsCount}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Sherwani Measurements', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              _buildMeasurementRow("Serial No", measurement!['serialNo']),
              _buildMeasurementRow("Name", measurement!['name']),
              _buildMeasurementRow("Address", measurement!['address']),
              _buildMeasurementRow("Mobile No", measurement!['mobileNo']),
              pw.SizedBox(height: 20),

              pw.Text("Measurements", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),

              _buildMeasurementRow("Lambai", measurement!['lambai']),
              _buildMeasurementRow("Chaati", measurement!['chaati']),
              _buildMeasurementRow("Kamar", measurement!['kamar']),
              _buildMeasurementRow("Hip", measurement!['hip']),
              _buildMeasurementRow("Baazu", measurement!['bazu']),
              _buildMeasurementRow("Teera", measurement!['teera']),
              _buildMeasurementRow("Gala", measurement!['gala']),
              _buildMeasurementRow("Cross Back", measurement!['crossBack']),

              _buildCheckbox("Fancy Button", measurement!['fancyButton']),
              _buildCheckbox("Special Request", measurement!['specialRequest']),
              _buildMeasurementRow("Note", measurement!['note']),
            ],
          ),
        ));
        break;
      case 'Waskit':
        measurement = measurementProvider.Waskit.firstWhere((m) => m['serialNo'] == SerialNo, orElse: () => {});
        pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.Text('Employee Name: $EmployeeName', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Employee ID: $EmployeeId', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Measurements for Order ${order.invoiceNumber}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Suits Count ${order.suitsCount}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Waskit Measurements', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              _buildMeasurementRow("Serial No", measurement!['serialNo']),
              _buildMeasurementRow("Name", measurement!['name']),
              _buildMeasurementRow("Address", measurement!['address']),
              _buildMeasurementRow("Mobile No", measurement!['mobileNo']),
              pw.SizedBox(height: 20),

              pw.Text("Waskit Measurements", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),

              _buildMeasurementRow("Lambai", measurement!['lambai']),
              _buildMeasurementRow("Chaati", measurement!['chaati']),
              _buildMeasurementRow("Kamar", measurement!['kamar']),
              _buildMeasurementRow("Hip", measurement!['hip']),
              _buildMeasurementRow("Teera", measurement!['teera']),

              // Gala Type
              _buildMeasurementRow("Gala Type", measurement!['galaType'] ?? "N/A"),

              // Checkbox Option
              _buildCheckbox("Fancy Button", measurement!['fancyButton']),

              // Note Field
              _buildMeasurementRow("Note", measurement!['note']),
            ],
          ),
        ));
        break;




    // Add other measurement types as needed

      default:
        throw Exception("Invalid MeasureMentType: $MeasureMentType");
    }

    // Save the PDF document for web
    try {
      Uint8List pdfData = await pdf.save();
      final blob = html.Blob([pdfData], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');

      // Create a link to download the PDF
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'measurements_${order.serial}/${order.invoiceNumber}.pdf')
        ..click();

      // Cleanup
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print("Error saving or opening PDF: $e");
      // Optionally show an alert dialog here
    }
  }

  Future<Uint8List> _getCompanyLogoBytes() async {
    final logoData = await rootBundle.load('assets/images/logo.png');
    return logoData.buffer.asUint8List();
  }

}
