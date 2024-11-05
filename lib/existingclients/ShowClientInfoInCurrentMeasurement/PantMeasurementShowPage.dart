import 'package:flutter/cupertino.dart';
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
                            _buildReadOnlyField("Lambai", pantData?['bodylambai']),
                            _buildReadOnlyField("Lambai", pantData?['lambai']),
                          ]
                      ),

                      TableRow(
                          children: [
                            _buildReadOnlyField("Hip", pantData?['bodyhip']),
                            _buildReadOnlyField("Hip", pantData?['hip']),
                          ]
                      ),

                      TableRow(
                          children: [
                            _buildReadOnlyField("Kamar", pantData?['bodykamar']),
                            _buildReadOnlyField("Kamar", pantData?['kamar']),
                          ]
                      ),

                      TableRow(
                          children: [
                            _buildReadOnlyField("Thai", pantData?['bodythai']),
                            _buildReadOnlyField("Thai", pantData?['thai']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildReadOnlyField("Pauncha", pantData?['bodypauncha']),
                            _buildReadOnlyField("Pauncha", pantData?['pauncha']),
                          ]
                      ),

                    ],
                  ),
                  Expanded(child: _buildReadOnlyField("Note:", pantData?['note'])),
                ],
              ),
            ),

            _buildReadOnlyCheckbox("Smart Fitting", pantData?['smartFitting']),

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
