// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_generic_function_type_aliases, sized_box_for_whitespace, avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/retailmodul/classedititemmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/classsumamryorderslidemobile.dart';

typedef void StringCallback(IafjrndtClass val);

class SlideUpPanel extends StatefulWidget {
  final ScrollController controllers;
  final StringCallback callback;
  final IafjrndtClass? trnoinfo;
  final Outlet outletinfo;
  final int? qty;
  final num? amount;
  final List<IafjrndtClass> listdata;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  final String trno;
  final bool animated;

  const SlideUpPanel(
      {Key? key,
      required this.controllers,
      required this.trnoinfo,
      this.qty,
      this.amount,
      required this.callback,
      required this.listdata,
      this.updatedata,
      this.refreshdata,
      required this.trno,
      required this.outletinfo,
      required this.animated})
      : super(key: key);

  @override
  State<SlideUpPanel> createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  final editdesc = TextEditingController();
  final editamount = TextEditingController();
  final editqty = TextEditingController();
  late DatabaseHandler handler;
  String query = 'trno';
  int? totalbarang = 0;
  List? initial = [];
  String trno = '';
  num? amounttotal = 0;
  String trdt = '';
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  num? amountidisc;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
    trno = widget.trno;
    formattedDate = formatter.format(now);
    getDataSlide();
    print(widget.trnoinfo!.trdt);
  }

  getDataSlide() async {
    handler = DatabaseHandler();
    await handler.initializeDB();
    handler.retrieveDetailIafjrndt(widget.trno.toString()).then((isi) {
      if (isi.isNotEmpty) {
        setState(() {
          totalbarang = isi.length;
        });
      } else {
        setState(() {
          totalbarang = 0;
        });
      }
    });

    await handler.checktotalAmountNett(trno).then((value) {
      setState(() {
        amounttotal = value.first.nettamt;
      });
      ClassRetailMainMobile.of(context)!.string = value.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.menu_sharp,
                size: 25,
              )),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Divider(),
          //     ),
          //   ],
          // ),

          Container(
            decoration: BoxDecoration(
                // color: Colors.blue,
                ),
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      'BARANG : ${widget.qty} ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.people_alt,
                      ),
                      iconSize: 25,
                      color: Colors.black,
                      splashColor: Colors.purple,
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogCustomerList();
                            });
                      },
                    )),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Divider(),
          Container(
              height: widget.qty! <= 4
                  ? MediaQuery.of(context).size.height *
                      0.11 *
                      double.parse(widget.qty.toString())
                  : MediaQuery.of(context).size.height * 0.11 * 4,
              child: FutureBuilder(
                  future: handler.retrieveDetailIafjrndt(widget.trno),
                  builder:
                      (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return SafeArea(
                        child: ListView.builder(
                            controller: widget.controllers,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: ValueKey<int>(snapshot.data![index].id!),
                                direction: DismissDirection.endToStart,
                                onDismissed:
                                    (DismissDirection direction) async {
                                  await handler
                                      .deleteiafjrndtItems(
                                          snapshot.data![index].id!.toInt())
                                      .whenComplete(() {
                                    setState(() {
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                  }).then((value) {
                                    getDataSlide();
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SafeArea(
                                      child: ListTile(
                                        tileColor: Colors.black,
                                        onTap: () async {
                                          final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClassEditItemMobile(
                                                        updatedata:
                                                            widget.updatedata,
                                                        data: snapshot
                                                            .data![index],
                                                        editamount: editamount,
                                                        editdesc: editdesc,
                                                        editqty: editqty,
                                                      ))).then((_) {
                                            widget.refreshdata;
                                            widget.updatedata!();
                                          });
                                          if (result == null) {
                                            ClassRetailMainMobile.of(context)!
                                                    .string =
                                                IafjrndtClass(
                                                    trdt: widget.trnoinfo!.trno,
                                                    pscd: widget.trnoinfo!.pscd,
                                                    trdesc: '',
                                                    nettamt: 0,
                                                    trno:
                                                        widget.trnoinfo!.trno);
                                          } else {
                                            ClassRetailMainMobile.of(context)!
                                                .string = result;
                                          }
                                        },
                                        dense: true,
                                        visualDensity: VisualDensity(
                                            vertical: -2), // to compact
                                        title: Text(
                                            snapshot.data![index].trdesc!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                                '${CurrencyFormat.convertToIdr(snapshot.data![index].rateamt, 0)},',
                                                style: TextStyle(fontSize: 12)),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Text('x',
                                                style: TextStyle(fontSize: 12)),
                                            Text('${snapshot.data![index].qty}',
                                                style: TextStyle(fontSize: 12)),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            snapshot.data![index].discamt != 0
                                                ? Row(
                                                    children: [
                                                      Text('Discount',
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      Text(
                                                          '-${CurrencyFormat.convertToIdr(snapshot.data![index].discamt, 0)}',
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.black,
                                                size: 15.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Text(
                                                  '${CurrencyFormat.convertToIdr(snapshot.data![index].rvnamt, 0)}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      indent: 20,
                                      endIndent: 20,
                                    ),

                                    ///////////////////////// SUMMARY ORDER///////////////////////
                                  ],
                                ),
                              );
                            }),
                      );
                    } else if (snapshot.hasError) {
                      return Container();
                    }
                    return Container();
                  })),
          widget.qty != 0
              ? Expanded(
                  flex: 1,
                  child: SummaryOrderSlidemobile(
                    trno: widget.trno,
                  ),
                )
              : Expanded(
                  flex: 1,
                  child: Text(''),
                ),
          // Expanded(
          //   flex: 1,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Bouncing(
          //           onPress: () {
          //             print('simpan');
          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(12),
          //               color: Colors.blue,
          //             ),
          //             height: MediaQuery.of(context).size.height * 0.06,
          //             width: MediaQuery.of(context).size.width * 0.4,
          //             child: Text(
          //               'Simpan',
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 12),
          //             ),
          //           )),
          //       Bouncing(
          //           onPress: () async {

          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(12),
          //               color: Colors.blue,
          //             ),
          //             height: MediaQuery.of(context).size.height * 0.06,
          //             width: MediaQuery.of(context).size.width * 0.4,
          //             child: Text(
          //               'Bayar Rp.${widget.amount ?? 0}',
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 12),
          //             ),
          //           )),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
