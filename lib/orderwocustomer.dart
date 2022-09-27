import 'package:flutter/material.dart';
import 'package:internapp/productpage.dart';

class OrderWithoutCustomer extends StatefulWidget {
  const OrderWithoutCustomer({ Key? key }) : super(key: key);

  @override
  State<OrderWithoutCustomer> createState() => _OrderWithoutCustomerState();
}

class _OrderWithoutCustomerState extends State<OrderWithoutCustomer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: ProductPage(isFromLocalPage: false, isFromWithoutCustomer: true),
      ),
    );
  }
}


// return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               color: Colors.amber,
//               width: size.width,
//               height: size.height *.20,
//               child: Column(
//                 children: [
                  
//                 ]
//               ),
//             ),

//             const SizedBox(
//               height: 10,
//             ),

//             SizedBox(
//               width: size.width,
//               height: 60,
//               child: ElevatedButton(
//                 child: const Text('Take Order',
//                   style: TextStyle(
//                     color: Colors.white, 
//                     fontSize: 25, 
//                     letterSpacing: 5
//                   )
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15)
//                   ), 
//                   backgroundColor: const Color.fromARGB(255, 40, 84, 232)
//                 ),
//                 onPressed: (){
//                   Navigator.push(
//                     context, MaterialPageRoute(
//                       builder: (context) => ProductPage(
//                         isFromLocalPage: true, 
//                         height: 685,
//                         // cusname: _customername.text,
//                         // cusid: customerDetails!.id,
//                       )
//                     )
//                   );
//                 },
//               ),
//             )
//           ],
//         )
//       ),
//     );