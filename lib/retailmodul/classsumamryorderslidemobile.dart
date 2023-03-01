// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
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

  SummaryOrderSlidemobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.sum,
      required this.updatedata,
      required this.refreshdata,
      required this.outletinfo})
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
                                                  .discount = value.first.discamt!;
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
                  TextButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => DialogClassCancelorder(
                                outletinfo: widget.outletinfo,
                                outletcd: widget.pscd!,
                                trno: x.first.transno!)).then((_) {
                          setState(() {});
                        });
                      },
                      child: Text('Batalkan transaksi'))
                ],
              ),
            );
          }
          return Container();
        });
  }
}
