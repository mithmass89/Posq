// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PaymentV2TabClass extends StatefulWidget {
  final String trno;
  final String pscd;
  final String trdt;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;

  const PaymentV2TabClass({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.trdt,
    required this.balance,
    this.outletname,
    this.outletinfo,
    required this.datatrans,
    required this.fromsaved,
  }) : super(key: key);

  @override
  State<PaymentV2TabClass> createState() => _PaymentV2TabClassState();
}

class _PaymentV2TabClassState extends State<PaymentV2TabClass>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  bool additional = false;
  bool discbyamount = true;
  TextEditingController discountpct = TextEditingController(text: '0');
  TextEditingController discountamount = TextEditingController(text: '0');
  TextEditingController amountcash = TextEditingController();
  TextEditingController ongkir = TextEditingController(text: '0');
  num? result = 0;
  final PanelController _pc = PanelController();
  bool _scrollisanimated = false;
  late DatabaseHandler handler;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  bool zerobill = false;
  List<IafjrndtClass> listdata = [];
  List<IafjrndtClass> listdatabill = [];
  String serverkeymidtrans = '';
  bool midtransonline = false;
  String pymtmthd = '';
  String compcode = '';
  String compdescription = '';
  List<PaymentMaster> paymentlist = [];

  List payment = [
    'Cash',
    'Debit',
    'Kartu Credit',
    'E-wallet',
    'Bank transfer',
    'Lain Lain'
  ];

  String selectedpy = '';

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    loadKey();
    getDataTransaksi();
    checkbalance();
    result = widget.balance;
    _controller = TabController(length: 2, vsync: this);
    // result = widget.balance - num.parse(amountcash.text);
    amountcash.addListener(() {
      setState(() {
        result = widget.balance - num.parse(amountcash.text);
      });
      checkbalance();
    });
  }

  getDataTransaksi() async {
    await ClassApi.getTrnoDetail(widget.trno, dbname, '').then((isi) {
      print(List.generate(isi.length, (index) => isi[index].id));
      setState(() {
        listdata = isi;
      });
    });
  }

  getPaymentMaster() async {
    await ClassApi.getPaymentMaster('').then((isi) {
      print(List.generate(isi.length, (index) => isi[index].id));
      setState(() {
        paymentlist = isi;
      });
    });
  }

  Future<dynamic> checkbalance() async {
    await ClassApi.getSumPyTrno(widget.trno).then((value) {
      if (value[0]['totalamt'] != null) {
        setState(() {
          result = widget.balance - value.first.totalamt!;
        });
        if (result == 0) {
          setState(() {
            zerobill = true;
          });
        }
      } else {
        setState(() {
          zerobill = false;
        });
      }
    });
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: '${widget.trno}',
        split: 1,
        pscd: '${widget.pscd}',
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: '',
        pax: '1',
        pymtmthd: pymtmthd,
        ftotamt: double.parse(widget.balance.toString()),
        totalamt: double.parse(widget.balance.toString()),
        framtrmn: double.parse(widget.balance.toString()),
        amtrmn: double.parse(widget.balance.toString()),
        trdesc: '$pymtmthd ${widget.trno}',
        trdesc2: '$pymtmthd ${widget.trno}',
        compcd: compcode,
        compdesc: compdescription,
        active: 1,
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd);
  }

  loadKey() async {
    final midtranskey = await SharedPreferences.getInstance();
    serverkeymidtrans = midtranskey.getString('serverkey') == null
        ? ''
        : midtranskey.getString('serverkey')!;
    if (serverkeymidtrans != '') {
      setState(() {
        midtransonline = true;
      });
    } else {
      setState(() {
        midtransonline = false;
      });
    }
  }

  checkSelected(String? compcd, String? compdesc, String methode) {
    setState(() {
      compcode = compcd!;
      compdescription = compdesc!;
      pymtmthd = methode;
      zerobill = true;
    });
    print('main $compdescription');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Pembayaran', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange,
        ),
        body: Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        color: Color.fromARGB(255, 0, 153, 145),
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Text(
                          'Methode',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: selectedpy == 'Cash'
                                            ? Colors.white
                                            : Colors.orange // Background color
                                        ),
                                    onPressed: () {
                                      selectedpy = 'Cash';
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Cash',
                                      style: TextStyle(
                                          color: selectedpy == 'Cash'
                                              ? Colors.orange
                                              : Colors.white),
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: selectedpy == 'Debit'
                                            ? Colors.white
                                            : Colors.orange // Background color
                                        ),
                                    onPressed: () {
                                      selectedpy = 'Debit';
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Debit',
                                      style: TextStyle(
                                          color: selectedpy == 'Debit'
                                              ? Colors.orange
                                              : Colors.white),
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: selectedpy ==
                                                'Kartu Kredit'
                                            ? Colors.white
                                            : Colors.orange // Background color
                                        ),
                                    onPressed: () {
                                      selectedpy = 'Kartu Kredit';
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Kartu Kredit',
                                      style: TextStyle(
                                          color: selectedpy == 'Kartu Kredit'
                                              ? Colors.orange
                                              : Colors.white),
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: selectedpy ==
                                                'E-wallet'
                                            ? Colors.white
                                            : Colors.orange // Background color
                                        ),
                                    onPressed: () {
                                      selectedpy = 'E-wallet';
                                      setState(() {});
                                    },
                                    child: Text(
                                      'E-wallet',
                                      style: TextStyle(
                                          color: selectedpy == 'E-wallet'
                                              ? Colors.orange
                                              : Colors.white),
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: selectedpy ==
                                                'Bank transfer'
                                            ? Colors.white
                                            : Colors.orange // Background color
                                        ),
                                    onPressed: () {
                                      selectedpy = 'Bank transfer';
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Bank transfer',
                                      style: TextStyle(
                                          color: selectedpy == 'Bank transfer'
                                              ? Colors.orange
                                              : Colors.white),
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: selectedpy ==
                                                'Lain lain'
                                            ? Colors.white
                                            : Colors.orange // Background color
                                        ),
                                    onPressed: () {
                                      selectedpy = 'Lain lain';
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Lain lain',
                                      style: TextStyle(
                                          color: selectedpy == 'Lain lain'
                                              ? Colors.orange
                                              : Colors.white),
                                    )),
                              ),
                            ],
                          )),
                      Container(
                        alignment: Alignment.center,
                        color: Color.fromARGB(255, 0, 146, 139),
                        height: MediaQuery.of(context).size.height * 0.173,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Intergrasi Payment',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            5), // <-- Radius
                                      ),
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.white
                                      // Background color
                                      ),
                                  onPressed: () {
                                    selectedpy = 'Lain lain';
                                    setState(() {});
                                  },
                                  child: Text(
                                    'Lain lain',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 146, 139),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Expanded(
                flex: 4,
                child: Container(
                  color: Colors.grey[200],
                  child: Builder(builder: (context) {
                    switch (selectedpy) {
                      case 'Cash':
                        return Row(
                          children: [
                            // Container(
                            //     width: MediaQuery.of(context).size.width * 0.3,
                            //     child: PaymentCashTabs(
                            //       controller: amountcash,
                            //     )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.48,
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: Colors.blue,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.47,
                                                  child: Text(
                                                    'Saran',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ],
                                          ))),
                                ],
                              ),
                            ),
                          ],
                        );

                      //  default:Container();
                    }
                    return Container();
                  }),
                )),
          ],
        ));
  }
}
