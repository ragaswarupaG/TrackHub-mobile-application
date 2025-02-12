import 'package:flutter/material.dart';
import 'package:mbap_project_part_2/main.dart';
import 'package:mbap_project_part_2/screens/Login_page.dart';

class SignUp extends StatelessWidget {
  static const routeName = '/signup';     //sign up screen
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
             
              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    )),
                child: ClipOval(
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(height: 60), 


              const Text(
                'Sign up',          // users to know that this is a sign up screen 


 
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35), 

              Form(
                key: formKey,
                child: Column(
                  children: [    //inputs for users to fill up to register themselves as a member

                    TextFormField(
                       keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        
                        labelStyle: TextStyle(fontSize: 20 , 
                         color: Color.fromRGBO(112, 112, 112, 0.6)),

                           fillColor: Color.fromARGB(92, 200, 200, 200),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide.none),
                      ),


                      validator: (value) {       //checks and alerts the user if the email placeholder is empty
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(height: 30), 
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        
                        labelText: 'Password',
                       labelStyle: TextStyle(fontSize: 20 , 
                        color: Color.fromRGBO(112, 112, 112, 0.6)),

                       fillColor: Color.fromARGB(92, 200, 200, 200),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide.none),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {     // alerts the user that hte password placeholder is empty
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.pushNamed(context, MainScreen.routeName);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                            backgroundColor: Color.fromARGB(255, 194, 232, 195),
                        textStyle:
                            const TextStyle(fontSize: 25 ), // Increase font size
                      ),
                      child: const Text(
                        'Create account',   // users can click this to register themsleves and become a user, this leads them to the home page
                      style: TextStyle(color: Color.fromARGB(255, 84, 84, 84)),
                      ),
                    )

                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {Navigator.pushNamed(context, Login.routeName);},
                child: const Text("Click here to sign in" , style: TextStyle(fontSize: 17),),     // users can choose to sign in instead of sign up
              ),
            ],
          ),
        ),
      ),
    );
  }
}
