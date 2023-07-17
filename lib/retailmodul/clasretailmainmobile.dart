// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, avoid_print, unused_field, must_be_immutable
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classdialogvoidtab.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/draweretailmobile.dart';
import 'package:posq/classui/payment/paymentmainmobilev2.dart';
import 'package:posq/classui/registerproductmobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/payment/paymentmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/retailmodul/retailmodultab/classdrawermaintabs.dart';
import 'package:posq/retailmodul/classretailmanualtab.dart';
import 'package:posq/retailmodul/retailmodultab/classretailproducttabs.dart';
import 'package:posq/retailmodul/retailmodultab/detailtranstab.dart';
import 'package:posq/retailmodul/savedtransaction/classlisttransactionmobile.dart';
import 'package:posq/retailmodul/productclass/classretailproductmobile.dart';
import 'package:posq/retailmodul/savedtransaction/classsavedtransactionmobile.dart';
import 'package:posq/retailmodul/classslideuppanel.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/collapsepanel.dart';
import 'package:posq/retailmodul/savedtransaction/classtablet/classsavedtransactiontab.dart';
import 'package:posq/userinfo.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/retailmodul/classretailmanualmobil.dart';
import 'package:posq/classui/searchwidget.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class ClassRetailMainMobile extends StatefulWidget {
  final String pscd;
  final Outlet outletinfo;
  final int qty;
  late String? trno;
  final bool? fromsaved;

  ClassRetailMainMobile(
      {Key? key,
      required this.pscd,
      required this.outletinfo,
      required this.qty,
      this.trno,
      required this.fromsaved})
      : super(key: key);

  @override
  State<ClassRetailMainMobile> createState() => _ClassRetailMainMobileState();
  static _ClassRetailMainMobileState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ClassRetailMainMobileState>();
}

class _ClassRetailMainMobileState extends State<ClassRetailMainMobile>
    with SingleTickerProviderStateMixin {
  final PanelController _pc = PanelController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final search = TextEditingController();
  TabController? controller;
  IafjrndtClass? iafjrndt;
  List<IafjrndtClass>? listdata = [];
  late DatabaseHandler handler;
  int? item = 0;
  num? summaryamount = 0;
  late num sum = 0;
  String? query = '';
  String? trno = '';
  bool _scrollisanimated = false;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  String? selectedcostumer;
  int? trnolanjut;
  int? pending;
  String _scanBarcode = 'Unknown';
  String? guestname = '';
  String? email = '';
  String? telp = '';
  num discount = 0;
  int itemseq = 0;
  int itemlength = 0;
  Random random = new Random();
  int randomNumber = 0;
  int tabindex = 0;

  set discounts(num value) {
    setState(() {
      discount = value;
    });
  }

  List<TransactionTipe> data = [];

  set string(IafjrndtClass value) {
    print(' ini value settring $value');
    setState(() {
      trno = value.transno ?? widget.trno;
      if (value.transno == null) {
        setState(() {
          item = 0;
          itemlength = 0;
          sum = 0;
        });
      } else {
        itemseq++;
        getDetailData();
        getDataSlide();
      }
      setState(() {});
      print('oke dari item class');
      iafjrndt = IafjrndtClass(
          trdt: value.trdt,
          pscd: value.pscd,
          transno: value.transno,
          split: value.split,
          transno1: value.transno1,
          itemcode: value.itemcode,
          trno1: value.trno1,
          itemseq: value.itemseq,
          cono: value.cono,
          waitercd: value.waitercd,
          discpct: value.discpct,
          discamt: value.discamt,
          qty: value.qty,
          ratecurcd: value.ratecurcd,
          ratebs1: value.ratebs1,
          ratebs2: value.ratebs2,
          rateamtcost: value.rateamtcost,
          rateamtitem: value.rateamtitem,
          rateamtservice: value.rateamtservice,
          rateamttax: value.rateamttax,
          rateamttotal: value.rateamttotal,
          revenueamt: value.revenueamt,
          taxamt: value.taxamt,
          serviceamt: value.serviceamt,
          totalaftdisc: value.totalaftdisc,
          rebateamt: value.rebateamt,
          rvncoa: value.rvncoa,
          taxcoa: value.taxcoa,
          servicecoa: value.servicecoa,
          costcoa: value.costcoa,
          active: value.active,
          usercrt: value.usercrt,
          userupd: value.userupd,
          userdel: value.userdel,
          prnkitchen: value.prnkitchen,
          prnkitchentm: value.trno1,
          confirmed: value.confirmed,
          description: value.description,
          taxpct: value.taxpct,
          svchgpct: value.svchgpct);
    });
    print('tersampaikan');
  }

  getTransaksiTipe() async {
    var datas = await ClassApi.getTransactionTipe(pscd, dbname, '');
    data = datas;
    setState(() {});
    print(data);
  }

//terakir sampai sini / pengen refresh
  getDataSlide() async {
    await ClassApi.getTrnoDetail(widget.trno!, dbname, query!).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          listdata = value;
        });
      } else {
        setState(() {
          listdata = [];
        });
      }
    });
  }

  checkTrno() async {
    var transno = await ClassApi.checkTrno();
    trno =
        widget.outletinfo.outletcd + '-' + transno[0]['transnonext'].toString();
  }

  updateTrno() async {
    await ClassApi.updateTrno(dbname);
    await checkTrno();
  }

  getDetailData() async {
    print('sampe getdata');
    await ClassApi.getTrnoDetail(widget.trno!, dbname, query!).then((isi) {
      if (isi.isNotEmpty) {
        print(isi);
        num totalSlsNett = isi.fold(
            0, (previousValue, isi) => previousValue + isi.totalaftdisc!);

        setState(() {
          item = isi.length;
          itemlength = isi
              .where((element) => element.condimenttype == '')
              .toList()
              .length;
          sum = totalSlsNett + discount;
        });
        print('ini length item${itemlength}');
      } else {
        setState(() {
          item = 0;
          itemlength = 0;
          sum = 0;
        });
      }
    });
  }

  checkSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String guestPref = prefs.getString('savecostmrs') ?? "";
    if (guestPref.isNotEmpty) {
      Map<String, dynamic> userMap =
          jsonDecode(guestPref) as Map<String, dynamic>;
      setState(() {
        guestname = userMap['guestname'];
        email = userMap['email'];
        telp = userMap['telp'];
      });
    }
  }

  checkPending() {
    ClassApi.getOutstandingBill(query!, dbname, '').then((value) {
      setState(() {
        pending = value.length;
      });
    });
  }

  @override
  void initState() {
    randomNumber = random.nextInt(100);
    controller = TabController(vsync: this, length: 2);
    //tambahkan SingleTickerProviderStateMikin pada class _HomeState
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _scrollisanimated = false;
    ToastContext().init(context);
    print('print ini trno : ${widget.trno}');
    formattedDate = formatter.format(now);
    checkPending();
    checkTrno();
    _pc.isAttached;
    controller!.animateTo(1);
    tabindex = 1;
    getTransaksiTipe();
    iafjrndt = IafjrndtClass(
      trdt: '',
      pscd: '',
      transno: trno,
      split: 1,
      transno1: '',
      itemcode: '',
      trno1: '',
      itemseq: 1,
      cono: '',
      waitercd: '',
      discpct: 0,
      discamt: 0,
      qty: 0,
      ratecurcd: '',
      ratebs1: 0,
      ratebs2: 0,
      rateamtcost: 0,
      rateamtitem: 0,
      rateamtservice: 0,
      rateamttax: 0,
      rateamttotal: 0,
      revenueamt: 0,
      taxamt: 0,
      serviceamt: 0,
      totalaftdisc: 0,
      rebateamt: 0,
      rvncoa: '',
      taxcoa: '',
      servicecoa: '',
      costcoa: '',
      active: 0,
      usercrt: '',
      userupd: '',
      userdel: '',
      prnkitchen: 0,
      prnkitchentm: '',
      confirmed: '',
      description: '',
    );
    if (widget.trno != null) {
      getDetailData();
      getDataSlide();
    }
  }

  getSavedCustomers() async {
    final savecostmrs = await SharedPreferences.getInstance();
    await savecostmrs.setString('savecostmrs', selectedcostumer.toString());
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print('result scaning $barcodeScanRes');
// barcodeScanRes='8998009010231';
      await ClassApi.getItemByBarCode(pscd, dbname, barcodeScanRes, '')
          .then((value) async {
        print(value);
        if (value == [] || value == '') {
          Toast.show("Produk tidak Terdaftar",
              duration: Toast.lengthLong, gravity: Toast.center);
        } else {
          await ClassApi.getItemByCode(pscd, dbname, value.first.itemcode!, '')
              .then((value) async {
            Toast.show("Produk Terdaftar ${value.first.itemdesc}",
                duration: Toast.lengthLong, gravity: Toast.center);

            await insertIafjrndt(value.first);
            await getDetailData();
            await getDataSlide();
          });
        }
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  insertIafjrndt(Item items) async {
    await ClassApi.insertPosDetail(
        IafjrndtClass(
            trdt: formattedDate,
            pscd: pscd,
            transno: widget.trno,
            split: 1,
            transno1: widget.trno,
            itemcode: items.itemcode,
            itemdesc: items.itemdesc,
            trno1: widget.trno,
            itemseq: 1,
            cono: 'cono',
            waitercd: 'waitercd',
            discpct: 0,
            discamt: 0,
            qty: 1,
            ratecurcd: 'Rupiah',
            ratebs1: 1,
            ratebs2: 1,
            rateamtcost: items.costamt,
            rateamtitem: items.slsamt,
            rateamtservice: 0,
            rateamttax: 0,
            rateamttotal: items.slsnett,
            revenueamt: 1 * items.slsamt!.toDouble(),
            taxamt: 0,
            serviceamt: 0,
            totalaftdisc: 1 * items.slsnett!.toDouble(),
            rebateamt: 0,
            rvncoa: 'REVENUE',
            taxcoa: 'TAX',
            servicecoa: 'SERVICE',
            costcoa: 'COST',
            active: 1,
            usercrt: usercd,
            userupd: usercd,
            userdel: usercd,
            prnkitchen: 0,
            prnkitchentm: '10:10',
            confirmed: '1',
            description: items.itemdesc,
            taxpct: items.taxpct,
            svchgpct: items.svchgpct,
            guestname: guestname != '' ? 'No Guest' : guestname,
            createdt: now.toString()),
        pscd);
  }

  @override
  void dispose() {
    controller!.dispose();
    // _pc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 480) {
        return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            drawer: DrawerRetailMain(
              fromsaved: widget.fromsaved!,
              outletinfo: widget.outletinfo,
              outletname: widget.outletinfo.outletname,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height * 1,
              color: Colors.white,
              child: WillPopScope(
                onWillPop: () async {
                  return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogClassWillPop(
                          outletinfo: widget.outletinfo,
                          trno: trno.toString(),
                        );
                      });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SlidingUpPanel(
                        onPanelSlide: (value) {
                          if (value == 0.0) {
                            setState(() {
                              _scrollisanimated = false;
                            });
                            // print(_scrollisanimated);
                          } else if (value < 0.5) {
                            setState(() {
                              _scrollisanimated = true;
                            });
                          }
                        },
                        controller: _pc,
                        // header :Center(child: Text('ini header')),

                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        minHeight: MediaQuery.of(context).size.height * 0.20,
                        maxHeight: MediaQuery.of(context).size.height * 0.96,
                        body: Column(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                              width: MediaQuery.of(context).size.width * 1,
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.orange),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                    ),
                                    iconSize: 30,
                                    color: Colors.white,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      _scaffoldKey.currentState!.openDrawer();
                                    },
                                  ),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.62,
                                      child: TextFieldMobile2(
                                        hint: 'Searching',
                                        controller: search,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        typekeyboard: TextInputType.text,
                                      )),
                                  IconButton(
                                    icon: Image.asset(
                                      'assets/icons8-barcode-100.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    iconSize: 30,
                                    color: Colors.white,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      scanBarcodeNormal();
                                    },
                                  ),
                                  Stack(
                                    children: [
                                      IconButton(
                                        icon: Image.asset(
                                            'assets/icons8-checklist-100.png',
                                            height: 20,
                                            width: 20),
                                        iconSize: 30,
                                        color: Colors.white,
                                        splashColor: Colors.transparent,
                                        onPressed: () async {
                                          await checkSF();
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClassSavedTransactionMobile(
                                                        trno: widget.trno,
                                                        pscd: widget
                                                            .outletinfo.alamat,
                                                        outletinfo:
                                                            widget.outletinfo,
                                                      )));
                                        },
                                      ),
                                      pending != 0
                                          ? Positioned(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.009,
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: Colors.red),
                                                child: Text(
                                                  pending.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ))
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(color: Colors.grey[200]),
                              child: TabBar(
                                controller: controller,
                                tabs: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: Text(
                                      'Manual',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: Text(
                                      'Produk',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.007,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width * 1,
                              child: TabBarView(
                                controller: controller,
                                children: [
                                  ClassRetailManualMobile(
                                      guestname: guestname == ''
                                          ? randomNumber.toString()
                                          : guestname!,
                                      refreshdata: getDataSlide,
                                      trno: widget.trno == null
                                          ? trno
                                          : widget.trno,
                                      itemlenght: item,
                                      outletinfo: widget.outletinfo),
                                  ClassRetailProductMobile(
                                    guestname: guestname == ''
                                        ? randomNumber.toString()
                                        : guestname!,
                                    itemseq: itemseq,
                                    controller: search,
                                    trno: widget.trno.toString(),
                                    pscd: widget.outletinfo.outletcd,
                                  )
                                  // Center(child: Text('Product')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        panelBuilder: (_pc) {
                          switch (_scrollisanimated) {
                            case true:
                              return SlideUpPanel(
                                guestname: guestname!.isEmpty
                                    ? randomNumber.toString()
                                    : guestname!,
                                datatransaksi: data,
                                fromsaved: widget.fromsaved,
                                sum: refundmode == false ? sum : -sum,
                                animated: _scrollisanimated,
                                outletinfo: Outlet(
                                  alamat: widget.outletinfo.alamat,
                                  kodepos: widget.outletinfo.kodepos,
                                  outletcd: widget.outletinfo.outletcd,
                                  outletname: widget.outletinfo.outletname,
                                  telp: widget.outletinfo.telp,
                                  trnonext: widget.outletinfo.trnonext,
                                  trnopynext: widget.outletinfo.trnopynext,
                                ),
                                updatedata: getDataSlide,
                                listdata: listdata!,
                                qty: item,
                                amount: sum,
                                trno: widget.trno.toString(),
                                trnoinfo: iafjrndt,
                                controllers: _pc,
                                callback: (IafjrndtClass val) {
                                  getDataSlide();
                                },
                                refreshdata: () {
                                  getDataSlide();
                                },
                                itemlength: itemlength,
                              );
                            case false:
                              return Container(
                                child: Column(
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                'BARANG : ${itemlength}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.money_off,
                                                ),
                                                iconSize: 25,
                                                color: refundmode == false
                                                    ? Colors.grey
                                                    : Colors.red,
                                                splashColor: Colors.purple,
                                                onPressed: () async {
                                                  refundmode = !refundmode;
                                                  // showDialog(
                                                  //   context: context,
                                                  //   builder:
                                                  //       (BuildContext context) {
                                                  //     return DialogClassRefundorder(
                                                  //       fromsaved:
                                                  //           widget.fromsaved,
                                                  //       outletcd: pscd,
                                                  //       outletinfo:
                                                  //           widget.outletinfo,
                                                  //       trno: widget.trno!,
                                                  //     );
                                                  //   },
                                                  // );
                                                },
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.people,
                                                ),
                                                iconSize: 25,
                                                color: Colors.blueGrey,
                                                splashColor: Colors.purple,
                                                onPressed: () async {
                                                  guestname = await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return DialogCustomerList();
                                                      });
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                          }
                          return Container();
                        }),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.025,
                      child: ButtonNoIconAnimated(
                          curve: Curves.linear,
                          duration: 300,
                          textcolor: _scrollisanimated == true
                              ? Colors.orange
                              : Colors.white,
                          color: _scrollisanimated == true
                              ? Colors.white
                              : Colors.orange,
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: _scrollisanimated == false
                              ? MediaQuery.of(context).size.width * 0.95
                              : MediaQuery.of(context).size.width * 0.40,
                          onpressed: () async {
                            _pc.open();
                            if (_scrollisanimated == true) {
                              await getDataSlide();
                              return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogClassSimpan(
                                      datatrans: listdata!.first,
                                      fromsaved: false,
                                      outletinfo: widget.outletinfo,
                                      pscd: widget.outletinfo.outletcd,
                                      trno: trno == ''
                                          ? widget.trno!
                                          : trno.toString(),
                                    );
                                  });
                            }
                          },
                          name: _scrollisanimated == false
                              ? 'Tagih ${CurrencyFormat.convertToIdr(sum, 0)} '
                              : 'Simpan'),
                    ),
                    AnimatedPositioned(
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 400),
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      left: _scrollisanimated == false
                          ? MediaQuery.of(context).size.width * 0.9
                          : MediaQuery.of(context).size.width * 0.45,
                      child: ButtonNoIconAnimated(
                          curve: Curves.linear,
                          duration: 400,
                          textcolor: Colors.white,
                          color: Colors.orange,
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: _scrollisanimated == false
                              ? MediaQuery.of(context).size.width * 0.0
                              : MediaQuery.of(context).size.width * 0.53,
                          onpressed: () async {
                            // await ClassApi.checkPointCustomer(
                            //         guestname!, dbname)
                            //     .then((value) async {
                            //   if (value[0]['points'] != 0) {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentV2MobileClass(
                                        guestname: guestname == ''
                                            ? randomNumber.toString()
                                            : guestname!,
                                        fromsplit: false,
                                        fromsaved: widget.fromsaved!,
                                        datatrans: listdata!,
                                        outletinfo: widget.outletinfo,
                                        balance: sum.toInt(),
                                        pscd: widget.outletinfo.outletcd,
                                        trdt: formattedDate,
                                        trno: widget.trno.toString(),
                                        outletname:
                                            widget.outletinfo.outletname,
                                      )),
                            );
                            ClassRetailMainMobile.of(context)!.string = result!;
                            //   } else {
                            //     final result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               PaymentV2MobileClass(
                            //                 guestname: guestname == ''
                            //                     ? randomNumber.toString()
                            //                     : guestname!,
                            //                 fromsplit: false,
                            //                 fromsaved: widget.fromsaved!,
                            //                 datatrans: listdata!,
                            //                 outletinfo: widget.outletinfo,
                            //                 balance: sum.toInt(),
                            //                 pscd: widget.outletinfo.outletcd,
                            //                 trdt: formattedDate,
                            //                 trno: widget.trno.toString(),
                            //                 outletname:
                            //                     widget.outletinfo.outletname,
                            //               )),
                            //     );

                            //     ClassRetailMainMobile.of(context)!.string =
                            //         result!;
                            //   }
                            // });
                          },
                          name: 'Bayar'),
                    ),
                  ],
                ),
              ),
            ));
      } else if (constraints.maxWidth >= 820) {
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(35.0), // here the desired height
              child: SafeArea(
                child: AppBar(
                  // leading: IconButton(
                  //     icon: Icon(
                  //       Icons.list,
                  //       color: Colors.white,
                  //       size: 30,
                  //     ),
                  //     onPressed: () {
                  //       Scaffold.of(context).openDrawer();
                  //     }),

                  backgroundColor: Colors.orange,
                  title: Text(
                    'Transaksi',
                    style: TextStyle(color: Colors.white),
                  ),
                  // actions: [

                  //   // SizedBox(
                  //   //   width: MediaQuery.of(context).size.width * 0.16,
                  //   // ),
                  //   // IconButton(
                  //   //   icon: Image.asset(
                  //   //     'icons8-barcode-100.png',
                  //   //     height: 40,
                  //   //     width: 40,
                  //   //   ),
                  //   //   iconSize: 40,
                  //   //   color: Colors.white,
                  //   //   splashColor: Colors.transparent,
                  //   //   onPressed: () {
                  //   //     scanBarcodeNormal();
                  //   //   },
                  //   // ),

                  //   // Container(
                  //   //     height: MediaQuery.of(context).size.height * 0.1,
                  //   //     width: MediaQuery.of(context).size.width * 0.06,
                  //   //     child: IconButton(
                  //   //         onPressed: () {},
                  //   //         icon: Icon(
                  //   //           Icons.print,
                  //   //           color: Colors.white,
                  //   //         ))),
                  // ],
                ),
              ),
            ),
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            drawer: DrawerRetailMainTabs(
              fromsaved: widget.fromsaved!,
              outletinfo: widget.outletinfo,
              outletname: widget.outletinfo.outletname,
            ),
            body: SafeArea(
              child: WillPopScope(
                onWillPop: () async {
                  return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogClassWillPop(
                          outletinfo: widget.outletinfo,
                          trno: trno.toString(),
                        );
                      });
                },
                child: Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width * 0.65,
                              // decoration: BoxDecoration(color: Colors.grey[200]),
                              child: Column(
                                children: [
                                  TabBar(
                                    indicatorColor: Colors.white,
                                    onTap: (int i) {
                                      print(i);
                                      tabindex = i;
                                      setState(() {});
                                    },
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.black,
                                    indicator: BoxDecoration(
                                      color: Color.fromARGB(255, 0, 160, 147),
                                    ),
                                    controller: controller,
                                    tabs: [
                                      Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          'Manual',
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Text(
                                          'Produk',
                                        ),
                                      ),
                                    ],
                                  ),
                                  tabindex != 0
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.095,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: TextFieldTab1(
                                            suffixIcon: Icon(Icons.search),
                                            hint: 'Cari barang',
                                            controller: search,
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            typekeyboard: TextInputType.text,
                                          ))
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TabBarView(
                            controller: controller,
                            children: [
                              ClassRetailManualTabs(
                                  guestname: guestname == ''
                                      ? randomNumber.toString()
                                      : guestname!,
                                  refreshdata: getDataSlide,
                                  trno:
                                      widget.trno == null ? trno : widget.trno,
                                  itemlenght: item,
                                  outletinfo: widget.outletinfo),
                              ClassRetailProductTabs(
                                refreshdata: () async {
                                  await getDataSlide();
                                },
                                updatedata: () {
                                  getDataSlide();
                                },
                                guestname: guestname == ''
                                    ? randomNumber.toString()
                                    : guestname!,
                                itemseq: itemseq,
                                controller: search,
                                trno: widget.trno.toString(),
                                pscd: widget.outletinfo.outletcd,
                              )
                              // Center(child: Text('Product')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  color: Color.fromARGB(255, 0, 129, 119),
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  height: MediaQuery.of(context).size.height *
                                      0.056,
                                  child: PopupMenuButton<int>(
                                    color: Colors.white,
                                    itemBuilder: (context) => [
                                      // popupmenu item 1
                                      PopupMenuItem(
                                        value: 1,
                                        // row has two child icon and text.
                                        child: Row(
                                          children: [
                                            Icon(Icons.list),
                                            SizedBox(
                                              // sized box with width 10
                                              width: 10,
                                            ),
                                            Text("Order management")
                                          ],
                                        ),
                                      ),
                                      // popupmenu item 2
                                      PopupMenuItem(
                                        value: 2,
                                        // row has two child icon and text
                                        child: Row(
                                          children: [
                                            Icon(Icons.money_off),
                                            SizedBox(
                                              // sized box with width 10
                                              width: 10,
                                            ),
                                            Text("Refund")
                                          ],
                                        ),
                                      ),
                                    ],
                                    offset: Offset(
                                        MediaQuery.of(context).size.height *
                                            0.25,
                                        MediaQuery.of(context).size.height *
                                            0.06), //(left,bottom)

                                    elevation: 2,
                                    onSelected: (value) async {
                                      if (value == 1) {
                                        await checkSF();
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassSavedTransactionTab(
                                                      trno: widget.trno!,
                                                      pscd: widget
                                                          .outletinfo.alamat,
                                                      outletinfo:
                                                          widget.outletinfo,
                                                    )));
                                      } else if (value == 2) {
                                        refundmode = !refundmode;
                                        setState(() {});
                                        // accesslistuser
                                        //             .contains('canceltrans') ==
                                        //         true
                                        //     ? showDialog(
                                        //         context: context,
                                        //         builder:
                                        //             (BuildContext context) {
                                        //           return DialogClassRefundorder(
                                        //             fromsaved: widget.fromsaved,
                                        //             outletcd: pscd,
                                        //             outletinfo:
                                        //                 widget.outletinfo,
                                        //             trno: widget.trno!,
                                        //           );
                                        //         },
                                        //       )
                                        //     : Toast.show(
                                        //         "Tidak punya akses refund",
                                        //         duration: Toast.lengthLong,
                                        //         gravity: Toast.center);
                                      }
                                    },
                                  ),
                                ),
                                // Container(
                                //   color: Color.fromARGB(255, 0, 129, 119),
                                //   alignment: Alignment.center,
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.05,
                                //   height: MediaQuery.of(context).size.height *
                                //       0.056,
                                //   child: GestureDetector(
                                //     child: Icon(
                                //       Icons.list,
                                //       size: 22,
                                //       color: Colors.white,
                                //     ),
                                //     onTap: () async {
                                //       await checkSF();
                                //       await Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   ClassSavedTransactionTab(
                                //                     trno: widget.trno!,
                                //                     pscd: widget
                                //                         .outletinfo.alamat,
                                //                     outletinfo:
                                //                         widget.outletinfo,
                                //                   )));
                                //     },
                                //   ),
                                // ),

                                Container(
                                    color: Color.fromARGB(255, 0, 160, 147),
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.height *
                                        0.057,
                                    child: Text(
                                      'Detail',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )),
                                Container(
                                  color: Color.fromARGB(255, 0, 129, 119),
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  height: MediaQuery.of(context).size.height *
                                      0.056,
                                  child: GestureDetector(
                                    child: Icon(
                                      Icons.close,
                                      size: 22,
                                      color: Colors.orange,
                                    ),
                                    onTap: accesslistuser
                                                .contains('canceltrans') ==
                                            true
                                        ? () async {
                                            print(strictuser);
                                            if (strictuser == '1') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return PasswordDialog(
                                                      guestname:
                                                          guestname!.isEmpty
                                                              ? randomNumber
                                                                  .toString()
                                                              : guestname!,
                                                      frompaymentmobile: false,
                                                      frompayment: false,
                                                      trno: widget.trno,
                                                      outletcd: pscd,
                                                      outletinfo:
                                                          widget.outletinfo,
                                                      fromsaved:
                                                          widget.fromsaved,
                                                      dialogcancel: true,
                                                      onPasswordEntered: (String
                                                          password) async {
                                                        print(
                                                            'Entered password: $password');

                                                        // Lakukan sesuatu dengan password yang dimasukkan di sini
                                                      });
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogClassCancelorder(
                                                    fromsaved: widget.fromsaved,
                                                    outletcd: pscd,
                                                    outletinfo:
                                                        widget.outletinfo,
                                                    trno: widget.trno!,
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        : () {
                                            Toast.show(
                                                "Tidak punya akses cancel",
                                                duration: Toast.lengthLong,
                                                gravity: Toast.center);
                                          },
                                  ),
                                ),
                              ],
                            ),
                            DetailTransTabs(
                              guestname: guestname!.isEmpty
                                  ? randomNumber.toString()
                                  : guestname!,
                              datatransaksi: data,
                              fromsaved: widget.fromsaved,
                              sum: sum,
                              animated: _scrollisanimated,
                              outletinfo: Outlet(
                                alamat: widget.outletinfo.alamat,
                                kodepos: widget.outletinfo.kodepos,
                                outletcd: widget.outletinfo.outletcd,
                                outletname: widget.outletinfo.outletname,
                                telp: widget.outletinfo.telp,
                                trnonext: widget.outletinfo.trnonext,
                                trnopynext: widget.outletinfo.trnopynext,
                              ),
                              updatedata: () {
                                getDataSlide();
                              },
                              listdata: listdata!,
                              qty: item,
                              amount: sum,
                              trno: widget.trno.toString(),
                              trnoinfo: iafjrndt,
                              callback: (IafjrndtClass val) {
                                getDataSlide();
                              },
                              refreshdata: () {
                                getDataSlide();
                              },
                              itemlength: itemlength,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ));
      }
      return Text('Device Not Supported Yet');
    });
  }
}
