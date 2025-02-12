import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mbap_project_part_2/services/firebase_service.dart';
import 'package:mbap_project_part_2/widgets/most_used_today.dart';

// creating a screen to filter out records to display the appliance with a high usage today
class HighestUsageToday extends StatefulWidget {
  static String routeName = '/highest-usageToday';

  @override
  State<HighestUsageToday> createState() => _HighestUsageTodayState();
}


class _HighestUsageTodayState extends State<HighestUsageToday> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
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
      body: MostUsedToday(), // calling out the function 
    );
  }
}