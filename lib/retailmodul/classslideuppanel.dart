// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_generic_function_type_aliases, sized_box_for_whitespace, avoid_print, prefer_typing_uninitialized_variables, must_be_immutable, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classdialogvoidtab.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/membershiptransmobile.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/retailmodul/classedititemmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/classsumamryorderslidemobile.dart';
import 'package:posq/retailmodul/productclass/classretailcondiment.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/printer/classtextprint.dart';
import 'package:posq/userinfo.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void StringCallback(IafjrndtClass val);
PrintSmall? printing;

class SlideUpPanel extends StatefulWidget {
  final ScrollController controllers;
  final StringCallback callback;
  final IafjrndtClass? trnoinfo;
  final Outlet outletinfo;
  late int? qty;
  late int? itemlength;
  final num? amount;
  late List<IafjrndtClass> listdata;
  final Function? updatedata;
  final num summarybill;
  final VoidCallback? refreshdata;
  final String trno;
  final bool animated;
  final bool? fromsaved;
  late num? sum;
  final List<TransactionTipe> datatransaksi;
  late String guestname;

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
      required this.itemlength,
      this.fromsaved,
      required this.datatransaksi,
      required this.guestname,
      required this.summarybill})
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
  Future<List<IafjrndtClass>>? getDetails;
  List<IafjrndtClass> datadetail = [];
  List<String> ordertype = ['Dine in', 'Take Away'];
  int multiprice = 0;
  int? selectedindex;
  bool hasmember = false;
  String guestnames = '';
  TemplatePrinter ?template;

  @override
  void initState() {
    super.initState();
    checkGuest();
    // print('ini listdata ${widget.listdata}');
    trno = widget.trno;
    formattedDate = formatter.format(now);
    getDataSlide();
    // print(widget.trnoinfo!.trdt);
    checkPrinter();
    getSumm();
    getDetails = getDetailTrnos();
     getTemplatePrinter();
  }

  Future<List<IafjrndtClass>> getDetailTrnos() async {
    datadetail = await ClassApi.getTrnoDetail(trno, dbname, '');
    if (datadetail.first.salestype != 'normal') {
      selectedindex = widget.datatransaksi.indexWhere(
          (element) => element.transdesc == datadetail.first.salestype);
      // print('ini index : ${datadetail.first}');
    }

    setState(() {});
    return datadetail;
  }

  checkGuest() async {
    final savecostmrs = await SharedPreferences.getInstance();
    Map<String, dynamic> guest =
        json.decode(savecostmrs.getString('savecostmrs')!);
    guestnames = guest['guestname'];
    if (guest.isNotEmpty) {
      hasmember = true;
    } else {
      hasmember = false;
    }
    print('ini guest $guest');
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
          ClassRetailMainMobile.of(context)!.string = IafjrndtClass(
              totalaftdisc: totalSlsNett, totalcost: 0, ratecostamt: 0);
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
        // print('ini summary : $summary');
      } else {
        amounttotal = 0;
      }
    });
  }

  getSumm() async {
    await ClassApi.getSumTrans(widget.trno, dbname, '').then((value) {
      // print('ini summary : $value');
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

  getTemplatePrinter() async {
   template=  await ClassApi.getTemplatePrinter();
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
                      'BARANG : ${widget.itemlength}',
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
                      onPressed:
                          accesslistuser.contains('settingprinter') == true
                              ? () async {
                                  await getSumm();
                                  if (connected == true) {
                                    await printing.prints(
                                        widget.listdata,
                                        summary,
                                        widget.outletinfo.outletname!,
                                        widget.outletinfo,template!);
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
                    )),
                hasmember == true
                    ? Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: Icon(
                              Icons.card_membership,
                            ),
                            iconSize: 25,
                            // color: connected == true ? Colors.green : Colors.red,
                            splashColor: Colors.purple,
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MembershipsTrans(
                                          sum: widget.summarybill,
                                          databill: widget.listdata.first,
                                          membername: guestnames,
                                          trno: widget.trno,
                                        )),
                              );
                              await ClassApi.getSumTrans(widget.trno, pscd, '')
                                  .then(
                                (hasils) {
                                  print('refresh main');
                                  ClassRetailMainMobile.of(context)!.string =
                                      hasils.first;
                                  ClassRetailMainMobile.of(context)!.discount =
                                      hasils.first.discamt!;
                                  setState(() {
                                    widget.sum = hasils.first.totalaftdisc;
                                  });
                                  setState(() {});
                                },
                              );
                            }))
                    : Container(),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.people_alt,
                      ),
                      iconSize: 25,
                      color: Colors.blueGrey,
                      splashColor: Colors.blueGrey,
                      onPressed: () async {
                        hasmember = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogCustomerList();
                            });
                        await checkGuest();
                        setState(() {});
                      },
                    )),
                // Expanded(
                //     flex: 1,
                //     child: IconButton(
                //       icon: Icon(
                //         Icons.table_bar,
                //       ),
                //       iconSize: 25,
                //       color: Colors.blueGrey,
                //       splashColor: Colors.blueGrey,
                //       onPressed: () async {
                //         await showDialog(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return DialogCustomerList();
                //             });
                //       },
                //     )),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          widget.datatransaksi.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.datatransaksi.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: selectedindex != index
                                    ? Color.fromARGB(255, 0, 147, 167)
                                    : Colors.pink, // foreground
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
                                      ratecostamt: element.ratecostamt,
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
                                          ? element.qty! * amountprice.first.amount -
                                              element.discamt!
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
                                                      amountprice.first.amount) *
                                                  element.svchgpct! /
                                                  100) -
                                              element.discamt!
                                          : element.totalaftdisc,
                                      id: element.id,
                                      totalcost: 0);

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
                                            : widget.trnoinfo!.transno,
                                        totalcost: 0,
                                        ratecostamt: 0);
                                setState(() {});
                              },
                              child:
                                  Text(widget.datatransaksi[index].transdesc!)),
                        );
                      }),
                )
              : Container(),
          Container(
              alignment: Alignment.topCenter,
              height: widget.qty! <= 4
                  ? MediaQuery.of(context).size.height *
                      0.11 *
                      double.parse(widget.qty.toString())
                  : MediaQuery.of(context).size.height * 0.11 * 4,
              child: FutureBuilder(
                  future: getDetails,
                  builder:
                      (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      // print(datadetail);
                      return SafeArea(
                        child: ListView.builder(
                            controller: widget.controllers,
                            itemCount: datadetail.length,
                            itemBuilder: (context, index) {
                              widget.listdata = datadetail;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  datadetail[index].qty != 0
                                      ? ListTile(
                                          tileColor: Colors.black,
                                          onTap: () async {
                                            if (datadetail[index].typ !=
                                                    'condiment' &&
                                                datadetail[index].havecond! <=
                                                    0) {
                                              final result =
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ClassEditItemMobile(
                                                                updatedata: widget
                                                                    .updatedata,
                                                                data:
                                                                    datadetail[
                                                                        index],
                                                                editamount:
                                                                    editamount,
                                                                editdesc:
                                                                    editdesc,
                                                                editqty:
                                                                    editqty,
                                                              ))).then((_) {
                                                widget.refreshdata;
                                                widget.updatedata!();
                                              });
                                              ClassRetailMainMobile.of(context)!
                                                      .string =
                                                  IafjrndtClass(
                                                      trdt: widget
                                                          .trnoinfo!.transno,
                                                      pscd:
                                                          widget.trnoinfo!.pscd,
                                                      description: '',
                                                      totalaftdisc: 0,
                                                      transno: widget
                                                          .trnoinfo!.transno,
                                                      totalcost: 0,
                                                      ratecostamt: 0);
                                              await getDetailTrnos()
                                                  .then((value) {
                                                setState(() {
                                                  datadetail = value;
                                                });
                                              });
                                              if (result == null) {
                                                ClassRetailMainMobile.of(context)!
                                                        .string =
                                                    IafjrndtClass(
                                                        trdt: widget
                                                            .trnoinfo!.transno,
                                                        pscd: widget
                                                            .trnoinfo!.pscd,
                                                        description: '',
                                                        totalaftdisc: 0,
                                                        transno: widget
                                                            .trnoinfo!.transno,
                                                        totalcost: 0,
                                                        ratecostamt: 0);
                                              } else {
                                                ClassRetailMainMobile.of(
                                                        context)!
                                                    .string = result;
                                                await getDetailTrnos()
                                                    .then((value) {
                                                  setState(() {
                                                    datadetail = value;
                                                  });
                                                });
                                              }
                                            } else {
                                              ///edit condiment mode///
                                              final result = datadetail[index]
                                                          .condimenttype ==
                                                      ''
                                                  ? await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ClassInputCondiment(
                                                                guestname: widget
                                                                    .guestname,
                                                                datatransaksi:
                                                                    datadetail[
                                                                        index],
                                                                iditem:
                                                                    datadetail[
                                                                            index]
                                                                        .id,
                                                                fromedit: true,
                                                                dataedit:
                                                                    datadetail,
                                                                data: Item(
                                                                    packageflag:
                                                                        0,
                                                                    multiprice:
                                                                        multiprice,
                                                                    itemcode: datadetail[index]
                                                                        .itemcode,
                                                                    itemdesc:
                                                                        datadetail[index]
                                                                            .itemdesc,
                                                                    outletcode:
                                                                        datadetail[index]
                                                                            .pscd,
                                                                    slsamt: datadetail[index]
                                                                            .revenueamt! /
                                                                        datadetail[index]
                                                                            .qty!,
                                                                    costamt: 0,
                                                                    slsnett: datadetail[
                                                                            index]
                                                                        .totalaftdisc,
                                                                    taxpct: datadetail[
                                                                            index]
                                                                        .taxpct,
                                                                    svchgpct: datadetail[
                                                                            index]
                                                                        .svchgpct,
                                                                    slsfl: 1),
                                                                itemseq: datadetail[
                                                                        index]
                                                                    .itemseq!,
                                                                outletcd: widget
                                                                    .trnoinfo!
                                                                    .pscd!,
                                                                transno:
                                                                    widget.trno,
                                                              ))).then(
                                                      (_) async {
                                                      widget.refreshdata;
                                                      widget.updatedata!();
                                                    })
                                                  : null;
                                              ClassRetailMainMobile.of(context)!
                                                      .string =
                                                  IafjrndtClass(
                                                      trdt: widget
                                                          .trnoinfo!.transno,
                                                      pscd:
                                                          widget.trnoinfo!.pscd,
                                                      description: '',
                                                      totalaftdisc: 0,
                                                      transno: widget
                                                          .trnoinfo!.transno,
                                                      totalcost: 0,
                                                      ratecostamt: 0);
                                              await getDetailTrnos()
                                                  .then((value) {
                                                setState(() {
                                                  datadetail = value;
                                                });
                                              });
                                              if (result == null) {
                                                ClassRetailMainMobile.of(context)!
                                                        .string =
                                                    IafjrndtClass(
                                                        trdt: widget
                                                            .trnoinfo!.transno,
                                                        pscd: widget
                                                            .trnoinfo!.pscd,
                                                        description: '',
                                                        totalaftdisc: 0,
                                                        transno: widget
                                                            .trnoinfo!.transno,
                                                        totalcost: 0,
                                                        ratecostamt: 0);
                                              } else {
                                                ClassRetailMainMobile.of(
                                                        context)!
                                                    .string = result;
                                              }
                                            }
                                          },
                                          dense: true,
                                          visualDensity: VisualDensity(
                                              vertical: -2), // to compact
                                          title: Text(
                                              datadetail[index].typ !=
                                                      'condiment'
                                                  ? datadetail[index].itemdesc!
                                                  : ' *** ${datadetail[index].itemdesc!} ***',
                                              style: datadetail[index].typ !=
                                                      'condiment'
                                                  ? TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : TextStyle(
                                                      fontSize: 12,
                                                    )),
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                  '${CurrencyFormat.convertToIdr(datadetail[index].rateamtitem, 0)},',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                              ),
                                              Text('x',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Text('${datadetail[index].qty}',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                              ),
                                              datadetail[index].discamt != 0
                                                  ? Row(
                                                      children: [
                                                        Text('Discount',
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                        Text(
                                                            '-${CurrencyFormat.convertToIdr(datadetail[index].discamt, 0)}',
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                    '${CurrencyFormat.convertToIdr(datadetail[index].revenueamt!, 0)}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54)),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    if (strictuser == '1') {
                                                      var passwords =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Builder(
                                                              builder:
                                                                  (context) {
                                                            return PasswordDialog(
                                                              guestname: widget
                                                                  .guestname,
                                                              frompaymentmobile:
                                                                  false,
                                                              frompayment:
                                                                  false,
                                                              dialogcancel:
                                                                  false,
                                                              onPasswordEntered:
                                                                  (String
                                                                      password) async {
                                                                print(
                                                                    'Entered password: $password');

                                                                // Lakukan sesuatu dengan password yang dimasukkan di sini
                                                              },
                                                            );
                                                          });
                                                        },
                                                      );
                                                      await ClassApi
                                                              .getAccessCodevoid(
                                                                  passwords)
                                                          .then((value) async {
                                                        if (value.isEmpty) {
                                                          await Fluttertoast.showToast(
                                                              msg:
                                                                  "Kode yg anda masukan salah",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          11,
                                                                          12,
                                                                          14),
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        } else {
                                                          // print(value);
                                                          if (datadetail[index]
                                                                  .typ !=
                                                              'condiment') {
                                                            await ClassApi.deactivePoscondimentByALL(
                                                                datadetail[
                                                                        index]
                                                                    .transno!,
                                                                datadetail[
                                                                        index]
                                                                    .itemseq
                                                                    .toString(),
                                                                dbname);
                                                            await ClassApi.deactivePosdetail(
                                                                    datadetail[
                                                                            index]
                                                                        .id!
                                                                        .toInt(),
                                                                    dbname)
                                                                .whenComplete(
                                                                    () async {
                                                              setState(() {
                                                                datadetail.remove(
                                                                    datadetail[
                                                                        index]);
                                                              });
                                                              await getSumm();
                                                              widget
                                                                  .updatedata!();
                                                              widget
                                                                  .refreshdata!();
                                                              ClassRetailMainMobile.of(context)!.string = IafjrndtClass(
                                                                  trdt: widget
                                                                      .trnoinfo!
                                                                      .trdt,
                                                                  pscd: widget
                                                                      .trnoinfo!
                                                                      .pscd,
                                                                  description:
                                                                      '',
                                                                  totalaftdisc:
                                                                      0,
                                                                  transno: datadetail
                                                                              .length ==
                                                                          0
                                                                      ? null
                                                                      : widget
                                                                          .trnoinfo!
                                                                          .transno,
                                                                  totalcost: 0,
                                                                  ratecostamt:
                                                                      0);
                                                            });
                                                            await getDetails!
                                                                .then((value) {
                                                              setState(() {});
                                                            });
                                                          } else {
                                                            await ClassApi.deactivePoscondimentByID(
                                                                    datadetail[
                                                                            index]
                                                                        .transno!,
                                                                    datadetail[
                                                                            index]
                                                                        .itemseq
                                                                        .toString(),
                                                                    datadetail[
                                                                            index]
                                                                        .optioncode!,
                                                                    dbname)
                                                                .whenComplete(
                                                                    () {
                                                              datadetail.remove(
                                                                  datadetail[
                                                                      index]);
                                                            });
                                                            widget.refreshdata;
                                                            await getDetailTrnos()
                                                                .then((value) {
                                                              setState(() {});
                                                            });
                                                            await getSumm();
                                                            ClassRetailMainMobile.of(context)!
                                                                    .string =
                                                                IafjrndtClass(
                                                                    trdt: widget
                                                                        .trnoinfo!
                                                                        .trdt,
                                                                    pscd: widget
                                                                        .trnoinfo!
                                                                        .pscd,
                                                                    description:
                                                                        '',
                                                                    totalaftdisc:
                                                                        0,
                                                                    transno: datadetail.length ==
                                                                            0
                                                                        ? null
                                                                        : widget
                                                                            .trnoinfo!
                                                                            .transno,
                                                                    totalcost:
                                                                        0,
                                                                    ratecostamt:
                                                                        0);
                                                          }
                                                        }
                                                      });
                                                    } else {
                                                      // showDialog(
                                                      //   context: context,
                                                      //   builder: (BuildContext
                                                      //       context) {
                                                      //     return DialogDeleteItem(
                                                      //       itemdesc:
                                                      //           datadetail[
                                                      //                   index]
                                                      //               .itemdesc!,
                                                      //       onPasswordEntered:
                                                      //           (String
                                                      //               password) async {
                                                      //         print(
                                                      //             'Entered password: $password');

                                                      //         // Lakukan sesuatu dengan password yang dimasukkan di sini
                                                      //       },
                                                      //     );
                                                      //   },
                                                      // );
                                                      if (datadetail[index]
                                                              .typ !=
                                                          'condiment') {
                                                        await ClassApi
                                                            .deactivePoscondimentByALL(
                                                                datadetail[
                                                                        index]
                                                                    .transno!,
                                                                datadetail[
                                                                        index]
                                                                    .itemseq
                                                                    .toString(),
                                                                dbname);
                                                        await ClassApi
                                                                .deactivePosdetail(
                                                                    datadetail[
                                                                            index]
                                                                        .id!
                                                                        .toInt(),
                                                                    dbname)
                                                            .whenComplete(
                                                                () async {
                                                          setState(() {
                                                            datadetail.remove(
                                                                datadetail[
                                                                    index]);
                                                          });
                                                          await getSumm();
                                                          widget.updatedata!();
                                                          widget.refreshdata;

                                                          ClassRetailMainMobile.of(
                                                                      context)!
                                                                  .string =
                                                              IafjrndtClass(
                                                                  trdt:
                                                                      widget
                                                                          .trnoinfo!
                                                                          .trdt,
                                                                  pscd:
                                                                      widget
                                                                          .trnoinfo!.pscd,
                                                                  description:
                                                                      '',
                                                                  totalaftdisc:
                                                                      0,
                                                                  transno: datadetail
                                                                              .length ==
                                                                          0
                                                                      ? null
                                                                      : widget
                                                                          .trnoinfo!
                                                                          .transno,
                                                                  totalcost: 0,
                                                                  ratecostamt:
                                                                      0);
                                                        });
                                                        await getDetails!
                                                            .then((value) {
                                                          setState(() {});
                                                        });
                                                      } else {
                                                        await ClassApi.deactivePoscondimentByID(
                                                                datadetail[
                                                                        index]
                                                                    .transno!,
                                                                datadetail[
                                                                        index]
                                                                    .itemseq
                                                                    .toString(),
                                                                datadetail[
                                                                        index]
                                                                    .optioncode!,
                                                                dbname)
                                                            .whenComplete(() {
                                                          datadetail.remove(
                                                              datadetail[
                                                                  index]);
                                                        });
                                                        widget.refreshdata;
                                                        await getDetailTrnos()
                                                            .then((value) {
                                                          setState(() {});
                                                        });
                                                        await getSumm();
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
                                                                transno: datadetail
                                                                            .length ==
                                                                        0
                                                                    ? null
                                                                    : widget
                                                                        .trnoinfo!
                                                                        .transno,
                                                                totalcost: 0,
                                                                ratecostamt: 0);
                                                      }
                                                    }
                                                  },
                                                  icon: Icon(
                                                    datadetail[index].typ !=
                                                            'condiment'
                                                        ? Icons.close
                                                        : null,
                                                    color: Colors.red,
                                                    size: 17.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Divider(
                                    height: 2,
                                    indent: 20,
                                    endIndent: 20,
                                  ),

                                  ///////////////////////// SUMMARY ORDER///////////////////////
                                ],
                              );
                            }),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ShimmerLoading(
                        isLoading: true,
                        child: ListView.builder(
                            itemCount: widget.itemlength,
                            itemBuilder: (context, index) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              );
                            }),
                      );
                    }
                    return Container();
                  })),
          widget.qty != 0
              ? Expanded(
                  flex: 1,
                  child: SummaryOrderSlidemobile(
                    guestname: widget.guestname == '' ? '' : widget.guestname,
                    datatransaksi: datadetail,
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
