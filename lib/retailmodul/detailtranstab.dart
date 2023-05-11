// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_generic_function_type_aliases, sized_box_for_whitespace, avoid_print, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/retailmodul/classedititemmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/classsumamryorderslidemobile.dart';
import 'package:posq/retailmodul/productclass/classretailcondiment.dart';
import 'package:posq/retailmodul/summarybilltab.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/printer/classtextprint.dart';
import 'package:posq/userinfo.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

typedef void StringCallback(IafjrndtClass val);
PrintSmall? printing;

class DetailTransTabs extends StatefulWidget {
  final StringCallback callback;
  final IafjrndtClass? trnoinfo;
  final Outlet outletinfo;
  late int? qty;
  late int? itemlength;
  final num? amount;
  late List<IafjrndtClass> listdata;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  final String trno;
  final bool animated;
  final bool? fromsaved;
  late num? sum;
  final List<TransactionTipe> datatransaksi;
  final String guestname;

  DetailTransTabs(
      {Key? key,
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
      required this.itemlength,
      this.fromsaved,
      required this.datatransaksi,
      required this.guestname})
      : super(key: key);

  @override
  State<DetailTransTabs> createState() => _DetailTransTabsState();
}

class _DetailTransTabsState extends State<DetailTransTabs>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
  Future<List<IafjrndtClass>>? getDetails;
  List<IafjrndtClass> datadetail = [];
  List<String> ordertype = ['Dine in', 'Take Away'];
  int multiprice = 0;
  int? selectedindex;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    trno = widget.trno;
    formattedDate = formatter.format(now);
    // getDataSlide();
    print(widget.trnoinfo!.trdt);
    checkPrinter();
    getSumm();
    getDetails = getDetailTrnos();
  }

  Future<List<IafjrndtClass>> getDetailTrnos() async {
    datadetail = await ClassApi.getTrnoDetail(widget.trno, dbname, '');
    if (datadetail.first.salestype != 'normal') {
      selectedindex = widget.datatransaksi.indexWhere(
          (element) => element.transdesc == datadetail.first.salestype);
      print('ini index : ${datadetail.first}');
    }

    setState(() {});
    return datadetail;
  }

  checkPrinter() async {
    connected = await bluetooth.isConnected.then((value) => value!);
    setState(() {});
    print(connected);
  }

  set refreshtrans(IafjrndtClass value) {
    print('oke ');
    getDetails;
    setState(() {});
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

  checkSalesType() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       // color: Colors.blue,
                //       ),
                //   height: MediaQuery.of(context).size.height * 0.04,
                //   width: MediaQuery.of(context).size.width * 0.9,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Expanded(
                //           flex: 4,
                //           child: Text(
                //             'BARANG : ${widget.itemlength}',
                //             style: TextStyle(
                //                 color: Colors.black,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 17),
                //           )),
                //       Expanded(
                //           flex: 1,
                //           child: IconButton(
                //             icon: Icon(
                //               connected == true ? Icons.print : Icons.print_disabled,
                //             ),
                //             iconSize: 25,
                //             color: connected == true ? Colors.green : Colors.red,
                //             splashColor: Colors.purple,
                //             onPressed: accesslist.contains('settingprinter') == true
                //                 ? () async {
                //                     await getSumm();
                //                     if (connected == true) {
                //                       await printing.prints(
                //                           widget.listdata,
                //                           summary,
                //                           widget.outletinfo.outletname!,
                //                           widget.outletinfo);
                //                     } else {
                //                       await Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>
                //                                   ClassMainPrinter()));
                //                     }
                //                   }
                //                 : () {
                //                     Fluttertoast.showToast(
                //                         msg: "Tidak Punya Akses Printer",
                //                         toastLength: Toast.LENGTH_LONG,
                //                         gravity: ToastGravity.CENTER,
                //                         timeInSecForIosWeb: 1,
                //                         backgroundColor:
                //                             Color.fromARGB(255, 11, 12, 14),
                //                         textColor: Colors.white,
                //                         fontSize: 16.0);
                //                   },
                //           )),
                //       Expanded(
                //           flex: 1,
                //           child: IconButton(
                //             icon: Icon(
                //               Icons.people_alt,
                //             ),
                //             iconSize: 25,
                //             color: Colors.blueGrey,
                //             splashColor: Colors.blueGrey,
                //             onPressed: () async {
                //               await showDialog(
                //                   context: context,
                //                   builder: (BuildContext context) {
                //                     return DialogCustomerList();
                //                   });
                //             },
                //           )),
                //       Expanded(
                //           flex: 1,
                //           child: IconButton(
                //             icon: Icon(
                //               Icons.table_bar,
                //             ),
                //             iconSize: 25,
                //             color: Colors.blueGrey,
                //             splashColor: Colors.blueGrey,
                //             onPressed: () async {
                //               await showDialog(
                //                   context: context,
                //                   builder: (BuildContext context) {
                //                     return DialogCustomerList();
                //                   });
                //             },
                //           )),
                //     ],
                //   ),
                // ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.datatransaksi.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: selectedindex != index
                                    ? Colors.orange
                                    : Color.fromARGB(
                                        255, 0, 146, 156), // foreground
                              ),
                              onPressed: () async {
                                selectedindex = index;
                                print(index == index);
                                Fluttertoast.showToast(
                                    msg: "Sukses Change",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 12, 14),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                for (var element in datadetail) {
                                  var amountprice = element.pricelist!
                                      .where((element) =>
                                          element.transtype ==
                                          widget.datatransaksi[index].transtype)
                                      .toList();
                                  var result = IafjrndtClass(
                                      salestype:
                                          widget.datatransaksi[index].transdesc,
                                      condimenttype: element.condimenttype,
                                      svchgpct: element.svchgpct,
                                      multiprice: element.multiprice,
                                      pricelist: element.pricelist,
                                      typ: element.typ,
                                      optioncode: element.optioncode,
                                      havecond: element.havecond,
                                      active: element.active,
                                      trdt: element.trdt,
                                      transno: element.transno,
                                      split: element.split,
                                      itemdesc: element.itemdesc,
                                      qty: element.qty,
                                      description: element.description,
                                      createdt: element.createdt,
                                      rateamtitem: amountprice.isNotEmpty
                                          ? amountprice.first.amount
                                          : element.rateamtitem,
                                      discamt: element.discamt,
                                      discpct: element.discpct,
                                      taxpct: element.taxpct,
                                      revenueamt: amountprice.isNotEmpty
                                          ? element.qty! *
                                              amountprice.first.amount
                                          : element.revenueamt,
                                      taxamt: amountprice.isNotEmpty
                                          ? (element.qty! *
                                                  amountprice.first.amount) *
                                              element.taxpct! /
                                              100
                                          : element.taxamt,
                                      serviceamt: amountprice.isNotEmpty
                                          ? (element.qty! *
                                                  amountprice.first.amount) *
                                              element.svchgpct! /
                                              100
                                          : element.serviceamt,
                                      totalaftdisc: amountprice.isNotEmpty
                                          ? (element.qty! *
                                                  amountprice.first.amount) +
                                              ((element.qty! *
                                                      amountprice
                                                          .first.amount) *
                                                  element.taxpct! /
                                                  100) +
                                              ((element.qty! *
                                                      amountprice
                                                          .first.amount) *
                                                  element.svchgpct! /
                                                  100)
                                          : element.totalaftdisc,
                                      id: element.id);

                                  ClassApi.updatePosDetail(result, pscd);
                                }
                                await getDetailTrnos().then((value) {
                                  setState(() {});
                                });
                                await getSumm();
                                widget.updatedata!();
                                widget.refreshdata;

                                ClassRetailMainMobile.of(context)!.string =
                                    IafjrndtClass(
                                        trdt: widget.trnoinfo!.trdt,
                                        pscd: widget.trnoinfo!.pscd,
                                        description: '',
                                        totalaftdisc: 0,
                                        transno: datadetail.length == 0
                                            ? null
                                            : widget.trnoinfo!.transno);
                                setState(() {});
                              },
                              child:
                                  Text(widget.datatransaksi[index].transdesc!)),
                        );
                      }),
                ),
                SafeArea(
                  child: Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.43,
                      child: FutureBuilder(
                          future:
                              ClassApi.getTrnoDetail(widget.trno, dbname, ''),
                          builder: (context,
                              AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              datadetail = snapshot.data!;
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    // widget.listdata = datadetail;
                                    return SafeArea(
                                      left: false,
                                      child: Column(
                                        children: [
                                          Dismissible(
                                            key: ValueKey<int>(
                                                snapshot.data![index].id!),
                                            direction: accesslist.contains(
                                                        'deleteitem') ==
                                                    true
                                                ? DismissDirection.endToStart
                                                : DismissDirection.none,
                                            onDismissed: accesslist.contains(
                                                        'deleteitem') ==
                                                    true
                                                ? (DismissDirection
                                                    direction) async {
                                                    if (snapshot
                                                            .data![index].typ !=
                                                        'condiment') {
                                                      await ClassApi
                                                          .deactivePoscondimentByALL(
                                                              snapshot
                                                                  .data![index]
                                                                  .transno!,
                                                              snapshot
                                                                  .data![index]
                                                                  .itemseq
                                                                  .toString(),
                                                              dbname);
                                                      await ClassApi
                                                              .deactivePosdetail(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!
                                                                      .toInt(),
                                                                  dbname)
                                                          .whenComplete(() {
                                                        setState(() {
                                                          snapshot.data!.remove(
                                                              snapshot.data![
                                                                  index]);
                                                        });
                                                        widget.updatedata!();
                                                        widget.refreshdata;

                                                        ClassRetailMainMobile.of(context)!
                                                                .string =
                                                            IafjrndtClass(
                                                                trdt: widget
                                                                    .trnoinfo!
                                                                    .trdt,
                                                                pscd: widget
                                                                    .trnoinfo!
                                                                    .pscd,
                                                                description: '',
                                                                totalaftdisc: 0,
                                                                transno: snapshot
                                                                            .data!
                                                                            .length ==
                                                                        0
                                                                    ? null
                                                                    : widget
                                                                        .trnoinfo!
                                                                        .transno);
                                                      });
                                                      await getDetails!
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                    } else {
                                                      await ClassApi
                                                              .deactivePoscondimentByID(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .transno!,
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .itemseq
                                                                      .toString(),
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .optioncode!,
                                                                  dbname)
                                                          .whenComplete(() {
                                                        snapshot.data!.remove(
                                                            snapshot
                                                                .data![index]);
                                                      });
                                                      widget.refreshdata;
                                                      await getDetailTrnos()
                                                          .then((value) {
                                                        setState(() {});
                                                      });

                                                      ClassRetailMainMobile
                                                                  .of(context)!
                                                              .string =
                                                          IafjrndtClass(
                                                              trdt: widget
                                                                  .trnoinfo!
                                                                  .trdt,
                                                              pscd: widget
                                                                  .trnoinfo!
                                                                  .pscd,
                                                              description: '',
                                                              totalaftdisc: 0,
                                                              transno: snapshot
                                                                          .data!
                                                                          .length ==
                                                                      0
                                                                  ? null
                                                                  : widget
                                                                      .trnoinfo!
                                                                      .transno);
                                                    }
                                                  }
                                                : (DismissDirection direction) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Tidak Dapat Akses delete",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                11, 12, 14),
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  },
                                            child:
                                                snapshot.data![index].qty != 0
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          if (snapshot
                                                                      .data![
                                                                          index]
                                                                      .typ !=
                                                                  'condiment' &&
                                                              snapshot
                                                                      .data![
                                                                          index]
                                                                      .havecond! <=
                                                                  0) {
                                                            final result = await Navigator
                                                                .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ClassEditItemMobile(
                                                                              updatedata: widget.updatedata,
                                                                              data: snapshot.data![index],
                                                                              editamount: editamount,
                                                                              editdesc: editdesc,
                                                                              editqty: editqty,
                                                                            ))).then(
                                                                (_) {
                                                              widget
                                                                  .refreshdata;
                                                              widget
                                                                  .updatedata!();
                                                            });
                                                            ClassRetailMainMobile.of(context)!
                                                                    .string =
                                                                IafjrndtClass(
                                                                    trdt: widget
                                                                        .trnoinfo!.transno,
                                                                    pscd: widget
                                                                        .trnoinfo!
                                                                        .pscd,
                                                                    description:
                                                                        '',
                                                                    totalaftdisc:
                                                                        0,
                                                                    transno: widget
                                                                        .trnoinfo!
                                                                        .transno);
                                                            await getDetailTrnos()
                                                                .then((value) {
                                                              setState(() {
                                                                datadetail =
                                                                    value;
                                                              });
                                                            });
                                                            if (result ==
                                                                null) {
                                                              ClassRetailMainMobile.of(context)!.string = IafjrndtClass(
                                                                  trdt: widget
                                                                      .trnoinfo!
                                                                      .transno,
                                                                  pscd: widget
                                                                      .trnoinfo!
                                                                      .pscd,
                                                                  description:
                                                                      '',
                                                                  totalaftdisc:
                                                                      0,
                                                                  transno: widget
                                                                      .trnoinfo!
                                                                      .transno);
                                                            } else {
                                                              ClassRetailMainMobile
                                                                      .of(context)!
                                                                  .string = result;
                                                              await getDetailTrnos()
                                                                  .then(
                                                                      (value) {
                                                                setState(() {
                                                                  datadetail =
                                                                      value;
                                                                });
                                                              });
                                                            }
                                                          } else {
                                                            ///edit condiment mode///
                                                            final result = snapshot
                                                                        .data![
                                                                            index]
                                                                        .condimenttype ==
                                                                    ''
                                                                ? await Navigator
                                                                    .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ClassInputCondiment(
                                                                                  guestname: widget.guestname,
                                                                                  datatransaksi: snapshot.data![index],
                                                                                  iditem: snapshot.data![index].id,
                                                                                  fromedit: true,
                                                                                  dataedit: snapshot.data!,
                                                                                  data: Item(multiprice: multiprice, itemcode: snapshot.data![index].itemcode, itemdesc: snapshot.data![index].itemdesc, outletcode: snapshot.data![index].pscd, slsamt: snapshot.data![index].revenueamt! / datadetail[index].qty!, costamt: 0, slsnett: snapshot.data![index].totalaftdisc, taxpct: snapshot.data![index].taxpct, svchgpct: snapshot.data![index].svchgpct, slsfl: 1),
                                                                                  itemseq: snapshot.data![index].itemseq!,
                                                                                  outletcd: widget.trnoinfo!.pscd!,
                                                                                  transno: widget.trno,
                                                                                ))).then(
                                                                    (_) async {
                                                                    widget
                                                                        .refreshdata;
                                                                    widget
                                                                        .updatedata!();
                                                                  })
                                                                : null;
                                                            ClassRetailMainMobile.of(context)!
                                                                    .string =
                                                                IafjrndtClass(
                                                                    trdt: widget
                                                                        .trnoinfo!.transno,
                                                                    pscd: widget
                                                                        .trnoinfo!
                                                                        .pscd,
                                                                    description:
                                                                        '',
                                                                    totalaftdisc:
                                                                        0,
                                                                    transno: widget
                                                                        .trnoinfo!
                                                                        .transno);
                                                            await getDetailTrnos()
                                                                .then((value) {
                                                              setState(() {
                                                                datadetail =
                                                                    value;
                                                              });
                                                            });
                                                            if (result ==
                                                                null) {
                                                              ClassRetailMainMobile.of(context)!.string = IafjrndtClass(
                                                                  trdt: widget
                                                                      .trnoinfo!
                                                                      .transno,
                                                                  pscd: widget
                                                                      .trnoinfo!
                                                                      .pscd,
                                                                  description:
                                                                      '',
                                                                  totalaftdisc:
                                                                      0,
                                                                  transno: widget
                                                                      .trnoinfo!
                                                                      .transno);
                                                            } else {
                                                              ClassRetailMainMobile
                                                                      .of(context)!
                                                                  .string = result;
                                                            }
                                                          }
                                                        },
                                                        child: SafeArea(
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.18,
                                                                      child: Text(
                                                                          snapshot.data![index].typ != 'condiment'
                                                                              ? snapshot.data![index].itemdesc!
                                                                              : ' *** ${snapshot.data![index].itemdesc!} ***',
                                                                          style: snapshot.data![index].typ != 'condiment'
                                                                              ? TextStyle(fontSize: 12, fontWeight: FontWeight.normal)
                                                                              : TextStyle(
                                                                                  fontSize: 12,
                                                                                )),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.15,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.1,
                                                                            child:
                                                                                Text('${CurrencyFormat.convertToIdr(snapshot.data![index].revenueamt, 0)}', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                                                          ),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.02,
                                                                            child:
                                                                                Icon(
                                                                              snapshot.data![index].typ != 'condiment' ? Icons.edit : null,
                                                                              color: Colors.black,
                                                                              size: 15.0,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      '${CurrencyFormat.convertToIdr(snapshot.data![index].rateamtitem, 0)},',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10)),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.01,
                                                                  ),
                                                                  Text('x',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10)),
                                                                  Text(
                                                                      '${snapshot.data![index].qty}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10)),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.13,
                                                                  ),
                                                                  snapshot.data![index]
                                                                              .discamt !=
                                                                          0
                                                                      ? Container(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.11,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Text('Discount', style: TextStyle(fontSize: 10)),
                                                                              Text('-${CurrencyFormat.convertToIdr(snapshot.data![index].discamt, 0)}', style: TextStyle(fontSize: 10)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    );
                                  });
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ShimmerLoading(
                                isLoading: true,
                                child: ListView.builder(
                                    itemCount: widget.itemlength,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                      );
                                    }),
                              );
                            }
                            return Center(
                                child: Container(
                              child: Text('Tidak Ada transaksi'),
                            ));
                          })),
                ),

                widget.qty != 0
                    ? Expanded(
                        flex: 1,
                        child: SummaryOrderSlideTabs(
                          listdata: datadetail,
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
                          balance: summary[0].totalaftdisc == null
                              ? 0
                              : summary[0].totalaftdisc!,
                        ),
                      )
                    : Expanded(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.17,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Subtotal ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.17,
                                  ),
                                  Text(
                                    CurrencyFormat.convertToIdr(0, 0),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: null,
                                    child: Text(
                                      'Discount',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.10,
                                  ),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size(50, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              alignment: Alignment.centerRight),
                                          onPressed: () async {},
                                          child: Text(
                                            '>',
                                            style: TextStyle(fontSize: 20),
                                          )))
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
                              Row(
                                children: [
                                  Text(
                                    'Total ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.195,
                                  ),
                                  Text(
                                    CurrencyFormat.convertToIdr(0, 0),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width: MediaQuery.of(context).size.width *
                                        0.22,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5), // <-- Radius
                                          ),
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors
                                              .grey[200] // Background color
                                          ),
                                      onPressed: () async {},
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5), // <-- Radius
                                          ),
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors
                                              .grey[200] // Background color
                                          ),
                                      onPressed: () {},
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Color.fromARGB(255, 0,
                                            160, 147), // Background color
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.22,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // <-- Radius
                                        ),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Color.fromARGB(255, 0,
                                            160, 147), // Background color
                                      ),
                                      onPressed: () {
                                        print('tagihkan');
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
