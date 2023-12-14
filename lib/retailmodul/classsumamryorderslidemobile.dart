// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable, unused_local_variable

import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:epson_epos/epson_epos.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classdialogvoidtab.dart';
import 'package:posq/classui/classfontsize.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/productclass/classdialogsplitbilltab.dart';
import 'package:posq/setting/printer/printer_wifi/classprintwifi.dart';
import 'package:posq/setting/promo/classcreatepromomobile.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/selectdiscountmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class SummaryOrderSlidemobile extends StatefulWidget {
  final String trno;
  final String? pscd;
  late num? sum;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  final Outlet outletinfo;
  final bool? fromsaved;
  late List<IafjrndtClass> summary;
  final List<IafjrndtClass> datatransaksi;
  final String guestname;

  SummaryOrderSlidemobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.sum,
      required this.updatedata,
      required this.refreshdata,
      required this.outletinfo,
      required this.summary,
      this.fromsaved,
      required this.datatransaksi,
      required this.guestname})
      : super(key: key);

  @override
  State<SummaryOrderSlidemobile> createState() =>
      _SummaryOrderSlidemobileState();
}

class _SummaryOrderSlidemobileState extends State<SummaryOrderSlidemobile> {
  late DatabaseHandler handler;
  Promo? result;
  ClassPrinterNetwork printer = ClassPrinterNetwork();
  List<EpsonPrinterModel> printers = [];
  List printerCaptain = [];

  @override
  void initState() {
    super.initState();
    onDiscoveryTCP();
  }

  Future<dynamic> onDiscoveryTCP() async {
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.TCP);
      if (data != null && data.isNotEmpty) {
        for (var element in data) {
          print(element.toJson());
        }
        printers = data;
      }
    } catch (e) {
      log("Error: $e");
    }
    return printers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ClassApi.getSumTrans(widget.trno, dbname, ''),
        builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
          var x = snapshot.data ?? [];
          widget.summary = x;
          if (x.isNotEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Total',style: TextStyle(fontSize: CustomFontSize.smallFontSize(context)),),
                    trailing: Text(
                      CurrencyFormat.convertToIdr(x.first.revenueamt, 0),
                      style: TextStyle(
                          fontSize: CustomFontSize.smallFontSize(context)),
                    ),
                  ),
                  ListTile(
                      onTap: x.first.discamt == 0
                          ? () async {
                              var xxx = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectPromoMobile(
                                            sum: widget.sum!,
                                            refreshdata: widget.refreshdata,
                                            updatedata: widget.updatedata,
                                            databill: x.first,
                                            pscd: widget.pscd,
                                            trno: widget.trno,
                                          )));
                              await ClassApi.getSumTrans(widget.trno, pscd, '')
                                  .then((hasils) {
                                print('refresh main');
                                ClassRetailMainMobile.of(context)!.string =
                                    hasils.first;
                                ClassRetailMainMobile.of(context)!.discount =
                                    hasils.first.discamt!;
                                setState(() {
                                  widget.sum = hasils.first.totalaftdisc;
                                });
                              });

                              await widget.refreshdata;
                              await widget.updatedata;
                            }
                          : null,
                      visualDensity: VisualDensity(vertical: -4), // to compact
                      dense: true,
                      title: Text('Discount',style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                      trailing: x.first.discamt == 0
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.06,
                              child: TextButton(
                                  onPressed: () async {
                                    Promo hasil = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectPromoMobile(
                                                  sum: widget.sum!,
                                                  refreshdata:
                                                      widget.refreshdata,
                                                  updatedata: widget.updatedata,
                                                  databill: x.first,
                                                  pscd: widget.pscd,
                                                  trno: widget.trno,
                                                ))).then((values) async {
                                      await ClassApi.getSumTrans(
                                              widget.trno, pscd, '')
                                          .then((hasils) {
                                        print('refresh main');
                                        ClassRetailMainMobile.of(context)!
                                            .string = hasils.first;
                                        ClassRetailMainMobile.of(context)!
                                            .discount = hasils.first.discamt!;
                                        setState(() {
                                          widget.sum =
                                              hasils.first.totalaftdisc;
                                        });
                                      });
                                      await widget.refreshdata;
                                      await widget.updatedata;
                                      return values;
                                    });
                                  },
                                  child: Text('>',style: TextStyle(fontSize: CustomFontSize.smallFontSize(context)))))
                          : Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(CurrencyFormat.convertToIdr(
                                      x.first.discamt, 0),style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.065,
                                      child: TextButton(
                                          onPressed: () async {
                                            await ClassApi.deactivePromoTrno(
                                                    widget.trno, dbname)
                                                .whenComplete(() {
                                              setState(() {});
                                            });
                                            await ClassApi.deleteRewardTrans(
                                                widget.trno, dbname);
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
                                              ClassRetailMainMobile.of(context)!
                                                  .string = value.first;
                                              ClassRetailMainMobile.of(context)!
                                                      .discount =
                                                  value.first.discamt!;
                                            });
                                          },
                                          child: Text('X',style: TextStyle(fontSize: CustomFontSize.smallFontSize(context)))))
                                ],
                              ))),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Pajak',style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                    trailing:
                        Text(CurrencyFormat.convertToIdr(x.first.taxamt, 0),style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Service',style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                    trailing: Text(
                        CurrencyFormat.convertToIdr(x.first.serviceamt, 0),style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Grand total',style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                    trailing: Text(
                        CurrencyFormat.convertToIdr(x.first.totalaftdisc, 0),style: TextStyle(fontSize: CustomFontSize.smallFontSize(context))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: accesslistuser.contains('canceltrans') ==
                                  true
                              ? () async {
                                  if (strictuser == '1') {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PasswordDialog(
                                            guestname: widget.guestname,
                                            frompaymentmobile: false,
                                            frompayment: false,
                                            trno: x.first.transno!,
                                            outletcd: pscd,
                                            outletinfo: widget.outletinfo,
                                            fromsaved: widget.fromsaved,
                                            dialogcancel: true,
                                            onPasswordEntered:
                                                (String password) async {
                                              print(
                                                  'Entered password: $password');

                                              // Lakukan sesuatu dengan password yang dimasukkan di sini
                                            });
                                      },
                                    );
                                  } else {
                                    await showDialog(
                                        context: context,
                                        builder: (_) => DialogClassCancelorder(
                                            fromsaved: widget.fromsaved,
                                            outletinfo: widget.outletinfo,
                                            outletcd: widget.pscd!,
                                            trno: x.first.transno!)).then((_) {
                                      setState(() {});
                                    });
                                  }
                                }
                              : () {
                                  Fluttertoast.showToast(
                                      msg: "Tidak Punya Akses Cancel Order",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Color.fromARGB(255, 11, 12, 14),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                          child: Text('Batalkan transaksi')),
                      usekitchen == true
                          ? TextButton(
                              onPressed: () async {
                                if (printers.isNotEmpty) {
                                  //function printer kitchen dan CO //
                                  // print(widget.datatransaksi);
                                  DateTime currentTime = DateTime.now();

                                  // Format the time in "hh:mm a" (12-hour format)
                                  String formattedTime =
                                      DateFormat('hh:mm a').format(currentTime);
                                  String formatedDate =
                                      DateFormat('d MMM y').format(currentTime);
                                  Map<String, List<IafjrndtClass>> groupedData =
                                      {};
                                  // grouping list item dimana printer sesuai dengan settigan
                                  for (var item in widget.datatransaksi) {
                                    String printerPath = item.printerpath!;
                                    if (groupedData.containsKey(printerPath)) {
                                      groupedData[printerPath]!.add(item);
                                    } else {
                                      groupedData[printerPath] = [item];
                                    }
                                  }

                                  // print('ini grouperd data : $groupedData');
                                  for (var x in groupedData.keys) {
                                    //extracted data untuk prepare data yang akan di kirim printer //
                                    // print(groupedData.entries
                                    //     .where((element) => element.value
                                    //         .map((e) => e.printerpath == x)
                                    //         .first)
                                    //     .map((e) => e.value)
                                    //     .first);
                                    List data = groupedData.entries
                                        .where((element) => element.value
                                            .map((e) => e.printerpath == x)
                                            .first)
                                        .map((e) => e.value)
                                        .first;
                                    EpsonPrinterModel selectedprinter =
                                        await printers
                                            .where((element) =>
                                                element.ipAddress!.contains(x))
                                            .first;
                                    await printer
                                        .preparedataKitchen(data)
                                        .then((value) async {
                                      await printer.onPrintKitchen(
                                          selectedprinter,
                                          value,
                                          widget.trno,
                                          '',
                                          '',
                                          '',
                                          formattedTime,
                                          formatedDate);
                                    });
                                  }
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Printer Not found',
                                    desc: 'Problem di wifi / printer ',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  )..show();
                                }
                              },
                              child: Text(
                                'Kitchen',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 192, 0, 0)),
                              ))
                          : Container(),
                      TextButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => DialogSplitTab(
                                      guestname: widget.guestname,
                                      balance: x.first.totalaftdisc!,
                                      datatrans: widget.datatransaksi,
                                      fromsaved: false,
                                      outletinfo: widget.outletinfo,
                                      pscd: pscd,
                                      trdt: widget.datatransaksi.first.trdt!,
                                      trno: widget.trno,
                                    )).then((_) {
                              setState(() {});
                            });
                          },
                          child: Text(
                            'Split bill',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 162, 184)),
                          )),
                    ],
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }
}
