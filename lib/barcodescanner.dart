import 'package:flutter/material.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({ Key? key }) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 40, 84, 232),
        elevation: 0,
        title: const Text("Barcode Scanner", textAlign: TextAlign.left),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}