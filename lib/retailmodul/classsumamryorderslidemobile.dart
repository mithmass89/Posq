// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classdialogvoidtab.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/productclass/classdialogsplitbilltab.dart';
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
      required this.datatransaksi})
      : super(key: key);

  @override
  State<SummaryOrderSlidemobile> createState() =>
      _SummaryOrderSlidemobileState();
}

class _SummaryOrderSlidemobileState extends State<SummaryOrderSlidemobile> {
  late DatabaseHandler handler;
  Promo? result;

  @override
  void initState() {
    super.initState();
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
                    title: Text('Total'),
                    trailing: Text(
                        CurrencyFormat.convertToIdr(x.first.revenueamt, 0)),
                  ),
                  ListTile(
                      onTap: x.first.discamt == 0
                          ? () async {
                              var hasil = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectPromoMobile(
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
                                  ClassRetailMainMobile.of(context)!.discount =
                                      hasil.first.discamt!;
                                });
                                await widget.refreshdata;
                                await widget.updatedata;
                              });
                              setState(() {
                                widget.sum = hasil;
                              });
                            }
                          : null,
                      visualDensity: VisualDensity(vertical: -4), // to compact
                      dense: true,
                      title: Text('Discount'),
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
                                  child: Text('>')))
                          : Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(CurrencyFormat.convertToIdr(
                                      x.first.discamt, 0)),
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
                                          child: Text('X')))
                                ],
                              ))),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Pajak'),
                    trailing:
                        Text(CurrencyFormat.convertToIdr(x.first.taxamt, 0)),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Service'),
                    trailing: Text(
                        CurrencyFormat.convertToIdr(x.first.serviceamt, 0)),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Grand total'),
                    trailing: Text(
                        CurrencyFormat.convertToIdr(x.first.totalaftdisc, 0)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: accesslistuser.contains('canceltrans') == true
                              ? () async {
                                  if (strictuser == '1') {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PasswordDialog(
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
                      TextButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => DialogSplitTab(
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
