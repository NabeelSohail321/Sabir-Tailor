import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sabir_tailors/existingclients/EditMeasurements/EditPant.dart';
import 'package:sabir_tailors/providers/MeasurementProvider.dart';

import '../ShowClientInfoInCurrentMeasurement/PantMeasurementShowPage.dart';

class PantData extends StatefulWidget {
  const PantData({super.key});

  @override
  State<PantData> createState() => _PantDataState();
}

class _PantDataState extends State<PantData> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Measurementprovider>(context, listen: false)
          .FetchMeausurements('Pants'); // Fetch measurements for Pant
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pant Measurements", style: GoogleFonts.lora()),
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
          } else if (measurementProvider.pants.isEmpty) { // Adjust according to your provider's property
            return Center(child: Text("No measurements"));
          } else {
            final filteredMeasurements = measurementProvider.pants
                .where((measurement) =>
                measurement['serialNo']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();

            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                    SizedBox(height: 16.0),
                    SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FixedColumnWidth(MediaQuery.of(context).size.width*0.1), // Fixed width for Serial No
                          1: FixedColumnWidth(MediaQuery.of(context).size.width*0.1), // Fixed width for Name
                          2: FixedColumnWidth(MediaQuery.of(context).size.width*0.1), // Fixed width for Mobile No
                          3: FixedColumnWidth(MediaQuery.of(context).size.width*0.2), // Fixed width for Address
                          4: FixedColumnWidth(MediaQuery.of(context).size.width*0.2),
                        },
                        children: [
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
                                          // Navigate to Pant Measurement page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PantMeasurementShowPage(serialNo: measurement['serialNo'].toString()),
                                            ),
                                          );
                                        },
                                        child: Text("Show Measurements"),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigate to Edit Measurement page (if applicable)
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PantsMeasurementForm(measurement: measurement),
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
