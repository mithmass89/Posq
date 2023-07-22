// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

PaymentGate? paymentapi;

class PaymentDebitCardMobile extends StatefulWidget {
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
  final void Function(String compcd, String compdesc, String methode)
      checkselected;
  final bool fromsplit;
  final String guestname;
  PaymentDebitCardMobile({
    Key? key,
    required this.midtransonline,
    required this.trno,
    required this.pscd,
    required this.balance,
    this.outletname,
    this.outletinfo,
    this.discbyamount,
    required this.datatrans,
    required this.zerobill,
    this.result,
    required this.callback,
    this.compcode,
    this.compdescription,
    required this.checkselected,
    required this.fromsaved,
    required this.fromsplit,
    required this.guestname,
  }) : super(key: key);

  @override
  State<PaymentDebitCardMobile> createState() => _PaymentDebitCardMobileState();
}

class _PaymentDebitCardMobileState extends State<PaymentDebitCardMobile> {
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
    print(widget.result);
    List.generate(
        widget.datatrans.length,
        (index) => listitem.add(Midtransitem(
            id: '${widget.datatrans[index].itemcode}'.replaceAll(' ', ''),
            price: num.parse(
                '${widget.datatrans[index].totalaftdisc! / widget.datatrans[index].qty!}'),
            quantity: int.parse('${widget.datatrans[index].qty}'),
            name: '${widget.datatrans[index].description}')));
    print(listitem);
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
                child:
                    Text('EDC', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      color: widget.compdescription == 'Debit Card BCA'
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
                      widget.checkselected(
                          widget.compcode = 'DBTBCA',
                          widget.compdescription = 'Debit Card BCA',
                          'Debit Card');
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'Debit Card BNI'
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

                      widget.checkselected(
                          widget.compcode = 'DBTBNI',
                          widget.compdescription = 'Debit Card BNI',
                          'Debit Card');
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'Debit Card BRI'
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
                      widget.checkselected(
                          widget.compcode = 'DBTBRI',
                          widget.compdescription = 'Debit Card BRI',
                          'Debit Card');
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'Debit Card MANDIRI'
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
                      widget.checkselected(
                          widget.compcode = 'DBTMANDIRI',
                          widget.compdescription = 'Debit Card MANDIRI',
                          'Debit Card');
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'Debit Card PERMATA'
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

                        widget.checkselected(
                            widget.compcode = 'DBTPERMATA',
                            widget.compdescription = 'Debit Card PERMATA',
                            'Debit Card');
                      
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'OTHERS'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment2(
                    name: 'Lainnya',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                    
                        widget.checkselected(
                            widget.compcode = 'DBTOTHERS',
                            widget.compdescription = 'Debit Card OTHERS',
                            'Debit Card');
                      
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
