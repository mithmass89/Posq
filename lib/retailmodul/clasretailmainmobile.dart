// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, avoid_print, unused_field, must_be_immutable
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/draweretailmobile.dart';
import 'package:posq/classui/paymentmainmobilev2.dart';
import 'package:posq/classui/registerproductmobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/classui/paymentmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/retailmodul/classlisttransactionmobile.dart';
import 'package:posq/retailmodul/classretailproductmobile.dart';
import 'package:posq/retailmodul/classslideuppanel.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/collapsepanel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/retailmodul/classretailmanualmobil.dart';
import 'package:posq/classui/searchwidget.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

Future<void> main() async {
  runApp(ClassRetailMainMobile(
    outletinfo: Outlet(
      outletcd: 'Mitrt1',
      outletname: 'Mitro tech',
    ),
    pscd: 'Mitrt1',
    qty: 0,
  ));
}

class ClassRetailMainMobile extends StatefulWidget {
  final String pscd;
  final Outlet outletinfo;
  final int qty;
  late String? trno;

  ClassRetailMainMobile(
      {Key? key,
      required this.pscd,
      required this.outletinfo,
      required this.qty,
      this.trno})
      : super(key: key);

  @override
  State<ClassRetailMainMobile> createState() => _ClassRetailMainMobileState();
  static _ClassRetailMainMobileState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ClassRetailMainMobileState>();
}

class _ClassRetailMainMobileState extends State<ClassRetailMainMobile>
    with SingleTickerProviderStateMixin {
  final PanelController _pc = PanelController();

  final search = TextEditingController();
  TabController? controller;
  IafjrndtClass? iafjrndt;
  List<IafjrndtClass>? listdata = [];
  late DatabaseHandler handler;
  int? item = 0;
  num? summaryamount = 0;
  num sum = 0;
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

  set string(IafjrndtClass value) {
    setState(() {
      trno = value.trno;
      if (value.trno == null) {
        item = 0;
        sum = 0;
      } else {
        ///checkitem
        handler = DatabaseHandler();
        handler.initializeDB();
        handler.checktotalItem(value.trno.toString()).then((value) {
          setState(() {
            item = value.first.qty;
          });
        });

        // item.add(value.itemcd);

        handler.checktotalAmountNett(value.trno.toString()).then((value) {
          setState(() {
            sum = value.first.nettamt != null
                ? num.parse(value.first.nettamt.toString())
                : 0;
          });
        });
      }

      getDataSlide();
      getDetailData();
      iafjrndt = IafjrndtClass(
          trdt: value.trdt,
          pscd: value.pscd,
          trno: value.trno,
          split: value.split,
          trnobill: value.trnobill,
          itemcd: value.itemcd,
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
          rateamt: value.rateamt,
          rateamtservice: value.rateamtservice,
          rateamttax: value.rateamttax,
          rateamttotal: value.rateamttotal,
          rvnamt: value.rvnamt,
          taxamt: value.taxamt,
          serviceamt: value.serviceamt,
          nettamt: value.nettamt,
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
          trdesc: value.trdesc,
          taxpct: value.taxpct,
          servicepct: value.servicepct);
    });
  }

//terakir sampai sini / pengen refresh
  getDataSlide() async {
    handler = DatabaseHandler();
    await handler.initializeDB();
    handler.retrieveDetailIafjrndt(trno.toString()).then((isi) {
      if (isi.isNotEmpty) {
        setState(() {
          listdata = isi;
        });
      } else {
        setState(() {
          listdata = [];
        });
      }
    });
  }

  getDetailData() async {
    handler.retrieveDetailIafjrndt(widget.trno.toString()).then((isi) {
      if (isi.isNotEmpty) {
        setState(() {
          item = isi.length;
          print('total barang retailmain $item');
        });
      } else {
        setState(() {
          item = 0;
        });
      }

      print('terpanggil');
    });

    await handler.checktotalAmountNett(widget.trno.toString()).then((value) {
      setState(() {
        sum = value.first.nettamt!;
      });
      ClassRetailMainMobile.of(context)!.string = value.first;
    });
  }

  checkPending() {
    handler.checkPendingTransaction().then((value) {
      setState(() {
        pending = value;
      });
    });
  }

  @override
  void initState() {
    controller = TabController(vsync: this, length: 2);
    //tambahkan SingleTickerProviderStateMikin pada class _HomeState
    super.initState();
    ToastContext().init(context);
    handler = DatabaseHandler();
    handler.initializeDB();
    checkPending();
    formattedDate = formatter.format(now);
    _pc.isAttached;
    getTrno();
    iafjrndt = IafjrndtClass(
      trdt: '',
      pscd: '',
      trno: trno,
      split: '',
      trnobill: '',
      itemcd: '',
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
      rateamt: 0,
      rateamtservice: 0,
      rateamttax: 0,
      rateamttotal: 0,
      rvnamt: 0,
      taxamt: 0,
      serviceamt: 0,
      nettamt: 0,
      rebateamt: 0,
      rvncoa: '',
      taxcoa: '',
      servicecoa: '',
      costcoa: '',
      active: '',
      usercrt: '',
      userupd: '',
      userdel: '',
      prnkitchen: '',
      prnkitchentm: '',
      confirmed: '',
      trdesc: '',
    );
    getDetailData();
  }

  getTrno() async {
    handler = DatabaseHandler();
    await handler.initializeDB();
    await handler.getTrno(widget.pscd).then((value) {
      setState(() {
        trno = '${widget.pscd}${value.first.trnonext}';
      });
      print('ini trno dari mainretail ${widget.pscd}${value.first.trnonext}');
    });
  }

  getSavedCustomers() async {
    final savecostmrs = await SharedPreferences.getInstance();
    await savecostmrs.setString('savecostmrs', selectedcostumer.toString());
  }

  Future<dynamic> checkTrno() async {
    await handler.getTrno(widget.pscd.toString()).then((value) {
      setState(() {
        trnolanjut = value.first.trnonext;
      });
      print('ini trno $trno');
    });
    await updateTrnonext();
  }

  updateTrnonext() async {
    await handler.updateTrnoNext(
        Outlet(outletcd: widget.pscd.toString(), trnonext: trnolanjut! + 1));
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
      print(barcodeScanRes);

      await handler.queryCheckRegister(barcodeScanRes).then((value) async {
        if (value == 'Oke item masih kosong') {
          Toast.show("Produk tidak Terdaftar",
              duration: Toast.lengthLong, gravity: Toast.center);
        } else {
          await handler.getItemFromBarcode(value).then((value) async {
            Toast.show("Produk Terdaftar ${value.first.itemdesc}",
                duration: Toast.lengthLong, gravity: Toast.center);
            print(value);
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

  Future<int> insertIafjrndt(Item items) async {
    IafjrndtClass iafjrndt2 = IafjrndtClass(
      trdt: formattedDate,
      pscd: items.outletcd,
      trno: widget.trno,
      split: 'A',
      trnobill: 'trnobill',
      itemcd: items.itemcd,
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
      rateamt: items.slsamt,
      rateamtservice: 0,
      rateamttax: 0,
      rateamttotal: items.slsnett,
      rvnamt: 1 * items.slsamt!.toDouble(),
      taxamt: 0,
      serviceamt: 0,
      nettamt: 1 * items.slsnett!.toDouble(),
      rebateamt: 0,
      rvncoa: 'REVENUE',
      taxcoa: 'TAX',
      servicecoa: 'SERVICE',
      costcoa: 'COST',
      active: '1',
      usercrt: 'Admin',
      userupd: 'Admin',
      userdel: 'Admin',
      prnkitchen: '1',
      prnkitchentm: '10:10',
      confirmed: '1',
      trdesc: items.itemdesc,
      taxpct: items.taxpct,
      servicepct: items.svchgpct,
    );
    List<IafjrndtClass> listiafjrndt = [iafjrndt2];

    setState(() {
      widget.trno = iafjrndt2.trno;
      // string = iafjrndt2;
    });

    return await handler.insertIafjrndt(listiafjrndt);
  }

  @override
  void dispose() {
    controller!.dispose();
    // _pc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: DrawerRetailMain(),
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          color: Colors.white,
          child: WillPopScope(
            onWillPop: () async {
              return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogClassWillPop(
                      trno: trno.toString(),
                    );
                  });
            },
            child: Stack(
              overflow: Overflow.visible,
              children: [
                SlidingUpPanel(
                    onPanelSlide: (value) {
                      print(value);

                      if (value > 0.5) {
                        setState(() {
                          _scrollisanimated = true;
                        });
                        print(_scrollisanimated);
                      } else {
                        setState(() {
                          _scrollisanimated = false;
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
                          height: MediaQuery.of(context).size.height * 0.035,
                          width: MediaQuery.of(context).size.width * 1,
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.blue),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                ),
                                iconSize: 30,
                                color: Colors.white,
                                splashColor: Colors.transparent,
                                onPressed: () {},
                              ),
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width:
                                      MediaQuery.of(context).size.width * 0.62,
                                  child: TextFieldMobile2(
                                    hint: 'Search',
                                    controller: search,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    typekeyboard: TextInputType.number,
                                  )),
                              IconButton(
                                icon: Icon(
                                  Icons.qr_code,
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
                                    icon: Icon(
                                      Icons.list_alt,
                                    ),
                                    iconSize: 30,
                                    color: Colors.white,
                                    splashColor: Colors.transparent,
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Listtransaction(
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
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
                          decoration: BoxDecoration(color: Colors.grey[200]),
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
                          height: MediaQuery.of(context).size.height * 0.007,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width * 1,
                          child: TabBarView(
                            controller: controller,
                            children: [
                              ClassRetailManualMobile(
                                refreshdata: getDataSlide,
                                trno: widget.trno,
                                itemlenght: item,
                                outletinfo: Outlet(
                                  alamat: widget.outletinfo.alamat,
                                  kodepos: widget.outletinfo.kodepos,
                                  outletcd: widget.outletinfo.outletcd,
                                  outletname: widget.outletinfo.outletname,
                                  telp: widget.outletinfo.telp,
                                  trnonext: widget.outletinfo.trnonext,
                                  trnopynext: widget.outletinfo.trnopynext,
                                ),
                              ),
                              ClassRetailProductMobile(
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
                      return SlideUpPanel(
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
                      );
                    }),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.025,
                  child: ButtonNoIconAnimated(
                      curve: Curves.linear,
                      duration: 300,
                      textcolor: _scrollisanimated == true
                          ? Colors.blue
                          : Colors.white,
                      color: _scrollisanimated == true
                          ? Colors.white
                          : Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: _scrollisanimated == false
                          ? MediaQuery.of(context).size.width * 0.95
                          : MediaQuery.of(context).size.width * 0.40,
                      onpressed: () async {
                        _pc.open();
                        if (_scrollisanimated == true) {
                          await checkTrno().whenComplete(() {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
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
                      color: Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: _scrollisanimated == false
                          ? MediaQuery.of(context).size.width * 0.0
                          : MediaQuery.of(context).size.width * 0.53,
                      onpressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentV2MobileClass(
                                    datatrans: listdata!,
                                    outletinfo: widget.outletinfo,
                                    balance: sum.toInt(),
                                    pscd: widget.outletinfo.outletcd,
                                    trdt: formattedDate,
                                    trno: widget.trno.toString(),
                                    outletname: widget.outletinfo.outletname,
                                  )),
                        );
                        ClassRetailMainMobile.of(context)!.string = result!;
                        // final result = await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => PaymentMobileClass(
                        //             outletinfo: widget.outletinfo,
                        //             balance: widget.amount!.toInt(),
                        //             pscd: widget.outletinfo!.outletcd,
                        //             trdt: widget.trnoinfo!.trdt!,
                        //             trno: widget.trnoinfo!.trno!,
                        //             outletname: widget.outletname,
                        //           )),
                        // );
                        // ClassRetailMainMobile.of(context)!.string = result!;
                      },
                      name: 'Bayar'),
                ),
              ],
            ),
          ),
        ));
  }
}
