import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/databasehandler.dart';
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
      required this.datatrans,})
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

    handler.initializeDB();
    paymentapi = PaymentGate();
    formattedDate = formatter.format(now);
    List.generate(
        widget.datatrans.length,
        (index) => listitem.add(Midtransitem(
            id: '${widget.datatrans[index].itemcd}'.replaceAll(' ', ''),
            price: num.parse(
                '${widget.datatrans[index].nettamt! / widget.datatrans[index].qty!}'),
            quantity: int.parse('${widget.datatrans[index].qty}'),
            name: '${widget.datatrans[index].trdesc}')));
    print(listitem);
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
                child: Text('E-Wallet',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.grey[100],
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
                ButtonClassPayment(
                  name: '',
                  iconasset: 'gopay.jpg',
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  onpressed: () async {
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
                            duration: Toast.lengthLong, gravity: Toast.center);
                      }
                    });
                  },
                ),
                ButtonClassPayment(
                  styleasset: BoxFit.fitWidth,
                  name: '',
                  iconasset: 'ovo.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  onpressed: () async {
                    setState(() {
                      compcd = 'ovo';
                      compdesc = 'ovo';
                    });
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
                            duration: Toast.lengthLong, gravity: Toast.center);
                      }
                    });
                  },
                ),
                ButtonClassPayment(
                  name: '',
                  iconasset: 'logo-dana-indonesia.jpg',
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  onpressed: () async {
                    setState(() {
                      compcd = 'dana';
                      compdesc = 'dana';
                    });
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
                          duration: Toast.lengthLong, gravity: Toast.center);
                    });
                  },
                ),
                ButtonClassPayment(
                  name: '',
                  iconasset: 'logo-shopeepay.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  onpressed: () async {
                    setState(() {
                      compcd = 'shoopepay';
                      compdesc = 'shoopepay';
                    });
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
                          duration: Toast.lengthLong, gravity: Toast.center);
                    });
                  },
                ),
                ButtonClassPayment(
                  name: '',
                  iconasset: 'link.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  onpressed: () async {
                    setState(() {
                      compcd = 'link';
                      compdesc = 'link';
                    });
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
                          duration: Toast.lengthLong, gravity: Toast.center);
                    });
                  },
                ),
                ButtonClassPayment2(
                  name: 'Lainnya',
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  onpressed: () async {
                    setState(() {
                      compcd = 'other';
                      compdesc = 'other';
                    });
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
                          duration: Toast.lengthLong, gravity: Toast.center);
                    });
                  },
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
                TextButton(onPressed: () {}, child: Text('disini'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
