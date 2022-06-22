import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/image.dart';
import 'package:posq/model.dart';

enum ImageSourceType { gallery, camera }

class ClassTabCreateProducr extends StatefulWidget {
  late TextEditingController productcd;
  late TextEditingController productname;
  late TextEditingController amountcost;
  late TextEditingController amountsales;
  late TextEditingController kategory;
  late TextEditingController stock;
  late TextEditingController pcttax;
  late TextEditingController pctservice;
  late TextEditingController description;
  late String? selectedctg;
  final Function? callbackctg;

  ClassTabCreateProducr({
    Key? key,
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

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SizedBox(
          //   height: 20,
          // ),
          // // Text(pathimage == null ? 'Upload Image' : pathimage.toString()),
          // SizedBox(
          //   height: 20,
          // ),
          // Container(
          //     height: 200,
          //     width: 200,
          //     child: ImageFromGalleryEx(ImageSourceType.gallery)),
          // SizedBox(
          //   height: 20,
          // ),
          // Divider(
          //   thickness: 1,
          //   indent: 20,
          //   endIndent: 20,
          // ),
          // Text('Kategori'),
          // TextFieldMobileButton(
          //     hint: 'Pilih Kategori',
          //     controller: kategory,
          //     typekeyboard: TextInputType.text,
          //     onChanged: (value) {},
          //     ontap: () async {
          //       Ctg result = await showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return DialogTabClass();
          //           });
          //       setState(() {
          //         selectedctg = result.ctgcd;
          //         kategory.text = result.ctgdesc;
          //       });
          //     }),
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
                  handler.queryCheckItem().then((value) {
                    maxid = value.toString();
                    widget.productcd.text =
                        '${widget.selectedctg}${itemdesc!.substring(0, 2)}$maxid';
                  });
                });
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
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.03,
                      //     ),
                      //     Container(
                      //       height: MediaQuery.of(context).size.height * 0.08,
                      //       width: MediaQuery.of(context).size.width * 0.3,
                      //       child: TextFieldMobile2(
                      //           maxline: 1,
                      //           label: 'Stock',
                      //           controller: widget.stock,
                      //           onChanged: (value) {},
                      //           typekeyboard: TextInputType.number),
                      //     ),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.1,
                      //     ),

                      //   ],
                      // ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
