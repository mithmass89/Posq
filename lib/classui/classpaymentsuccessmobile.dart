// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';

PaymentGate? paymentapi;

class ClassPaymetSucsessMobile extends StatefulWidget {
  final bool frombanktransfer;
  final String? virtualaccount;
  final String trno;
  final num amount;
  final String paymenttype;
  final String? guestname;
  final String? trdt;
  final String? outletcd;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? cash;


  const ClassPaymetSucsessMobile({
    Key? key,
    required this.trno,
    required this.amount,
    required this.paymenttype,
    this.guestname,
    this.trdt,
    this.outletcd,
    this.outletname,
    required this.outletinfo,
    required this.cash,
    this.virtualaccount,
    required this.frombanktransfer,
  }) : super(key: key);

  @override
  State<ClassPaymetSucsessMobile> createState() =>
      _ClassPaymetSucsessMobileState();
}

class _ClassPaymetSucsessMobileState extends State<ClassPaymetSucsessMobile> {
  late DatabaseHandler handler;
  int? trno;
  String? nexttrno;
  String? statustransaction = '';
  final bool pending = true;
  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
    checkTrno();
    if (widget.cash == false) {
      PaymentGate.getStatusTransaction(widget.trno).then((value) {
        print(value);
        setState(() {
          statustransaction = value;
        });
      });
    } else {
      setState(() {
        statustransaction = 'Settlement';
      });
    }
  }

  Stream<String> _getstatus() async* {
    if (widget.cash == false) {
      await PaymentGate.getStatusTransaction(widget.trno).then((value) {
        print(value);
        setState(() {
          statustransaction = value;
        });
      });
    }

    // This loop will run forever because _running is always true
  }

  checkTrno() async {
    await handler.getTrno(widget.outletcd.toString()).then((value) {
      setState(() {
        trno = value.first.trnonext;
      });
      print('ini trno $trno');
    });
    await updateTrnonext();
  }

  updateTrnonext() async {
    await handler.updateTrnoNext(
        Outlet(outletcd: widget.outletcd.toString(), trnonext: trno! + 1));
  }

  Color _getColorByEventtext(String event) {
    if (statustransaction == "settlement") return Colors.green;
    if (statustransaction == "pending") return Colors.red;

    return Colors.black;
  }

  getTrno() async {
    handler = DatabaseHandler();
    await handler.initializeDB();
    await handler.getTrno(widget.outletcd!).then((value) {
      setState(() {
        nexttrno = '${widget.outletcd}${value.first.trnonext}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _getstatus(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 95,
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      'Transaksi Berhasil',
                      style: TextStyle(fontSize: 25, color: Colors.green),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.height * 0.14,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('correct.png'),
                        fit: BoxFit.fill,
                      )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Status Transaksi',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        statustransaction == null
                                            ? 'Success'
                                            : statustransaction.toString(),
                                        style: TextStyle(
                                            color: _getColorByEventtext(
                                                statustransaction!)),
                                      ))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Payment Type',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.paymenttype),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Jumlah Transaksi',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.amount.toString()),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Nomer Transaksi',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.trno.toString()),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Tanggal Transaksi',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.trdt.toString()),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Nama Outlet',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )),
                              Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.outletinfo!.outletname
                                        .toString()),
                                  )),
                            ],
                          ),
                          widget.cash == false
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Virtual Account',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        )),
                                    Container(
                                        alignment: Alignment.centerRight,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              widget.virtualaccount.toString()),
                                        )),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonNoIcon(
                                textcolor: Colors.white,
                                color: Colors.blue,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width:
                                    MediaQuery.of(context).size.height * 0.18,
                                onpressed: () {},
                                name: 'PRINT',
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              ButtonNoIcon(
                                textcolor: Colors.white,
                                color: Colors.blue,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width:
                                    MediaQuery.of(context).size.height * 0.18,
                                onpressed: () async {
                                  await getTrno();
                                  print(widget.outletcd);
                                  print(nexttrno);
                                  print(widget.outletinfo);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => ClassRetailMainMobile(
                                            pscd: widget.outletcd!,
                                            trno: nexttrno,
                                            outletinfo: widget.outletinfo!,
                                            qty: 0,
                                          )),
                                      (Route<dynamic> route) => false);
                                },
                                name: 'TRANSAKSI BARU',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          ButtonNoIcon(
                            textcolor: Colors.white,
                            color: Colors.blue,
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.height * 0.18,
                            onpressed: () {},
                            name: 'CETAK TIKET',
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
