import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CoatMeasurementForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Coat Measurement Form", style: GoogleFonts.lora()),
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
  bool isLoading = false;

  // Controllers for form fields
  final TextEditingController serialNoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController lambaiController = TextEditingController();
  final TextEditingController chaatiController = TextEditingController();
  final TextEditingController kamarController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController bazuController = TextEditingController();
  final TextEditingController teeraController = TextEditingController();
  final TextEditingController galaController = TextEditingController();
  final TextEditingController crossBackController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Checkbox fields
  bool twoButtons = false;
  bool sideJak = false;
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
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildAdditionalFields(),
                  SizedBox(height: 20),

                  // Coat Measurements Section
                  Center(
                    child: Text('Coat Measurements',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  _buildCoatMeasurements(),

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

  Widget _buildCoatMeasurements() {
    return Column(
      children: [
        _buildTextField(lambaiController, 'Lambai'),
        _buildTextField(chaatiController, 'Chaati'),
        _buildTextField(kamarController, 'Kamar'),
        _buildTextField(hipController, 'Hip'),
        _buildTextField(bazuController, 'Baazu'),
        _buildTextField(teeraController, 'Teera'),
        _buildTextField(galaController, 'Gala'),
        _buildTextField(crossBackController, 'Cross Back'),

        // Checkbox Options
        CheckboxListTile(
          title: Text('2 Buttons'),
          value: twoButtons,
          onChanged: (bool? value) {
            setState(() {
              twoButtons = value!;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Side Jak'),
          value: sideJak,
          onChanged: (bool? value) {
            setState(() {
              sideJak = value!;
            });
          },
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

        // Note Field (Not Required)
        Padding(
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
            // No validation for the note field
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Card(
      child: InkWell(
        onTap: !isLoading? () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });
            // Create a map to store all the data
            final ref = FirebaseDatabase.instance.ref("measurements");

            // Check if a record with the same serialNo already exists
            DataSnapshot snapshot = await ref
                .child("Coat")
                .orderByChild('serialNo')
                .equalTo(serialNoController.text)
                .once()
                .then((value) => value.snapshot);

            if (snapshot.value == null) {
              final ref = FirebaseDatabase.instance.ref("measurements");
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
                'bazu': bazuController.text,
                'teera': teeraController.text,
                'gala': galaController.text,
                'crossBack': crossBackController.text,
                'twoButtons': twoButtons,
                'sideJak': sideJak,
                'fancyButton': fancyButton,
                'note': noteController.text,
              };

// Store data in Firebase Realtime Database
              ref.child('Coat/$id').set(formData).then((value) {
// Clear all the text fields after successful submission
                serialNoController.clear();
                nameController.clear();
                mobileNoController.clear();
                addressController.clear();
                lambaiController.clear();
                chaatiController.clear();
                kamarController.clear();
                hipController.clear();
                bazuController.clear();
                teeraController.clear();
                galaController.clear();
                crossBackController.clear();
                noteController.clear();

// Reset checkbox values
                setState(() {
                  twoButtons = false;
                  sideJak = false;
                  fancyButton = false;
                  isLoading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data submitted successfully')));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit data: $error')));
                setState(() {
                  isLoading = false;
                });
              });
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Serial number already exists')));
              setState(() {
                isLoading = false;
              });
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
        keyboardType: label != 'Name' && label != 'Address'
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: label != 'Name' && label != 'Address'
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        // Validator to check if the field is empty
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
