import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sabir_tailors/existingclients/EditMeasurements/EditShalwarQameez.dart';
import 'package:sabir_tailors/providers/MeasurementProvider.dart';

import '../ShowClientInfoInCurrentMeasurement/ShalwarQameezMeasurementShowPage.dart';

class ShalwarQameezData extends StatefulWidget {
  const ShalwarQameezData({super.key});

  @override
  State<ShalwarQameezData> createState() => _ShalwarQameezDataState();
}

class _ShalwarQameezDataState extends State<ShalwarQameezData> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Measurementprovider>(context, listen: false)
          .FetchMeausurements('ShalwarQameez');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shalwar Qameez Measurements", style: GoogleFonts.lora()),
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Consumer<Measurementprovider>(
        builder: (context, measurementProvider, child) {
          if (measurementProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (measurementProvider.shalwarQameez.isEmpty) {
            return Center(child: Text("No measurements"));
          } else {
            // Filtered measurements based on the search query
            final filteredMeasurements = measurementProvider.shalwarQameez
                .where((measurement) =>
                measurement['serialNo']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.toString().toLowerCase()))
                .toList();

            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Search by Serial No",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.0), // Spacing between the search field and the table
                    SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FixedColumnWidth(100), // Fixed width for Serial No
                          1: FixedColumnWidth(150), // Fixed width for Name
                          2: FixedColumnWidth(150), // Fixed width for Mobile No
                          3: FixedColumnWidth(300), // Fixed width for Address
                          4: FixedColumnWidth(300), // Fixed width for Actions
                        },
                        children: [
                          // Table Header
                          TableRow(
                            decoration: BoxDecoration(color: Colors.lightBlueAccent),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Serial No',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Name',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Mobile No',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Address',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Actions',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Table Rows for filtered measurements
                          for (var measurement in filteredMeasurements)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(measurement['serialNo'], style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(measurement['name'], style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(measurement['mobileNo'], style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(measurement['address'], style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigate to Show Measurements page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShalwarQameezMeasurementPage( serialNo: measurement['serialNo'].toString(),),
                                            ),
                                          );
                                        },
                                        child: Text("Show Measurements"),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigate to Edit Measurement page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShalwarQameezMeasurementForm(measurement: measurement),
                                            ),
                                          );
                                        },
                                        child: Text("Edit"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// Replace these classes with your actual implementations
