import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/MeasurementProvider.dart';

class PantMeasurementShowPage extends StatefulWidget {
  final String serialNo;

  const PantMeasurementShowPage({Key? key, required this.serialNo}) : super(key: key);

  @override
  _PantMeasurementShowPageState createState() => _PantMeasurementShowPageState();
}

class _PantMeasurementShowPageState extends State<PantMeasurementShowPage> {
  Map? pantData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPantData();
    });
  }

  void _fetchPantData() {
    final measurementProvider = Provider.of<Measurementprovider>(context, listen: false);
    pantData = measurementProvider.pants.firstWhere(
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
            Text("Serial No: ${pantData?['serialNo']}", style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Name: ${pantData?['name']}", style: GoogleFonts.lora(fontSize: 18)),
            Text("Address: ${pantData?['address']}", style: GoogleFonts.lora(fontSize: 18)),
            Text("Mobile No: ${pantData?['mobileNo']}", style: GoogleFonts.lora(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildPantMeasurements() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pant Measurements", style: GoogleFonts.lora(fontSize: 22, fontWeight: FontWeight.bold)),
            Divider(),
            _buildReadOnlyField("Lambai", pantData?['lambai']),
            _buildReadOnlyField("Hip", pantData?['hip']),
            _buildReadOnlyField("Kamar", pantData?['kamar']),
            _buildReadOnlyField("Thai", pantData?['thai']),
            _buildReadOnlyField("Pauncha", pantData?['pauncha']),
            _buildReadOnlyCheckbox("Smart Fitting", pantData?['smartFitting']),
            _buildReadOnlyField("Note", pantData?['note']),
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
    if (pantData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Pant Measurements", style: GoogleFonts.lora()),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildPantMeasurements(),
          ],
        ),
      ),
    );
  }
}
