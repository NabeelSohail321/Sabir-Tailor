import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;
import 'existingclients/ShowClientInfoInCurrentMeasurement/CoatMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/PantMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/ShalwarQameezMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/SherwaniMeasurementShowPage.dart';
import 'existingclients/ShowClientInfoInCurrentMeasurement/WaskitMeasurementShowPage.dart';
import 'providers/MeasurementProvider.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PlaceOrderPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Place Order", style: GoogleFonts.lora()),
          titleTextStyle: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
            PlaceOrderForm(),
          ],
        ),
      );

  }
}

class PlaceOrderForm extends StatefulWidget {

  @override
  _PlaceOrderFormState createState() => _PlaceOrderFormState();
}

class _PlaceOrderFormState extends State<PlaceOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('measurements');
  final TextEditingController serialController = TextEditingController();
  final TextEditingController suitsCountController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController AdvancepaymentController = TextEditingController();
  DateTime? completionDate; // Field for completion date
  bool isLoading = false;
  String selectedMeasurementType = "ShalwarQameez";
  bool isSerialValid = false;
  bool isSearching = false;
  List<Map<dynamic, dynamic>> searchResults = [];
  int? invoiceNumber;

  Future<void> _generateAndPrintPDF() async {
    final logoBytes = await _getCompanyLogoBytes();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Sabir Tailors",
                          style: pw.TextStyle(
                              fontSize: 28, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Phone: +92-3XX-XXXXXXX",
                          style: pw.TextStyle(fontSize: 16)),
                      pw.Text("Invoice Number: #$invoiceNumber",
                          style: pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                  pw.Image(
                    pw.MemoryImage(logoBytes),
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text('Order Summary',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Measurement Type: $selectedMeasurementType'),
              pw.Text('Serial Number: ${serialController.text}'),
              pw.Text('Number of Suits: ${suitsCountController.text}'),
              pw.Text('Total Payment: ${paymentController.text}'),
              pw.Text('Advance Payment: ${AdvancepaymentController.text}'),
              pw.Text('Order Date: ${DateTime.now()?.toLocal()}'),

              pw.Text('Completion Date: ${completionDate?.toLocal()}'),
              pw.Text('Remaining Payment: ${(double.tryParse(paymentController.text))! - (double.parse(AdvancepaymentController.text))}'),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.Center(
                child: pw.Text('Thank you for choosing Sabir Tailors!',
                    style: pw.TextStyle(
                        fontSize: 16, fontStyle: pw.FontStyle.italic)),
              ),
            ],
          );
        },
      ),
    );


    // Convert PDF to bytes and trigger the print/download action
    Uint8List pdfBytes = await pdf.save();


    // Create a blob from the PDF bytes
    final blob = html.Blob([pdfBytes], 'application/pdf');

    // Create an object URL for the blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Open the PDF in a new browser tab
    html.window.open(url, '_blank');
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'Orders_${invoiceNumber}.pdf')
      ..click();


    // Revoke the object URL after the file is opened
    html.Url.revokeObjectUrl(url);
  }

  Future<Uint8List> _getCompanyLogoBytes() async {
    final logoData = await rootBundle.load('assets/images/logo.png');
    return logoData.buffer.asUint8List();
  }

  Future<void> searchSerial() async {
    setState(() {
      isSearching = true;
      isSerialValid = false;
      searchResults.clear();
    });

    final serial = serialController.text.trim();
    if (serial.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a serial number.")),
      );
      setState(() {
        isSearching = false;
      });
      return;
    }

    final DatabaseReference typeRef = dbRef.child(selectedMeasurementType);
    DataSnapshot snapshot = await typeRef.orderByChild('serialNo').equalTo(serial).get();

    setState(() {
      isSearching = false;
      if (snapshot.exists) {
        isSerialValid = true;
        searchResults = [];
        snapshot.children.forEach((child) {
          searchResults.add(child.value as Map<dynamic, dynamic>);
        });
      } else {
        isSerialValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Serial does not exist in the selected type.")),
        );
      }
    });
  }

  void placeOrder() {
    if(searchResults.isEmpty||suitsCountController.text.isEmpty||paymentController.text.isEmpty||completionDate==null){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all The fields first then place the order')));
    }
    else{

      if (_formKey.currentState!.validate() && completionDate != null) {
        setState(() {
          isLoading = true;
        });
        final suitsCount = int.tryParse(suitsCountController.text.trim());
        final paymentAmount = double.tryParse(paymentController.text.trim());
        final AdvancepaymentAmount = double.tryParse(AdvancepaymentController.text.trim());
        final remainingAmount = paymentAmount!-AdvancepaymentAmount!;

        final orderRef = FirebaseDatabase.instance.ref('orders');
        String id = orderRef.push().key.toString();

        orderRef.child(id).set({
          "id": id,
          'measurementType': selectedMeasurementType,
          'serial': serialController.text.trim(),
          'suitsCount': suitsCount,
          'paymentAmount': paymentAmount,
          'AdvancePayment': AdvancepaymentAmount ?? '0',
          'reaminingAmount': remainingAmount,
          'orderDate': DateTime.now().toIso8601String(),
          'completionDate': completionDate!.toIso8601String(), // Add completion date
          'invoiceNumber': invoiceNumber
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Order placed successfully!")),
          );
          setState(() {
            isLoading=false;
          });
          _clearFields();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $error")),
          );
          setState(() {
            isLoading=false;
          });
        });
      }

    }
  }

  void _clearFields() {
    serialController.clear();
    suitsCountController.clear();
    paymentController.clear();
    AdvancepaymentController.clear();
    setState(() {
      isSerialValid = false;
      searchResults.clear();
      completionDate = null; // Clear the completion date
    });
  }

  Future<void> _selectCompletionDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: completionDate ?? DateTime.now().add(Duration(days: 1)), // Default to tomorrow if no date is selected
      firstDate: DateTime.now().add(Duration(days: 1)), // Allow only future dates
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != completionDate) {
      setState(() {
        completionDate = picked; // Update the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AdvancepaymentController.text = "0";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 8.0),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildMeasurementTypeDropdown(),
                  SizedBox(height: 20),
                  _buildSerialSearchField(),
                  SizedBox(height: 20),
                  if (isSerialValid) _buildSearchedList(),
                  if (isSerialValid) ...[
                    _buildOrderFields(),
                    SizedBox(height: 20),
                    _buildCompletionDatePicker(), // Add completion date picker
                    SizedBox(height: 20),
                  ],
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedMeasurementType,
      items: [
        DropdownMenuItem(value: "ShalwarQameez", child: Text("Shalwar Qameez")),
        DropdownMenuItem(value: "Coat", child: Text("Coat")),
        DropdownMenuItem(value: "Pants", child: Text("Pants")),
        DropdownMenuItem(value: "Sherwani", child: Text("Sherwani")),
        DropdownMenuItem(value: "Waskit", child: Text("Waskit")),
      ],
      onChanged: (value) {
        setState(() {
          selectedMeasurementType = value!;
          serialController.clear();
          isSerialValid = false;
          searchResults.clear();
        });
      },
      decoration: InputDecoration(
        labelText: "Select Measurement Type",
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.lightBlue[50], // Light blue background for better visibility
      ),
    );
  }

  Widget _buildSerialSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: serialController,
            decoration: InputDecoration(
              labelText: "Enter Serial Number",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue[50], // Light blue background for better visibility
            ),
          ),
        ),
        SizedBox(width: 10),
        Card(
          child: InkWell(
            onTap: isSearching ? null : searchSerial,
            child: Container(
              width: 100.0, // Adjust width as needed
              height: 50.0, // Adjust height as needed
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Colors.greenAccent,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: isSearching
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Search",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildSearchedList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              title: Text("Name: ${result['name']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Serial No: ${result['serialNo']}"),
                  Text("Mobile No: ${result['mobileNo']}"),
                  Text("Address: ${result['address']}"),
                ],
              ),
              isThreeLine: true,
              onTap: () async {
                String? serialNo = result['serialNo']?.toString(); // Use null-aware operator
                if (serialNo != null) {
                  // Proceed with navigation
                  final measurementProvider = Provider.of<Measurementprovider>(context, listen: false);
                  if (selectedMeasurementType == 'ShalwarQameez') {
                    await measurementProvider.FetchMeausurements('ShalwarQameez');
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShalwarQameezMeasurementPage(serialNo: serialNo)),
                    );
                  } else if (selectedMeasurementType == 'Coat') {
                    await measurementProvider.FetchMeausurements('Coat');

                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CoatMeasurementPage(serialNo: serialNo)),
                    );
                  } else if (selectedMeasurementType == 'Pants') {
                    await measurementProvider.FetchMeausurements('Pants');

                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PantMeasurementShowPage(serialNo: serialNo)),
                    );
                  } else if (selectedMeasurementType == 'Sherwani') {
                    await measurementProvider.FetchMeausurements('Sherwani');

                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SherwaniMeasurementShowPage(serialNo: serialNo)),
                    );
                  } else if (selectedMeasurementType == 'Waskit') {
                    await measurementProvider.FetchMeausurements('Waskit');

                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WaskitMeasurementPage(serialNo: serialNo)),
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: suitsCountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Number of Suits",
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.lightBlue[50], // Light blue background for better visibility
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the number of suits.";
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: paymentController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Payment Amount",
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.lightBlue[50], // Light blue background for better visibility
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the payment amount.";
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: AdvancepaymentController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Advance Payment Amount",
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.lightBlue[50], // Light blue background for better visibility
          ),
          validator: (value){
            if(double.parse(paymentController.text)<double.parse(value!)){
              return 'Advance payment should be less than Total Payment';
            }
            if(value.isEmpty){
              return 'Enter Advance payment If not Enter 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCompletionDatePicker() {
    return ListTile(
      title: Text(
        completionDate == null
            ? 'Select Completion Date'
            : 'Completion Date: ${completionDate!.toLocal().toIso8601String().split('T')[0]}',
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.calendar_today),
      onTap: () => _selectCompletionDate(context), // Open date picker on tap
      tileColor: Colors.grey[200], // Optional: Add background color for better visibility
    );
  }

  Widget _buildSubmitButton() {
    return Card(
      child: InkWell(
        onTap: !isLoading? () async {


          invoiceNumber = DateTime.now().millisecondsSinceEpoch;
           await _generateAndPrintPDF();
           placeOrder();
          setState(() {
            isLoading=false;
          });
        }:(){},
        child: Container(
          width: 200.0,
          height: 50.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.greenAccent,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: !isLoading? Text(
              "Place Order",
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ): CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

}
