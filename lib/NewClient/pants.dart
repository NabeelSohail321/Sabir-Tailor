import 'package:firebase_database/firebase_database.dart';
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

  bool isLoading = true;
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
  final TextEditingController noteController = TextEditingController();

  // Checkbox for Smart Fitting
  bool smartFitting = false;

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
        _buildTextField(lambaiController, 'Lambai'),
        _buildTextField(hipController, 'Hip'),
        _buildTextField(kamarController, 'Kamar'),
        _buildTextField(thaiController, 'Thai'),
        _buildTextField(paunchaController, 'Pauncha'),

        // Checkbox for Smart Fitting
        CheckboxListTile(
          title: Text('Smart Fitting'),
          value: smartFitting,
          onChanged: (bool? value) {
            setState(() {
              smartFitting = value!;
            });
          },
        ),

        // Note Field
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
                'lambai': lambaiController.text,
                'hip': hipController.text,
                'kamar': kamarController.text,
                'thai': thaiController.text,
                'pauncha': paunchaController.text,
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

                // Reset checkbox value
                setState(() {
                  smartFitting = false;
                });

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
