import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbap_project_part_2/main.dart';
import 'package:mbap_project_part_2/screens/change_password.dart';
import 'package:mbap_project_part_2/screens/font_size.dart';
import 'package:mbap_project_part_2/screens/highest_usage.dart';
import 'package:mbap_project_part_2/screens/highest_usage_today.dart';
import 'package:mbap_project_part_2/screens/qr_code.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';
import 'package:mbap_project_part_2/services/theme_service.dart';


// this is the app drawer, more features and information is here

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? profileImageURL;   //havign the profile pic as a URL

  // getting the necessary services
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  final ThemeService themeService = GetIt.instance<ThemeService>();

  @override
  void initState() {
    super.initState();
    _fetchProfileImageURL();
  }

  Future<void> _fetchProfileImageURL() async {
    String? url = await fbService.getProfileImageURL();
    setState(() {
      profileImageURL = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(""),
            accountEmail: fbService.getCurrentUser() == null
                ? const Text("Hello Friend!")  // if user not authenticated
                : FittedBox(
                    child: Text(
                      "Hello " + fbService.getCurrentUser()!.email!,  //if authenticated then gets the email
                    ),
                  ),
            currentAccountPicture: GestureDetector(
              onTap: () {      //by tapping we can see more options
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BottomSheetContent(
                      fbService: fbService,
                      onImageUpdated: _fetchProfileImageURL,
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 100,
                backgroundImage: profileImageURL != null
                    ? NetworkImage(profileImageURL!)
                    : AssetImage('images/man.png') as ImageProvider,  // if no pic then this pic will be the default
              ),
            ),
          ),




          ListTile(
            
            leading: const Icon(Icons.home),
            title: const Text('Home'), 
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(MainScreen.routeName),
          ),
      
          const Divider(height: 3, color: Colors.blueGrey),
          

          ListTile(
            leading: const Icon(Icons.palette),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Themes'),
                  GestureDetector(
                    child: CircleAvatar(
                        backgroundColor: Colors.deepPurple, maxRadius: 15),
                    onTap: () {
                      themeService.setTheme(Colors.deepPurple, 'deepPurple');
                         Navigator.pushReplacementNamed(context, MainScreen.routeName);
                    },
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                        backgroundColor: Colors.blue, maxRadius: 15),
                    onTap: () {
                      themeService.setTheme(Colors.blue, 'blue');
                         Navigator.pushReplacementNamed(context, MainScreen.routeName);
                    },
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                        backgroundColor: Colors.green, maxRadius: 15),
                    onTap: () {
                      themeService.setTheme(Colors.green, 'green');
                         Navigator.pushReplacementNamed(context, MainScreen.routeName);
                    },
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                        backgroundColor: Colors.red, maxRadius: 15),
                    onTap: () {
                      themeService.setTheme(Colors.red, 'red');
                        Navigator.pushReplacementNamed(context, MainScreen.routeName);
                      
                    },
                  ),
                ]),
          ),
           const Divider(height: 3, color: Colors.blueGrey),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Logout'),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        fbService.logOut().then((value) {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Logout successfully!')),
                          );
                          Navigator.of(context).pop();
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
            ),
          ),

          const Divider(height: 3, color: Colors.blueGrey),
        
          ListTile(
            leading: const Icon(Icons.bolt),
            title: const Text('High usage appliances'),
            onTap: () =>
                Navigator.of(context).pushNamed(HighestUsage.routeName),
          ),
          const Divider(height: 3, color: Colors.blueGrey),

          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('High usage appliances today'),
            onTap: () =>
                Navigator.of(context).pushNamed(HighestUsageToday.routeName),
          ),
          const Divider(height: 3, color: Colors.blueGrey),

          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text(
                'QR code scanner'), // users can use the QR scanner to scan ( going to implement in part 4)
            onTap: () => Navigator.of(context).pushNamed(QRpage.routeName),
          ),
           const Divider(height: 3, color: Colors.blueGrey),


           ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change password'),
            onTap: () =>
                Navigator.of(context).pushNamed(ChangePassword.routeName),
          ),
          const Divider(height: 3, color: Colors.blueGrey),

           ListTile(
            leading: const Icon(Icons.font_download),
            title: const Text('Change font size'),
            onTap: () =>
                Navigator.of(context).pushNamed(FontSize.routeName),
          ),
          const Divider(height: 3, color: Colors.blueGrey),

        ],
      ),
    );
  }
}






class BottomSheetContent extends StatelessWidget {
  final FirebaseService fbService;
  final VoidCallback onImageUpdated;

  BottomSheetContent({required this.fbService, required this.onImageUpdated});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File profilePicture = File(pickedFile.path);
      await fbService.addProfileImage(profilePicture);
      onImageUpdated();

          WidgetsBinding.instance!.addPostFrameCallback((_) {
            DelightToastBar(
              builder: (context) {
                return ToastCard(
                  title: Text("Profile picture added"),
                );
              },
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              snackbarDuration: Durations.extralong3,
            ).show(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              leading: const Icon(Icons.image),
              onTap: () => _pickImage(context),
              title: const Text('Add Image'),
            ),
           
          ],
        ),
      ),
    );
  }
}










// class BottomSheetContent extends StatelessWidget {
//   final FirebaseService fbService;

//   BottomSheetContent({required this.fbService});

//   final ImagePicker _picker = ImagePicker();

 
// Future<void> _pickImage(BuildContext context) async {
//   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     File profilePicture = File(pickedFile.path);
//     await fbService.addProfileImage(profilePicture);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Profile picture uploaded')),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       child: Center(
//         child: ListView(
//           children: [
//             ListTile(
//               contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 leading: const Icon(Icons.image),
//                 onTap: () => _pickImage(context),
//                 title: const Text('Add Image'),
            
//             ),
//             const Divider(height: 3, color: Colors.blueGrey),
//             ListTile(
//               contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               leading: const Icon(Icons.close),
//               title: const Text('Remove picture'),
            
//                 onTap: () => (context)
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // profile pic can be shown in this code
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mbap_project_part_2/main.dart';
// import 'package:mbap_project_part_2/screens/change_password.dart';
// import 'package:mbap_project_part_2/screens/font_size.dart';
// import 'package:mbap_project_part_2/screens/highest_usage.dart';
// import 'package:mbap_project_part_2/screens/highest_usage_today.dart';
// import 'package:mbap_project_part_2/screens/home_page.dart';
// import 'package:mbap_project_part_2/screens/qr_code.dart';
// import 'package:mbap_project_part_2/screens/visuals_page.dart';
// import 'package:mbap_project_part_2/services/firebase_service.dart';
// import 'package:mbap_project_part_2/services/theme_service.dart';
// import 'package:mbap_project_part_2/screens/profile.dart';

// class AppDrawer extends StatefulWidget {
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   String? profileImageURL;
//   final FirebaseService fbService = GetIt.instance<FirebaseService>();
//   final ThemeService themeService = GetIt.instance<ThemeService>();

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileImageURL();
//   }

//   Future<void> _fetchProfileImageURL() async {
//     String? url = await fbService.getProfileImageURL();
//     setState(() {
//       profileImageURL = url;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: const Text(""),
//             accountEmail: fbService.getCurrentUser() == null
//                 ? const Text("Hello Friend!")
//                 : FittedBox(
//                     child: Text(
//                       "Hello " + fbService.getCurrentUser()!.email!,
//                     ),
//                   ),
//             currentAccountPicture: GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return BottomSheetContent(
//                       fbService: fbService,
//                       onImageUpdated: _fetchProfileImageURL,
//                     );
//                   },
//                 );
//               },
//               child: CircleAvatar(
//                 radius: 100,
//                 backgroundImage: profileImageURL != null
//                     ? NetworkImage(profileImageURL!)
//                     : AssetImage('images/man.png') as ImageProvider,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Home'),
//             onTap: () => Navigator.of(context)
//                 .pushReplacementNamed(MainScreen.routeName),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),
//           ListTile(
//             leading: const Icon(Icons.palette),
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Themes'),

//                  ListTile(
//             leading: const Icon(Icons.palette),
//             title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Themes'),
//                   GestureDetector(
//                     child: CircleAvatar(
//                         backgroundColor: Colors.deepPurple, maxRadius: 15),
//                     onTap: () {
//                       themeService.setTheme(Colors.deepPurple, 'deepPurple');
//                          Navigator.pushReplacementNamed(context, MainScreen.routeName);
//                     },
//                   ),
//                   GestureDetector(
//                     child: CircleAvatar(
//                         backgroundColor: Colors.blue, maxRadius: 15),
//                     onTap: () {
//                       themeService.setTheme(Colors.blue, 'blue');
//                          Navigator.pushReplacementNamed(context, MainScreen.routeName);
//                     },
//                   ),
//                   GestureDetector(
//                     child: CircleAvatar(
//                         backgroundColor: Colors.green, maxRadius: 15),
//                     onTap: () {
//                       themeService.setTheme(Colors.green, 'green');
//                          Navigator.pushReplacementNamed(context, MainScreen.routeName);
//                     },
//                   ),
//                   GestureDetector(
//                     child: CircleAvatar(
//                         backgroundColor: Colors.red, maxRadius: 15),
//                     onTap: () {
//                       themeService.setTheme(Colors.red, 'red');
//                         Navigator.pushReplacementNamed(context, MainScreen.routeName);

//                     },
//                   ),
//                 ]),
//           ),
//            const Divider(height: 3, color: Colors.blueGrey),
                
//               ],
//             ),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),
          
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () => showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: const Text('Logout'),
//                   content: const Text(
//                     'Are you sure you want to logout?',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         fbService.logOut().then((value) {
//                           FocusScope.of(context).unfocus();
//                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Logout successfully!')),
//                           );
//                           Navigator.of(context).pop();
//                         });
//                       },
//                       child: const Text('Yes'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('No'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),













//           const Divider(height: 3, color: Colors.blueGrey),
//           ListTile(
//             leading: const Icon(Icons.bolt),
//             title: const Text('High usage appliances'),
//             onTap: () =>
//                 Navigator.of(context).pushNamed(HighestUsage.routeName),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),
//           ListTile(
//             leading: const Icon(Icons.today),
//             title: const Text('High usage appliances today'),
//             onTap: () =>
//                 Navigator.of(context).pushNamed(HighestUsageToday.routeName),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),
//           ListTile(
//             leading: const Icon(Icons.qr_code),
//             title: const Text('QR code scanner'),
//             onTap: () => Navigator.of(context).pushNamed(QRpage.routeName),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),
//           ListTile(
//             leading: const Icon(Icons.password),
//             title: const Text('Change password'),
//             onTap: () =>
//                 Navigator.of(context).pushNamed(ChangePassword.routeName),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),
//           ListTile(
//             leading: const Icon(Icons.font_download),
//             title: const Text('Change font size'),
//             onTap: () => Navigator.of(context).pushNamed(FontSize.routeName),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),
//           ListTile(
//             leading: const Icon(Icons.image),
//             title: const Text('Change profile pic'),
//             onTap: () => Navigator.of(context).pushNamed(profile.routeName),
//           ),
//           const Divider(height: 3, color: Colors.blueGrey),

           
//            const Divider(height: 3, color: Colors.blueGrey),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text(
//             'Are you sure you want to logout?',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 fbService.logOut().then((value) {
//                   FocusScope.of(context).unfocus();
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Logout successfully!')),
//                   );
//                   Navigator.of(context).pop();
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
// }















// class BottomSheetContent extends StatelessWidget {
//   final FirebaseService fbService;
//   final VoidCallback onImageUpdated;

//   BottomSheetContent({required this.fbService, required this.onImageUpdated});

//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(BuildContext context) async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       File profilePicture = File(pickedFile.path);
//       await fbService.addProfileImage(profilePicture);
//       onImageUpdated();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Profile picture uploaded')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       child: Center(
//         child: ListView(
//           children: [
//             ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               leading: const Icon(Icons.image),
//               onTap: () => _pickImage(context),
//               title: const Text('Add Image'),
//             ),
//             const Divider(height: 3, color: Colors.blueGrey),
//             ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               leading: const Icon(Icons.close),
//               title: const Text('Remove picture'),
//               onTap: () {
                
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
