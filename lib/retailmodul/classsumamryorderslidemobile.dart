// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/classcreatepromomobile.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/selectdiscountmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class SummaryOrderSlidemobile extends StatefulWidget {
  final String trno;
  final String? pscd;
  late num? sum;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  SummaryOrderSlidemobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.sum,
      required this.updatedata,
      required this.refreshdata})
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
    handler = DatabaseHandler();
    result = Promo(promocd: '', amount: 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: handler.summarybill(widget.trno),
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
                    trailing:
                        Text(CurrencyFormat.convertToIdr(x.first.rvnamt, 0)),
                  ),
                  ListTile(
                      onTap: x.first.discamt == 0
                          ? () async {
                              var hasil = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectPromoMobile(
                                            refreshdata: widget.refreshdata,
                                            updatedata: widget.updatedata,
                                            databill: x.first,
                                            pscd: widget.pscd,
                                            trno: widget.trno,
                                          ))).then((_) async {
                                await handler
                                    .checktotalAmountNett(widget.trno)
                                    .then((hasil) {
                                  ClassRetailMainMobile.of(context)!.string =
                                      hasil.first;
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
                              width: MediaQuery.of(context).size.width * 0.05,
                              child: TextButton(
                                  onPressed: () async {
                                    var hasil = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectPromoMobile(
                                                  refreshdata:
                                                      widget.refreshdata,
                                                  updatedata: widget.updatedata,
                                                  databill: x.first,
                                                  pscd: widget.pscd,
                                                  trno: widget.trno,
                                                ))).then((_) async {
                                      await widget.refreshdata;
                                      await widget.updatedata;
                                      await handler
                                          .checktotalAmountNett(widget.trno)
                                          .then((hasil) {
                                        ClassRetailMainMobile.of(context)!
                                            .string = hasil.first;
                                      });
                                    });
                                    setState(() {
                                      widget.sum = hasil;
                                    });
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
                                          0.05,
                                      child: TextButton(
                                          onPressed: () async {
                                            await handler
                                                .deletePromoActive(
                                                    x.first.trno!)
                                                .whenComplete(() {
                                              setState(() {});
                                            });
                                            await handler
                                                .checktotalAmountNett(
                                                    widget.trno.toString())
                                                .then((value) async {
                                              setState(() {
                                                widget.sum =
                                                    value.first.nettamt!;
                                              });
                                              await widget.updatedata;
                                              await widget.refreshdata!;
                                              ClassRetailMainMobile.of(context)!
                                                  .string = value.first;
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
                    trailing:
                        Text(CurrencyFormat.convertToIdr(x.first.nettamt, 0)),
                  ),
                  TextButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => DialogClassCancelorder(
                                outletcd: widget.pscd!,
                                trno: x.first.trno!)).then((_) {
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
