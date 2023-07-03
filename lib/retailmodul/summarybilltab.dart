// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/payment/paymentmainmobilev2.dart';
import 'package:posq/classui/payment/paymenttablet/dialogclasspayment.dart';
import 'package:posq/classui/payment/paymenttablet/mainpaymenttab.dart';
import 'package:posq/classui/selectpromodiscounttab.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/productclass/classdialogsplitbilltab.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/printer/classtextprint.dart';
import 'package:posq/setting/promo/classcreatepromomobile.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/selectdiscountmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

typedef void StringCallback(IafjrndtClass val);
PrintSmall? printing;

class SummaryOrderSlideTabs extends StatefulWidget {
  final String trno;
  final String? pscd;
  late num? sum;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  final Outlet outletinfo;
  final bool? fromsaved;
  late List<IafjrndtClass> summary;
  late List<IafjrndtClass> listdata;
  final num balance;
  final String guestname;
  SummaryOrderSlideTabs(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.sum,
      required this.updatedata,
      required this.refreshdata,
      required this.outletinfo,
      required this.listdata,
      required this.summary,
      required this.balance,
      this.fromsaved,
      required this.guestname})
      : super(key: key);

  @override
  State<SummaryOrderSlideTabs> createState() => _SummaryOrderSlideTabsState();
}

class _SummaryOrderSlideTabsState extends State<SummaryOrderSlideTabs> {
  Promo? result;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  num? amounttotal = 0;
  List<IafjrndtClass> summary = [];
  bool connected = false;

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    print('listdata : summary ${widget.listdata}');
    getSumm();
  }

  checkPrinter() async {
    connected = await bluetooth.isConnected.then((value) => value!);
    setState(() {});
    print(connected);
  }

  getSumm() async {
    await ClassApi.getSumTrans(widget.trno, dbname, '').then((value) {
      print('ini summary : $value');
      if (value.isNotEmpty) {
        setState(() {
          summary = value;
          amounttotal = value.first.totalaftdisc;
        });
      } else {
        amounttotal = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ClassApi.getSumTrans(widget.trno, dbname, ''),
        builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
          var x = snapshot.data ?? [];
          widget.summary = x;
          if (x.isNotEmpty) {
            return Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text(
                          'Subtotal ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Text(
                          CurrencyFormat.convertToIdr(x.first.revenueamt, 0),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: x.first.discamt == 0
                            ? () async {
                                var hasil = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectPromoTab(
                                              sum: widget.sum!,
                                              refreshdata: widget.refreshdata,
                                              updatedata: widget.updatedata,
                                              databill: x.first,
                                              pscd: widget.pscd,
                                              trno: widget.trno,
                                            ))).then((_) async {
                                  await ClassApi.getSumTrans(
                                          widget.trno, pscd, '')
                                      .then((hasil) {
                                    ClassRetailMainMobile.of(context)!.string =
                                        hasil.first;
                                    ClassRetailMainMobile.of(context)!
                                        .discount = hasil.first.discamt!;
                                  });
                                  await widget.refreshdata;
                                  await widget.updatedata;
                                });
                                setState(() {
                                  widget.sum = hasil;
                                });
                              }
                            : null,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.09,
                          child: Text(
                            'Discount',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      x.first.discamt == 0
                          ? Row(
                              children: [
                                Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(50, 30),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            alignment: Alignment.centerRight),
                                        onPressed: () async {
                                          Promo hasil = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectPromoTab(
                                                        sum: widget.sum!,
                                                        refreshdata:
                                                            widget.refreshdata,
                                                        updatedata:
                                                            widget.updatedata,
                                                        databill: x.first,
                                                        pscd: widget.pscd,
                                                        trno: widget.trno,
                                                      ))).then((value) async {
                                            await widget.refreshdata;
                                            await widget.updatedata;
                                            return value;
                                          });
                                          setState(() {
                                            widget.sum = hasil.amount;
                                          });
                                          ClassRetailMainMobile.of(context)!
                                              .discount = hasil.amount!;
                                        },
                                        child: Text(
                                          '>',
                                          style: TextStyle(fontSize: 20),
                                        ))),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Text(
                                          CurrencyFormat.convertToIdr(
                                              x.first.discamt, 0),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //  Spacer(),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size(10, 30),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                alignment:
                                                    Alignment.centerLeft),
                                            onPressed: () async {
                                              await ClassApi.deactivePromoTrno(
                                                      widget.trno, dbname)
                                                  .whenComplete(() {
                                                setState(() {});
                                              });
                                              await ClassApi.getSumTrans(
                                                      widget.trno.toString(),
                                                      pscd,
                                                      '')
                                                  .then((value) async {
                                                setState(() {
                                                  widget.sum =
                                                      value.first.totalaftdisc!;
                                                });
                                                await widget.updatedata;
                                                await widget.refreshdata!;
                                                ClassRetailMainMobile.of(
                                                        context)!
                                                    .string = value.first;
                                                ClassRetailMainMobile.of(
                                                            context)!
                                                        .discount =
                                                    value.first.discamt!;
                                              });
                                            },
                                            child: Text(
                                              'X',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      ],
                                    )),
                              ],
                            )
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Pajak',
                  //       style: TextStyle(fontSize: 10),
                  //     ),
                  //     Text(
                  //       CurrencyFormat.convertToIdr(x.first.taxamt, 0),
                  //       style: TextStyle(fontSize: 10),
                  //     ),
                  //   ],
                  // ),

                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text(
                          'Tax & Service',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Text(
                          CurrencyFormat.convertToIdr(
                              x.first.serviceamt! + x.first.taxamt!, 0),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text(
                          'Total ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Text(
                          CurrencyFormat.convertToIdr(x.first.totalaftdisc, 0),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // <-- Radius
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor:
                                  Colors.grey[200] // Background color
                              ),
                          onPressed: () async {
                            return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogClassSimpanTab(
                                    datatrans: widget.listdata.first,
                                    fromsaved: widget.fromsaved!,
                                    outletinfo: widget.outletinfo,
                                    pscd: widget.outletinfo.outletcd,
                                    trno: widget.trno.toString(),
                                  );
                                });
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Simpan ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // <-- Radius
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor:
                                  Colors.grey[200] // Background color
                              ),
                          onPressed:
                              accesslistuser.contains('settingprinter') == true
                                  ? () async {
                                      await getSumm();
                                      if (connected == true) {
                                        await printing!.prints(
                                            widget.listdata,
                                            summary,
                                            widget.outletinfo.outletname!,
                                            widget.outletinfo);
                                      } else {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassMainPrinter()));
                                      }
                                    }
                                  : () {
                                      Fluttertoast.showToast(
                                          msg: "Tidak Punya Akses Printer",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Color.fromARGB(255, 11, 12, 14),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Print bill ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // <-- Radius
                            ),
                            padding: EdgeInsets.zero,
                            backgroundColor: Color.fromARGB(
                                255, 0, 160, 147), // Background color
                          ),
                          onPressed: () async {
                            final result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogSplitTab(
                                      guestname: widget.guestname,
                                      fromsaved: false,
                                      datatrans: widget.listdata,
                                      outletinfo: widget.outletinfo,
                                      balance:
                                          widget.summary.first.totalaftdisc!,
                                      pscd: widget.outletinfo.outletcd,
                                      trdt: formattedDate,
                                      trno: widget.trno.toString(),
                                      outletname: widget.outletinfo.outletname,
                                    )).then((_) {
                              setState(() {});
                            });
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Split ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.22,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // <-- Radius
                            ),
                            padding: EdgeInsets.zero,
                            backgroundColor: Color.fromARGB(
                                255, 0, 160, 147), // Background color
                          ),
                          onPressed: () async {
                            final result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogPaymentTab(
                                      guestname: widget.guestname,
                                      fromsplit: false,
                                      fromsaved: widget.fromsaved!,
                                      datatrans: widget.listdata,
                                      outletinfo: widget.outletinfo,
                                      balance:
                                          widget.summary.first.totalaftdisc!,
                                      pscd: widget.outletinfo.outletcd,
                                      trdt: formattedDate,
                                      trno: widget.trno.toString(),
                                      outletname: widget.outletinfo.outletname,
                                    )).then((_) {
                              setState(() {});
                            });
                            // final result = await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => PaymentV2TabClass(
                            //             fromsaved: widget.fromsaved!,
                            //             datatrans: widget.listdata,
                            //             outletinfo: widget.outletinfo,
                            //             balance:
                            //                 widget.summary.first.totalaftdisc!,
                            //             pscd: widget.outletinfo.outletcd,
                            //             trdt: formattedDate,
                            //             trno: widget.trno.toString(),
                            //             outletname:
                            //                 widget.outletinfo.outletname,
                            //           )),
                            // );
                            // ClassRetailMainMobile.of(context)!.string = result!;
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tagihkan ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  // TextButton(
                  //     style: TextButton.styleFrom(
                  //         padding: EdgeInsets.zero,
                  //         minimumSize: Size(50, 30),
                  //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         alignment: Alignment.centerLeft),
                  //     onPressed: accesslist.contains('canceltrans') == true
                  //         ? () async {
                  //             await showDialog(
                  //                 context: context,
                  //                 builder: (_) => DialogClassCancelorder(
                  //                     fromsaved: widget.fromsaved,
                  //                     outletinfo: widget.outletinfo,
                  //                     outletcd: widget.pscd!,
                  //                     trno: x.first.transno!)).then((_) {
                  //               setState(() {});
                  //             });
                  //           }
                  //         : () {
                  //             Fluttertoast.showToast(
                  //                 msg: "Tidak Punya Akses Cancel Order",
                  //                 toastLength: Toast.LENGTH_LONG,
                  //                 gravity: ToastGravity.CENTER,
                  //                 timeInSecForIosWeb: 1,
                  //                 backgroundColor:
                  //                     Color.fromARGB(255, 11, 12, 14),
                  //                 textColor: Colors.white,
                  //                 fontSize: 10.0);
                  //           },
                  //     child: Text(
                  //       'Batalkan transaksi',
                  //       style: TextStyle(fontSize: 10),
                  //     ))
                ],
              ),
            );
          }
          return Container();
        });
  }
}
