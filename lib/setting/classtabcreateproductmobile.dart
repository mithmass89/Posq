// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/image.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ImageSourceType { gallery, camera }

class ClassTabCreateProducr extends StatefulWidget {
  late int multiprice;
  late TextEditingController productcd;
  late TextEditingController productname;
  late TextEditingController amountcost;
  late TextEditingController amountsales;
  late TextEditingController kategory;
  late TextEditingController stock;
  late TextEditingController pcttax;
  late TextEditingController pctservice;
  late TextEditingController description;
  late TextEditingController barcode;
  late TextEditingController sku;
  late String? selectedctg;
  final Function? callbackctg;
  final Function? multipriceSet;
  final String? imagepath;
  late List<TextEditingController>? controllerMulti;
  late List<PriceList>? pricelist;
  final bool fromedit;
  final bool multiflag;


  ClassTabCreateProducr({
    Key? key,
    required this.productcd,
    required this.multiprice,
    required this.productname,
    required this.amountcost,
    required this.amountsales,
    required this.kategory,
    required this.stock,
    required this.pcttax,
    required this.pctservice,
    required this.description,
    this.selectedctg,
    this.callbackctg,
    this.pricelist,
    required this.barcode,
    required this.sku,
    required this.imagepath,
    this.controllerMulti,
    required this.fromedit,
    required this.multipriceSet,
    required this.multiflag, 
  }) : super(key: key);

  @override
  State<ClassTabCreateProducr> createState() => _ClassTabCreateProducrState();
}

class _ClassTabCreateProducrState extends State<ClassTabCreateProducr> {
  String? maxid;
  String? itemdesc;
  int? salesflag;
  double? pctnett;
  String? pathimage;
  String? query = '';
  late DatabaseHandler handler;
  bool detailon = false;
  bool multiharga = false;
  List<TransactionTipe> transtp = [];
  FToast? fToast;

  ScrollController _controllerscroll = ScrollController();

  @override
  void initState() {
    super.initState();
    gettransactionTipe();
    fToast = FToast();
    fToast!.init(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This is a Custom Toast"),
        ],
      ),
    );
  }

  gettransactionTipe() async {
    transtp = await ClassApi.getTransactionTipe(pscd, dbname, '');
    for (var x in transtp) {
      widget.controllerMulti!.add(TextEditingController(text: '0'));
      if (widget.fromedit == false) {
        widget.pricelist!.add(PriceList(
            transtype: x.transtype!, transdesc: x.transdesc!, amount: 0));
      }
    }
    multiharga = widget.multiflag;
    if (widget.multiflag == true) {
      multiharga = widget.multiflag;
      for (var x in widget.controllerMulti!) {
        x.text = widget.pricelist![widget.controllerMulti!.indexOf(x)].amount
            .toString();

        setState(() {});
      }
      widget.multipriceSet!(1);
    } else {
      widget.multipriceSet!(0);
    }
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      widget.barcode.text = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controllerscroll,
      shrinkWrap: false,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Detail Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          child: TextFieldMobile2(
            label: 'Nama produk',
            controller: widget.productname,
            typekeyboard: TextInputType.text,
            onChanged: (value) {
              // print(value);
              itemdesc = value;
              setState(() {
                widget.productcd.text = itemdesc!;
              });
              print(widget.productcd.text);
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          child: TextFieldMobile2(
            label: 'Harga Jual',
            controller: widget.amountsales,
            typekeyboard: TextInputType.number,
            onChanged: (value) {},
          ),
        ),
        Divider(
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
            title: Text(
              'Multiple Harga',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Checkbox(
                value: multiharga,
                onChanged: (value) async {
                  if (widget.fromedit == false) {
                    if (widget.amountsales.text != '') {
                      multiharga = value!;
                      for (var x in widget.controllerMulti!) {
                        x.text = widget.amountsales.text;
                      }
                      for (var x in widget.pricelist!) {
                        x.amount = num.parse(widget.amountsales.text);
                      }
                      print(widget.pricelist);
                      setState(() {});
                      if (multiharga == true) {
                        widget.multiprice = 1;
                        setState(() {});
                        widget.multipriceSet!(widget.multiprice);
                        print(widget.multiprice);
                      } else {
                        widget.multiprice = 0;
                        print(widget.multiprice);
                        widget.multipriceSet!(widget.multiprice);
                      }
                    } else {
                      // await _showToast();
                      Fluttertoast.showToast(
                          msg: "Harga harus terisi dulu",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } else {
                    for (var x in widget.controllerMulti!) {
                      multiharga = value!;
                      x.text = widget
                          .pricelist![widget.controllerMulti!.indexOf(x)].amount
                          .toString();
                      setState(() {});
                    }
                    if (multiharga == true) {
                      widget.multiprice = 1;
                      widget.multipriceSet!(widget.multiprice);
                      setState(() {});
                    } else {
                      widget.multiprice = 0;
                      widget.multipriceSet!(widget.multiprice);
                    }
                  }
                })),
        multiharga == true
            ? Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: ListView.builder(
                    controller: _controllerscroll,
                    itemCount: transtp.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        subtitle: TextFieldMobile2(
                          label: transtp[index].transdesc!,
                          controller: widget.controllerMulti![index],
                          typekeyboard: TextInputType.number,
                          onChanged: (value) {
                            widget.pricelist![index].amount = widget
                                    .controllerMulti![index].text.isNotEmpty
                                ? num.parse(widget.controllerMulti![index].text)
                                : 0;
                            print(widget.pricelist);
                            setState(() {});
                          },
                        ),
                      );
                    }),
              )
            : Container(),
        ListTile(
          title: Text(
            'Detail Tambahan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: detailon == false
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_drop_up_rounded,
                  ),
                  iconSize: 30,
                  color: Colors.blue,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      detailon = !detailon;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down_circle_rounded,
                  ),
                  iconSize: 30,
                  color: Colors.blue,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      detailon = !detailon;
                    });
                  },
                ),
        ),
        detailon == true
            ? Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    // Text(pathimage == null ? 'Upload Image' : pathimage.toString()),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Container(
                          color: Colors.grey,
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ImageFromGalleryEx(
                            ImageSourceType.gallery,
                            savingimage: widget.imagepath,
                            fromedit: widget.fromedit,
                            imagepath: widget.imagepath,
                            fromtemplateprint: false,
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    TextFieldMobileButton(
                        hint: 'Pilih Kategori',
                        controller: widget.kategory,
                        typekeyboard: TextInputType.text,
                        onChanged: (value) {},
                        ontap: () async {
                          Ctg result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogTabClass();
                              });
                          setState(() {
                            widget.selectedctg = result.ctgcd;
                            widget.kategory.text = result.ctgdesc;
                          });
                          widget.callbackctg!(result.ctgcd);
                          print(widget.selectedctg);
                        }),
                    Container(
                      child: TextFieldMobile2(
                        minLines: null,
                        maxline: null,
                        expands: true,
                        hint:
                            'Masakan Jawa Dengan Bumbu Rempah yg sangat kuat yg di sukai emak emak',
                        label: 'Description',
                        controller: widget.description,
                        typekeyboard: TextInputType.text,
                        onChanged: (value) {
                          // print(value);
                          // itemdesc = value;
                        },
                      ),
                    ),
                    TextFieldMobile2(
                      label: 'Harga Modal',
                      controller: widget.amountcost,
                      typekeyboard: TextInputType.number,
                      onChanged: (value) {},
                    ),
                    TextFieldMobile2(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.qr_code_scanner_outlined),
                        iconSize: 30,
                        color: Colors.blue,
                        splashColor: Colors.transparent,
                        onPressed: () async {
                          scanBarcodeNormal();
                        },
                      ),
                      label: 'Barcode',
                      controller: widget.barcode,
                      typekeyboard: TextInputType.number,
                      onChanged: (value) {},
                    ),
                    TextFieldMobile2(
                      label: 'SKU',
                      controller: widget.sku,
                      typekeyboard: TextInputType.number,
                      onChanged: (value) {},
                    ),
                    Row(
                      children: [
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.01,
                        // ),
                        // SizedBox(
                        //     width: MediaQuery.of(context).size.width * 0.2,
                        //     child: Text('Sales Flag')),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFieldMobile2(
                              maxline: 1,
                              label: 'Service',
                              controller: widget.pctservice,
                              onChanged: (value) {},
                              typekeyboard: TextInputType.number),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFieldMobile2(
                              maxline: 1,
                              label: 'Tax',
                              controller: widget.pcttax,
                              onChanged: (value) {},
                              typekeyboard: TextInputType.number),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
