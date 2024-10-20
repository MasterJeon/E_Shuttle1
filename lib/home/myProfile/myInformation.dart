import 'package:flutter/material.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart'; // For ImagePicker and ImageSource
import 'package:intl/intl.dart'; // For date formatting
// For date formatting
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyInformation(),
  ),
);

class MyInformation extends StatefulWidget {
  const MyInformation({Key? key}) : super(key: key);

  @override
  MyInformationState createState() => MyInformationState();
}

class MyInformationState extends State<MyInformation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _intakeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String _dropdownValue1 = 'Male';
  DateTime? _selectedDate; // To store the selected date
  File? _imageFile; // To store the selected image

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchPassengerData();
  }

  Future<void> _fetchPassengerData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('No user logged in.');
      return; // Ensure the user is logged in
    }
    if (_selectedDate != null) {
      _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('passenger')
          .doc(user.uid)
          .get();

      final data = doc.data();

      setState(() {
        _nameController.text = data?['full_name'] ?? ''; // Default to an empty string if 'name' is null
        _emailController.text = data?['email'] ?? ''; // Default to an empty string if 'email' is null
        _facultyController.text = data?['faculty'] ?? ''; // Default to an empty string if 'faculty' is null
        _intakeController.text = data?['intake'] ?? ''; // Default to an empty string if 'intake' is null
        _contactController.text = data?['contact_no'] ?? ''; // Default to an empty string if 'contact' is null
        _addressController.text = data?['address'] ?? ''; // Default to an empty string if 'address' is null
        _dropdownValue1 = data?['gender'] ?? 'Male'; // Default to 'Male' if 'gender' is null
        _selectedDate = data?['dob'] != null ? (data?['dob'] as Timestamp).toDate() : null; // Default to null if 'dob' is missing
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  Future<void> _updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return; // Handle case where user is not logged in
    }

    try {
      final userDocRef = FirebaseFirestore.instance.collection('passenger').doc(user.uid);

      await userDocRef.set({
        'full_name': _nameController.text,
        'email': _emailController.text,
        'faculty': _facultyController.text,
        'intake': _intakeController.text,
        'contact_no': _contactController.text,
        'address': _addressController.text,
        'gender': _dropdownValue1,
        'dob': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : FieldValue.delete(),
      }, SetOptions(merge: true)); // Merge with existing data

      // If you need to handle additional fields or special cases, you can add logic here

      print('User data updated successfully');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Information'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromRGBO(239, 108, 0, 1),
                Color.fromRGBO(255, 167, 38, 1),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.05,
          horizontal: screenSize.width * 0.05,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Selector with OnClick to edit
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: _imageFile == null
                        ? AssetImage('assets/b 3s.jpg') as ImageProvider
                        : FileImage(_imageFile!) as ImageProvider,child: Align(
                      alignment: Alignment.bottomRight,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),

              TextFieldWidget(_nameController, 'Full Name', 'Enter your name'),
              TextFieldWidget(_emailController, 'Email', 'Enter your email'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _dropdownValue1,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Male', 'Female', 'Rather Not Say']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue1 = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dobController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFieldWidget(_facultyController, 'Faculty', 'Enter your faculty'),
              TextFieldWidget(_intakeController, 'Intake', 'Enter your intake'),
              TextFieldWidget(_contactController, 'Contact No.', 'Enter your contact number'),
              TextFieldWidget(_addressController, 'Address', 'Enter your address'),
              SizedBox(height: screenSize.height * 0.03),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle form submission
                    _updateUserData();
                  }
                },
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.02,
                    horizontal: screenSize.width * 0.2,
                  ),
                  //primary: const Color.fromRGBO(255, 167, 38, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TextFieldWidget(TextEditingController controller, String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }
}
