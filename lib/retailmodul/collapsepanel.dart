// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/classretailmanualmobil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CollapsePanelRetail extends StatefulWidget {
  final PanelController pc;
  final StringCallback callback;
  final IafjrndtClass? trnoinfo;
  final Outlet? outletinfo;
  final int? qty;
  final num? amount;
  final List<IafjrndtClass>? listdata;
  final String? outletname;
  late String? trno;
  CollapsePanelRetail(
      {Key? key,
      required this.callback,
      required this.trnoinfo,
      this.qty,
      this.amount,
      this.listdata,
      required this.outletname,
      this.outletinfo,
      this.trno,
      required this.pc})
      : super(key: key);

  @override
  State<CollapsePanelRetail> createState() => _CollapsePanelRetailState();
}

class _CollapsePanelRetailState extends State<CollapsePanelRetail> {
  late DatabaseHandler handler;
  String trno = '';
  int? totalbarang = 0;
  num? amounttotal = 0;

  @override
  void initState() {
    super.initState();
    // widget.pc.open();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    trno = widget.trno.toString();
    getDataSlide();
    print('trno on collapse ${widget.trno.toString()}');
  }

  getDataSlide() async {
    handler.retrieveDetailIafjrndt(trno.toString()).then((isi) {
      if (isi.isNotEmpty) {
        setState(() {
          totalbarang = isi.length;
          print('total barang collpse $totalbarang');
        });
      } else {
        setState(() {
          totalbarang = 0;
        });
      }

      print('terpanggil');
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
    return FutureBuilder(
        future: handler.retrieveDetailIafjrndt(trno),
        builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [

              ],
            ),
          );
        });
  }
}
