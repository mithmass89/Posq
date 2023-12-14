// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unnecessary_string_interpolations, unused_import, avoid_print

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/image.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/product_master/classkelolastockmobile.dart';
import 'package:posq/setting/classtabcreateproductmobile.dart';
import 'package:posq/userinfo.dart';

// enum ImageSourceType { gallery, camera }

class Editproduct extends StatefulWidget {
  final Item? productcode;
  final String? pscd;

  Editproduct({
    Key? key,
    this.productcode,
    this.pscd,
  }) : super(key: key);

  @override
  State<Editproduct> createState() => _EditproductState();

  static _EditproductState? of(BuildContext context) =>
      context.findAncestorStateOfType<_EditproductState>();
}

class _EditproductState extends State<Editproduct>
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
  final adjusmentstock = TextEditingController();
  final catatan = TextEditingController();
  final barcode = TextEditingController();
  final sku = TextEditingController();
  final printer = TextEditingController();

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
  String? costcoa;
  String? revenuecoa;
  String? taxcoa;
  String? svchgcoa;
  num? qty = 0;
  late int trackstock;
  List<TransactionTipe> transtp = [];
  List<PriceList> pricelist = [];
  List<TextEditingController> controllerMulti = [];
  set string(String value) => setState(() {
        pathimage = value;
        print('ganti ke $pathimage');
      });
  int multiprice = 0;
  bool multiflag = false;

  @override
  void initState() {
    super.initState();
    print(widget.productcode);
    controller = TabController(vsync: this, length: 2);
    productcd.text = widget.productcode!.itemcode!;
    productname.text = widget.productcode!.itemdesc!;
    description.text = widget.productcode!.description.toString();
    amountcost.text = widget.productcode!.costamt.toString();
    amountsales.text = widget.productcode!.slsamt.toString();
    kategory.text = widget.productcode!.ctg.toString();
    pcttax.text = widget.productcode!.taxpct.toString();
    pctservice.text = widget.productcode!.svchgpct.toString();
    stock.text = widget.productcode!.stock.toString();
    salesflag = widget.productcode!.slsfl!.toInt();
    costcoa = widget.productcode!.costcoa;
    revenuecoa = widget.productcode!.revenuecoa;
    taxcoa = widget.productcode!.taxcoa;
    svchgcoa = widget.productcode!.svchgcoa;
    pathimage = widget.productcode!.pathimage;
    stock.text = widget.productcode!.stock.toString();
    trackstock = widget.productcode!.trackstock!;
    print('test barcode : ${widget.productcode!.barcode}');
    barcode.text = widget.productcode!.barcode.toString();
    sku.text = widget.productcode!.sku.toString();
    pricelist = widget.productcode!.pricelist!;
    adjusmentstock.text = widget.productcode!.stock.toString();
    printer.text = widget.productcode!.printer.toString();
    if (widget.productcode!.multiprice == 1) {
      multiflag = true;
    } else {
      multiflag = false;
    }
  }

  getCtg(String ctg) {
    setState(() {
      selectedctg = ctg;
    });
  }

  updateStockTrack(value) {
    setState(() {
      trackstock = value;
    });
    print("ini trackstock flag ${trackstock}");
  }

  changeValueMultiPrice(int multiharga) {
    multiprice = multiharga;
    setState(() {});
  }

  checkMultiPrice() {
    print(widget.productcode!.pricelist!.any((element) => element.amount == 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Produk',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Informasi produk'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Kelola Stock'),
                      ),
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
                      printer: printer,
                      multiflag: multiflag,
                      multipriceSet: changeValueMultiPrice,
                      multiprice: multiprice,
                      fromedit: true,
                      pricelist: pricelist,
                      controllerMulti: controllerMulti,
                      imagepath: pathimage,
                      barcode: barcode,
                      sku: sku,
                      callbackctg: getCtg,
                      productcd: productcd,
                      productname: productname,
                      amountcost: amountcost,
                      amountsales: amountsales,
                      kategory: kategory,
                      stock: stock,
                      pcttax: pcttax,
                      pctservice: pctservice,
                      description: description,
                      selectedctg: selectedctg,
                    ),
                    ClassKelolaStockMobile(
                      trackstockcallback: updateStockTrack,
                      data: widget.productcode!,
                      trackstock: trackstock,
                      catatan: catatan,
                      minproduct: minproduct,
                      adjusmentstock: adjusmentstock,
                      qty: qty!,
                      stocknow: stock,
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
                name: 'Update',
                color: Color.fromARGB(255, 255, 145, 0),
                textcolor: Colors.white,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.94,
                onpressed: () async {
                  checkMultiPrice();
                  setState(() {
                    pctnett = (double.parse(pcttax.text) +
                            double.parse(pctservice.text)) /
                        100;
                  });
                  print(pctnett);

                  await ClassApi.updateProduct(
                      Item(
                        moderetail: 0,
                        packageflag: 0,
                        multiprice: multiprice,
                        trackstock: trackstock,
                        outletcode: widget.productcode!.outletcode,
                        itemcode: widget.productcode!.itemcode,
                        itemdesc: productname.text,
                        description: description.text,
                        slsamt: num.parse(amountsales.text),
                        costamt: num.parse(amountcost.text),
                        slsnett: pctnett != 0
                            ? num.parse(amountsales.text) *
                                    pctnett!.toDouble() +
                                num.parse(amountsales.text)
                            : num.parse(amountsales.text),
                        taxpct: num.parse(pcttax.text),
                        svchgpct: num.parse(pctservice.text),
                        revenuecoa: revenuecoa.toString(),
                        taxcoa: taxcoa.toString(),
                        svchgcoa: svchgcoa,
                        slsfl: salesflag!.toInt(),
                        costcoa: costcoa.toString(),
                        ctg: kategory.text,
                        pathimage: pathimage,
                        stock: int.parse(adjusmentstock.text),
                        id: widget.productcode!.id,
                        barcode: barcode.text,
                        sku: sku.text,
                        pricelist: widget.productcode!.pricelist!,
                      ),
                      pscd);
                  Navigator.of(context).pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
