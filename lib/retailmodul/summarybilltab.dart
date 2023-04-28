// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/promo/classcreatepromomobile.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/selectdiscountmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class SummaryOrderSlideTabs extends StatefulWidget {
  final String trno;
  final String? pscd;
  late num? sum;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  final Outlet outletinfo;
  final bool? fromsaved;
  late List<IafjrndtClass> summary;

  SummaryOrderSlideTabs(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.sum,
      required this.updatedata,
      required this.refreshdata,
      required this.outletinfo,
      required this.summary,
      this.fromsaved})
      : super(key: key);

  @override
  State<SummaryOrderSlideTabs> createState() => _SummaryOrderSlideTabsState();
}

class _SummaryOrderSlideTabsState extends State<SummaryOrderSlideTabs> {
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
            return Container(
       
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Total',
                    //       style: TextStyle(fontSize: 10),
                    //     ),
                    //     Text(
                    //       CurrencyFormat.convertToIdr(x.first.revenueamt, 0),
                    //       style: TextStyle(fontSize: 10),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: x.first.discamt == 0
                              ? () async {
                                  var hasil = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectPromoMobile(
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
                                      ClassRetailMainMobile.of(context)!
                                          .string = hasil.first;
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
                          child: Text(
                            'Discount',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.10,
                        ),
                        x.first.discamt == 0
                            ? Container(
                              alignment: Alignment.centerRight,
                  
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                    
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(50, 30),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        alignment: Alignment.centerRight),
                                    onPressed: () async {
                                      Promo hasil = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectPromoMobile(
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
                                    )))
                            : Container(
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      CurrencyFormat.convertToIdr(
                                          x.first.discamt, 0),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                              style: TextStyle(fontSize: 10),
                                            )))
                                  ],
                                ))
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
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Service',
                    //       style: TextStyle(fontSize: 10),
                    //     ),
                    //     Text(
                    //       CurrencyFormat.convertToIdr(x.first.serviceamt, 0),
                    //       style: TextStyle(fontSize: 10),
                    //     ),
                    //   ],
                    // ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Color.fromARGB(
                            255, 0, 160, 147), // Background color
                      ),
                      onPressed: () {},
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Grand total ',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(
                                  x.first.totalaftdisc, 0),
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ]),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft),
                        onPressed: accesslist.contains('canceltrans') == true
                            ? () async {
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
                            : () {
                                Fluttertoast.showToast(
                                    msg: "Tidak Punya Akses Cancel Order",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 12, 14),
                                    textColor: Colors.white,
                                    fontSize: 10.0);
                              },
                        child: Text(
                          'Batalkan transaksi',
                          style: TextStyle(fontSize: 10),
                        ))
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}
