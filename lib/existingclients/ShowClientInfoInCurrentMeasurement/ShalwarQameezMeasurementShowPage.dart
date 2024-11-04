import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/MeasurementProvider.dart';

class ShalwarQameezMeasurementPage extends StatefulWidget {
  final String serialNo;

  const ShalwarQameezMeasurementPage({super.key, required this.serialNo});

  @override
  State<ShalwarQameezMeasurementPage> createState() => _ShalwarQameezMeasurementPageState();
}

class _ShalwarQameezMeasurementPageState extends State<ShalwarQameezMeasurementPage> {
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
    measurement = measurementProvider.shalwarQameez.firstWhere(
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
            Text("Serial No: ${measurement!['serialNo']}", style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Name: ${measurement!['name']}", style: GoogleFonts.lora(fontSize: 18)),
            Text("Address: ${measurement!['address']}", style: GoogleFonts.lora(fontSize: 18)),
            Text("Mobile No: ${measurement!['mobileNo']}", style: GoogleFonts.lora(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildQameezSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Qameez Measurements", style: GoogleFonts.lora(fontSize: 22, fontWeight: FontWeight.bold)),
            Divider(),
            _buildMeasurementRow("Lambai", measurement!['qameezLambai']),
            _buildMeasurementRow("Chaati", measurement!['chaati']),
            _buildMeasurementRow("Kamar", measurement!['kamar']),
            _buildMeasurementRow("Daman", measurement!['daman']),
            _buildMeasurementRow("Bazu", measurement!['bazu']),
            _buildMeasurementRow("Teera", measurement!['teera']),
            _buildMeasurementRow("Gala", measurement!['gala']),
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
      ),
    );
  }

  Widget _buildBottomSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bottom Measurements", style: GoogleFonts.lora(fontSize: 22, fontWeight: FontWeight.bold)),
            Divider(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.lora(fontSize: 18)),
          Text(value.toString(), style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool? value) {
    return CheckboxListTile(
      title: Text(title, style: GoogleFonts.lora(fontSize: 18)),
      value: value ?? false,
      onChanged: null, // Disable interaction
      controlAffinity: ListTileControlAffinity.leading, // Place checkbox on the left
    );
  }

  Widget _buildRadioGroup(String title, List<String> options, String groupValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold)),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option, style: GoogleFonts.lora(fontSize: 16)),
            value: option,
            groupValue: groupValue,
            onChanged: null, // Disable interaction
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (measurement == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Shalwar Qameez Measurement", style: GoogleFonts.lora()),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Shalwar Qameez Measurement", style: GoogleFonts.lora()),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildHeader()),
              _buildQameezSection(),
              SizedBox(height: 20),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }
}
