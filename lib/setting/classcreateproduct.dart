// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unnecessary_string_interpolations, unused_import, avoid_print

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/image.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/classkelolastockmobile.dart';
import 'package:posq/setting/classtabcreateproductmobile.dart';

enum ImageSourceType { gallery, camera }

class Createproduct extends StatefulWidget {
  final Item? productcode;
  final String? pscd;

  const Createproduct({Key? key, this.productcode, this.pscd})
      : super(key: key);

  @override
  State<Createproduct> createState() => _CreateproductState();

  static _CreateproductState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CreateproductState>();
}

class _CreateproductState extends State<Createproduct>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  final productcd = TextEditingController();
  final productname = TextEditingController();
  final amountcost = TextEditingController();
  final amountsales = TextEditingController();
  final kategory = TextEditingController(text: 'Pilih Kategori');
  final stock = TextEditingController();
  final pcttax = TextEditingController();
  final pctservice = TextEditingController();
  final description = TextEditingController();
    final minproduct = TextEditingController();
  final adjusmentmin = TextEditingController();
  final adjusmentplus = TextEditingController();
   final catatan = TextEditingController();
  bool forresto = false;
  bool forretail = false;
  String? selectedctg = 'Pilih Kategori';
  late DatabaseHandler handler;
  String? maxid;
  String? itemdesc;
  int? salesflag;
  double? pctnett;
  String? pathimage;
  String? query = '';
  num? qty = 0;

  set string(String value) => setState(() => pathimage = value);

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    controller = TabController(vsync: this, length: 2);
  }

  Future<int> addItem() async {
    setState(() {
      pctnett = pcttax == '' || pctservice == ''
          ? (double.parse(pcttax == '' ? '0.0' : pcttax.text) +
                  double.parse(pctservice == '' ? '0.0' : pctservice.text)) /
              100
          : 0;
    });
    print(pcttax.text);
    Item ctg = Item(
      outletcd: widget.pscd.toString(),
      itemcd: productcd.text,
      itemdesc: productname.text,
      costcoa: 'COST',
      revenuecoa: 'REVENUE',
      taxcoa: 'TAX',
      svchgcoa: 'SERVICE',
      taxpct: pcttax.text.isEmpty ? 0 : num.parse(pcttax.text),
      svchgpct: pctservice.text.isEmpty ? 0 : num.parse(pctservice.text),
      costamt: amountcost.text.isEmpty ? 0 : num.parse(amountcost.text),
      slsamt: amountsales.text.isEmpty ? 0 : num.parse(amountsales.text),
      slsnett: pctnett != 0
          ? num.parse(amountsales.text) * pctnett! + num.parse(amountsales.text)
          : amountsales.text.isEmpty
              ? 0
              : num.parse(amountsales.text),
      ctg: selectedctg ?? '',
      slsfl: 1,
      stock: num.parse(stock.text.isEmpty ? '0' : stock.text),
      pathimage: pathimage ?? 'Empty',
      description: description.text.isEmpty ? 'Empty' : description.text,
    );
    List<Item> listctg = [ctg];
    return await handler.insertItem(listctg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Buat Produk baru',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.black,
                    controller: controller,
                    tabs: [
                      Text('Informasi produk'),
                      Text('Kelola Stock'),
                    ]),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.70,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    ClassTabCreateProducr(
                      productcd: productcd,
                      productname: productname,
                      amountcost: amountcost,
                      amountsales: amountsales,
                      kategory: kategory,
                      stock: stock,
                      pcttax: pcttax,
                      pctservice: pctservice,
                      description: description,
                    ),
                    ClassKelolaStockMobile(
                      catatan: catatan,
                      minproduct: minproduct,
                      adjusmentmin: adjusmentmin,
                      adjusmentplus: adjusmentplus,
                      stock: stock,
                      qty: qty!,
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.height * 0.80,
            child: ButtonNoIcon(
                name: 'Save',
                color: Colors.blue,
                textcolor: Colors.white,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.94,
                onpressed: () async {
                  setState(() {
                    pctnett = pcttax == '' || pctservice == ''
                        ? (double.parse(pcttax == '' ? '0.0' : pcttax.text) +
                                double.parse(pctservice == ''
                                    ? '0.0'
                                    : pctservice.text)) /
                            100
                        : 0;
                  });
                  print(pctnett);
                  handler = DatabaseHandler();
                  handler.initializeDB().whenComplete(() async {
                    await addItem().whenComplete(() async {
                      print(handler.retrieveItems(query!).then((value) {
                        print('${value.map((e) => e.itemdesc)}');
                      }));
                    });
                    setState(() {});
                  }).then((_) {
                    Navigator.of(context).pop(context);
                  });
                }),
          ),
        ],
      ),
    );
  }
}
