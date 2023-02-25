// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable, prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names

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

class PaymentTransferMobile extends StatefulWidget {
  final String trno;
  final String pscd;
  late num? result;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? discbyamount;
  final List<IafjrndtClass> datatrans;

  PaymentTransferMobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.balance,
      this.result,
      this.outletname,
      this.outletinfo,
      this.discbyamount,
      required this.datatrans})
      : super(key: key);

  @override
  State<PaymentTransferMobile> createState() => _PaymentTransferMobileState();
}

class _PaymentTransferMobileState extends State<PaymentTransferMobile> {
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
            price: num.parse('${widget.datatrans[index].totalaftdisc!/widget.datatrans[index].qty!}'),
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

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: widget.trno,
          transno1: widget.trno,
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
        compcd: compcd,
        compdesc: compdesc,
        active: 1,
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    List<IafjrnhdClass> listiafjrnhd = [iafjrnhd];
    return await handler.insertIafjrnhd(listiafjrnhd);
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
                  iconasset: 'bca.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  onpressed: () async {
                    await PaymentGate.bankTransfer(
                            guestname,
                            'bca',
                            phone,
                            email,
                            widget.trno,
                            widget.result.toString(),
                            listitem.toList())
                        .then((value) async {
                      if (value['status_code'] != '406') {
                        List x = value['va_numbers'];
                        print(x.first['va_number']);
                        setState(() {
                          virtualaccount = x.first['va_number'];
                          bank = x.first['bank'];
                          transactionstatus = value['transaction_status'];
                          totalamount = num.parse(value['gross_amount']);
                        });
                        await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DialogClassBankTransfer(
                              datatrans:widget.datatrans,
                                paymenttype: 'Account',
                                virtualaccount: virtualaccount,
                                bank: bank,
                                transactionstatus: transactionstatus,
                                grossmaount: totalamount,
                                compcd: compcd,
                                compdesc: compdesc,
                                result: widget.result,
                                balance: widget.balance,
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
                                outletinfo: widget.outletinfo,
                              );
                            });
                        setState(() {
                          compcd = 'BCA VA';
                          compdesc = 'BCA VA';
                        });
                      }
                      Toast.show(
                          "Payment Information already sent to customers email",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ButtonClassPayment(
                  styleasset: BoxFit.fitWidth,
                  name: '',
                  iconasset: 'bni.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  onpressed: () async {
                    setState(() {
                      compcd = 'BNIVA';
                      compdesc = 'BNI VA';
                    });
                    await PaymentGate.bankTransfer(
                            guestname,
                            'bni',
                            phone,
                            email,
                            widget.trno,
                            widget.result.toString(),
                            listitem.toList())
                        .then((value) async {
                      if (value['status_code'] != '406') {
                        if (value != null) {
                          List x = value['va_numbers'];
                          print(x.first['va_number']);
                          setState(() {
                            virtualaccount = x.first['va_number'];
                            bank = x.first['bank'];
                            transactionstatus = value['transaction_status'];
                            totalamount = num.parse(value['gross_amount']);
                          });
                        }
                        await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DialogClassBankTransfer(
                                 datatrans:widget.datatrans,
                                paymenttype: 'Account',
                                virtualaccount: virtualaccount,
                                bank: bank,
                                transactionstatus: transactionstatus,
                                grossmaount: totalamount,
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
                      Toast.show(
                          "Payment Information already sent to customers email",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ButtonClassPayment(
                  name: '',
                  iconasset: 'bri.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  onpressed: () async {
                    await PaymentGate.bankTransfer(
                            guestname,
                            'bri',
                            phone,
                            email,
                            widget.trno,
                            widget.result.toString(),
                            listitem.toList())
                        .then((value) async {
                      if (value['status_code'] != '406') {
                        List x = value['va_numbers'];
                        print(x.first['va_number']);
                        setState(() {
                          virtualaccount = x.first['va_number'];
                          bank = x.first['bank'];
                          transactionstatus = value['transaction_status'];
                          totalamount = num.parse(value['gross_amount']);
                        });
                        await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DialogClassBankTransfer(
                  datatrans:widget.datatrans,
                                paymenttype: 'Account',
                                virtualaccount: virtualaccount,
                                bank: bank,
                                transactionstatus: transactionstatus,
                                grossmaount: totalamount,
                                compcd: compcd,
                                compdesc: compdesc,
                                result: widget.result,
                                balance: widget.balance,
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
                                outletinfo: widget.outletinfo,
                              );
                            });
                        setState(() {
                          compcd = 'BRIVA';
                          compdesc = 'BRI VA';
                        });
                      }
                      Toast.show(
                          "Payment Information already sent to customers email",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ButtonClassPayment(
                  name: '',
                  iconasset: 'mandiri.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  onpressed: () async {
                    await PaymentGate.mandiribillers(
                            guestname,
                            phone,
                            email,
                            widget.trno,
                            widget.result.toString(),
                            listitem.toList())
                        .then((value) async {
                      if (value['status_code'] != '406') {
                        print(value['bill_key']);
                        setState(() {
                          bill_key = value['bill_key'];
                          biller_code = value['biller_code'];
                          transactionstatus = value['transaction_status'];
                          totalamount = num.parse(value['gross_amount']);
                        });
                        setState(() {
                          compcd = 'MANDIRIVA';
                          compdesc = 'MANDIRI VA';
                        });
                        await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DialogClassMandiribiller(
                             datatrans:widget.datatrans,
                                paymenttype: 'Account',
                                bill_key: bill_key,
                                biller_code: biller_code,
                                transactionstatus: transactionstatus,
                                grossmaount: totalamount,
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
                      Toast.show(
                          "Payment Information already sent to customers email",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ButtonClassPayment(
                  name: '',
                  iconasset: 'permatabank.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  onpressed: () async {
                    await PaymentGate.getvaPermata(
                      guestname,
                      email,
                      phone,
                      widget.trno,
                      listitem.toList(),
                      widget.result.toString(),
                    ).then((value) async {
                      if (value['status_code'] != '406') {
                        print(value);
                        setState(() {
                          virtualaccount = value['permata_va_number'];
                          bank = 'permata bank';
                          transactionstatus = value['transaction_status'];
                          totalamount = num.parse(value['gross_amount']);
                        });
                        await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DialogClassBankTransfer(
                            datatrans:widget.datatrans,
                                paymenttype: 'Account',
                                virtualaccount: virtualaccount,
                                bank: bank,
                                transactionstatus: transactionstatus,
                                grossmaount: totalamount,
                                compcd: compcd,
                                compdesc: compdesc,
                                result: widget.result,
                                balance: widget.balance,
                                pscd: widget.outletinfo!.outletcd,
                                trno: widget.trno,
                                outletinfo: widget.outletinfo,
                              );
                            });
                        setState(() {
                          compcd = 'PERMATAVA';
                          compdesc = 'PERMATA VA';
                        });
                      }
                      Toast.show(
                          "Payment Information already sent to customers email",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
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
    );
  }
}
