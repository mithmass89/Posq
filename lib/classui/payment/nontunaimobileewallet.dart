// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/integrasipayment/classpaymentmidtrans.dart';
import 'package:posq/model.dart';
import 'package:toast/toast.dart';

PaymentGate? paymentapi;

class EWalletClassNonTunai extends StatefulWidget {
  final TextEditingController amountcash;
  final num balance;
  final String? trno;
  final String? pscd;
  final Outlet outletinfo;
  late num result;
  late bool zerobill;
  final Function callback;
  final List<IafjrndtClass> datatrans;
  final bool midtransonline;
  late String? compcode;
  late String? compdescription;
  late String? pymtmthd;
  final void Function(String compcd, String compdesc, String methode)
      checkselected;
  EWalletClassNonTunai(
      {Key? key,
      required this.amountcash,
      required this.balance,
      this.trno,
      this.pscd,
      required this.outletinfo,
      required this.callback,
      required this.zerobill,
      required this.result,
      required this.midtransonline,
      required this.datatrans,
      this.compcode,
      this.compdescription,
      this.pymtmthd,
      required this.checkselected})
      : super(key: key);

  @override
  State<EWalletClassNonTunai> createState() => _EWalletClassNonTunaiState();
}

class _EWalletClassNonTunaiState extends State<EWalletClassNonTunai> {
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  bool paymentsuccess = false;
  String compcd = '';
  String compdesc = '';
  String qr = '';
  List<Midtransitem> listitem = [];
  String email = 'mithmass2@gmail.com';
  String phone = '+6282221769478';
  String guestname = 'Nico Cahya Yunianto';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();

    handler.initializeDB(databasename);
    paymentapi = PaymentGate();
    formattedDate = formatter.format(now);
   
    List.generate(
        widget.datatrans.length,
        (index) => listitem.add(Midtransitem(
            id: '${widget.datatrans[index].itemcode}'.replaceAll(' ', ''),
            price: num.parse(
                '${widget.datatrans[index].totalaftdisc! / widget.datatrans[index].qty!}'),
            quantity: int.parse('${widget.datatrans[index].qty}'),
            name: '${widget.datatrans[index].description}')));
    print(' hasil : $listitem');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: MediaQuery.of(context).size.height * 0.29,
      width: MediaQuery.of(context).size.width * 0.90,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            children: [
              Container(
                child: Text('E - Wallet',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            // color: Colors.grey[100],
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.90,
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1.6,
                crossAxisCount: 3,
              ),
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'gopay'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'gopay.jpg',
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    onpressed: () async {
                      print(serverkeymidtrans);
                      if (widget.midtransonline == true) {
                        await PaymentGate.goPayQris(
                                'gopay',
                                guestname,
                                email,
                                phone,
                                widget.trno.toString(),
                                widget.result.toString(),
                                listitem.toList())
                            .then((value) async {
                          print(value);
                          if (value['status_code'] != '406') {
                            List action = value['actions'];
                            setState(() {
                              qr = action.first['url'];
                            });
                            setState(() {
                              compcd = 'gopay';
                              compdesc = 'gopay';
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogClassEwallet(
                                          datatrans: widget.datatrans,
                                    url: qr,
                                    compcd: compcd,
                                    compdesc: compdesc,
                                    result: widget.result,
                                    balance: widget.balance,
                                    pscd: widget.outletinfo.outletcd,
                                    trno: widget.trno.toString(),
                                    outletinfo: widget.outletinfo,
                                  );
                                });
                          } else {
                            Toast.show("Payment Request already sent",
                                duration: Toast.lengthLong,
                                gravity: Toast.center);
                          }
                        });
                      } else {
                        widget.checkselected(widget.compcode = 'gopay',
                            widget.compdescription = 'gopay', 'E-Wallet');
                        // setState(() {
                        //   widget.compcode = 'gopay';
                        //   widget.compdescription = 'gopay';
                        // });
                        print('di child ${widget.compdescription}');
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'ovo'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    styleasset: BoxFit.fitWidth,
                    name: '',
                    iconasset: 'ovo.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    onpressed: () async {
                      if (widget.midtransonline == true) {
                        await PaymentGate.goPayQris(
                                'qris',
                                guestname,
                                email,
                                phone,
                                widget.trno.toString(),
                                widget.result.toString(),
                                listitem.toList())
                            .then((value) async {
                          print(value);
                          if (value['status_code'] != '406') {
                            List action = value['actions'];
                            setState(() {
                              qr = action.first['url'];
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogClassEwallet(
                                          datatrans: widget.datatrans,
                                    url: qr,
                                    compcd: compcd,
                                    compdesc: compdesc,
                                    result: widget.result,
                                    balance: widget.balance,
                                    pscd: widget.outletinfo.outletcd,
                                    trno: widget.trno.toString(),
                                    outletinfo: widget.outletinfo,
                                  );
                                });
                          } else {
                            Toast.show("Payment Request already sent",
                                duration: Toast.lengthLong,
                                gravity: Toast.center);
                          }
                        });
                      } else {
                        widget.checkselected(widget.compcode = 'ovo',
                            widget.compdescription = 'ovo', 'E-Wallet');
                        // setState(() {
                        //   widget.compcd = 'ovo';
                        //   widget.compdesc = 'ovo';
                        // });
                        print('di child ${widget.compdescription}');
                      }

                      setState(() {
                        compcd = 'ovo';
                        compdesc = 'ovo';
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'dana'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'logo-dana-indonesia.jpg',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      setState(() {
                        compcd = 'dana';
                        compdesc = 'dana';
                      });
                      if (widget.midtransonline == true) {
                        await PaymentGate.goPayQris(
                                'qris',
                                guestname,
                                email,
                                phone,
                                widget.trno.toString(),
                                widget.result.toString(),
                                listitem.toList())
                            .then((value) async {
                          if (value['status_code'] != '406') {
                            List action = value['actions'];
                            setState(() {
                              qr = action.first['url'];
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogClassEwallet(
                                          datatrans: widget.datatrans,
                                    url: qr,
                                    compcd: compcd,
                                    compdesc: compdesc,
                                    result: widget.result,
                                    balance: widget.balance,
                                    pscd: widget.outletinfo.outletcd,
                                    trno: widget.trno.toString(),
                                    outletinfo: widget.outletinfo,
                                  );
                                });
                          }
                          Toast.show("Payment Request already sent",
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        });
                      } else {
                        widget.checkselected(widget.compcode = 'dana',
                            widget.compdescription = 'dana', 'E-Wallet');
                        // setState(() {
                        //   widget.compcd = 'dana';
                        //   widget.compdesc = 'dana';
                        // });
                        print('di child ${widget.compdescription}');
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'shoopepay'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'logo-shopeepay.png',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      setState(() {
                        compcd = 'shoopepay';
                        compdesc = 'shoopepay';
                      });
                      if (widget.midtransonline == true) {
                        await PaymentGate.goPayQris(
                                'qris',
                                guestname,
                                email,
                                phone,
                                widget.trno!,
                                widget.result.toString(),
                                listitem.toList())
                            .then((value) async {
                          if (value['status_code'] != '406') {
                            List action = value['actions'];
                            setState(() {
                              qr = action.first['url'];
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogClassEwallet(
                                          datatrans: widget.datatrans,
                                    url: qr,
                                    compcd: compcd,
                                    compdesc: compdesc,
                                    result: widget.result,
                                    balance: widget.balance,
                                    pscd: widget.outletinfo.outletcd,
                                    trno: widget.trno.toString(),
                                    outletinfo: widget.outletinfo,
                                  );
                                });
                          }
                          Toast.show("Payment Request already sent",
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        });
                      } else {
                        widget.checkselected(widget.compcode = 'shoopepay',
                            widget.compdescription = 'shoopepay', 'E-Wallet');

                        print('di child ${widget.compdescription}');
                        // setState(() {
                        //   widget.compcd = 'shoopepay';
                        //   widget.compdesc = 'shoopepay';
                        // });
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'link'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'link.png',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      setState(() {
                        compcd = 'link';
                        compdesc = 'link';
                      });

                      if (widget.midtransonline == true) {
                        await PaymentGate.goPayQris(
                                'qris',
                                guestname,
                                email,
                                phone,
                                widget.trno.toString(),
                                widget.result.toString(),
                                listitem.toList())
                            .then((value) async {
                          if (value['status_code'] != '406') {
                            List action = value['actions'];
                            setState(() {
                              qr = action.first['url'];
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogClassEwallet(
                                          datatrans: widget.datatrans,
                                    compcd: compcd,
                                    compdesc: compdesc,
                                    result: widget.result,
                                    balance: widget.balance,
                                    pscd: widget.outletinfo.outletcd,
                                    trno: widget.trno.toString(),
                                    outletinfo: widget.outletinfo,
                                  );
                                });
                          }
                          Toast.show("Payment Request already sent",
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        });
                      } else {
                        widget.checkselected(widget.compcode = 'link',
                            widget.compdescription = 'link', 'E-Wallet');

                        print('di child ${widget.compdescription}');
                        // setState(() {
                        //   widget.compcd = 'link';
                        //   widget.compdesc = 'link';
                        // });
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'other'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment2(
                    name: 'Lainnya',
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    onpressed: () async {
                      setState(() {
                        compcd = 'other';
                        compdesc = 'other';
                      });
                      if (widget.midtransonline == true) {
                        await PaymentGate.goPayQris(
                                'qris',
                                guestname,
                                email,
                                phone,
                                widget.trno.toString(),
                                widget.result.toString(),
                                listitem.toList())
                            .then((value) async {
                          if (value['status_code'] != '406') {
                            List action = value['actions'];
                            setState(() {
                              qr = action.first['url'];
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogClassEwallet(
                                          datatrans: widget.datatrans,
                                    compcd: compcd,
                                    compdesc: compdesc,
                                    result: widget.result,
                                    balance: widget.balance,
                                    pscd: widget.outletinfo.outletcd,
                                    trno: widget.trno.toString(),
                                    outletinfo: widget.outletinfo,
                                  );
                                });
                          }
                          Toast.show("Payment Request already sent",
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        });
                      } else {
                        setState(() {
                          widget.compcode = '';
                          widget.compdescription = '';
                        });
                        widget.checkselected(widget.compcode = 'other',
                            widget.compdescription = 'other', 'E-Wallet');

                        print('di child ${widget.compdescription}');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.yellow[100]),
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.88,
            child: Row(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(color: Colors.yellow[100]),
                    child: Text('Integrasi Pembayaran Online')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ClassPaymentMidtrans();
                      }));
                    },
                    child: Text('disini'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
