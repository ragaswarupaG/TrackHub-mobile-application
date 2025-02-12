import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mbap_project_part_2/main.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';


// this screen is to handle the new records added

class NewRecord extends StatefulWidget {
  static String routeName = '/newrecord';



  @override
  State<NewRecord> createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();   // firebase service 

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? name;

  int? duration;

  DateTime? usageDate;

  TextEditingController dateController = TextEditingController();

  File? appliancePhoto;


// config for the camera & image picking
  Future<Null> pickImage(mode) {
    ImageSource chosenSource =
        mode == 0 ? ImageSource.camera : ImageSource.gallery;
    return ImagePicker()
        .pickImage(
            source: chosenSource,
            maxWidth: 600,
            imageQuality: 50,
            maxHeight: 150)
        .then((imageFile) {
      if (imageFile != null) {
        setState(() {
          appliancePhoto = File(imageFile.path);
        });
      }
    });
  }
// saving the form & submitting it to the db
  void saveForm() {
    bool isValid = formKey.currentState!.validate();

    if (usageDate == null) usageDate = DateTime.now();

    if (isValid) {
      formKey.currentState!.save();
      debugPrint(name);
      debugPrint(duration.toString());
      debugPrint(usageDate.toString());

      fbService.addAppliancePhoto(appliancePhoto!).then((imageUrl) {
        fbService
            .addRecord(imageUrl!, name!, duration!, usageDate!)
            .then((value) {
          

          FocusScope.of(context).unfocus();

          formKey.currentState!.reset();
          usageDate = null;

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Record added successfully!'), // notifies user on the record whihc has been added successfully
          ));
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ' + error.toString()),
          ));
        });
      });
    }
    ;
  }

// date picker widget to allow users to pick a date
  void presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        usageDate = value;
        dateController.text = DateFormat('dd/MM/yyyy').format(usageDate!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a new record?', // heading of the page
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 37),
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                    // in this column , there are text feilds for users to fill up to create a new record to be stored.
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter the name of the appliance',
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter the appliance name',
                            labelStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(0, 0, 0, 0.6)),
                            fillColor: Color.fromARGB(92, 200, 200, 200),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.all(15)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the appliance name'; // this validator ensures inputs is not  empty
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value;
                        },
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Enter the duration of usage',
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Duration in minutes',
                            hintText: 'Enter the duration',
                            labelStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(0, 0, 0, 0.6)),
                            fillColor: Color.fromARGB(92, 200, 200, 200),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.all(15)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the duration'; // this validator ensures inputs is not  empty
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'[\t ]')), // doesnt allow spaces & tabs
                          FilteringTextInputFormatter.deny(RegExp(
                              r'[a-zA-Z]')), // doesnt allow text to be inputted in the form
                        ],
                        onSaved: (value) {
                          duration = int.tryParse(value!);
                        },
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Enter the date of usage', // users can make use of the date picker widget to pick a date
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: dateController,
                        onTap: () => presentDatePicker(context),
                        decoration: const InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(0, 0, 0, 0.6)),
                            fillColor: Color.fromARGB(92, 200, 200, 200),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.all(15)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a date'; // this validator ensures inputs is not  empty
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'[\t ]')), //doesnt allow tabs & spaces
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 150,
                              height: 100,
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
                              child: appliancePhoto != null
                                  ? FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.file(appliancePhoto!))
                                  : Center()),
                          Column(
                            children: [
                              // icons for users to click in order to access image & gallery storage function
                              TextButton.icon(
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () => pickImage(0),
                                  label: const Text('Take Photo')),
                              TextButton.icon(
                                  icon: const Icon(Icons.image),
                                  onPressed: () => pickImage(1),
                                  label: const Text('Add Image')),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                saveForm();
                                Navigator.pushNamed(context, MainScreen.routeName);
                               
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              backgroundColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              textStyle: const TextStyle(fontSize: 25),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.black ),
                            ),
                          )
                        ],
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
