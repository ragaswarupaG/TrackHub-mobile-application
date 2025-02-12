import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mbap_project_part_2/main.dart';
import 'package:mbap_project_part_2/models/myrecord.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';

class UpdateRecord extends StatefulWidget {
  static String routeName = '/update';

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? name;

  int? duration;

  DateTime? usageDate;

  TextEditingController? dateController;

  File? appliancePhoto;

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

  void deleteRecord(String id) {
    showDialog<Null>(
      context: context,
      builder: (context) {
        return AlertDialog(
          // alert dialog to let users to choose to delete record
          title: const Text('Confirmation'),
          content: const Text(
            'Are you sure you want to delete this record?',
           
          ),

          actions: [
            TextButton(
              onPressed: () {
                fbService.deleteRecord(id).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Record deleted successfully!',
                      style: TextStyle(color: Colors.white),
                    ) //informs users on the deleted record
                        ),
                  );
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, MainScreen.routeName);
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $error'),
                    ),
                  );
                });
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void saveForm(id) {
    bool isValid = formKey.currentState!.validate();
    usageDate ??= DateTime.now();

    showDialog<Null>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
            'Are you sure you want to update?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // TextButton(onPressed: () {
            //   fbService.addAppliancePhoto(appliancePhoto!).then(
            //     (imageUrl) {
            //       fbService
            //           .updateRecord(imageUrl!, id, duration!, name!, usageDate!)
            //           .then((value) {
            //         debugPrint('called this function');

            //         FocusScope.of(context).unfocus();

            //         formKey.currentState!.reset();
            //         usageDate = null;

            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //               content: Text(
            //             'Record updated successfully!',
            //             style: TextStyle(color: Colors.white),
            //           )),
            //         );
            //         Navigator.of(context).pop();
            //         Navigator.pushNamed(context, MainScreen.routeName);
            //       }).onError((error, stackTrace) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //             content: Text('Error: $error'),
            //           ),
            //         );
            //       });
            //     },
            //     child: const Text('Yes'),
            //   );
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: const Text('No'),
            //   );
            // })


TextButton(
  onPressed: () {
    fbService.addAppliancePhoto(appliancePhoto!).then(
      (imageUrl) {
        fbService.updateRecord(imageUrl!, id, duration!, name!, usageDate!)
          .then((value) {

            FocusScope.of(context).unfocus();
            formKey.currentState!.reset();
            usageDate = null;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Record updated successfully!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
            Navigator.of(context).pop();
            Navigator.pushNamed(context, MainScreen.routeName);
          }).onError((error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
              ),
            );
          });
      },
    );
  },
  child: const Text('Yes'),
),
TextButton(
  onPressed: () {
    Navigator.of(context).pop();
  },
  child: const Text('No'),
),


          ],
        );
      },
    );
  }

// this is the 'U' function update
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
        dateController!.text = DateFormat('dd/MM/yyyy').format(usageDate!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MyRecord selectedRecord =
        ModalRoute.of(context)?.settings.arguments as MyRecord;
    if (usageDate == null) usageDate = selectedRecord.usageDate;

    dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy')
            .format(usageDate!)); //setting the date as the default
    debugPrint(usageDate!.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit your record!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteRecord(selectedRecord.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Appliance name',
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: selectedRecord.name.toString(),
                        keyboardType: TextInputType.text,

                        decoration: const InputDecoration(
                          labelText: 'Name', // lable for the text input
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(0, 0, 0, 0.6)),
                          fillColor: Color.fromARGB(92, 200, 200, 200),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the appliance name'; // this validator ensures inputs is not  empty
                          }
                          return null;
                        },
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.deny(RegExp(r'[\t ]')),
                        // ],
                        onSaved: (value) {
                          name = value;
                        },
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Duration of usage', // another input to enter the duration
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: selectedRecord.duration.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(0, 0, 0, 0.6)),
                          fillColor: Color.fromARGB(92, 200, 200, 200),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the duration'; // this validator ensures inputs is not  empty
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[\t ]')),
                          FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
                        ],
                        onSaved: (value) {
                          duration = int.tryParse(value!);
                        },
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Date of usage', //users can make use of the date picker widget to pick a date
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: dateController,
                        onTap: () => presentDatePicker(context),
                        decoration: const InputDecoration(
                          labelText: 'Date ',
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(0, 0, 0, 0.6)),
                          fillColor: Color.fromARGB(92, 200, 200, 200),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide.none),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a date'; // this validator ensures inputs is not  empty
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[\t ]')),
                        ],
                      ),
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
                                  : selectedRecord.imageUrl != ''
                                      ? FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.network(
                                              selectedRecord.imageUrl))
                                      : Center()),
                          Column(
                            children: [
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
                              saveForm(selectedRecord.id);

                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 28),
                              backgroundColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              textStyle: const TextStyle(
                                  fontSize: 25), // Increase font size
                            ),
                            child: const Text(
                              'Save', // this button will save the new values and brings back the user to the home page
                              style:
                                  TextStyle(color: Colors.black, fontSize: 29),
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
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'TrackHub',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:mbap_project_part_2/main.dart';
// import 'package:mbap_project_part_2/models/myrecord.dart';
// import 'package:mbap_project_part_2/services/firebase_service.dart';

// class UpdateRecord extends StatefulWidget {
//   static String routeName = '/update';

//   @override
//   State<UpdateRecord> createState() => _UpdateRecordState();
// }

// class _UpdateRecordState extends State<UpdateRecord> {
//   final FirebaseService fbService = GetIt.instance<FirebaseService>();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   String? name;
//   int? duration;
//   DateTime? usageDate;
//   TextEditingController? dateController;
//   File? appliancePhoto;

//   Future<void> pickImage(int mode) async {
//     ImageSource chosenSource = mode == 0 ? ImageSource.camera : ImageSource.gallery;
//     final imageFile = await ImagePicker().pickImage(
//       source: chosenSource,
//       maxWidth: 600,
//       imageQuality: 50,
//       maxHeight: 150,
//     );
//     if (imageFile != null) {
//       setState(() {
//         appliancePhoto = File(imageFile.path);
//       });
//     }
//   }

//   void deleteRecord(String id) {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Confirmation'),
//           content: const Text(
//             'Are you sure you want to delete this record?',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 fbService.deleteRecord(id).then((value) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         'Record deleted successfully!',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   );
//                   Navigator.of(context).pop();
//                   Navigator.pushNamed(context, MainScreen.routeName);
//                 }).onError((error, stackTrace) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Error: $error'),
//                     ),
//                   );
//                 });
//               },
//               child: const Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void saveForm(String id) {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }
//     formKey.currentState!.save();
//     usageDate ??= DateTime.now();

//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Confirmation'),
//           content: const Text(
//             'Are you sure you want to update?',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 fbService.addAppliancePhoto(appliancePhoto!).then(
//                   (imageUrl) {
//                     fbService.updateRecord(imageUrl!, id, duration!, name!, usageDate!).then((value) {
//                       debugPrint('called this function');

//                       FocusScope.of(context).unfocus();
//                       formKey.currentState!.reset();
//                       usageDate = null;

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             'Record updated successfully!',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       );
//                       Navigator.of(context).pop();
//                       Navigator.pushNamed(context, MainScreen.routeName);
//                     }).onError((error, stackTrace) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Error: $error'),
//                         ),
//                       );
//                     });
//                   },
//                 );
//               },
//               child: const Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void presentDatePicker(BuildContext context) {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now().subtract(const Duration(days: 30)),
//       lastDate: DateTime.now(),
//     ).then((value) {
//       if (value == null) return;
//       setState(() {
//         usageDate = value;
//         dateController!.text = DateFormat('dd/MM/yyyy').format(usageDate!);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     MyRecord selectedRecord = ModalRoute.of(context)?.settings.arguments as MyRecord;
//     if (usageDate == null) usageDate = selectedRecord.usageDate;

//     dateController = TextEditingController(
//       text: DateFormat('dd/MM/yyyy').format(usageDate!),
//     );
//     debugPrint(usageDate!.toString());
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Edit your record!',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () {
//                       deleteRecord(selectedRecord.id);
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Form(
//                 key: formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Appliance name',
//                       style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 99, 99, 99)),
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       initialValue: selectedRecord.name,
//                       keyboardType: TextInputType.text,
//                       decoration: const InputDecoration(
//                         labelText: 'Name',
//                         labelStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 0.6)),
//                         fillColor: Color.fromARGB(92, 200, 200, 200),
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter the appliance name';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         name = value;
//                       },
//                     ),
//                     const SizedBox(height: 35),
//                     const Text(
//                       'Duration of usage',
//                       style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 99, 99, 99)),
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       initialValue: selectedRecord.duration.toString(),
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'Duration',
//                         labelStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 0.6)),
//                         fillColor: Color.fromARGB(92, 200, 200, 200),
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter the duration';
//                         }
//                         return null;
//                       },
//                       inputFormatters: [
//                         FilteringTextInputFormatter.deny(RegExp(r'[\t ]')),
//                         FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
//                       ],
//                       onSaved: (value) {
//                         duration = int.tryParse(value!);
//                       },
//                     ),
//                     const SizedBox(height: 35),
//                     const Text(
//                       'Date of usage',
//                       style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 99, 99, 99)),
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: dateController,
//                       onTap: () => presentDatePicker(context),
//                       readOnly: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Date',
//                         labelStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 0.6)),
//                         fillColor: Color.fromARGB(92, 200, 200, 200),
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please choose a date';
//                         }
//                         return null;
//                       },
//                       inputFormatters: [
//                         FilteringTextInputFormatter.deny(RegExp(r'[\t ]')),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             children: [
//                               const Text(
//                                 'Camera',
//                                 style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 99, 99, 99)),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.camera_alt),
//                                 iconSize: 50,
//                                 onPressed: () => pickImage(0),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               const Text(
//                                 'Gallery',
//                                 style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 99, 99, 99)),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.image),
//                                 iconSize: 50,
//                                 onPressed: () => pickImage(1),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: appliancePhoto != null
//                               ? Image.file(
//                                   appliancePhoto!,
//                                   height: 100,
//                                   width: 100,
//                                   fit: BoxFit.cover,
//                                 )
//                               : selectedRecord.imageUrl != null
//                                   ? Image.network(
//                                    selectedRecord.imageUrl!,
//                                       height: 100,
//                                       width: 100,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : const Text('No image chosen'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 50),
//                     Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color.fromARGB(255, 99, 99, 99),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 15,
//                           ),
//                         ),
//                         onPressed: () => saveForm(selectedRecord.id),
//                         child: const Text(
//                           'Update',
//                           style: TextStyle(fontSize: 22, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
