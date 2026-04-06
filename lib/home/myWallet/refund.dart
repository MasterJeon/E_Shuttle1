import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the selected date

class RefundPage extends StatefulWidget {
  const RefundPage({Key? key}) : super(key: key);

  @override
  _RefundPageState createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _stopController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _routeController.dispose();
    _stopController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _sendRequest() {
    if (_formKey.currentState!.validate()) {
      // Process the refund request here
      // You can access the values using the controllers:
      // _amountController.text, _dateController.text, etc.

      // For now, let's just show a simple dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Request Sent'),
          content: const Text('Your refund request has been submitted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Clear the form after submission
      _formKey.currentState!.reset();
      _dateController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Refund"),
        //backgroundColor: const Color.fromRGBO(0, 69, 230, 1),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please fill out the following details to request a refund:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Date Field
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Route Field
                  TextFormField(
                    controller: _routeController,
                    decoration: const InputDecoration(
                      labelText: 'Route',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the route';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Relevant Stop Field
                  TextFormField(
                    controller: _stopController,
                    decoration: const InputDecoration(
                      labelText: 'Your Relevant Stop',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your relevant stop';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Reason Field
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Reason for Requesting',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a reason for requesting a refund';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // Send Request Button
                  GestureDetector(
                    onTap: _sendRequest,
                    child: Container(
                      height: 50,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 69, 230, 1),
                            Color.fromRGBO(0, 115, 239, 1),
                            Color.fromRGBO(38, 201, 255, 1)
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Send Request",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
