import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mbap_project_part_2/models/myrecord.dart';
import 'package:mbap_project_part_2/screens/update_page.dart';
import 'package:mbap_project_part_2/services/firebase_notification_service.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';



// home page for the app 

class HomePage extends StatefulWidget {
  static String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  List<MyRecord>? myRetrievedRecord;  // putting the retrieved items in this list
  TextEditingController searchController = TextEditingController(); // for the search query
  String searchQuery = "";

  void deleteRecord(String id) {   //deletion of the record in a alert dialog
    showDialog<Null>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
            'Are you sure you want to delete this record?'
            
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
                      ),
                    ),
                  );
                  setState(() {
                    myRetrievedRecord = null;
                  });
                  Navigator.of(context).pop();
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


// this is for the shuffle feature where users can shuffle the records
  void shuffleList() {
    setState(() {
      myRetrievedRecord?.shuffle();
      if (myRetrievedRecord != null && myRetrievedRecord!.isNotEmpty) {
        debugPrint(myRetrievedRecord![0].name.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<MyRecord>>(
        stream: fbService.getRecord(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {  //in the event where there r no records at all in the databse
            return Center(
              child: Text(
                'No records yet, add a new one today!',
                style: TextStyle( fontWeight: FontWeight.bold),
              ),
            );
          }

          if (myRetrievedRecord == null) myRetrievedRecord = snapshot.data;

       

          // Filtered list based on the search query
          List<MyRecord> filteredRecords = myRetrievedRecord!.where((record) {
            return record.name.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();



          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your electrical usage!',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                   
                  ),
                  const SizedBox(height: 30),

                  TextField(
                    controller: searchController,
                    onSubmitted: (value) {
                      setState(() {
                        searchQuery = value;
                      
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for your records here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: 230,
                    height: 45,
                    child: Container(
                      color: const Color.fromARGB(92, 173, 173, 173),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        child: DropdownButtonFormField<String>(
                          value: 'Highest to Lowest',
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'Highest to Lowest',
                              child: Text('Highest to Lowest'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Lowest to Highest',
                              child: Text('Lowest to Highest'),
                            ),
                          ],
                          onChanged: (String? value) {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  ListView.builder(    // putting the records in a listview builder so that it is more organised
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      var record = filteredRecords[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          tileColor: Theme.of(context).colorScheme.inversePrimary,
                          key: Key(record.id),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            record.name,
                            style: const TextStyle(fontSize: 25),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.duration.toString() + " minutes",
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                  record.usageDate,
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          // handling what the icons are meant to do
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    UpdateRecord.routeName,
                                    arguments: record,
                                  ).then((value) {
                                    setState(() {
                                      myRetrievedRecord = null; 
                                    });
                                  });
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  deleteRecord(record.id);
                                  setState(() {
                                    myRetrievedRecord = null; 
                                  });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: () {
                      debugPrint('shuffle button is clicked');
                      shuffleList();
                    },
                    child: const Icon(Icons.shuffle),
                  ),

                  SizedBox(height: 20,),

                // local notification

                  ElevatedButton(onPressed: (){
                      NotificationService()
                     .showNotification(title: 'TrackHub', body: 'Remember to reduce electrical usage!');


                  }, child: Text("View all notifications"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
