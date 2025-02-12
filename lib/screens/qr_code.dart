import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRpage extends StatefulWidget {
  static String routeName ='/qr'; 
  @override
  State<QRpage> createState() => _QRpageState();
}

class _QRpageState extends State<QRpage> {
 // this page is suppsoed to display the QR scanner 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         toolbarHeight: 80,
         
          backgroundColor:Theme.of(context).colorScheme.inversePrimary,
          title: const Text('TrackHub' , style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold) ,),
        ),
  
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed:    DetectionSpeed.noDuplicates,   //wont allow duplicate scanning
          returnImage: true
        ),
        
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List ? image = capture.image;

          for (final barcode in barcodes){
            print("barcode found! ${barcode.rawValue}");
          }

          if (image!= null){
            showDialog(context: context, builder: (context){
              return AlertDialog(title: Text(
                barcodes.first.rawValue ?? "",
              ),
              content: Image(image: MemoryImage(image),),
              );
            });
          }
          
      })
    );
  }
}