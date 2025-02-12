import 'package:flutter/material.dart';
import 'package:mbap_project_part_2/screens/reset_password_screen.dart';
import 'package:mbap_project_part_2/widgets/login_form.dart';
import 'package:mbap_project_part_2/widgets/register_form.dart';


// this is my authentication screen where the login , sign up , forget password takes place

class AuthScreen extends StatefulWidget {
  static String routeName = '/auth';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool loginScreen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     
      body: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                loginScreen ? LoginForm() : RegisterForm(),   //widgets which will be loaded based on what button is clicked
                const SizedBox(height: 5),
                loginScreen
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            loginScreen = false;
                          });
                        },
                        child: const Text('No account? Sign up here!'))
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            loginScreen = true;
                          });
                        },
                        child: const Text('Existing user? Login in here!')),
                loginScreen
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ResetPasswordScreen.routeName);
                        },
                        child: const Text('Forgotten Password'))
                    : const Center()
              ],
            ),
          )),
    );
  }
}
