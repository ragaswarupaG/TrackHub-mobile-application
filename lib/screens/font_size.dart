import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbap_project_part_2/services/font_service.dart';


// this handles the font sizing in the app

class FontSize extends StatefulWidget {
  FontService fontService = GetIt.instance<FontService>();

  static String routeName = '/font-size';  //in this page, users can select the font size they need

  @override
  State<FontSize> createState() => _FontSizeState();
}

class _FontSizeState extends State<FontSize> {
  double _fontSize = 16.0; //original font size

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'TrackHub',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(

          children: [
            SizedBox(height: 20),




            ElevatedButton(
              onPressed: () {
                setState(() {
                  _fontSize = 20.0;   // new font size
                  widget.fontService.setFont(_fontSize);  //using the service to make sure the new font size is set
                });
              },
              child: Text("Click me for a bigger font"),
            ),




            SizedBox(height: 20),




            ElevatedButton(      //another button to reset to the regular font size
              onPressed: () {
                setState(() {
                  _fontSize = 16.0;
                  widget.fontService.setFont(_fontSize);
                });
              },
              child: Text("Click me for the regular font"),
            ),



            SizedBox(height: 20),
            Text(
              'Hello! This is how your font will look like',   //sample text for users to view 
              style: TextStyle(fontSize: _fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
