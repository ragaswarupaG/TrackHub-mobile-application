import 'package:flutter/material.dart';
import 'package:mbap_project_part_2/main.dart';
import 'package:mbap_project_part_2/screens/sign_up_screen.dart';

class Login extends StatelessWidget {
  static const routeName = '/login';
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
                  
                  child: 
                   
                  Image.asset('images/logo.png' ),  //Logo off my app
                ),
              ),

              const SizedBox(height: 60),
              const Text(
                'Sign in',   // 'sign in' heading
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
                  children: [   // the children's widget contians the text fields for the users to enter to login
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email', // email & password is neccessary for users to enter to login successfully
                        labelStyle: TextStyle(
                            fontSize: 20, color: Color.fromRGBO(112, 112, 112, 0.6)),
                        fillColor: Color.fromARGB(92, 200, 200, 200),

                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';           // this validator ensures inputs is not  empty
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
                        labelText: 'Password', // password text field
                        labelStyle: TextStyle(
                            fontSize: 20,  color: Color.fromRGBO(112, 112, 112, 0.6)),
                         fillColor: Color.fromARGB(92, 200, 200, 200),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide.none),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';        // this validator ensures inputs is not  empty
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(height: 5),

                    Row(
                     
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                   
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            
                            'Click here if you forgot your password',    // a button where users can click if they forgot their password ( just for decoration )
                            style: TextStyle(fontSize: 13 , color: Color.fromARGB(255, 155, 155, 155)),
                          ),
                        ),
                      ],
                      
                    ),

                   
                    const SizedBox(height: 20),
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
                        'Login',  //this button can be clicked after entering all the detials and this will lead the user to the home page
                        style: TextStyle(color: Color.fromARGB(255, 84, 84, 84)),
                      ),
                    )

                    
                  ],
                ),
              ),

              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUp.routeName);
                },
                child: const Text("Click here to sign up" , style: TextStyle(fontSize: 17),),      //users can clikc on this button if they want to sign up and not login
              ),
            ],
          ),
        ),
      ),
    );
  }
}
