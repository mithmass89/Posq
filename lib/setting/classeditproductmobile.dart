// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/registerproductmobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/image.dart';
import 'package:posq/model.dart';

enum ImageSourceType { gallery, camera }

class ClassEditProductMobile extends StatefulWidget {
  final Item? productcode;
  const ClassEditProductMobile({Key? key, this.productcode}) : super(key: key);

  @override
  State<ClassEditProductMobile> createState() => _ClassEditProductMobileState();
  static _ClassEditProductMobileState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ClassEditProductMobileState>();
}

class _ClassEditProductMobileState extends State<ClassEditProductMobile> {
  final productcd = TextEditingController();
  final productname = TextEditingController();
  final amountcost = TextEditingController();
  final amountsales = TextEditingController();
  final kategory = TextEditingController(text: 'Pilih Kategori');
  final stock = TextEditingController();
  final pcttax = TextEditingController(text: '0');
  final pctservice = TextEditingController(text: '0');
  final description = TextEditingController(text: '0');
  String? itemdesc;
  int? salesflag;
  double? pctnett;
  String? pathimage;
  late DatabaseHandler handler;
  String? maxid;
  String? selectedctg = 'Pilih Kategori';
  bool forresto = false;
  bool forretail = false;
  set string(String value) => setState(() => pathimage = value);
  String? costcoa;
  String? revenuecoa;
  String? taxcoa;
  String? svchgcoa;

  @override
  void initState() {
    super.initState();
    
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
  }

  Future<int> addItem() async {
    Item ctg = Item(
      outletcode: 'OUTLET',
      itemcode: productcd.text,
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
          ? num.parse(amountsales.text) * pctnett!
          : num.parse(amountsales.text),
      ctg: selectedctg,
      slsfl: salesflag!,
      stock: num.parse(stock.text),
      pathimage: pathimage,
      description: description.text,
      trackstock: 0,
    );
    List<Item> listctg = [ctg];
    return await handler.insertItem(listctg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Produk',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text('Tap Image to edit'),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 200,
                  width: 200,
                  child: ImageFromGalleryEx(
                    ImageSourceType.gallery,
                    savingimage: pathimage,
                  )),
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
                    final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogTabClass();
                        });
                    setState(() {
                      selectedctg = result;
                      kategory.text = result;
                    });
                  }),
              // TextFieldMobile(
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
                onChanged: (value) {
                  print(amountsales.text);
                },
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClassScanRegisterProdMobile(
                                        produk: widget.productcode!.itemcode!,
                                        produkname:
                                            widget.productcode!.itemdesc!,
                                      )),
                            );
                          },
                          child: Text('Register')),
                    )
                  ],
                ),
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
                  onpressed: () {
                    setState(() {
                      pctnett = (double.parse(pcttax.text) +
                              double.parse(pctservice.text)) /
                          100;
                    });
                    print(pctnett);
                    handler = DatabaseHandler();
                    handler.initializeDB(databasename).whenComplete(() async {
                      await handler.updateItems(Item(
                        trackstock: 0,
                        outletcode: widget.productcode!.outletcode,
                        itemcode: widget.productcode!.itemcode,
                        itemdesc: productname.text,
                        description: description.text,
                        slsamt: num.parse(amountsales.text),
                        costamt: num.parse(amountcost.text),
                        slsnett: pctnett != 0
                            ? num.parse(amountsales.text) * pctnett!.toDouble() + num.parse(amountsales.text)
                            : num.parse(amountsales.text),
                        taxpct: num.parse(pcttax.text),
                        svchgpct: num.parse(pctservice.text),
                        revenuecoa: revenuecoa.toString(),
                        taxcoa: taxcoa.toString(),
                        svchgcoa: svchgcoa,
                        slsfl: salesflag!.toInt(),
                        costcoa: costcoa.toString(),
                        ctg: selectedctg == ''
                            ? widget.productcode!.ctg
                            : selectedctg,
                        pathimage: pathimage,
                        stock: num.parse(stock.text),
                        id: widget.productcode!.id,
                      ));
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
