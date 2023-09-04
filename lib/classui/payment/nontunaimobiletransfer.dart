// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

PaymentGate? paymentapi;

class NonTunaiMobileTransfer extends StatefulWidget {
  final String trno;
  final String pscd;
  late num? result;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? discbyamount;
  final List<IafjrndtClass> datatrans;
  late bool zerobill;
  final Function callback;
  final bool midtransonline;
  late String? compcode;
  late String? compdescription;
  final bool fromsaved;
  final bool fromsplit;
  final String guestname;
  final void Function(String compcd, String compdesc, String methode)
      checkselected;

  NonTunaiMobileTransfer(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.balance,
      this.outletname,
      this.outletinfo,
      this.discbyamount,
      this.result,
      required this.zerobill,
      required this.datatrans,
      required this.midtransonline,
      required this.callback,
      this.compcode,
      this.compdescription,
      required this.checkselected,
      required this.fromsaved,
      required this.fromsplit,
      required this.guestname})
      : super(key: key);

  @override
  State<NonTunaiMobileTransfer> createState() => _NonTunaiMobileTransferState();
}

class _NonTunaiMobileTransferState extends State<NonTunaiMobileTransfer> {
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  bool paymentsuccess = false;
  String compcd = '';
  String compdesc = '';
  String virtualaccount = '';
  String bank = '';
  String bill_key = '';
  String biller_code = '';
  String transactionstatus = '';
  num totalamount = 0;
  String email = 'mithmass2@gmail.com';
  String phone = '+6282221769478';
  String guestname = 'None';
  List<Midtransitem> listitem = [];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    formattedDate = formatter.format(now);
    paymentapi = PaymentGate();

    List.generate(widget.datatrans.length, (index) {
      print('ini nett ${widget.datatrans[index].totalaftdisc!}');
      listitem.add(Midtransitem(
          id: '${widget.datatrans[index].itemcode}'.replaceAll(' ', ''),
          price: widget.datatrans[index].totalaftdisc! /
              widget.datatrans[index].qty!,
          quantity: int.parse('${widget.datatrans[index].qty}'),
          name: '${widget.datatrans[index].description}'));
    });
    // print(listitem);
    checkSF();
  }

  checkSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String guestPref = prefs.getString('savecostmrs') ?? "";
    if (guestPref.isNotEmpty) {
      Map<String, dynamic> userMap =
          jsonDecode(guestPref) as Map<String, dynamic>;
      if (userMap != []) {
        setState(() {
          guestname = userMap['guestname'];
          email = userMap['email'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: Colors.grey[100],
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            children: [
              Container(
                child: Text('Bank Transfer',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
            color: Colors.grey[100],
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.90,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1.6,
              crossAxisCount: 3,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'BCA VA'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'assets/bca.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    onpressed: () async {
                      widget.checkselected(widget.compcode = 'BCAVA',
                          widget.compdescription = 'BCA VA', 'Transfer');
                      setState(() {
                        widget.compcode = 'BCAVA';
                        widget.compdescription = 'BCA VA';
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'BNI VA'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'assets/bni.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    onpressed: () async {
                      setState(() {
                        compcd = 'BNIVA';
                        compdesc = 'BNI VA';
                      });

                      widget.checkselected(widget.compcode = 'BNIVA',
                          widget.compdescription = 'BNI VA', 'Transfer');
                      // setState(() {
                      //   widget.compcode = 'BNIVA';
                      //   widget.compdescription = 'BNI VA';
                      // });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'BRI VA'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'assets/bri.png',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      widget.checkselected(widget.compcode = 'BRIVA',
                          widget.compdescription = 'BRI VA', 'Transfer');
                      setState(() {
                        compcd = 'BRIVA';
                        compdesc = 'BRI VA';
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'MANDIRI VA'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'assets/mandiri.png',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      widget.checkselected(widget.compcode = 'MANDIRIVA',
                          widget.compdescription = 'MANDIRI VA', 'Transfer');
                      setState(() {
                        widget.compcode = 'MANDIRIVA';
                        widget.compdescription = 'MANDIRI VA';
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'PERMATA VA'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'assets/permatabank.png',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      widget.checkselected(widget.compcode = 'PERMATAVA',
                          widget.compdescription = 'PERMATA VA', 'Transfer');
                      setState(() {
                        widget.compcode = 'PERMATAVA';
                        widget.compdescription = 'PERMATA VA';
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'Lainnya'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment2(
                    name: 'Lainnya',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      widget.checkselected(widget.compcode = 'Lainnya',
                          widget.compdescription = 'Lainnya', 'Transfer');
                      setState(() {
                        widget.compcode = 'Lainnya';
                        widget.compdescription = 'Lainnya';
                      });
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: ButtonClassPayment(
                //     name: '',
                //     iconasset: '',
                //     height: MediaQuery.of(context).size.height * 0.1,
                //     width: MediaQuery.of(context).size.width * 0.1,
                //     onpressed: () {
                //       setState(() {
                //         compcd = 'qris';
                //         compdesc = 'qris';
                //       });
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
