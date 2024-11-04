import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sabir_tailors/existingclients/EditMeasurements/EditSherwani.dart';
import '../../providers/MeasurementProvider.dart';
import '../ShowClientInfoInCurrentMeasurement/SherwaniMeasurementShowPage.dart';

class SherwaniData extends StatefulWidget {
  const SherwaniData({Key? key}) : super(key: key);

  @override
  State<SherwaniData> createState() => _SherwaniDataState();
}

class _SherwaniDataState extends State<SherwaniData> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Measurementprovider>(context, listen: false)
          .FetchMeausurements('Sherwani'); // Fetch measurements for Sherwani
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sherwani Measurements", style: GoogleFonts.lora()),
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
          } else if (measurementProvider.sherwani.isEmpty) { // Adjust according to your provider's property
            return Center(child: Text("No measurements"));
          } else {
            final filteredMeasurements = measurementProvider.sherwani
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
                        columnWidths: const {
                          0: FixedColumnWidth(100),
                          1: FixedColumnWidth(150),
                          2: FixedColumnWidth(150),
                          3: FixedColumnWidth(300),
                          4: FixedColumnWidth(300),
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
                                          // Navigate to Sherwani Measurement page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SherwaniMeasurementShowPage(serialNo: measurement['serialNo'].toString()),
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
                                              builder: (context) => SherwaniMeasurementForm(measurement: measurement),
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
