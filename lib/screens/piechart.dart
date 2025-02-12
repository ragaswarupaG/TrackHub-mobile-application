import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part_2/models/myrecord.dart';
import 'package:mbap_project_part_2/services/firebase_service.dart';

// This page i will be showing the pie chart

class PieChartVisual extends StatefulWidget {
  final FirebaseService fbService = GetIt.instance<FirebaseService>();
  static String routeName = '/piechart';

  @override
  State<PieChartVisual> createState() => _PieChartVisualState();
}

class _PieChartVisualState extends State<PieChartVisual> {
  late List<Tuple2<String, double>> values;

  @override
  void initState() {
    super.initState();
    values = [];   // storing values 
    
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MyRecord>>(
      stream: widget.fbService.getRecord(),  //getting all the records
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<String> applianceNames = [];   // for each appliance name, i am placing it in this
          for (var doc in snapshot.data!) {
            applianceNames.add(doc.name);
          }

          Map<String, int> counts = {};  //the count for each appliance will be stored here
          for (var name in applianceNames) {
            counts[name] = (counts[name] ?? 0) + 1;
          }
          
        
          values = counts.entries
              .map((entry) => Tuple2(entry.key, entry.value.toDouble()))
              .toList();
          
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              'TrackHub',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          body: _buildUI(),
        );
      },
    );
  }


//havign a widget to build the pie chart

  Widget _buildUI() {
  
  return Column(
    mainAxisSize: MainAxisSize.min,
    
    children: [
      const Padding(
        padding: EdgeInsets.all(28.0),
        child: Text(
          'Appliance usage count',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      Expanded(
        child: PieChart(
          PieChartData(
            sections: pieChartSections(),  // calling function
            sectionsSpace: 0,
            centerSpaceRadius: 60,  //doughnut pie chart
          ),
        ),
      ),
    ],
  );
}


 

  List<PieChartSectionData> pieChartSections() {
    List<Color> sectionColors = [
   // putting differetn colors into the list
      Color.fromARGB(255, 82, 172, 228),
      const Color.fromARGB(255, 191, 251, 193),
         Color.fromARGB(255, 255, 212, 209),
      Colors.yellow,
      const Color.fromARGB(255, 173, 218, 255),
      Colors.green,
      Color.fromARGB(255, 198, 193, 255),
      Color.fromARGB(255, 219, 103, 71),
      const Color.fromARGB(255, 172, 172, 172),
    ];


// here, the color gets assigned to the values with count
    return List.generate(values.length, (i) {
      final radius = 100.0;
      final fontSize = 30.0;
      final tuple = values[i];

      return PieChartSectionData(
        color: sectionColors[i % sectionColors.length],
        radius: radius,
        value: tuple.count,
        title: "${tuple.name}\n${tuple.count.toInt()}",
        titleStyle: TextStyle(
         
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      );
    });
  }
}

class Tuple2<T1, T2> {
  final T1 name;
  final T2 count;

  Tuple2(this.name, this.count);
}


