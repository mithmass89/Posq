// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unnecessary_string_interpolations, unused_import, avoid_print, unused_local_variable

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/cloudapi.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/image.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/product_master/classkelolastockmobile.dart';
import 'package:posq/setting/classtabcreateproductmobile.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

enum ImageSourceType { gallery, camera }

ClassApi? apicloud;

class Createproductv3 extends StatefulWidget {
  final Item? productcode;
  final String? pscd;

  const Createproductv3({Key? key, this.productcode, this.pscd})
      : super(key: key);

  @override
  State<Createproductv3> createState() => _Createproductv3State();

  static _Createproductv3State? of(BuildContext context) =>
      context.findAncestorStateOfType<_Createproductv3State>();
}

class _Createproductv3State extends State<Createproductv3>
    with SingleTickerProviderStateMixin {
  var uuid = Uuid();
  TabController? controller;
  final TextEditingController productcd = TextEditingController();
  final TextEditingController productname = TextEditingController();
  final TextEditingController amountcost = TextEditingController();
  final TextEditingController amountsales = TextEditingController();
  final TextEditingController kategory =
      TextEditingController(text: 'Pilih Kategori');
  final TextEditingController stock = TextEditingController();
  final TextEditingController pcttax = TextEditingController();
  final TextEditingController pctservice = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController minproduct = TextEditingController();
  final TextEditingController adjusmentmin = TextEditingController();
  final TextEditingController adjusmentstock = TextEditingController();
  final TextEditingController catatan = TextEditingController();
  final TextEditingController barcode = TextEditingController();
  final TextEditingController sku = TextEditingController();
  final TextEditingController printer = TextEditingController();

  late int trackstock;
  Gntrantp? gntrantp;
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
  bool connect = false;
  bool multiflag = false;
  set string(String value) => setState(() => pathimage = value);
  int multiprice = 0;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    adjusmentstock.addListener(() {});
    trackstock = 0;
    checkInternet();
  }

  updateStockTrack(value) {
    setState(() {
      trackstock = value;
    });
  }

  Future<dynamic> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('$host');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          connect = true;
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        connect = false;
      });
    }
  }

  changeValueMultiPrice(int multiharga) {
    multiprice = multiharga;
    setState(() {});
  }

  Future<void> _createProduct(Item data, String dbname) async {
    print(data);
    await ClassApi.insertProduct(
        Item(
          moderetail: 0,
          packageflag: 0,
          multiprice: multiprice,
          outletcode: data.outletcode,
          itemcode: data.itemcode.toString(),
          itemdesc: data.itemdesc.toString(),
          slsamt: data.slsamt,
          costamt: data.costamt,
          slsnett: data.slsnett,
          taxpct: data.taxpct,
          svchgpct: data.svchgpct,
          revenuecoa: data.revenuecoa.toString(),
          taxcoa: data.taxcoa.toString(),
          svchgcoa: data.svchgcoa.toString(),
          slsfl: data.slsfl,
          costcoa: data.costcoa.toString(),
          ctg: data.ctg.toString(),
          stock: adjusmentstock.text != '' ? num.parse(adjusmentstock.text) : 0,
          pathimage: pathimage.toString(),
          description: description.text.toString(),
          trackstock: trackstock,
          barcode: barcode.text.toString(),
          sku: sku.text,
        ),
        dbname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Buat Produk baru',
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
                      Text('Informasi produk'),
                      Text('Kelola Stock'),
                    ]),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.60,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    ClassTabCreateProducr(
                      printer: printer,
                      imagepath: pathimage,
                      multiprice: multiprice,
                      fromedit: false,
                      barcode: barcode,
                      sku: sku,
                      productcd: productcd,
                      productname: productname,
                      amountcost: amountcost,
                      amountsales: amountsales,
                      kategory: kategory,
                      stock: stock,
                      pcttax: pcttax,
                      pctservice: pctservice,
                      description: description,
                      multipriceSet: changeValueMultiPrice,
                      multiflag: multiflag,
                    ),
                    ClassKelolaStockMobile(
                      trackstockcallback: updateStockTrack,
                      data: widget.productcode,
                      trackstock: trackstock,
                      gntrantp: gntrantp,
                      catatan: catatan,
                      minproduct: minproduct,
                      adjusmentstock: adjusmentstock,
                      stocknow: stock,
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
                color: productname.text != '' &&
                        productcd.text != '' &&
                        amountsales.text != ''
                    ? Colors.blue
                    : Colors.grey[300],
                textcolor: Colors.white,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.94,
                onpressed: productname.text != '' &&
                        productcd.text != '' &&
                        amountsales.text != ''
                    ? () async {
                        setState(() {
                          pctnett = pcttax == '' || pctservice == ''
                              ? (double.parse(
                                          pcttax == '' ? '0.0' : pcttax.text) +
                                      double.parse(pctservice == ''
                                          ? '0.0'
                                          : pctservice.text)) /
                                  100
                              : 0;
                        });
                        await checkInternet().whenComplete(() async {
                          if (connect == true) {
                            var uuid = Uuid();
                            var random = uuid.v4();
                            await _createProduct(
                                Item(
                                  moderetail: 0,
                                  packageflag: 0,
                                  multiprice: multiprice,
                                  outletcode: widget.pscd!,
                                  itemcode: random,
                                  itemdesc: productname.text,
                                  costcoa: 'COST',
                                  revenuecoa: 'REVENUE',
                                  taxcoa: 'TAX',
                                  svchgcoa: 'SERVICE',
                                  taxpct: pcttax.text.isEmpty
                                      ? 0
                                      : num.parse(pcttax.text),
                                  svchgpct: pctservice.text.isEmpty
                                      ? 0
                                      : num.parse(pctservice.text),
                                  costamt: amountcost.text.isEmpty
                                      ? 0
                                      : num.parse(amountcost.text),
                                  slsamt: amountsales.text.isEmpty
                                      ? 0
                                      : num.parse(amountsales.text),
                                  slsnett: pctnett != 0
                                      ? num.parse(amountsales.text) * pctnett! +
                                          num.parse(amountsales.text)
                                      : amountsales.text.isEmpty
                                          ? 0
                                          : num.parse(amountsales.text),
                                  ctg: selectedctg ?? '',
                                  slsfl: 1,
                                  stock: num.parse(adjusmentstock.text.isEmpty
                                      ? '0'
                                      : adjusmentstock.text),
                                  pathimage: pathimage ?? 'Empty',
                                  description: description.text.isEmpty
                                      ? 'Empty'
                                      : description.text,
                                  trackstock: trackstock,
                                  sku: sku.text,
                                  barcode: barcode.text,
                                ),
                                widget.pscd!);
                            Navigator.of(context).pop();
                          } else {
                            Toast.show("Not Connect to server",
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom);
                          }
                        });
                      }
                    : null),
          ),
        ],
      ),
    );
  }
}
