import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/MeasurementProvider.dart';

class SherwaniMeasurementForm extends StatefulWidget {
  final Map<dynamic, dynamic> measurement;

  SherwaniMeasurementForm({required this.measurement});

  @override
  _SherwaniMeasurementFormState createState() => _SherwaniMeasurementFormState();
}

class _SherwaniMeasurementFormState extends State<SherwaniMeasurementForm> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sherwani Measurement Form", style: GoogleFonts.lora()),
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
            MeasurementForm(measurement: widget.measurement), // Pass measurement to the form
          ],
        ),
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
  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    serialNoController.text = widget.measurement['serialNo'] ?? '';
    nameController.text = widget.measurement['name'] ?? '';
    mobileNoController.text = widget.measurement['mobileNo'] ?? '';
    addressController.text = widget.measurement['address'] ?? '';
    lambaiController.text = widget.measurement['lambai'] ?? '';
    chaatiController.text = widget.measurement['chaati'] ?? '';
    kamarController.text = widget.measurement['kamar'] ?? '';
    hipController.text = widget.measurement['hip'] ?? '';
    bazuController.text = widget.measurement['bazu'] ?? '';
    teeraController.text = widget.measurement['teera'] ?? '';
    galaController.text = widget.measurement['gala'] ?? '';
    crossBackController.text = widget.measurement['crossBack'] ?? '';
    noteController.text = widget.measurement['note'] ?? '';
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
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildAdditionalFields(),
                  SizedBox(height: 20),

                  // Sherwani Measurements Section
                  Center(
                    child: Text('Sherwani Measurements',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  _buildSherwaniMeasurements(),

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

  Widget _buildSherwaniMeasurements() {
    return Column(
      children: [
        _buildTextField(lambaiController, 'Lambai', false),
        _buildTextField(chaatiController, 'Chaati', false),
        _buildTextField(kamarController, 'Kamar', false),
        _buildTextField(hipController, 'Hip', false),
        _buildTextField(bazuController, 'Baazu', false),
        _buildTextField(teeraController, 'Teera', false),
        _buildTextField(galaController, 'Gala', false),
        _buildTextField(crossBackController, 'Cross Back', false),

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
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Card(
      child: InkWell(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            final ref = FirebaseDatabase.instance.ref("measurements");
            String id = widget.measurement['id'];
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
              'note': noteController.text,
            };

            ref.child('Sherwani/$id').set(formData).then((value) {
              Provider.of<Measurementprovider>(context,listen: false)
                  .FetchMeausurements('Sherwani');

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Data submitted successfully')));
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to submit data: $error')));
            });
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
              'Submit',
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
        _buildTextField(serialNoController, 'Serial No', true),
        _buildTextField(nameController, 'Name', true),
        _buildTextField(mobileNoController, 'Mobile No', true),
        _buildTextField(addressController, 'Address', true),
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
        keyboardType:
        label != 'Name' && label != 'Address' ? TextInputType.number : TextInputType.text,
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
