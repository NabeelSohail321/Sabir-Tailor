import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PantsMeasurementForm extends StatelessWidget {
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
            PantsForm(),
          ],
        ),
      );
  }
}

class PantsForm extends StatefulWidget {
  @override
  _PantsFormState createState() => _PantsFormState();
}

class _PantsFormState extends State<PantsForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
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

  final drefQ = FirebaseDatabase.instance.ref('measurements').child('ShalwarQameez');
  final drefC = FirebaseDatabase.instance.ref('measurements').child('Coat');
  final drefW = FirebaseDatabase.instance.ref('measurements').child('Waskit');
  final drefS = FirebaseDatabase.instance.ref('measurements').child('Sherwani');
  final drefP = FirebaseDatabase.instance.ref('measurements').child('Pants');

  int? newSerial;

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
                        _buildTextField(blambaiController, 'Lambai'),
                        _buildTextField(lambaiController, 'Lambai'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bhipController, 'Hip'),
                        _buildTextField(hipController, 'Hip'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bkamarController, 'Kamar'),
                        _buildTextField(kamarController, 'Kamar'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bthaiController, 'Thai'),
                        _buildTextField(thaiController, 'Thai'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bpaunchaController, 'Pauncha'),
                        _buildTextField(paunchaController, 'Pauncha'),
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
        onTap: !isLoading? () async {
          if(serialNoController.text.isEmpty||nameController.text.isEmpty||mobileNoController.text.isEmpty||addressController.text.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pleasse fill Client Information')));
          }else{
            if (true) {
              setState(() {
                isLoading = true;
              });
              final ref = FirebaseDatabase.instance.ref("measurements");

              // Check if a record with the same serialNo already exists
              DataSnapshot snapshot = await ref
                  .child("Pants")
                  .orderByChild('serialNo')
                  .equalTo(serialNoController.text)
                  .once()
                  .then((value) => value.snapshot);

              // If no existing record found, proceed with adding data
              if (snapshot.value == null) {
                String id = ref.push().key.toString();
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
                  serialNoController.clear();
                  nameController.clear();
                  mobileNoController.clear();
                  addressController.clear();
                  lambaiController.clear();
                  hipController.clear();
                  kamarController.clear();
                  thaiController.clear();
                  paunchaController.clear();
                  noteController.clear();

                  blambaiController.clear();
                  bhipController.clear();
                  bkamarController.clear();
                  bthaiController.clear();
                  bpaunchaController.clear();

                  // Reset checkbox value
                  setState(() {
                    smartFitting = false;
                    isLoading = false;
                  });

                  getNewSerial();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data submitted successfully')));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to submit data: $error')));
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Serial number already exists')));
              }
            }
          }
        }: (){},
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
            child: !isLoading? Text(
              'Submit',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ): CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        _buildTextField(serialNoController, 'Serial No'),
        _buildTextField(nameController, 'Name'),
        _buildTextField(mobileNoController, 'Mobile No'),
        _buildTextField(addressController, 'Address'),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: label == 'Serial No' ? true:false,
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
