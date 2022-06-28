// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

PaymentGate? paymentapi;

class PaymentEwalletMobile extends StatefulWidget {
  final String trno;
  final String pscd;
  late num? result;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? discbyamount;
  final List<IafjrndtClass> datatrans;

  PaymentEwalletMobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.balance,
      this.result,
      this.outletname,
      this.outletinfo,
      this.discbyamount,
      required this.datatrans, })
      : super(key: key);

  @override
  State<PaymentEwalletMobile> createState() => _PaymentEwalletMobileState();
}

class _PaymentEwalletMobileState extends State<PaymentEwalletMobile> {
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
            price: num.parse('${widget.datatrans[index].nettamt!/widget.datatrans[index].qty!}'),
            quantity: int.parse('${widget.datatrans[index].qty}'),
            name: '${widget.datatrans[index].trdesc}')));
    print(listitem);
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        trno: widget.trno,
        split: 'A',
        pscd: widget.pscd,
        trtm: '00:00',
        disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
        pax: '1',
        pymtmthd: 'EWALLET',
        ftotamt: double.parse(widget.balance.toString()),
        totalamt: double.parse(widget.balance.toString()),
        framtrmn: double.parse(widget.balance.toString()),
        amtrmn: double.parse(widget.balance.toString()),
        trdesc2: compdesc,
        trdesc: compdesc,
        compcd: compcd,
        compdesc: compdesc,
        active: '1',
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    List<IafjrnhdClass> listiafjrnhd = [iafjrnhd];
    return await handler.insertIafjrnhd(listiafjrnhd);
  }

  checkSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String guestPref = prefs.getString('savecostmrs') ?? "";

    Map<String, dynamic> userMap =
        jsonDecode(guestPref) as Map<String, dynamic>;
    setState(() {
      guestname = userMap['guestname'];
      email = userMap['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.height * 0.8,
          child: GridView.count(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2 / 1,
            crossAxisCount: 2,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ButtonClassPayment(
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
                            widget.trno,
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
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
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
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ButtonClassPayment(
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
                            widget.trno,
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
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
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
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                    await PaymentGate.goPayQris(
                            'qris',
                            guestname,
                            email,
                            phone,
                            widget.trno,
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
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
                                outletinfo: widget.outletinfo,
                              );
                            });
                      }
                      Toast.show("Payment Request already sent",
                          duration: Toast.lengthLong, gravity: Toast.center);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                    await PaymentGate.goPayQris(
                            'qris',
                            guestname,
                            email,
                            phone,
                            widget.trno,
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
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
                                outletinfo: widget.outletinfo,
                              );
                            });
                      }        Toast.show("Payment Request already sent",
                            duration: Toast.lengthLong, gravity: Toast.center);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                    await PaymentGate.goPayQris(
                            'qris',
                            guestname,
                            email,
                            phone,
                            widget.trno,
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
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
                                outletinfo: widget.outletinfo,
                              );
                            });
                      }        Toast.show("Payment Request already sent",
                            duration: Toast.lengthLong, gravity: Toast.center);
                    });
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: ButtonClassPayment(
              //     name: '',
              //     iconasset: 'qris.png',
              //     height: MediaQuery.of(context).size.height * 0.1,
              //     width: MediaQuery.of(context).size.width * 0.1,
              //     onpressed: () async {
              //       setState(() {
              //         compcd = 'qris';
              //         compdesc = 'qris';
              //       });
              //       await showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return DialogClassEwallet(
              //               compcd: compcd,
              //               compdesc: compdesc,
              //               result: widget.result,
              //               balance: widget.balance,
              //               pscd: widget.outletinfo!.outletcd,
              //               trno: widget.trno,
              //               outletinfo: widget.outletinfo,
              //             );
              //           });
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
