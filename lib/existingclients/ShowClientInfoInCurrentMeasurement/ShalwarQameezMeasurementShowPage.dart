import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                          _buildMeasurementRow("Lambai", measurement!['bodyqameezLambai']),
                          _buildMeasurementRow("Lambai", measurement!['qameezLambai']),
                        ]
                      ),
                      TableRow(
                          children: [
                            _buildMeasurementRow("Chaati", measurement!['bodychaati']),
                            _buildMeasurementRow("Chaati", measurement!['chaati']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildMeasurementRow("Kamar", measurement!['bodykamar']),
                            _buildMeasurementRow("Kamar", measurement!['kamar']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildMeasurementRow("Daman", measurement!['bodydaman']),
                            _buildMeasurementRow("Daman", measurement!['daman']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildMeasurementRow("Bazu", measurement!['bodybazu']),
                            _buildMeasurementRow("Bazu", measurement!['bazu']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildMeasurementRow("Teera", measurement!['bodyteera']),
                            _buildMeasurementRow("Teera", measurement!['teera']),
                          ]
                      ),
                      TableRow(
                          children: [
                            _buildMeasurementRow("Gala", measurement!['bodygala']),
                            _buildMeasurementRow("Gala", measurement!['gala']),
                          ]
                      ),
                    ],
                  ),
                  Expanded(child: _buildMeasurementRow("Note", measurement!['QameezNote'])),
                ],
              ),
            ),

            _buildCheckbox('Kaff', measurement!['kaff']),
            _buildCheckbox('Shalwar Pocket', measurement!['shalwarPocket']),
            _buildCheckbox('Front Pocket', measurement!['frontPocket']),
            _buildCheckbox('Side Pocket', measurement!['sidePocket']),
            _buildRadioGroup('Kalar or Been', ['Kalar', 'Been'], measurement!['selectedKalarOrBeen']),
            _buildRadioGroup('Daman Style', ['Gool', 'Choras'], measurement!['selectedDamanStyle']),
            _buildRadioGroup('Silai Type', ['Double Silai', 'Triple Silai'], measurement!['selectedSilaiType']),
            
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
              Container(
                child: Row(
                  children: [
                    Table(
                      columnWidths: {
                        0: FixedColumnWidth(MediaQuery.of(context).size.width*0.25), // Set the width of the Measurements column
                        1: FixedColumnWidth(MediaQuery.of(context).size.width*0.25)
                      },
                      children: [
                        TableRow(
                          children: [
                            _buildMeasurementRow("Shalwar Lambai", measurement!['bodyshalwarLambai']),
                            _buildMeasurementRow("Shalwar Lambai", measurement!['shalwarLambai']),
                          ]
                        ),
                        TableRow(
                            children: [
                              _buildMeasurementRow("Pauncha", measurement!['bodypauncha']),
                              _buildMeasurementRow("Pauncha", measurement!['pauncha']),
                            ]
                        ),
                        TableRow(
                            children: [
                              _buildMeasurementRow("Shalwar Gheera", measurement!['bodygheera']),
                              _buildMeasurementRow("Shalwar Gheera", measurement!['gheera']),
                            ]
                        ),
                      ],
                    ),
                    Expanded(child: _buildMeasurementRow("Note:", measurement!['ShalwarNote'])),

                  ],
                ),
              ),
            ] else ...[
              Container(
                child: Row(
                  children: [
                    Table(
                      columnWidths: {
                        0: FixedColumnWidth(MediaQuery.of(context).size.width*0.25), // Set the width of the Measurements column
                        1: FixedColumnWidth(MediaQuery.of(context).size.width*0.25)
                      },
                      children: [
                        TableRow(
                            children: [
                              _buildMeasurementRow("Trouser Lambai", measurement!['bodytrouserLambai']),
                              _buildMeasurementRow("Trouser Lambai", measurement!['trouserLambai']),
                            ]
                        ),
                        TableRow(
                            children: [
                              _buildMeasurementRow("Pauncha", measurement!['bodypauncha']),
                              _buildMeasurementRow("Pauncha", measurement!['pauncha']),
                            ]
                        ),
                        TableRow(
                            children: [
                              _buildMeasurementRow("Hip", measurement!['bodyhip']),
                              _buildMeasurementRow("Hip", measurement!['hip']),
                            ]
                        ),
                      ],
                    ),
                    Expanded(child: _buildMeasurementRow("Note:", measurement!['ShalwarNote'])),
                  ],
                ),
              ),

            ],
            _buildCheckbox('Trouser Pocket', measurement!['trouserPocket']),
            _buildCheckbox('Elastic + Doori', measurement!['elasticDoori']),

          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontFamily: 'lora',fontSize: 28,fontWeight: FontWeight.bold)),
          Text(value.toString(), style: GoogleFonts.lora(fontSize: 22, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool? value) {
    return CheckboxListTile(
      title: Text(title, style: TextStyle(color: Colors.black,fontFamily: 'lora',fontSize: 18,fontWeight: FontWeight.bold),),
      value: value ?? false,
      onChanged: null, // Disable interaction
      controlAffinity: ListTileControlAffinity.leading, // Place checkbox on the left
    );
  }

  Widget _buildRadioGroup(String title, List<String> options, String groupValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'lora',fontSize: 18)),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'lora',fontSize: 18)),
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
