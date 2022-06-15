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

class _CreateproductState extends State<Createproduct> {
  final productcd = TextEditingController();
  final productname = TextEditingController();
  final amountcost = TextEditingController();
  final amountsales = TextEditingController();
  final kategory = TextEditingController(text: 'Pilih Kategori');
  final stock = TextEditingController();
  final pcttax = TextEditingController(text: '0');
  final pctservice = TextEditingController(text: '0');
  final description = TextEditingController();
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

  set string(String value) => setState(() => pathimage = value);

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }



  Future<int> addItem() async {
        setState(() {
      pctnett =
          (double.parse(pcttax.text) + double.parse(pctservice.text)) / 100;
    });
    Item ctg = Item(
      outletcd: widget.pscd.toString(),
      itemcd: productcd.text,
      itemdesc: productname.text,
      costcoa: 'COST',
      revenuecoa: 'REVENUE',
      taxcoa: 'TAX',
      svchgcoa: 'SERVICE',
      taxpct: num.parse(pcttax.text),
      svchgpct: num.parse(pctservice.text),
      costamt: num.parse(amountcost.text),
      slsamt: num.parse(amountsales.text),
      slsnett: pctnett != 0
          ? num.parse(amountsales.text) * pctnett!+ num.parse(amountsales.text)
          : num.parse(amountsales.text),
      ctg: selectedctg,
      slsfl: salesflag!,
      stock: num.parse(stock.text),
      pathimage: pathimage,
      description: description.text,
    );
    List<Item> listctg = [ctg];
    return await handler.insertItem(listctg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create Product',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              // Text(pathimage == null ? 'Upload Image' : pathimage.toString()),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 200,
                  width: 200,
                  child: ImageFromGalleryEx(ImageSourceType.gallery)),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              Text('Kategori'),
              TextFieldMobileButton(
                  hint: 'Pilih Kategori',
                  controller: kategory,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {},
                  ontap: () async {
                    Ctg result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogTabClass();
                        });
                    setState(() {
                      selectedctg = result.ctgcd;
                      kategory.text = result.ctgdesc;
                    });
                  }),
              // TextFieldMobile(
              //   enable: false,
              //   label: 'Product Code',
              //   controller: productcd,
              //   typekeyboard: TextInputType.text,
              //   onChanged: (value) {},
              // ),
              TextFieldMobile2(
                label: 'Product Name',
                controller: productname,
                typekeyboard: TextInputType.text,
                onChanged: (value) {
                  // print(value);
                  itemdesc = value;
                  setState(() {
                    handler.queryCheckItem().then((value) {
                      maxid = value.toString();
                      productcd.text =
                          '$selectedctg${itemdesc!.substring(0, 2)}$maxid';
                    });
                  });
                },
              ),
              TextFieldMobile2(
                maxline: 3,
                hint:
                    'Masakan Jawa Dengan Bumbu Rempah yg sangat kuat yg di sukai emak emak',
                label: 'Description',
                controller: description,
                typekeyboard: TextInputType.text,
                onChanged: (value) {
                  // print(value);
                  // itemdesc = value;
                },
              ),
              TextFieldMobile2(
                label: 'Harga Pokok',
                controller: amountcost,
                typekeyboard: TextInputType.number,
                onChanged: (value) {},
              ),
              TextFieldMobile2(
                label: 'Harga Jual',
                controller: amountsales,
                typekeyboard: TextInputType.number,
                onChanged: (value) {},
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.07,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text('Sales Flag')),
                  Checkbox(
                      value: forresto,
                      onChanged: (values) {
                        setState(() {
                          forresto = values!;
                          if (values == true) {
                            salesflag = 1;
                          }
                        });
                      }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: TextFieldMobile2(
                        maxline: 1,
                        label: 'Tax',
                        controller: pcttax,
                        onChanged: (value) {},
                        typekeyboard: TextInputType.number),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFieldMobile2(
                        maxline: 1,
                        label: 'Stock',
                        controller: stock,
                        onChanged: (value) {},
                        typekeyboard: TextInputType.number),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFieldMobile2(
                        maxline: 1,
                        label: 'Service',
                        controller: pctservice,
                        onChanged: (value) {},
                        typekeyboard: TextInputType.number),
                  ),
                ],
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              ButtonNoIcon(
                  name: 'Save',
                  color: Colors.blue,
                  textcolor: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.95,
                  onpressed: () async {
                  
                    setState(() {
                      pctnett = (double.parse(pcttax.text) +
                              double.parse(pctservice.text)) /
                          100;
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
