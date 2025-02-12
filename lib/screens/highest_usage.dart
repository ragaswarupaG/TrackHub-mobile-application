import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';
import 'package:mbap_project_part_2/widgets/most_used.dart';


// this is a screen which filters out records based on thier duration
class HighestUsage extends StatefulWidget {
  static String routeName = '/highest-usage';

  @override
  State<HighestUsage> createState() => _HighestUsageState();
}

class _HighestUsageState extends State<HighestUsage> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();  //using the firebase
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor:Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            'TrackHub',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body:MostUsed(),    // calling out the function whihc performs the actions of retreiving 
       
  );}
}