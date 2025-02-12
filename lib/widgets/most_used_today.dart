import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbap_project_part_2/models/myrecord.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';
import 'package:get_it/get_it.dart';



// most used today widget, filters out records based on thier duration & usage date
class MostUsedToday extends StatefulWidget {
  @override
  State<MostUsedToday> createState() => _MostUsedTodayState();
}

class _MostUsedTodayState extends State<MostUsedToday> {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MyRecord>>(
      stream: fbService.getRecordsWithMultipleCondition(),     //getting the query from the fb service
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No record has a high usage for today! Great job'),
              ],
            ),
          );
        }

        var myRetrievedRecord = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appliances which are used for more than 100 minutes today:',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'Please try to reduce your usage & be more sustainable!',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 177, 177, 177),
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: myRetrievedRecord.length,
                itemBuilder: (context, index) {
                  var record = myRetrievedRecord[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
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
                            "${record.duration} minutes",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('dd/MM/yyyy').format(record.usageDate),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      tileColor:Theme.of(context).colorScheme.inversePrimary,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

