import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WaskitMeasurementForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Waskit Measurement Form", style: GoogleFonts.lora()),
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
  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;
  final TextEditingController serialNoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController lambaiController = TextEditingController();
  final TextEditingController chaatiController = TextEditingController();
  final TextEditingController kamarController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController teeraController = TextEditingController();
  final TextEditingController galaController = TextEditingController();


  final TextEditingController blambaiController = TextEditingController();
  final TextEditingController bchaatiController = TextEditingController();
  final TextEditingController bkamarController = TextEditingController();
  final TextEditingController bhipController = TextEditingController();
  final TextEditingController bteeraController = TextEditingController();
  final TextEditingController bgalaController = TextEditingController();
  
  
  final TextEditingController noteController = TextEditingController();

  String? galaType = 'Been';
  bool fancyButton = false;

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
                  Center(
                    child: Text('Waskit Measurements',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  _buildWaskitMeasurements(),
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

  Widget _buildWaskitMeasurements() {
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
                        _buildTextField(bchaatiController, 'Chaati'),
                        _buildTextField(chaatiController, 'Chaati'),
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
                        _buildTextField(bhipController, 'Hip'),
                        _buildTextField(hipController, 'Hip'),
                      ]
                  ),
                  TableRow(
                      children: [
                       _buildTextField(bteeraController, 'Teera'),
                        _buildTextField(teeraController, 'Teera'),
                      ]
                  ),
                  TableRow(
                      children: [
                        _buildTextField(bgalaController, 'Gala'),
                        _buildTextField(galaController, 'Gala'),
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
        
        
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Text("Gala Type", style: TextStyle(fontSize: 18,fontFamily: 'lora',fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text('Been'),
                leading: Radio<String>(
                  value: 'Been',
                  groupValue: galaType,
                  onChanged: (String? value) {
                    setState(() {
                      galaType = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Gool Gala'),
                leading: Radio<String>(
                  value: 'Gool Gala',
                  groupValue: galaType,
                  onChanged: (String? value) {
                    setState(() {
                      galaType = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('V Gala'),
                leading: Radio<String>(
                  value: 'V Gala',
                  groupValue: galaType,
                  onChanged: (String? value) {
                    setState(() {
                      galaType = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        CheckboxListTile(
          title: Text('Fancy Button'),
          value: fancyButton,
          onChanged: (bool? value) {
            setState(() {
              fancyButton = value!;
            });
          },
        ),

        
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Card(
      child: InkWell(
        onTap: !isLoading? () async {
          if(lambaiController.text.isEmpty||blambaiController.text.isEmpty||chaatiController.text.isEmpty||bchaatiController.text.isEmpty||kamarController.text.isEmpty||bkamarController.text.isEmpty||hipController.text.isEmpty||bhipController.text.isEmpty||teeraController.text.isEmpty||bteeraController.text.isEmpty||galaController.text.isEmpty||bgalaController.text.isEmpty||serialNoController.text.isEmpty||nameController.text.isEmpty||mobileNoController.text.isEmpty||addressController.text.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pleasse fill all the feilds')));
          }
          else{
            if (_formKey.currentState!.validate()) {
              setState(() {
                isLoading=true;
              });
              final ref = FirebaseDatabase.instance.ref("measurements");

              DataSnapshot snapshot = await ref
                  .child("Waskit")
                  .orderByChild('serialNo')
                  .equalTo(serialNoController.text)
                  .once()
                  .then((value) => value.snapshot);

              if (snapshot.value == null) {
                String id = ref.push().key.toString();
                Map<String, dynamic> formData = {
                  'id': id,
                  'serialNo': serialNoController.text,
                  'name': nameController.text,
                  'mobileNo': mobileNoController.text,
                  'address': addressController.text,
                  'lambai': lambaiController.text,
                  'chaati': chaatiController.text,
                  'kamar': kamarController.text,
                  'hip': hipController.text,
                  'teera': teeraController.text,
                  'gala': galaController.text,
                  'bodylambai': blambaiController.text,
                  'bodychaati': bchaatiController.text,
                  'bodykamar': bkamarController.text,
                  'bodyhip': bhipController.text,
                  'bodyteera': bteeraController.text,
                  'bodygala': bgalaController.text,
                  'galaType': galaType,
                  'fancyButton': fancyButton,
                  'note': noteController.text,
                };

                await ref.child('Waskit/$id').set(formData).then((value) {
                  serialNoController.clear();
                  nameController.clear();
                  mobileNoController.clear();
                  addressController.clear();
                  lambaiController.clear();
                  chaatiController.clear();
                  kamarController.clear();
                  hipController.clear();
                  teeraController.clear();
                  galaController.clear();
                  blambaiController.clear();
                  bchaatiController.clear();
                  bkamarController.clear();
                  bhipController.clear();
                  bteeraController.clear();
                  bgalaController.clear();
                  noteController.clear();

                  setState(() {
                    galaType = 'Been';
                    fancyButton = false;
                    isLoading = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data submitted successfully')));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to submit data: $error')));
                  setState(() {
                    isLoading=false;
                  });
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Serial number already exists')));
                setState(() {
                  isLoading=false;
                });
              }
            }
          }
        }:(){},
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
        keyboardType: label != 'Name' && label != 'Address' ? TextInputType.number : TextInputType.text,
        inputFormatters: label != 'Name' && label != 'Address'
            ? [FilteringTextInputFormatter.digitsOnly]
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
