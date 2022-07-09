// // ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print

// import 'package:flutter/material.dart';
// import 'package:posq/classui/buttonclass.dart';
// import 'package:posq/classui/classformat.dart';
// import 'package:posq/classui/classpaymenttransfermobile.dart';
// import 'package:posq/classui/classtabcashmobile.dart';
// import 'package:posq/classui/classtextfield.dart';
// import 'package:posq/classui/paymentewalletmobile.dart';
// import 'package:posq/model.dart';

// class PaymentMobileClass extends StatefulWidget {
//   final String trno;
//   final String pscd;
//   final String trdt;
//   final num balance;
//   final String? outletname;
//   final Outlet? outletinfo;
//   final List<IafjrndtClass> datatrans;

//   const PaymentMobileClass(
//       {Key? key,
//       required this.trno,
//       required this.pscd,
//       required this.trdt,
//       required this.balance,
//       required this.outletname,
//       required this.outletinfo,
//       required this.datatrans,})
//       : super(key: key);

//   @override
//   State<PaymentMobileClass> createState() => _PaymentMobileClassState();
// }

// class _PaymentMobileClassState extends State<PaymentMobileClass>
//     with SingleTickerProviderStateMixin {
//   final discountamount = TextEditingController(text: '0');
//   final discountpct = TextEditingController(text: '0');
//   final amountcash = TextEditingController(text: '0');
//   TabController? controller;
//   bool? discbyamount = true;
//   bool balancenotzero = true;
//   num result = 0;
//   num? hasildiscpct = 0;

//   @override
//   void initState() {
//     result = widget.balance - num.parse(amountcash.text);
//     print('ini outlet ${widget.pscd}');
//     super.initState();
//     amountcash.addListener(() {
//       setState(() {
//         result = widget.balance -
//             num.parse(amountcash.text) -
//             int.parse(discountamount.text);
//       });
//     });
//     controller = TabController(vsync: this, length: 3);
//   }

//   @override
//   void dispose() {
//     // controller!.dispose();
//     // _pc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         clipBehavior: Clip.none,
//         fit: StackFit.loose,
//         children: [
//           Positioned(
//             height: MediaQuery.of(context).size.height * 0.25,
//             width: MediaQuery.of(context).size.width * 1,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.25,
//               width: MediaQuery.of(context).size.width * 1,
//               decoration: const BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(70),
//                     bottomRight: Radius.circular(70)),
//               ),
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.15,
//             left: MediaQuery.of(context).size.width * 0.07,
//             child: Material(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               elevation: 5,
//               child: Container(
//                 alignment: Alignment.center,
//                 height: MediaQuery.of(context).size.height * 0.15,
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Total Pembayaran',
//                       style: TextStyle(color: Colors.blue, fontSize: 20),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.01,
//                       width: MediaQuery.of(context).size.width * 0.01,
//                     ),
//                     Text(
//                       '${CurrencyFormat.convertToIdr(widget.balance, 0)}',
//                       style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 25,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//               height: MediaQuery.of(context).size.height * 0.07,
//               width: MediaQuery.of(context).size.width * 0.85,
//               top: MediaQuery.of(context).size.height * 0.33,
//               left: MediaQuery.of(context).size.width * 0.07,
//               child: Material(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 elevation: 5,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     discbyamount == true
//                         ? Container(
//                             height: MediaQuery.of(context).size.height * 0.07,
//                             width: MediaQuery.of(context).size.width * 0.47,
//                             decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20)),
//                                 color: Colors.white),
//                             child: TextFieldMobileCustome(
//                               maxline: 1,
//                               outline: 0,
//                               label: 'Discount By Amount',
//                               controller: discountamount,
//                               onChanged: (String value) {
//                                 setState(() {
//                                   result = widget.balance -
//                                       int.parse(value) -
//                                       int.parse(amountcash.text);
//                                   // print(result);
//                                 });
//                               },
//                               // onSumbit: (value) {
//                               //   result = widget.balance -
//                               //       int.parse(value) -
//                               //       int.parse(amountcash.text);
//                               //   print(result);
//                               // },
//                               typekeyboard: TextInputType.number,
//                             ),
//                           )
//                         : Container(
//                             height: MediaQuery.of(context).size.height * 0.07,
//                             width: MediaQuery.of(context).size.width * 0.47,
//                             decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20)),
//                                 color: Colors.white),
//                             child: TextFieldMobileCustome(
//                               maxline: 1,
//                               outline: 0,
//                               label: 'Discount By Percent',
//                               controller: discountpct,
//                               onChanged: (value) {
//                                 setState(() {
//                                   result = widget.balance -
//                                       (widget.balance *
//                                           int.parse(value) /
//                                           100) -
//                                       int.parse(amountcash.text);
//                                 });
//                                 // print(result);
//                               },
//                               // onSumbit: (value) {
//                               //   setState(() {
//                               //     result = widget.balance -
//                               //         (widget.balance *
//                               //             int.parse(value) /
//                               //             100) -
//                               //         int.parse(amountcash.text);
//                               //   });
//                               //   print(result);
//                               // },
//                               typekeyboard: TextInputType.number,
//                             ),
//                           ),
//                     Row(
//                       children: [
//                         Bouncing(
//                             onPress: () {
//                               setState(() {
//                                 discbyamount = true;
//                                 discountpct.text = '0';
//                               });
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20),
//                                       bottomLeft: Radius.circular(20)),
//                                   // borderRadius:
//                                   //     BorderRadius.all(Radius.circular(20)),
//                                   color: discbyamount == true
//                                       ? Colors.blue
//                                       : Colors.white),
//                               height: MediaQuery.of(context).size.height * 0.06,
//                               width: MediaQuery.of(context).size.width * 0.15,
//                               child: Text(
//                                 'Rp',
//                                 style: TextStyle(
//                                     color: discbyamount == true
//                                         ? Colors.white
//                                         : Colors.blue,
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             )),
//                         Bouncing(
//                             onPress: () {
//                               setState(() {
//                                 discbyamount = false;
//                                 discountamount.text = '0';
//                               });
//                             },
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(20),
//                                         bottomRight: Radius.circular(20)),
//                                     color: discbyamount == false
//                                         ? Colors.blue
//                                         : Colors.white),
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.06,
//                                 width: MediaQuery.of(context).size.width * 0.15,
//                                 child: Text(
//                                   '%',
//                                   style: TextStyle(
//                                       color: discbyamount == false
//                                           ? Colors.white
//                                           : Colors.blue,
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold),
//                                 )))
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//           Positioned(
//               top: MediaQuery.of(context).size.height * 0.42,
//               left: MediaQuery.of(context).size.width * 0.14,
//               child: Material(
//                 child: Container(
//                     alignment: Alignment.centerLeft,
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     width: MediaQuery.of(context).size.width * 0.80,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                         color: Colors.transparent),
//                     child: Text(
//                       'Methode Pembayaran',
//                       style: TextStyle(color: Colors.blue, fontSize: 17),
//                     )),
//               )),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.47,
//             left: MediaQuery.of(context).size.width * 0.07,
//             child: Material(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               elevation: 5,
//               child: Container(
//                 alignment: Alignment.center,
//                 height: MediaQuery.of(context).size.height * 0.47,
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.01,
//                       width: MediaQuery.of(context).size.width * 0.85,
//                     ),
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.05,
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       child: TabBar(
//                         // indicator: BoxDecoration(
//                         //     // gradient: LinearGradient(colors: [
//                         //     //   Colors.blue,
//                         //     //   Colors.yellow
//                         //     // ]),
//                         //     borderRadius: BorderRadius.circular(5),
//                         //     color: Colors.blue),
//                         // unselectedLabelColor: Colors.blue,
//                         // labelColor: Colors.white,
//                         // labelStyle: TextStyle(color: Colors.white),
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         controller: controller,
//                         tabs: [
//                           Text('CASH',
//                               style:
//                                   TextStyle(color: Colors.blue, fontSize: 15)),
//                           Text('E-WALLET',
//                               style:
//                                   TextStyle(color: Colors.blue, fontSize: 15)),
//                           Text('TRANSFER',
//                               style:
//                                   TextStyle(color: Colors.blue, fontSize: 15)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.35,
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       child: TabBarView(controller: controller, children: [
//                         PaymentCashMobile(
                  
//                           outletinfo: widget.outletinfo!,
//                           outletname: widget.outletname,
//                           discbyamount: discbyamount,
//                           hasildiscpct: hasildiscpct,
//                           discpct: discountpct,
//                           trno: widget.trno,
//                           pscd: widget.pscd,
//                           result: result,
//                           balancenotzero: balancenotzero,
//                           discountamount: discountamount,
//                           amount: amountcash,
//                           balance: widget.balance.toInt(),
//                         ),
//                         PaymentEwalletMobile(
                  
//                           datatrans: widget.datatrans,
//                           result: result,
//                           discbyamount: discbyamount,
//                           outletinfo: widget.outletinfo!,
//                           outletname: widget.outletname,
//                           trno: widget.trno,
//                           pscd: widget.pscd,
//                           balance: widget.balance.toInt(),
//                         ),
//                         PaymentTransferMobile(
                     
//                           datatrans: widget.datatrans,
//                           result: result,
//                           discbyamount: discbyamount,
//                           outletinfo: widget.outletinfo!,
//                           outletname: widget.outletname,
//                           trno: widget.trno,
//                           pscd: widget.pscd,
//                           balance: widget.balance.toInt(),
//                         ),
//                       ]),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
