import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:internapp/profile_page.dart';

// ignore: must_be_immutable
class ScannerPage extends StatefulWidget {
  ScannerPage({ Key? key, this.isFromLocalPage = false}) : super(key: key);
  bool isFromLocalPage;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: widget.isFromLocalPage ? AppBar(
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 235),
                  child: SizedBox(
                    width: 100,
                    child: Image.asset("assets/images/WhiteLogo.png")
                  )
                ),
    
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
    
                child: IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      constraints: BoxConstraints(
                        maxHeight: size.height,
                      ),
                      context: context,
                      builder: (_) => BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY:5),
                        child: const ProfilePage()
                      )
                    );
                  }, 
                  icon: const Icon(Icons.person_rounded, color: Colors.blue)
                ),
              ),
            )
              ],
            ),
          ],
          automaticallyImplyLeading: false,
          elevation: 5,
          backgroundColor: const Color.fromARGB(255, 40, 84, 232),
        ) : null,
        
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context, MaterialPageRoute(
                    //     builder: (context) => const QrCodeScanner()
                    //   )
                    // );
                  },
                  child: Container(
                    width: 170,
                    height: 170,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color.fromARGB(255, 40, 84, 232)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 90),
                          Text('QR code\nScanner', style: TextStyle(fontSize: 25, color: Colors.white))
                        ],
                      ),
                  ),
                ),
              ),

              // Container(
              //   width: 170,
              //   height: 170,
              //   decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),
              //     color: Color.fromARGB(255, 40, 84, 232)),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: const [
              //       Padding(
              //         padding: EdgeInsets.only(top: 10),
              //         child: ImageIcon(AssetImage("assets/icons/barcode.png"), color: Colors.white, size: 90),
              //       ),
              //       Text('Barcode\nScanner', style: TextStyle(fontSize: 25, color: Colors.white))
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}