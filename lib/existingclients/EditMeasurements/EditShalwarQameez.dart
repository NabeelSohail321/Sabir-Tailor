import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/MeasurementProvider.dart';



class ShalwarQameezMeasurementForm extends StatefulWidget {
  Map<dynamic, dynamic> measurement;

  ShalwarQameezMeasurementForm({required this.measurement});

  @override
  _ShalwarQameezMeasurementFormState createState() => _ShalwarQameezMeasurementFormState();
}

class _ShalwarQameezMeasurementFormState extends State<ShalwarQameezMeasurementForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shalwar Qameez Form", style: GoogleFonts.lora()),
        titleTextStyle: TextStyle(
          fontSize: 25,
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
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          MeasurementForm(measurement: widget.measurement,), // Assuming MeasurementForm is another widget you have defined.
        ],
      ),
    );
  }
}


class MeasurementForm extends StatefulWidget {
  Map<dynamic, dynamic> measurement;

  MeasurementForm({required this.measurement});

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

  final TextEditingController bshalwarLambaiController = TextEditingController();
  final TextEditingController bpaunchaController = TextEditingController();
  final TextEditingController bgheeraController = TextEditingController();
  final TextEditingController bhipController = TextEditingController();
  final TextEditingController btrouserLambaiController = TextEditingController();
  final TextEditingController bShalwarNoteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedKalarOrBeen = widget.measurement['selectedKalarOrBeen'] ?? 'Kalar';
    selectedDamanStyle = widget.measurement['selectedDamanStyle'] ?? 'Default'; // Provide a default
    selectedSilaiType = widget.measurement['selectedSilaiType'] ?? 'Double Silai';
    kaff = widget.measurement['kaff'] ?? false;
    shalwarPocket = widget.measurement['shalwarPocket'] ?? false;
    frontPocket = widget.measurement['frontPocket'] ?? false;
    sidePocket = widget.measurement['sidePocket'] ?? false;
    selectedBottomType = widget.measurement['selectedBottomType'] ?? 'Shalwar';
    trouserPocket = widget.measurement['trouserPocket'] ?? false;
    elasticDoori = widget.measurement['elasticDoori'] ?? false;

    // Initialize controllers
    qameezLambaiController.text = widget.measurement['qameezLambai'] ?? '';
    chaatiController.text = widget.measurement['chaati'] ?? '';
    kamarController.text = widget.measurement['kamar'] ?? '';
    damanController.text = widget.measurement['daman'] ?? '';
    bazuController.text = widget.measurement['bazu'] ?? '';
    teeraController.text = widget.measurement['teera'] ?? '';
    galaController.text = widget.measurement['gala'] ?? '';
    _QameezNoteController.text = widget.measurement['QameezNote'] ?? '';

    bqameezLambaiController.text = widget.measurement['bodyqameezLambai'] ?? '';
    bchaatiController.text = widget.measurement['bodychaati'] ?? '';
    bkamarController.text = widget.measurement['bodykamar'] ?? '';
    bdamanController.text = widget.measurement['bodydaman'] ?? '';
    bbazuController.text = widget.measurement['bodybazu'] ?? '';
    bteeraController.text = widget.measurement['bodyteera'] ?? '';
    bgalaController.text = widget.measurement['bodygala'] ?? '';

    serialNoController.text = widget.measurement['serialNo'] ?? '';
    nameController.text = widget.measurement['name'] ?? '';
    mobileNoController.text = widget.measurement['mobileNo'] ?? '';
    addressController.text = widget.measurement['address'] ?? '';

    shalwarLambaiController.text = widget.measurement['shalwarLambai'] ?? '';
    paunchaController.text = widget.measurement['pauncha'] ?? '';
    gheeraController.text = widget.measurement['gheera'] ?? '';
    hipController.text = widget.measurement['hip'] ?? '';
    trouserLambaiController.text = widget.measurement['trouserLambai'] ?? '';
    ShalwarNoteController.text = widget.measurement['ShalwarNote'] ?? '';


    bshalwarLambaiController.text = widget.measurement['bodyshalwarLambai'] ?? '';
    bpaunchaController.text = widget.measurement['bodypauncha'] ?? '';
    bgheeraController.text = widget.measurement['bodygheera'] ?? '';
    bhipController.text = widget.measurement['bodyhip'] ?? '';
    btrouserLambaiController.text = widget.measurement['bodytrouserLambai'] ?? '';
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
                      onTap: () {
                        if (true) {
                          // Create a map to store all the data
                          final ref =
                          FirebaseDatabase.instance.ref("measurements");

                          String id = widget.measurement['id'];
                          Map<String, dynamic> formData = {
                            'id': id,
                            'serialNo': serialNoController.text,
                            'name': nameController.text,
                            'mobileNo': mobileNoController.text,
                            'address': addressController.text,
                            'qameezLambai': qameezLambaiController.text.isNotEmpty?qameezLambaiController.text:'0',
                            'chaati': chaatiController.text.isNotEmpty?chaatiController.text:'0',
                            'kamar': kamarController.text.isNotEmpty? kamarController.text: '0',
                            'daman': damanController.text.isNotEmpty? damanController.text: '0',
                            'bazu': bazuController.text.isNotEmpty? bazuController.text: '0',
                            'teera': teeraController.text.isNotEmpty? teeraController.text: '0',
                            'gala': galaController.text.isNotEmpty? galaController.text: '0',
                            'bodyqameezLambai': bqameezLambaiController.text.isNotEmpty? bqameezLambaiController.text:'0',
                            'bodychaati': bchaatiController.text.isNotEmpty?bchaatiController.text:'0',
                            'bodykamar': bkamarController.text.isNotEmpty?bkamarController.text: '0',
                            'bodydaman': bdamanController.text.isNotEmpty?bdamanController.text:'0',
                            'bodybazu': bbazuController.text.isNotEmpty? bbazuController.text:'0',
                            'bodyteera': bteeraController.text.isNotEmpty? bteeraController.text: '0',
                            'bodygala': bgalaController.text.isNotEmpty?bgalaController.text:'0' ,
                            'kaff': kaff,
                            'shalwartype': selectedBottomType,
                            'shalwarPocket': shalwarPocket,
                            'frontPocket': frontPocket,
                            'sidePocket': sidePocket,
                            'selectedKalarOrBeen': selectedKalarOrBeen,
                            'selectedDamanStyle': selectedDamanStyle,
                            'selectedSilaiType': selectedSilaiType,
                            'shalwarLambai': shalwarLambaiController.text.isNotEmpty? shalwarLambaiController.text: '0',
                            'trouserLambai': trouserLambaiController.text.isNotEmpty?trouserLambaiController.text:'0',
                            'shalwarGhera': gheeraController.text.isNotEmpty ? gheeraController.text:'0',
                            'pauncha': paunchaController.text.isNotEmpty ? paunchaController.text : '0',
                            'gheera': gheeraController.text.isNotEmpty ? gheeraController.text:'0',
                            'hip': hipController.text.isNotEmpty? hipController.text:'0',
                            'bodyshalwarLambai': bshalwarLambaiController.text.isNotEmpty? bshalwarLambaiController.text: '0',
                            'bodytrouserLambai': btrouserLambaiController.text.isNotEmpty? btrouserLambaiController.text : '0',
                            'bodyshalwarGhera': bgheeraController.text.isNotEmpty? bgheeraController.text:'0',
                            'bodypauncha': bpaunchaController.text.isNotEmpty? bpaunchaController.text:'0',
                            'bodygheera': bgheeraController.text.isNotEmpty? bgheeraController.text : '0',
                            'bodyhip': hipController.text.isNotEmpty? hipController.text: '0',
                            'selectedBottomType': selectedBottomType,
                            'elasticDoori': elasticDoori,
                            'QameezNote': _QameezNoteController.text,
                            'ShalwarNote': ShalwarNoteController.text,
                            'trouserPocket': trouserPocket
                          };

                          // Store data in Firebase Realtime Database
                          ref
                              .child('ShalwarQameez/${id}')
                              .update(formData)
                              .then((value) {
                            // Clear all the text fields after successful submission
                            Provider.of<Measurementprovider>(context, listen: false)
                                .FetchMeausurements('ShalwarQameez');

                            // Reset checkbox and radio values
                            setState(() {

                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Data updated successfully')));
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                Text('Failed to submit data: $error')));
                          });
                        }
                      },
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
                          child: Text(
                            'Update',
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                  0: FixedColumnWidth(MediaQuery.of(context).size.width*0.25), // Set the width of the Measurements column
                  1: FixedColumnWidth(MediaQuery.of(context).size.width*0.25)
                },
                children: [
                  TableRow(children: [
                    Text("Body Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text("Stitching Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bqameezLambaiController,
                        decoration: InputDecoration(
                          labelText: 'Lambai',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: qameezLambaiController,
                        decoration: InputDecoration(
                          labelText: 'Lambai',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: chaatiController,
                        decoration: InputDecoration(
                          labelText: 'Chaati',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: kamarController,
                        decoration: InputDecoration(
                          labelText: 'Kamar',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: damanController,
                        decoration: InputDecoration(
                          labelText: 'Daman',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bazuController,
                        decoration: InputDecoration(
                          labelText: 'Bazu',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: teeraController,
                        decoration: InputDecoration(
                          labelText: 'Teera',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: galaController,
                        decoration: InputDecoration(
                          labelText: 'Gala',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
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
        //
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
            readOnly: true,
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
            readOnly: true,
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
            readOnly: true,
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
              child: selectedBottomType == 'Shalwar'? Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width*0.25), // Set the width of the Measurements column
                  1: FixedColumnWidth(MediaQuery.of(context).size.width*0.25),
                },
                children: [
                  TableRow(
                      children: [
                        Text("Body Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("Stitching Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ]
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: bshalwarLambaiController,
                          decoration: InputDecoration(
                            labelText: 'Shalwar Lambai',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: shalwarLambaiController,
                          decoration: InputDecoration(
                            labelText: 'Shalwar Lambai',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: paunchaController,
                          decoration: InputDecoration(
                            labelText: 'Pauncha',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: gheeraController,
                          decoration: InputDecoration(
                            labelText: 'Shalwar Gheera',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      )
                    ],
                  ),
                ],
              ):Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width*0.25), // Set the width of the Measurements column
                  1: FixedColumnWidth(MediaQuery.of(context).size.width*0.25),
                },
                children: [
                  TableRow(
                      children: [
                        Text("Body Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("Stitching Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ]
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: btrouserLambaiController,
                          decoration: InputDecoration(
                            labelText: 'Trouser Lambai',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: trouserLambaiController,
                          decoration: InputDecoration(
                            labelText: 'Trouser Lambai',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: paunchaController,
                          decoration: InputDecoration(
                            labelText: 'Pauncha',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: hipController,
                          decoration: InputDecoration(
                            labelText: 'Hip',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
