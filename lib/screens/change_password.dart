//change password screen
// after being authenticated then users can change their password

import 'package:flutter/material.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';
import 'package:get_it/get_it.dart';

class ChangePassword extends StatelessWidget {
  static String routeName = '/change-password';
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FirebaseService fbService = GetIt.instance<FirebaseService>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'TrackHub',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _currentPasswordController,
                keyboardType: TextInputType.visiblePassword,      // ensuring a correct keyboard type is present
                decoration: const InputDecoration(
                  labelText: 'Current password', // need to ask for current password to make sure the right person is making this change 
                  labelStyle: TextStyle( color: Color.fromRGBO(112, 112, 112, 0.6)),
                  fillColor: Color.fromARGB(92, 200, 200, 200),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';            //validating
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _newPasswordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  labelText: 'New password',   // entering of new password
                  labelStyle: TextStyle( color: Color.fromRGBO(112, 112, 112, 0.6)),
                  fillColor: Color.fromARGB(92, 200, 200, 200),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  } else if (value.length < 6) {     //validation
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await fbService.changePassword(
                        _currentPasswordController.text,
                        _newPasswordController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Password changed successfully!'),
                      ));
                      Navigator.pop(context); 
                       fbService.logOut();     //using the firebase service to logout the user 
                      
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: ${e.toString()}'),
                      ));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  textStyle: const TextStyle(fontSize: 25),
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(color: Color.fromARGB(255, 84, 84, 84)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
