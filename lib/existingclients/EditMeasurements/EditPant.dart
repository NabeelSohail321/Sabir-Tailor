import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/MeasurementProvider.dart';

class PantsMeasurementForm extends StatefulWidget {
  Map<dynamic, dynamic> measurement;

  PantsMeasurementForm({required this.measurement});

  @override
  _PantsMeasurementFormState createState() => _PantsMeasurementFormState();
}

class _PantsMeasurementFormState extends State<PantsMeasurementForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pants Measurement Form", style: GoogleFonts.lora()),
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
            PantsForm(measurement: widget.measurement,), // Assuming PantsForm is another widget you have defined
          ],
        ),
      );
  }
}
class PantsForm extends StatefulWidget {
  Map<dynamic, dynamic> measurement;

  PantsForm({required this.measurement});

  @override
  _PantsFormState createState() => _PantsFormState();
}

class _PantsFormState extends State<PantsForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController serialNoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();


  final TextEditingController lambaiController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController kamarController = TextEditingController();
  final TextEditingController thaiController = TextEditingController();
  final TextEditingController paunchaController = TextEditingController();

  final TextEditingController blambaiController = TextEditingController();
  final TextEditingController bhipController = TextEditingController();
  final TextEditingController bkamarController = TextEditingController();
  final TextEditingController bthaiController = TextEditingController();
  final TextEditingController bpaunchaController = TextEditingController();

  final TextEditingController noteController = TextEditingController();

  // Checkbox for Smart Fitting
  bool smartFitting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serialNoController.text = widget.measurement['serialNo'] ?? '';
    nameController.text = widget.measurement['name'] ?? '';
    mobileNoController.text = widget.measurement['mobileNo'] ?? '';
    addressController.text = widget.measurement['address'] ?? '';
    lambaiController.text = widget.measurement['lambai'] ?? '';
    hipController.text = widget.measurement['hip'] ?? '';
    kamarController.text = widget.measurement['kamar'] ?? '';
    thaiController.text = widget.measurement['thai'] ?? '';
    paunchaController.text = widget.measurement['pauncha'] ?? '';

    blambaiController.text = widget.measurement['bodylambai'] ?? '';
    bhipController.text = widget.measurement['bodyhip'] ?? '';
    bkamarController.text = widget.measurement['bodykamar'] ?? '';
    bthaiController.text = widget.measurement['bodythai'] ?? '';
    bpaunchaController.text = widget.measurement['bodypauncha'] ?? '';


    noteController.text = widget.measurement['note'] ?? '';

    // Initialize smartFitting if it's in the measurement map
    smartFitting = widget.measurement['smartFitting'] ?? false;
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
            borderRadius: BorderRadius.circular(20),
          ),
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

                  // Pants Measurements Section
                  Center(
                    child: Text('Pants Measurements',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  _buildPantsMeasurements(),

                  // Submit Button
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPantsMeasurements() {
    return Column(
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

                  TableRow(
                      children: [
                        _buildTextField(blambaiController, 'Lambai',false),
                        _buildTextField(lambaiController, 'Lambai',false),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bhipController, 'Hip',false),
                        _buildTextField(hipController, 'Hip',false),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bkamarController, 'Kamar',false),
                        _buildTextField(kamarController, 'Kamar',false),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bthaiController, 'Thai',false),
                        _buildTextField(thaiController, 'Thai',false),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bpaunchaController, 'Pauncha',false),
                        _buildTextField(paunchaController, 'Pauncha',false),
                      ]
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 5,
                  ),
                ),
              ),
            ],
          ),
        ),




        // Checkbox for Smart Fitting
        // CheckboxListTile(
        //   title: Text('Smart Fitting'),
        //   value: smartFitting,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       smartFitting = value!;
        //     });
        //   },
        // ),

        // Note Field

      ],
    );
  }

  Widget _buildSubmitButton() {
    return Card(
      child: InkWell(
        onTap: () async {
          if(serialNoController.text.isEmpty||nameController.text.isEmpty||mobileNoController.text.isEmpty||addressController.text.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pleasse fill Client Information')));
          }
          else{
            if (true) {
              final ref = FirebaseDatabase.instance.ref("measurements");

              // Check if a record with the same serialNo already exists


              // If no existing record found, proceed with adding data
              String id = widget.measurement['id'];
              Map<String, dynamic> formData = {
                'id': id,
                'serialNo': serialNoController.text,
                'name': nameController.text,
                'mobileNo': mobileNoController.text,
                'address': addressController.text,
                'lambai': lambaiController.text.isNotEmpty? lambaiController.text: '0',
                'hip': hipController.text.isNotEmpty? hipController.text: '0',
                'kamar': kamarController.text.isNotEmpty ? kamarController.text : '0',
                'thai': thaiController.text.isNotEmpty? thaiController.text: '0',
                'pauncha': paunchaController.text.isNotEmpty? paunchaController.text: '0',
                'bodylambai': blambaiController.text.isNotEmpty? blambaiController.text: '0',
                'bodyhip': bhipController.text.isNotEmpty? bhipController.text: '0',
                'bodykamar': bkamarController.text.isNotEmpty? bkamarController.text: '0',
                'bodythai': bthaiController.text.isNotEmpty? bthaiController.text: '0',
                'bodypauncha': bpaunchaController.text.isNotEmpty? bpaunchaController.text: '0',
                'smartFitting': smartFitting,
                'note': noteController.text,
              };

              // Store data in Firebase Realtime Database
              await ref.child('Pants/$id').set(formData).then((value) {
                // Clear all the text fields after successful submission
                Provider.of<Measurementprovider>(context, listen: false)
                    .FetchMeausurements('Pants');

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data submitted successfully')));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit data: $error')));
              });

            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 50.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.greenAccent],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              'Update',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        _buildTextField(serialNoController, 'Serial No',true),
        _buildTextField(nameController, 'Name',true),
        _buildTextField(mobileNoController, 'Mobile No',true),
        _buildTextField(addressController, 'Address',true),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool readonly) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: readonly,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        keyboardType: label != 'Name' && label != 'Address' ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        inputFormatters: label != 'Name' && label != 'Address'
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))]
            : [],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}
