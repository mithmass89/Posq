// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_generic_function_type_aliases, sized_box_for_whitespace, avoid_print, prefer_typing_uninitialized_variables, must_be_immutable, unused_import

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classdialogvoidtab.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/dialogdeleteitemtab.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/retailmodul/classedititemmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/retailmodultab/classretailedittab.dart';
import 'package:posq/retailmodul/classsumamryorderslidemobile.dart';
import 'package:posq/retailmodul/productclass/classdialogedittab.dart';
import 'package:posq/retailmodul/productclass/classretailcondiment.dart';
import 'package:posq/retailmodul/retailmodultab/summarybilltab.dart';
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
  final note = TextEditingController();
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
  int? length=0;

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
    widget.listdata = await ClassApi.getTrnoDetail(widget.trno, dbname, '');
    if (widget.listdata.first.salestype != 'normal') {
      selectedindex = widget.datatransaksi.indexWhere(
          (element) => element.transdesc == widget.listdata.first.salestype);
      print('ini index : ${widget.listdata.first}');
    }

    setState(() {});
    return widget.listdata;
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

             widget.datatransaksi.isNotEmpty?   Container(
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
                                for (var element in widget.listdata) {
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
                                      id: element.id,
                                      totalcost: element.totalcost,
                                      ratecostamt: element.ratecostamt);

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
                                        transno: widget.listdata.length == 0
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
                ): Container(),
                Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height * 0.12*(length==0?4.1:length!<5?length!:4.0),
                    child: FutureBuilder(
                        future: getDetails,
                        builder: (context,
                            AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                          if (widget.listdata.length != 0) {
                            return ListView.builder(
                                itemCount: widget.listdata.length,
                                itemBuilder: (context, index) {
                                  // widget.listdata = widget.listdata;
                                  length=widget.listdata.length;
                                  print(length);
                                  return Column(
                                    children: [
                                      widget.listdata[index].qty != 0
                                          ? GestureDetector(
                                              onTap: () async {
                                                if (widget.listdata[index]
                                                            .typ !=
                                                        'condiment' &&
                                                    widget.listdata[index]
                                                            .havecond! <=
                                                        0) {
                                                  final result =
                                                      await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return DialogEditTab(
                                                              note: note,
                                                              updatedata: //                       updatedata:
                                                                  widget
                                                                      .updatedata,
                                                              data: widget
                                                                      .listdata[
                                                                  index],
                                                              editamount:
                                                                  editamount,
                                                              editdesc:
                                                                  editdesc,
                                                              editqty: editqty,
                                                            );
                                                          });

                                                  ClassRetailMainMobile.of(context)!
                                                          .string =
                                                      IafjrndtClass(
                                                          trdt: widget.trnoinfo!
                                                              .transno,
                                                          pscd: widget
                                                              .trnoinfo!.pscd,
                                                          description: '',
                                                          totalaftdisc: 0,
                                                          transno: widget
                                                              .trnoinfo!
                                                              .transno,
                                                          totalcost: 0,
                                                          ratecostamt: 0);
                                                  await getDetailTrnos()
                                                      .then((value) {
                                                    setState(() {
                                                      widget.listdata = value;
                                                    });
                                                  });
                                                  if (result == null) {
                                                    ClassRetailMainMobile.of(context)!
                                                            .string =
                                                        IafjrndtClass(
                                                            trdt: widget
                                                                .trnoinfo!
                                                                .transno,
                                                            pscd: widget
                                                                .trnoinfo!.pscd,
                                                            description: '',
                                                            totalaftdisc: 0,
                                                            transno: widget
                                                                .trnoinfo!
                                                                .transno,
                                                            totalcost: 0,
                                                            ratecostamt: 0);
                                                  } else {
                                                    ClassRetailMainMobile.of(
                                                            context)!
                                                        .string = result;
                                                    await getDetailTrnos()
                                                        .then((value) {
                                                      setState(() {
                                                        widget.listdata = value;
                                                      });
                                                    });
                                                  }
                                                } else {
                                                  ///edit condiment mode///
                                                  final result = widget
                                                              .listdata[index]
                                                              .condimenttype ==
                                                          ''
                                                      ? await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ClassInputCondiment(
                                                                    guestname:
                                                                        widget
                                                                            .guestname,
                                                                    datatransaksi:
                                                                        widget.listdata[
                                                                            index],
                                                                    iditem: widget
                                                                        .listdata[
                                                                            index]
                                                                        .id,
                                                                    fromedit:
                                                                        true,
                                                                    dataedit: widget
                                                                        .listdata,
                                                                    data: Item(
                                                                        packageflag:
                                                                            0,
                                                                        multiprice:
                                                                            multiprice,
                                                                        itemcode: widget
                                                                            .listdata[
                                                                                index]
                                                                            .itemcode,
                                                                        itemdesc: widget
                                                                            .listdata[
                                                                                index]
                                                                            .itemdesc,
                                                                        outletcode: widget
                                                                            .listdata[
                                                                                index]
                                                                            .pscd,
                                                                        slsamt: widget.listdata[index].revenueamt! /
                                                                            widget
                                                                                .listdata[
                                                                                    index]
                                                                                .qty!,
                                                                        costamt:
                                                                            0,
                                                                        slsnett: widget
                                                                            .listdata[
                                                                                index]
                                                                            .totalaftdisc,
                                                                        taxpct: widget
                                                                            .listdata[
                                                                                index]
                                                                            .taxpct,
                                                                        svchgpct: widget
                                                                            .listdata[
                                                                                index]
                                                                            .svchgpct,
                                                                        slsfl:
                                                                            1),
                                                                    itemseq: widget
                                                                        .listdata[
                                                                            index]
                                                                        .itemseq!,
                                                                    outletcd: widget
                                                                        .trnoinfo!
                                                                        .pscd!,
                                                                    transno:
                                                                        widget
                                                                            .trno,
                                                                  ))).then(
                                                          (_) async {
                                                          widget.refreshdata;
                                                          widget.updatedata!();
                                                        })
                                                      : null;
                                                  ClassRetailMainMobile.of(context)!
                                                          .string =
                                                      IafjrndtClass(
                                                          trdt: widget.trnoinfo!
                                                              .transno,
                                                          pscd: widget
                                                              .trnoinfo!.pscd,
                                                          description: '',
                                                          totalaftdisc: 0,
                                                          transno: widget
                                                              .trnoinfo!
                                                              .transno,
                                                          totalcost: 0,
                                                          ratecostamt: 0);
                                                  await getDetailTrnos()
                                                      .then((value) {
                                                    setState(() {
                                                      widget.listdata = value;
                                                    });
                                                  });
                                                  if (result == null) {
                                                    ClassRetailMainMobile.of(context)!
                                                            .string =
                                                        IafjrndtClass(
                                                            trdt: widget
                                                                .trnoinfo!
                                                                .transno,
                                                            pscd: widget
                                                                .trnoinfo!.pscd,
                                                            description: '',
                                                            totalaftdisc: 0,
                                                            transno: widget
                                                                .trnoinfo!
                                                                .transno,
                                                            totalcost: 0,
                                                            ratecostamt: 0);
                                                  } else {
                                                    ClassRetailMainMobile.of(
                                                            context)!
                                                        .string = result;
                                                  }
                                                }
                                              },
                                              child: SafeArea(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.18,
                                                            child: Text(
                                                                widget.listdata[index].typ !=
                                                                        'condiment'
                                                                    ? widget
                                                                        .listdata[
                                                                            index]
                                                                        .itemdesc!
                                                                    : ' *** ${widget.listdata[index].itemdesc!} ***',
                                                                style: widget
                                                                            .listdata[
                                                                                index]
                                                                            .typ !=
                                                                        'condiment'
                                                                    ? TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.normal)
                                                                    : TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      )),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.15,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.1,
                                                                  child: Text(
                                                                      '${CurrencyFormat.convertToIdr(widget.listdata[index].revenueamt, 0)}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black54)),
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.02,
                                                                  child: widget
                                                                              .listdata[index]
                                                                              .typ !=
                                                                          'condiment'
                                                                      ? IconButton(
                                                                          iconSize:
                                                                              17,
                                                                          onPressed:
                                                                              () async {
                                                                            if (strictuser ==
                                                                                '1') {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return PasswordDialog(
                                                                                    guestname: widget.guestname,
                                                                                    frompaymentmobile: false,
                                                                                    frompayment: false,
                                                                                    dialogcancel: false,
                                                                                    onPasswordEntered: (String password) async {
                                                                                      print('Entered password: $password');
                                                                                      await ClassApi.getAccessCodevoid(password).then((value) async {
                                                                                        if (value.isEmpty) {
                                                                                          await Fluttertoast.showToast(msg: "Kode yg anda masukan salah", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Color.fromARGB(255, 11, 12, 14), textColor: Colors.white, fontSize: 16.0);
                                                                                        } else {
                                                                                          print(value);
                                                                                          if (widget.listdata[index].typ != 'condiment') {
                                                                                            await ClassApi.deactivePoscondimentByALL(widget.listdata[index].transno!, widget.listdata[index].itemseq.toString(), dbname);
                                                                                            await ClassApi.deactivePosdetail(widget.listdata[index].id!.toInt(), dbname).whenComplete(() async {
                                                                                              setState(() {
                                                                                                widget.listdata.remove(widget.listdata[index]);
                                                                                              });
                                                                                              await getSumm();
                                                                                              widget.updatedata!();
                                                                                              widget.refreshdata;

                                                                                              ClassRetailMainMobile.of(context)!.string = IafjrndtClass(trdt: widget.trnoinfo!.trdt, pscd: widget.trnoinfo!.pscd, description: '', totalaftdisc: 0, transno: snapshot.data!.length == 0 ? null : widget.trnoinfo!.transno, totalcost: 0, ratecostamt: 0);
                                                                                            });
                                                                                            await getDetails!.then((value) {
                                                                                              setState(() {});
                                                                                            });
                                                                                          } else {
                                                                                            await ClassApi.deactivePoscondimentByID(widget.listdata[index].transno!, widget.listdata[index].itemseq.toString(), widget.listdata[index].optioncode!, dbname).whenComplete(() {
                                                                                              widget.listdata.remove(widget.listdata[index]);
                                                                                            });
                                                                                            widget.refreshdata;
                                                                                            await getDetailTrnos().then((value) {
                                                                                              setState(() {});
                                                                                            });
                                                                                            await getSumm();
                                                                                            ClassRetailMainMobile.of(context)!.string = IafjrndtClass(trdt: widget.trnoinfo!.trdt, pscd: widget.trnoinfo!.pscd, description: '', totalaftdisc: 0, transno: widget.listdata.length == 0 ? null : widget.trnoinfo!.transno, totalcost: 0, ratecostamt: 0);
                                                                                          }
                                                                                        }
                                                                                      });
                                                                                      // Lakukan sesuatu dengan password yang dimasukkan di sini
                                                                                    },
                                                                                  );
                                                                                },
                                                                              );
                                                                            } else {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return DialogDeleteItem(
                                                                                    itemdesc: widget.listdata[index].itemdesc!,
                                                                                    onPasswordEntered: (String password) async {
                                                                                      print('Entered password: $password');

                                                                                      if (widget.listdata[index].typ != 'condiment') {
                                                                                        await ClassApi.deactivePoscondimentByALL(widget.listdata[index].transno!, widget.listdata[index].itemseq.toString(), dbname);
                                                                                        await ClassApi.deactivePosdetail(widget.listdata[index].id!.toInt(), dbname).whenComplete(() async {
                                                                                          setState(() {
                                                                                            widget.listdata.remove(widget.listdata[index]);
                                                                                          });
                                                                                          await getSumm();
                                                                                          widget.updatedata!();
                                                                                          widget.refreshdata;

                                                                                          ClassRetailMainMobile.of(context)!.string = IafjrndtClass(trdt: widget.trnoinfo!.trdt, pscd: widget.trnoinfo!.pscd, description: '', totalaftdisc: 0, transno: snapshot.data!.length == 0 ? null : widget.trnoinfo!.transno, totalcost: 0, ratecostamt: 0);
                                                                                        });
                                                                                        await getDetails!.then((value) {
                                                                                          setState(() {});
                                                                                        });
                                                                                      } else {
                                                                                        await ClassApi.deactivePoscondimentByID(widget.listdata[index].transno!, widget.listdata[index].itemseq.toString(), widget.listdata[index].optioncode!, dbname).whenComplete(() {
                                                                                          widget.listdata.remove(widget.listdata[index]);
                                                                                        });
                                                                                        widget.refreshdata;
                                                                                        await getDetailTrnos().then((value) {
                                                                                          setState(() {});
                                                                                        });
                                                                                        await getSumm();
                                                                                        ClassRetailMainMobile.of(context)!.string = IafjrndtClass(trdt: widget.trnoinfo!.trdt, pscd: widget.trnoinfo!.pscd, description: '', totalaftdisc: 0, transno: widget.listdata.length == 0 ? null : widget.trnoinfo!.transno, totalcost: 0, ratecostamt: 0);
                                                                                      }

                                                                                      // Lakukan sesuatu dengan password yang dimasukkan di sini
                                                                                    },
                                                                                  );
                                                                                },
                                                                              );
                                                                            }
                                                                          },
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              168,
                                                                              173),
                                                                          icon:
                                                                              Icon(
                                                                            Icons.close,
                                                                          ),
                                                                        )
                                                                      : null,
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
                                                            '${CurrencyFormat.convertToIdr(widget.listdata[index].rateamtitem, 0)},',
                                                            style: TextStyle(
                                                                fontSize: 10)),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                        ),
                                                        Text('x',
                                                            style: TextStyle(
                                                                fontSize: 10)),
                                                        Text(
                                                            '${widget.listdata[index].qty}',
                                                            style: TextStyle(
                                                                fontSize: 10)),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.13,
                                                        ),
                                                        widget.listdata[index]
                                                                    .discamt !=
                                                                0
                                                            ? Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.11,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                        'Discount',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.red)),
                                                                    Text(
                                                                        '-${CurrencyFormat.convertToIdr(widget.listdata[index].discamt, 0)}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.red)),
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
                                      Divider(),
                                    ],
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

                widget.listdata.isNotEmpty
                    ? Builder(builder: (context) {
                        return Expanded(
                          flex: 1,
                          child: SummaryOrderSlideTabs(
                            guestname: widget.guestname,
                            listdata: widget.listdata,
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
                        );
                      })
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
                                    'Subtotal',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
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
                                  Spacer(),
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
                                  Spacer(),
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
                                      onPressed: accesslistuser
                                                  .contains('settingprinter') ==
                                              true
                                          ? () async {
                                              await getSumm();
                                              if (connected == true) {
                                                await printing.prints(
                                                    widget.listdata,
                                                    summary,
                                                    widget
                                                        .outletinfo.outletname!,
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
                                                  msg:
                                                      "Tidak Punya Akses Printer",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 11, 12, 14),
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            },
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
