import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';

// allows users to reset password incase they forget it
class ResetPasswordScreen extends StatelessWidget {
  FirebaseService fbService = GetIt.instance<FirebaseService>();  //using the firebase service
  static String routeName = '/reset-password';
  String? email;
  var form = GlobalKey<FormState>();

  void reset(BuildContext context) {
    bool isValid = form.currentState!.validate();  // validate
    if (isValid) {
      form.currentState!.save();
      fbService.forgotPassword(email).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please check your email to reset your password!'),  // snack bar to help users to understand the next step
        ));
        Navigator.of(context).pop();
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TrackHub'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Forgot password?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Don't worry! Enter your email & we will guide you",
                style: TextStyle(
                 
                 
                  color: Color.fromARGB(255, 161, 161, 161)
                ),
              ),
              const SizedBox(height: 30),
              


             const Text(
                        'Enter your email',
                        style: TextStyle(
                         
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                      const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(112, 112, 112, 0.6)),
                  fillColor: Color.fromARGB(92, 200, 200, 200),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide an email address.";
                  } else if (!value.contains('@')) {
                    return "Please provide a valid email address.";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  reset(context);
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
