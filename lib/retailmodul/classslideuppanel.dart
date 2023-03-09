// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_generic_function_type_aliases, sized_box_for_whitespace, avoid_print, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/retailmodul/classedititemmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/classsumamryorderslidemobile.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/printer/classtextprint.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

typedef void StringCallback(IafjrndtClass val);
PrintSmall? printing;

class SlideUpPanel extends StatefulWidget {
  final ScrollController controllers;
  final StringCallback callback;
  final IafjrndtClass? trnoinfo;
  final Outlet outletinfo;
  late int? qty;
  final num? amount;
  late List<IafjrndtClass> listdata;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  final String trno;
  final bool animated;
  final bool? fromsaved;
  late num? sum;

  SlideUpPanel(
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
      required this.animated,
      required this.sum,
      this.fromsaved})
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
  List<IafjrndtClass> summary = [];
  String trno = '';
  num? amounttotal = 0;
  String trdt = '';
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  num? amountidisc;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool connected = false;
  PrintSmall printing = PrintSmall();

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    trno = widget.trno;
    formattedDate = formatter.format(now);
    getDataSlide();
    print(widget.trnoinfo!.trdt);
    checkPrinter();
    getSumm();
  }

  checkPrinter() async {
    connected = await bluetooth.isConnected.then((value) => value!);
    setState(() {});
    print(connected);
  }

  getDataSlide() async {
    await ClassApi.getTrnoDetail(trno, dbname, query).then((isi) {
      if (isi.isNotEmpty) {
        num totalSlsNett = isi.fold(
            0, (previousValue, isi) => previousValue + isi.totalaftdisc!);
        setState(() {
          totalbarang = isi.length;
          amounttotal = totalSlsNett;
          ClassRetailMainMobile.of(context)!.string =
              IafjrndtClass(totalaftdisc: totalSlsNett);
        });
      } else {
        setState(() {
          totalbarang = 0;
        });
      }
    });

    await ClassApi.getSumTrans(trno, dbname, query).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          summary = value;
          amounttotal = value.first.totalaftdisc;
        });
        print('ini summary : $summary');
      } else {
        amounttotal = 0;
      }
    });
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
                        connected == true ? Icons.print : Icons.print_disabled,
                      ),
                      iconSize: 25,
                      color: connected == true ? Colors.green : Colors.red,
                      splashColor: Colors.purple,
                      onPressed: () async {
                        await getSumm();
                        if (connected == true) {
                          await printing.prints(widget.listdata, summary,
                              widget.outletinfo.outletname!,widget.outletinfo);
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClassMainPrinter()));
                        }
                      },
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
          Container(
              height: widget.qty! <= 4
                  ? MediaQuery.of(context).size.height *
                      0.11 *
                      double.parse(widget.qty.toString())
                  : MediaQuery.of(context).size.height * 0.11 * 4,
              child: FutureBuilder(
                  future: ClassApi.getTrnoDetail(trno, dbname, ''),
                  builder:
                      (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return SafeArea(
                        child: ListView.builder(
                            controller: widget.controllers,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              widget.listdata = snapshot.data!;
                              return Dismissible(
                                key: ValueKey<int>(snapshot.data![index].id!),
                                direction: DismissDirection.endToStart,
                                onDismissed:
                                    (DismissDirection direction) async {
                                  await ClassApi.deactivePosdetail(
                                          snapshot.data![index].id!.toInt(),
                                          dbname)
                                      .whenComplete(() {
                                    setState(() {
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                    widget.refreshdata;
                                    ClassRetailMainMobile.of(context)!.string =
                                        IafjrndtClass(
                                            trdt: widget.trnoinfo!.trdt,
                                            pscd: widget.trnoinfo!.pscd,
                                            description: '',
                                            totalaftdisc: 0,
                                            transno: snapshot.data!.length == 0
                                                ? null
                                                : widget.trnoinfo!.transno);
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
                                                    trdt: widget
                                                        .trnoinfo!.transno,
                                                    pscd: widget.trnoinfo!.pscd,
                                                    description: '',
                                                    totalaftdisc: 0,
                                                    transno: widget
                                                        .trnoinfo!.transno);
                                          } else {
                                            ClassRetailMainMobile.of(context)!
                                                .string = result;
                                          }
                                        },
                                        dense: true,
                                        visualDensity: VisualDensity(
                                            vertical: -2), // to compact
                                        title: Text(
                                            snapshot.data![index].description!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                                '${CurrencyFormat.convertToIdr(snapshot.data![index].rateamtitem, 0)},',
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
                                                  '${CurrencyFormat.convertToIdr(snapshot.data![index].revenueamt, 0)}',
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
                    summary: summary,
                    fromsaved: widget.fromsaved,
                    outletinfo: widget.outletinfo,
                    refreshdata: widget.refreshdata,
                    updatedata: () {
                      widget.refreshdata;
                    },
                    sum: widget.sum,
                    pscd: widget.outletinfo.outletcd,
                    trno: widget.trno,
                  ),
                )
              : Expanded(
                  flex: 1,
                  child: Text(''),
                ),
        ],
      ),
    );
  }
}
