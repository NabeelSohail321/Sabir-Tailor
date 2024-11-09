import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ShalwarQameezMeasurementForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shalwar Qameez Form", style: GoogleFonts.lora()),
        titleTextStyle: TextStyle(
          fontSize: 25, // Responsive font size for title
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
                // Add your image path here
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), // Adjust opacity here
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          MeasurementForm(),
        ],
      ),
    );
  }
}

class MeasurementForm extends StatefulWidget {
  @override
  _MeasurementFormState createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
  // Qameez Measurements
  String selectedKalarOrBeen = 'Kalar';
  String selectedDamanStyle = 'Gool';
  String selectedSilaiType = 'Double Silai';
  bool kaff = false;
  bool shalwarPocket = false;
  bool frontPocket = false;
  bool sidePocket = false;

  // Shalwar or Trouser Measurements
  String selectedBottomType = 'Shalwar'; // Shalwar or Trouser
  bool trouserPocket = false;
  bool elasticDoori = false;

  // Form keys
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController qameezLambaiController = TextEditingController();
  final TextEditingController chaatiController = TextEditingController();
  final TextEditingController kamarController = TextEditingController();
  final TextEditingController damanController = TextEditingController();
  final TextEditingController bazuController = TextEditingController();
  final TextEditingController teeraController = TextEditingController();
  final TextEditingController galaController = TextEditingController();
  final TextEditingController _QameezNoteController = TextEditingController();

  final TextEditingController bqameezLambaiController = TextEditingController();
  final TextEditingController bchaatiController = TextEditingController();
  final TextEditingController bkamarController = TextEditingController();
  final TextEditingController bdamanController = TextEditingController();
  final TextEditingController bbazuController = TextEditingController();
  final TextEditingController bteeraController = TextEditingController();
  final TextEditingController bgalaController = TextEditingController();

  final TextEditingController serialNoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController shalwarLambaiController = TextEditingController();
  final TextEditingController paunchaController = TextEditingController();
  final TextEditingController gheeraController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController trouserLambaiController = TextEditingController();
  final TextEditingController ShalwarNoteController = TextEditingController();

  final TextEditingController bshalwarLambaiController =
      TextEditingController();
  final TextEditingController bpaunchaController = TextEditingController();
  final TextEditingController bgheeraController = TextEditingController();
  final TextEditingController bhipController = TextEditingController();
  final TextEditingController btrouserLambaiController =
      TextEditingController();
  final TextEditingController bShalwarNoteController = TextEditingController();
  bool isLoading = false;
  int? newSerial;
  final drefQ = FirebaseDatabase.instance.ref('measurements').child('ShalwarQameez');
  final drefC = FirebaseDatabase.instance.ref('measurements').child('Coat');
  final drefW = FirebaseDatabase.instance.ref('measurements').child('Waskit');
  final drefS = FirebaseDatabase.instance.ref('measurements').child('Sherwani');
  final drefP = FirebaseDatabase.instance.ref('measurements').child('Pants');



  Future<void> getNewSerial() async {
    List<int> serials = [];

    // Helper function to get the serial number from the last node in a reference
    Future<void> addSerialFromReference(DatabaseReference ref) async {
      final snapshot = await ref.orderByKey().limitToLast(1).get();
      if (snapshot.exists) {
        // Loop through the snapshot to access each child node
        snapshot.children.forEach((child) {
          final data = child.value as Map<dynamic, dynamic>;
          if (data.containsKey('serialNo')) {
            // Convert serialNo to an int and add to serials list
            int serialNo = int.tryParse(data['serialNo'].toString()) ?? 0;
            serials.add(serialNo);
          }
        });
      }
    }

    // Call the helper function for each reference
    await addSerialFromReference(drefQ);
    await addSerialFromReference(drefC);
    await addSerialFromReference(drefW);
    await addSerialFromReference(drefS);
    await addSerialFromReference(drefP);

    // Find the maximum number in the serials list and add 1 to it
    int newSerial = serials.isNotEmpty ? (serials.reduce((a, b) => a > b ? a : b) + 1) : 1;

    // Update the serial number controller with the new serial number
    serialNoController.text = newSerial.toString();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewSerial();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 8.0),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildAdditionalFields(),
                  SizedBox(height: 20),
                  // Qameez Section
                  Center(
                      child: Text('Qameez Measurements',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  _buildQameezSection(),
                  SizedBox(height: 20),

                  // Bottom Type Section (Shalwar/Trouser)
                  Text('Shalwar / Trouser',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildBottomSection(),

                  // Submit Button
                  SizedBox(height: 20),
                  Card(
                    child: InkWell(
                      onTap: !isLoading
                          ? () async {
                              if (serialNoController.text.isEmpty ||
                                  nameController.text.isEmpty ||
                                  mobileNoController.text.isEmpty ||
                                  addressController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Please Client Information')));
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                if (true) {
                                  // Create a map to store all the data
                                  final ref = FirebaseDatabase.instance
                                      .ref("measurements");

                                  // Check if a record with the same serialNo already exists
                                  DataSnapshot snapshot = await ref
                                      .child("ShalwarQameez")
                                      .orderByChild('serialNo')
                                      .equalTo(serialNoController.text)
                                      .once()
                                      .then((value) => value.snapshot);

                                  if (snapshot.value == null) {
                                    final ref = FirebaseDatabase.instance
                                        .ref("measurements");

                                    String id = ref.push().key.toString();
                                    Map<String, dynamic> formData = {
                                      'id': id,
                                      'serialNo': serialNoController.text,
                                      'name': nameController.text,
                                      'mobileNo': mobileNoController.text,
                                      'address': addressController.text,
                                      'qameezLambai':
                                          qameezLambaiController.text.isNotEmpty
                                              ? qameezLambaiController.text
                                              : '0',
                                      'chaati': chaatiController.text.isNotEmpty
                                          ? chaatiController.text
                                          : '0',
                                      'kamar': kamarController.text.isNotEmpty
                                          ? kamarController.text
                                          : '0',
                                      'daman': damanController.text.isNotEmpty
                                          ? damanController.text
                                          : '0',
                                      'bazu': bazuController.text.isNotEmpty
                                          ? bazuController.text
                                          : '0',
                                      'teera': teeraController.text.isNotEmpty
                                          ? teeraController.text
                                          : '0',
                                      'gala': galaController.text.isNotEmpty
                                          ? galaController.text
                                          : '0',
                                      'bodyqameezLambai':
                                          bqameezLambaiController
                                                  .text.isNotEmpty
                                              ? bqameezLambaiController.text
                                              : '0',
                                      'bodychaati':
                                          bchaatiController.text.isNotEmpty
                                              ? bchaatiController.text
                                              : '0',
                                      'bodykamar':
                                          bkamarController.text.isNotEmpty
                                              ? bkamarController.text
                                              : '0',
                                      'bodydaman':
                                          bdamanController.text.isNotEmpty
                                              ? bdamanController.text
                                              : '0',
                                      'bodybazu':
                                          bbazuController.text.isNotEmpty
                                              ? bbazuController.text
                                              : '0',
                                      'bodyteera':
                                          bteeraController.text.isNotEmpty
                                              ? bteeraController.text
                                              : '0',
                                      'bodygala':
                                          bgalaController.text.isNotEmpty
                                              ? bgalaController.text
                                              : '0',
                                      'kaff': kaff,
                                      'shalwartype': selectedBottomType,
                                      'shalwarPocket': shalwarPocket,
                                      'frontPocket': frontPocket,
                                      'sidePocket': sidePocket,
                                      'selectedKalarOrBeen':
                                          selectedKalarOrBeen,
                                      'selectedDamanStyle': selectedDamanStyle,
                                      'selectedSilaiType': selectedSilaiType,
                                      'shalwarLambai': shalwarLambaiController
                                              .text.isNotEmpty
                                          ? shalwarLambaiController.text
                                          : '0',
                                      'trouserLambai': trouserLambaiController
                                              .text.isNotEmpty
                                          ? trouserLambaiController.text
                                          : '0',
                                      'shalwarGhera':
                                          gheeraController.text.isNotEmpty
                                              ? gheeraController.text
                                              : '0',
                                      'pauncha':
                                          paunchaController.text.isNotEmpty
                                              ? paunchaController.text
                                              : '0',
                                      'gheera': gheeraController.text.isNotEmpty
                                          ? gheeraController.text
                                          : '0',
                                      'hip': hipController.text.isNotEmpty
                                          ? hipController.text
                                          : '0',
                                      'bodyshalwarLambai':
                                          bshalwarLambaiController
                                                  .text.isNotEmpty
                                              ? bshalwarLambaiController.text
                                              : '0',
                                      'bodytrouserLambai':
                                          btrouserLambaiController
                                                  .text.isNotEmpty
                                              ? btrouserLambaiController.text
                                              : '0',
                                      'bodyshalwarGhera':
                                          bgheeraController.text.isNotEmpty
                                              ? bgheeraController.text
                                              : '0',
                                      'bodypauncha':
                                          bpaunchaController.text.isNotEmpty
                                              ? bpaunchaController.text
                                              : '0',
                                      'bodygheera':
                                          bgheeraController.text.isNotEmpty
                                              ? bgheeraController.text
                                              : '0',
                                      'bodyhip': hipController.text.isNotEmpty
                                          ? hipController.text
                                          : '0',
                                      'selectedBottomType': selectedBottomType,
                                      'elasticDoori': elasticDoori,
                                      'QameezNote': _QameezNoteController.text,
                                      'ShalwarNote': ShalwarNoteController.text,
                                      'trouserPocket': trouserPocket
                                    };

// Store data in Firebase Realtime Database
                                    ref
                                        .child('ShalwarQameez/${id}')
                                        .set(formData)
                                        .then((value) {
// Clear all the text fields after successful submission
                                      serialNoController.clear();
                                      nameController.clear();
                                      mobileNoController.clear();
                                      addressController.clear();
                                      qameezLambaiController.clear();
                                      chaatiController.clear();
                                      kamarController.clear();
                                      damanController.clear();
                                      bazuController.clear();
                                      teeraController.clear();
                                      galaController.clear();
                                      shalwarLambaiController.clear();
                                      paunchaController.clear();
                                      gheeraController.clear();
                                      hipController.clear();
                                      bgheeraController.clear();
                                      bpaunchaController.clear();
                                      bshalwarLambaiController.clear();
                                      bgalaController.clear();
                                      bteeraController.clear();
                                      bbazuController.clear();
                                      bdamanController.clear();
                                      bkamarController.clear();
                                      bchaatiController.clear();
                                      bhipController.clear();
                                      bqameezLambaiController.clear();
                                      btrouserLambaiController.clear();
// Reset checkbox and radio values
                                      setState(() {
                                        kaff = false;
                                        shalwarPocket = false;
                                        frontPocket = false;
                                        sidePocket = false;
                                        elasticDoori = false;
                                        selectedBottomType =
                                            'Shalwar'; // Reset to default
                                        selectedKalarOrBeen = 'Kalar';
                                        selectedDamanStyle = 'Gool';
                                        selectedSilaiType = 'Double Silai';
                                        isLoading = false;
                                      });
                                      getNewSerial();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Data submitted successfully')));
                                    }).catchError((error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Failed to submit data: $error')));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Serial Already exists')));
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Button not working')));
                                }
                              }
                            }
                          : () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
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
                          child: !isLoading
                              ? Text(
                                  'Submit',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Qameez section form fields
  Widget _buildQameezSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            children: [
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.25),
                  // Set the width of the Measurements column
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.25)
                },
                children: [
                  TableRow(children: [
                    Text("Body Measurements",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text("Stitching Measurements",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bqameezLambaiController,
                        decoration: InputDecoration(
                          labelText: 'Lambai',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: qameezLambaiController,
                        decoration: InputDecoration(
                          labelText: 'Lambai',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bchaatiController,
                        decoration: InputDecoration(
                          labelText: 'Chaati',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: chaatiController,
                        decoration: InputDecoration(
                          labelText: 'Chaati',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bkamarController,
                        decoration: InputDecoration(
                          labelText: 'Kamar',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: kamarController,
                        decoration: InputDecoration(
                          labelText: 'Kamar',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bdamanController,
                        decoration: InputDecoration(
                          labelText: 'Daman',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: damanController,
                        decoration: InputDecoration(
                          labelText: 'Daman',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bbazuController,
                        decoration: InputDecoration(
                          labelText: 'Bazu',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bazuController,
                        decoration: InputDecoration(
                          labelText: 'Bazu',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bteeraController,
                        decoration: InputDecoration(
                          labelText: 'Teera',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: teeraController,
                        decoration: InputDecoration(
                          labelText: 'Teera',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bgalaController,
                        decoration: InputDecoration(
                          labelText: 'Gala',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: galaController,
                        decoration: InputDecoration(
                          labelText: 'Gala',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'))
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ]),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _QameezNoteController,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      hintText: 'Enter any additional information or note here',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        // The rest of your widgets
        // CheckboxListTile(
        //   title: Text('Kaff'),
        //   value: kaff,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       kaff = value!;
        //     });
        //   },
        // ),
        // CheckboxListTile(
        //   title: Text('Shalwar Pocket'),
        //   value: shalwarPocket,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       shalwarPocket = value!;
        //     });
        //   },
        // ),
        // CheckboxListTile(
        //   title: Text('Front Pocket'),
        //   value: frontPocket,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       frontPocket = value!;
        //     });
        //   },
        // ),
        // CheckboxListTile(
        //   title: Text('Side Pocket'),
        //   value: sidePocket,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       sidePocket = value!;
        //     });
        //   },
        // ),

        // _buildRadioGroup(
        //   title: 'Kalar or Been',
        //   options: ['Kalar', 'Been'],
        //   groupValue: selectedKalarOrBeen,
        //   onChanged: (value) {
        //     setState(() {
        //       selectedKalarOrBeen = value!;
        //     });
        //   },
        // ),
        // _buildRadioGroup(
        //   title: 'Daman Style',
        //   options: ['Gool', 'Choras'],
        //   groupValue: selectedDamanStyle,
        //   onChanged: (value) {
        //     setState(() {
        //       selectedDamanStyle = value!;
        //     });
        //   },
        // ),
        // _buildRadioGroup(
        //   title: 'Silai Type',
        //   options: ['Double Silai', 'Triple Silai'],
        //   groupValue: selectedSilaiType,
        //   onChanged: (value) {
        //     setState(() {
        //       selectedSilaiType = value!;
        //     });
        //   },
        // ),
        // Continue with other CheckboxListTiles, RadioGroups, and other widgets
      ],
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(

            readOnly: true,
            controller: serialNoController,
            decoration: InputDecoration(
              labelText: 'Serial No',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allows only digits
            ],
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.name,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: mobileNoController,
            decoration: InputDecoration(
              labelText: 'Mobile No',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allows only digits
            ],
            keyboardType: TextInputType.phone,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.streetAddress,
          ),
        ),
      ],
    );
  }

  // Shalwar/Trouser section form fields
  Widget _buildBottomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRadioGroup(
          title: 'Bottom Type',
          options: ['Shalwar', 'Trouser'],
          groupValue: selectedBottomType,
          onChanged: (value) {
            setState(() {
              selectedBottomType = value!;
            });
          },
        ),
        Row(
          children: [
            Container(
              child: selectedBottomType == 'Shalwar'
                  ? Table(
                      columnWidths: {
                        0: FixedColumnWidth(
                            MediaQuery.of(context).size.width * 0.25),
                        // Set the width of the Measurements column
                        1: FixedColumnWidth(
                            MediaQuery.of(context).size.width * 0.25),
                      },
                      children: [
                        TableRow(children: [
                          Text("Body Measurements",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text("Stitching Measurements",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ]),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: bshalwarLambaiController,
                                decoration: InputDecoration(
                                  labelText: 'Shalwar Lambai',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: shalwarLambaiController,
                                decoration: InputDecoration(
                                  labelText: 'Shalwar Lambai',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: bpaunchaController,
                                decoration: InputDecoration(
                                  labelText: 'Pauncha',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: paunchaController,
                                decoration: InputDecoration(
                                  labelText: 'Pauncha',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: bgheeraController,
                                decoration: InputDecoration(
                                  labelText: 'Shalwar Gheera',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: gheeraController,
                                decoration: InputDecoration(
                                  labelText: 'Shalwar Gheera',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Table(
                      columnWidths: {
                        0: FixedColumnWidth(
                            MediaQuery.of(context).size.width * 0.25),
                        // Set the width of the Measurements column
                        1: FixedColumnWidth(
                            MediaQuery.of(context).size.width * 0.25),
                      },
                      children: [
                        TableRow(children: [
                          Text("Body Measurements",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text("Stitching Measurements",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ]),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: btrouserLambaiController,
                                decoration: InputDecoration(
                                  labelText: 'Trouser Lambai',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: trouserLambaiController,
                                decoration: InputDecoration(
                                  labelText: 'Trouser Lambai',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: bpaunchaController,
                                decoration: InputDecoration(
                                  labelText: 'Pauncha',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: paunchaController,
                                decoration: InputDecoration(
                                  labelText: 'Pauncha',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: bhipController,
                                decoration: InputDecoration(
                                  labelText: 'Hip',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: hipController,
                                decoration: InputDecoration(
                                  labelText: 'Hip',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: ShalwarNoteController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    hintText: 'Enter any additional information or note here',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 10,
                ),
              ),
            ),
          ],
        ),

        // CheckboxListTile(
        //   title: Text('Trouser Pocket'),
        //   value: trouserPocket,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       trouserPocket = value!;
        //     });
        //   },
        // ),
        // CheckboxListTile(
        //   title: Text('Elastic + Doori'),
        //   value: elasticDoori,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       elasticDoori = value!;
        //     });
        //   },
        // ),
      ],
    );
  }

  // Radio group widget for multiple choices
  Widget _buildRadioGroup(
      {required String title,
      required List<String> options,
      required String groupValue,
      required void Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ...options.map((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: groupValue,
              onChanged: onChanged,
            )),
      ],
    );
  }
}
