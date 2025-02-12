import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbap_project_part_2/main.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';

class LoginForm extends StatelessWidget {
  FirebaseService fbService = GetIt.instance<FirebaseService>();
  String? email;
  String? password;

  var form = GlobalKey<FormState>();

  void login(BuildContext context) {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      fbService.login(email, password).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login successfully!'),
        ));
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Incorrect email or password" )));  //incase wrong info is sent
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
            // const SizedBox(height: 10),
            Container(
              width: 230,
              height: 230,
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
            const SizedBox(height: 10),
            const Text(
              'Sign in', // 'sign in' heading
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
                      if (value == null || value.isEmpty)
                        return "Please provide an email address.";
                      else if (!value.contains('@'))
                        return "Please provide a valid email address.";
                      else
                        return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(height: 30),
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
                      if (value == null || value.isEmpty)
                        return 'Please provide a password.';
                      else if (value.length < 6)
                        return 'Password must be at least 6 characters.';
                      else
                        return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      textStyle: const TextStyle(fontSize: 25), // Increase font size
                    ),

                    child: const Text(
                      'Login', // This button can be clicked after entering all the details and will lead the user to the home page
                      style: TextStyle(color: Color.fromARGB(255, 84, 84, 84)),
                    ),
                  ),


                  SizedBox(height: 20,),

                  //googgle sign in

                  ElevatedButton.icon(
                    onPressed: () {
                      _signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                      backgroundColor: Colors.red, // Use Google's branding color
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    icon: const Icon(FontAwesomeIcons.google, color: Colors.white),

                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.white),
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




_signInWithGoogle()async{

    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null ){
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        // await _firebaseAuth.signInWithCredential(credential);
        return await FirebaseAuth.instance.signInWithCredential(credential);
        
        // Navigator.pushNamed(MainScreen.routeName);
       
      }

    }catch(e) {
SnackBar(content: Text("some error occured $e"));
    }


  }











}


