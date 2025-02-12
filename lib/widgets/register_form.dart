import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';

class RegisterForm extends StatelessWidget {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  String? email;
  String? password;
  String? confirmPassword;
  String? picture;

  final form = GlobalKey<FormState>();

  // void register(BuildContext context) {
  //   bool isValid = form.currentState!.validate();
  //   if (isValid) {
  //     form.currentState!.save();
  //     if (password != confirmPassword) {
  //       FocusScope.of(context).unfocus();
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text('Password and Confirm Password do not match!')));
  //       return; 
  //     }
      
  //     fbService.register(email, password).then((value) {
  //       FocusScope.of(context).unfocus();
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('User Registered successfully!'),
  //       ));
  //     }).catchError((error) {
  //       FocusScope.of(context).unfocus();
  //       String message = error.toString();
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(message)));
  //     });
  //   }
  // }

  void register(BuildContext context) {
  bool isValid = form.currentState!.validate();
  if (isValid) {
    form.currentState!.save();
    if (password != confirmPassword) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password and Confirm Password do not match!')));
      return;
    }

    fbService.register(email, password).then((value) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User Registered successfully!'),
      ));
    }).catchError((error) {
      FocusScope.of(context).unfocus();
      String message;

      if (error.toString().contains('email-already-in-use')) {
        message = 'The email address is already in use by another account.';
      } else {
        message = error.toString();
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: ClipOval(
                child: Image.asset('images/Applogo.png'), // Logo of my app
              ),
            ),
            // const SizedBox(height: 10),
            const Text(
              'Sign up', // 'sign up' heading
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email', // Email & password are necessary for users to enter to log in successfully
                      labelStyle: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(112, 112, 112, 0.6)),
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password', // Password text field
                      labelStyle: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(112, 112, 112, 0.6)),
                      fillColor: Color.fromARGB(92, 200, 200, 200),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide.none),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a password.';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password', // Confirm password text field
                      labelStyle: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(112, 112, 112, 0.6)),
                      fillColor: Color.fromARGB(92, 200, 200, 200),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide.none),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a password.';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      confirmPassword = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      register(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      backgroundColor:Theme.of(context).colorScheme.inversePrimary,
                      textStyle: const TextStyle(fontSize: 25), // Increase font size
                    ),
                    child: const Text(
                      'Register', // This button can be clicked after entering all the details and will lead the user to the home page
                      style: TextStyle(color: Color.fromARGB(255, 84, 84, 84)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
