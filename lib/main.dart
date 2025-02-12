import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part_2/firebase_options.dart';
import 'package:mbap_project_part_2/screens/Login_page.dart';
import 'package:mbap_project_part_2/screens/auth_screen.dart';
import 'package:mbap_project_part_2/screens/change_password.dart';
import 'package:mbap_project_part_2/screens/font_size.dart';
import 'package:mbap_project_part_2/screens/highest_usage.dart';
import 'package:mbap_project_part_2/screens/highest_usage_today.dart';
import 'package:mbap_project_part_2/screens/home_page.dart';
import 'package:mbap_project_part_2/screens/new_record.dart';
import 'package:mbap_project_part_2/screens/piechart.dart';
import 'package:mbap_project_part_2/screens/qr_code.dart';
import 'package:mbap_project_part_2/screens/reset_password_screen.dart';
import 'package:mbap_project_part_2/screens/sign_up_screen.dart';
import 'package:mbap_project_part_2/screens/update_page.dart';
import 'package:mbap_project_part_2/screens/visuals_page.dart';
import 'package:mbap_project_part_2/services/firebase_notification_service.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';
import 'package:mbap_project_part_2/services/font_service.dart';
import 'package:mbap_project_part_2/services/theme_service.dart';
import 'package:mbap_project_part_2/widgets/app_drawer.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 //await FirebaseApi().initNotifications();

  GetIt.instance.registerLazySingleton(() => FirebaseService());
  GetIt.instance.registerLazySingleton(() => ThemeService());
  GetIt.instance.registerLazySingleton(() => FontService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeService themeService = GetIt.instance<ThemeService>();
  final FontService fontService = GetIt.instance<FontService>();
  
  @override
  Widget build(BuildContext context) {
    fontService.loadFont();
    themeService.loadPreference();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return StreamBuilder<Color>(
          stream: themeService.getThemeStream(),
          builder: (contextTheme, snapshotTheme) {
            return StreamBuilder<double>(
              stream: fontService.getFontStream(),
              initialData: 16.0, // Default font size
              builder: (contextFont, snapshotFont) {
                double fontSize = snapshotFont.data ?? 16.0;
                return MaterialApp(
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: snapshotTheme.data ??
                          Color.fromARGB(255, 194, 232, 195),
                    ),
                    useMaterial3: true,
                    
                  ),
                  home: snapshot.connectionState != ConnectionState.waiting &&
                          snapshot.hasData
                      ? MainScreen()
                      : AuthScreen(),
                  routes: {
                    Login.routeName: (_) => Login(),
                    HomePage.routeName: (_) => HomePage(),
                    SignUp.routeName: (_) => SignUp(),
                    UpdateRecord.routeName: (_) => UpdateRecord(),
                    QRpage.routeName: (_) => QRpage(),
                    Visuals.routeName: (_) => Visuals(),
                    MainScreen.routeName: (_) => MainScreen(),
                    HighestUsage.routeName: (_) => HighestUsage(),
                    HighestUsageToday.routeName: (_) => HighestUsageToday(),
                    ResetPasswordScreen.routeName: (_) => ResetPasswordScreen(),
                    AuthScreen.routeName: (_) => AuthScreen(),
                    ChangePassword.routeName: (_) => ChangePassword(),
                    PieChartVisual.routeName: (_) => PieChartVisual(),
                    FontSize.routeName: (_) => FontSize(),
              
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  static String routeName = '/mainscreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 1;
  List<Widget> screens = [NewRecord(), HomePage(), Visuals()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Charts & Calendar',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      drawer: AppDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'TrackHub',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),

        // having an action icon at the right side of the appbar ( this is needed to share app to socials/ other platforms)
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final urlPreview = "https://www.youtube.com";
              await Share.share("Learn the importance of sustainability! \n\n$urlPreview");
            },

            // above is the message body
          ),
        ],
      ),
      body: screens[selectedIndex],
    );
  }
}
