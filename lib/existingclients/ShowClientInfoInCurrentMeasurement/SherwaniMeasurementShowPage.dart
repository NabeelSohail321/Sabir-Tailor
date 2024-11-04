import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/MeasurementProvider.dart';

class SherwaniMeasurementShowPage extends StatefulWidget {
  final String serialNo;

  const SherwaniMeasurementShowPage({Key? key, required this.serialNo})
      : super(key: key);

  @override
  State<SherwaniMeasurementShowPage> createState() => _SherwaniMeasurementShowPageState();
}

class _SherwaniMeasurementShowPageState extends State<SherwaniMeasurementShowPage> {
  Map? measurement;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMeasurementData();
    });
  }

  void _fetchMeasurementData() {
    final measurementProvider = Provider.of<Measurementprovider>(context, listen: false);
    measurement = measurementProvider.sherwani.firstWhere(
          (m) => m['serialNo'] == widget.serialNo,
      orElse: () => {},
    );
    setState(() {});
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Serial No: ${measurement?['serialNo']}", style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Name: ${measurement?['name']}", style: GoogleFonts.lora(fontSize: 18)),
            Text("Address: ${measurement?['address']}", style: GoogleFonts.lora(fontSize: 18)),
            Text("Mobile No: ${measurement?['mobileNo']}", style: GoogleFonts.lora(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildSherwaniMeasurements() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sherwani Measurements", style: GoogleFonts.lora(fontSize: 22, fontWeight: FontWeight.bold)),
            Divider(),
            // Displaying the sherwani measurements as read-only text fields
            _buildReadOnlyField("Lambai", measurement?['lambai']),
            _buildReadOnlyField("Chaati", measurement?['chaati']),
            _buildReadOnlyField("Kamar", measurement?['kamar']),
            _buildReadOnlyField("Hip", measurement?['hip']),
            _buildReadOnlyField("Baazu", measurement?['bazu']),
            _buildReadOnlyField("Teera", measurement?['teera']),
            _buildReadOnlyField("Gala", measurement?['gala']),
            _buildReadOnlyField("Cross Back", measurement?['crossBack']),

            // Checkbox Options
            // _buildReadOnlyCheckbox("Fancy Button", measurement?['fancyButton']),
            // _buildReadOnlyCheckbox("Special Request", measurement?['specialRequest']),

            // Note Field
            _buildReadOnlyField("Note", measurement?['note']),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.lora(fontSize: 18)),
          Container(
            width: 150,
            child: Text(
              value?.toString() ?? "N/A",
              style: GoogleFonts.lora(fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyCheckbox(String title, bool? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.lora(fontSize: 18)),
        Checkbox(
          value: value ?? false,
          onChanged: null, // Make it read-only
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (measurement == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sherwani Measurements", style: GoogleFonts.lora()),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildSherwaniMeasurements(),
          ],
        ),
      ),
    );
  }
}