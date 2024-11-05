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
            Container(
              child: Row(
                children: [
                  Table(
                    columnWidths: {
                      0: FixedColumnWidth(MediaQuery.of(context).size.width*0.25), // Set the width of the Measurements column
                      1: FixedColumnWidth(MediaQuery.of(context).size.width*0.25)
                    },
                    children: [
                      TableRow(children: [
                        Text("Body Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("Stitching Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ]),

                      TableRow(
                          children: [
                            _buildReadOnlyField("Lambai", measurement?['bodylambai']),
                            _buildReadOnlyField("Lambai", measurement?['lambai']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Chaati", measurement?['bodychaati']),
                            _buildReadOnlyField("Chaati", measurement?['chaati']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Kamar", measurement?['bodykamar']),
                            _buildReadOnlyField("Kamar", measurement?['kamar']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Hip", measurement?['bodyhip']),
                            _buildReadOnlyField("Hip", measurement?['hip']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Baazu", measurement?['bodybazu']),
                            _buildReadOnlyField("Baazu", measurement?['bazu']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Teera", measurement?['bodyteera']),
                            _buildReadOnlyField("Teera", measurement?['teera']),

                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Gala", measurement?['bodygala']),
                            _buildReadOnlyField("Gala", measurement?['gala']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Cross Back", measurement?['bodycrossBack']),
                            _buildReadOnlyField("Cross Back", measurement?['crossBack']),
                          ]
                      ),
                    ],
                  ),
                  Expanded(child: _buildReadOnlyField("Note: ", measurement?['note'])),

                ],
              ),
            ),

            // Checkbox Options
            // _buildReadOnlyCheckbox("Fancy Button", measurement?['fancyButton']),
            // _buildReadOnlyCheckbox("Special Request", measurement?['specialRequest']),

          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'lora',fontWeight: FontWeight.bold)),
          Container(
            width: 150,
            child: Text(
              value?.toString() ?? "N/A",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'lora',
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyCheckbox(String title, bool? value) {
    return CheckboxListTile(
      title: Text(title, style: TextStyle(color: Colors.black,fontFamily: 'lora',fontSize: 18,fontWeight: FontWeight.bold),),
      value: value ?? false,
      onChanged: null, // Disable interaction
      controlAffinity: ListTileControlAffinity.leading, // Place checkbox on the left
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
