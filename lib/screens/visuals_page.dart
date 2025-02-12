
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part_2/models/myrecord.dart';
import 'package:mbap_project_part_2/screens/piechart.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';


// this page i have some important app information & users can access the web & view the charts

class Visuals extends StatelessWidget {
  DateTime today = DateTime.now();
  final FirebaseService fbService = GetIt.instance<FirebaseService>();

  static String routeName = '/visuals';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MyRecord>>(
      stream: fbService.getRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Calculate sum of durations from MyRecord objects
        double sum = 0;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          snapshot.data!.forEach((doc) {
            sum += doc.duration ?? 0;
          });
        }

        return Scaffold(
          body: Center(
            child: ListView(
              children: [
                const SizedBox(height: 35),
                const Center(
                  child: Text(
                    'Your carbon footprint',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // this text button will allow the users to access the website in their browser 
                TextButton(
                  onPressed: () async {
                    const url = "https://www.greenplan.gov.sg/";   // the URL 
                    print('Attempting to launch URL: $url');
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      print('URL can be launched');
                      await launchUrl(uri);
                    } else {
                      print('Could not launch URL');
                    }
                  },
                  child: Text(
                      "To find out more about Singapore's sustainability plan click here" , style: TextStyle(fontSize: 13),),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(       // button to access the pie chart in the next page
                    onPressed: () {
                      Navigator.pushNamed(context, PieChartVisual.routeName);
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size(150, 40)), 
                    ),
                    child: Text('View Pie Chart'),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 30,
                            ),
                            const SizedBox(height: 5),
                            // using the sum query method to add up the duration time of all the records to display here
                            const Text(
                              'Duration of electricity used',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 19),
                            ),
                            SizedBox(height: 3),
                            Text(
                              sum.toString() + " minutes",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 30,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Total cost incurred',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 19),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '\$230',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 200,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.electric_bolt,
                              size: 30,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Total voltage used',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 19),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '450 Volts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                // calendar widget to show the date of today to the user
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "This month's calendar",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(height: 20), // Add some space between widgets

                      TableCalendar(
                          headerStyle: HeaderStyle(
                              formatButtonVisible: false, titleCentered: true),
                          focusedDay: today,
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 10, 16))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
