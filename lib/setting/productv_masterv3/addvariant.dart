// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/image.dart';
import 'package:posq/model.dart';

enum ImageSourceType { gallery, camera }
class AddVariantProduct extends StatefulWidget {
  final String itemcode;
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
  final String? imagepath;

  AddVariantProduct({
    Key? key,
    required this.itemcode,
    required this.productcd,
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
    required this.barcode,
    required this.sku,
    this.imagepath,
  }) : super(key: key);

  @override
  State<AddVariantProduct> createState() => _AddVariantProductState();
}

class _AddVariantProductState extends State<AddVariantProduct> {
  String? maxid;
  String? itemdesc;
  int? salesflag;
  double? pctnett;
  String? pathimage;
  String? query = '';
  bool detailon = false;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Varian'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.09,
            child: TextFieldMobile2(
              label: 'Nama variant',
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
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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
              : Container(),
              ElevatedButton(onPressed: (){}, child: Text('Save Variant'))

        ],
      ),
    );
  }
}
