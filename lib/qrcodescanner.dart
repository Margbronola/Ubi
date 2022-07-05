// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QrCodeScanner extends StatefulWidget {
//   const QrCodeScanner({ Key? key }) : super(key: key);

//   @override
//   State<QrCodeScanner> createState() => _QrCodeScannerState();
// }

// class _QrCodeScannerState extends State<QrCodeScanner> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   void reassemble(){
//     super.reassemble();
//     if(Platform.isAndroid){
//       controller!.pauseCamera();
//     }else if(Platform.isIOS){
//       controller!.resumeCamera();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         backgroundColor: const Color.fromARGB(255, 40, 84, 232),
//         elevation: 0,
//         title: const Text("QR Code Scanner", textAlign: TextAlign.left),
//         titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
//       ),

//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 3,
//             child: _buildQrView(context)
//           ),
//           Expanded(
//             flex: 1,
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   if(result != null)
//                     Text('Barcode Type : ${describeEnum(result!.format)} Data: ${result!.code}')
//                   else
//                     const Text('Scan a code'),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Container(
//                         width: 140,
//                         height: 30,
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async{
//                             await controller?.toggleFlash();
//                             setState(() {});
//                           },
//                           child: FutureBuilder(
//                             future: controller?.getFlashStatus(),
//                             builder: (context, snapshot){
//                               return Text('Flash: ${snapshot.data}');
//                             },
//                           ),
//                         ),
//                       ),

//                       Container(
//                         width: 140,
//                         height: 30,
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async{
//                             await controller?.flipCamera();
//                             setState(() {});
//                           }, 
//                           child: FutureBuilder(
//                             future: controller?.getCameraInfo(),
//                             builder: (context, snapshot) {
//                               if (snapshot.data != null){
//                                 return Text('Camera facing ${describeEnum(snapshot.data!)}');
//                               } else {
//                                 return const Text('Loading');
//                               }
//                             }
//                           )
//                         ),
//                       )
//                     ],
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 30,
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async{
//                             await controller?.pauseCamera();
//                             setState(() {});
//                           },  
//                           child: const Text('Pause', style: TextStyle(fontSize: 15),),
//                         )
//                       ),

//                       Container(
//                         width: 100,
//                         height: 30,
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async{
//                             await controller?.resumeCamera();
//                             setState(() {});
//                           },  
//                           child: const Text('Resume', style: TextStyle(fontSize: 15),),
//                         )
//                       )
//                     ],
//                   )

//                 ],
//               ),
//             )
//           )
//         ]
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context){
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//       MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;

//     return QRView(
//       key: qrKey, 
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: Colors.blueGrey,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: scanArea
//       ),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller){
//       this.controller = controller;
//     // setState(() {
//     // });
//     controller.scannedDataStream.listen((scanData) { 
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p){
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p){
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Permission')),);
//     }
//   }

//   @override
//   void dispose(){
//     controller?.dispose();
//     super.dispose();
//   }

// }