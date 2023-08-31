// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class ClassEditItemTab extends StatefulWidget {
  final String? title;
  late TextEditingController editdesc;
  final TextEditingController editamount;
  final TextEditingController editqty;
  final IafjrndtClass data;
  final Function? updatedata;
  ClassEditItemTab(
      {Key? key,
      this.title,
      required this.editdesc,
      required this.editamount,
      required this.data,
      required this.editqty,
      this.updatedata})
      : super(key: key);

  @override
  State<ClassEditItemTab> createState() => _ClassEditItemTabState();
}

class _ClassEditItemTabState extends State<ClassEditItemTab> {
  TextEditingController discountpct = TextEditingController(text: '0');
  TextEditingController discountamount = TextEditingController(text: '0');
  TextEditingController tax = TextEditingController();
  TextEditingController service = TextEditingController();
  num qty = 0;
  late DatabaseHandler handler;
  late IafjrndtClass hasil;
  num pcttax = 0;
  num pctservice = 0;
  bool additional = false;
  bool discbyamount = true;

  @override
  void initState() {
    super.initState();
    qty = num.parse(widget.data.qty.toString());
    widget.editdesc.text = widget.data.itemdesc!;
    widget.editamount.text = widget.data.rateamtitem.toString();
    widget.editqty.text = qty.toString();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    getInfoItem();
    getInfoAdditional();
  }

  getInfoItem() async {
    await ClassApi.getItemByCode(pscd, pscd, widget.data.itemcode!, '')
        .then((value) {
      if (value.length == 0) {
        setState(() {
          service.text = '0';
          tax.text = '0';
        });
      } else {
        setState(() {
          service.text = value.first.svchgpct.toString();
          tax.text = value.first.taxpct.toString();
          print(value.first.taxpct);
        });
      }
    });
  }

  getInfoAdditional() {
    if (widget.data.discpct != 0) {
      setState(() {
        print('ini discount ${widget.data.discamt}');
        additional = true;
        discbyamount = false;
        discountamount.text = widget.data.discamt.toString();
        discountpct.text = widget.data.discpct.toString();
      });
    } else if (widget.data.discpct == 0 && widget.data.discamt != 0) {
      setState(() {
        additional = true;
        discbyamount = true;
        discountamount.text = widget.data.discamt.toString();
        discountpct.text = widget.data.discpct.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Edit ${widget.data.itemdesc}',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(Icons.delete_outlined),
              iconSize: 30,
              color: Colors.white,
              splashColor: Colors.transparent,
              onPressed: () async {
                await handler
                    .deleteiafjrndtItems(widget.data.id!.toInt())
                    .then((_) {
                  handler
                      .retrievetotaltransaksi(widget.data.transno!)
                      .then((value) {
                    print('ini total transaksi ${value.first.transno}');
                    if (value.isNotEmpty) {
                      setState(() {
                        hasil = IafjrndtClass(
                          totalcost: value.first.totalcost,
                            itemcode: value.first.itemcode,
                            trdt: value.first.trdt,
                            split: 1,
                            rateamtitem: value.first.rateamtitem,
                            totalaftdisc: value.first.totalaftdisc,
                            transno: value.first.transno,
                            description: value.first.description, ratecostamt: value.first.ratecostamt);
                      });
                    } else {
                      setState(() {
                        hasil = IafjrndtClass(
                            itemcode: '',
                            trdt: widget.data.trdt,
                            transno: widget.data.transno,
                            totalaftdisc: 0,
                            description: '', totalcost: 0, ratecostamt: 0);
                      });
                    }
                  });
                });

                Navigator.of(context).pop();
                widget.updatedata;
              },
            ),
          ]),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.44,
                child: TextFieldMobile2(
                  label: 'Deskripsi',
                  controller: widget.editdesc,
                  onChanged: (String value) {},
                  typekeyboard: TextInputType.text,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.44,
                child: TextFieldMobile2(
                  label: 'Harga',
                  controller: widget.editamount,
                  onChanged: (String value) {
                    print(value);
                    print(qty);
                  },
                  typekeyboard: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            'Jumlah barang',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Bouncing(
                          onPress: () {
                            setState(() {
                              qty == 1 ? qty : qty--;
                              widget.editqty.text = qty.toString();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primaryColor,
                            ),
                            height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          )),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: TextFieldMobile2(
                          maxline: 1,
                          label: 'Qty',
                          controller: widget.editqty,
                          onChanged: (String value) {
                            qty = num.parse(widget.editqty.text);
                          },
                          typekeyboard: TextInputType.number,
                        ),
                      ),
                      Bouncing(
                          onPress: () {
                            setState(() {
                              qty++;
                              widget.editqty.text = qty.toString();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primaryColor,
                            ),
                            height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          )),
                      Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text('Additional'),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Switch(
                            value: additional,
                            onChanged: (value) {
                              setState(() {
                                additional = value;
                                if (additional == false) {
                                  print(additional);

                                  discountamount.clear();
                                  discountpct.clear();
                                }
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.1,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          AnimatedContainer(
            height: additional == true
                ? MediaQuery.of(context).size.height * 0.30
                : 0,
            curve: Curves.linear,
            duration: Duration(milliseconds: 100),
            child: additional == true
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          discbyamount == true
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: TextFieldMobile2(
                                    maxline: 1,
                                    label: 'Discount By Amount',
                                    controller: discountamount,
                                    onChanged: (String value) {
                                      setState(() {});
                                    },
                                    typekeyboard: TextInputType.number,
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: TextFieldMobile2(
                                    maxline: 1,
                                    label: 'Discount By Percent',
                                    controller: discountpct,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    typekeyboard: TextInputType.number,
                                  ),
                                ),
                          Row(
                            children: [
                              Bouncing(
                                  onPress: () {
                                    setState(() {
                                      discbyamount = true;
                                      discountpct.text = '0';
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        // borderRadius:
                                        //     BorderRadius.all(Radius.circular(20)),
                                        color: discbyamount == true
                                            ? AppColors.primaryColor
                                            : Colors.white),
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      'Rp',
                                      style: TextStyle(
                                          color: discbyamount == true
                                              ? Colors.white
                                              : AppColors.primaryColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Bouncing(
                                  onPress: () {
                                    setState(() {
                                      discbyamount = false;
                                      discountamount.text = '0';
                                    });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          color: discbyamount == false
                                              ? AppColors.primaryColor
                                              : Colors.white),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(
                                        '%',
                                        style: TextStyle(
                                            color: discbyamount == false
                                                ? Colors.white
                                                : AppColors.primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )))
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: TextFieldMobile2(
                              maxline: 1,
                              label: 'Pajak',
                              controller: tax,
                              onChanged: (String value) {
                                print(tax.text);
                              },
                              typekeyboard: TextInputType.number,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: TextFieldMobile2(
                              maxline: 1,
                              label: 'Service',
                              controller: service,
                              onChanged: (String value) {
                                print(service.text);
                              },
                              typekeyboard: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
          ),
          ElevatedButton(
              onPressed: () async {
                await ClassApi.checkStock(
                       widget.data.itemcode!, dbname,'')
                    .then((value) async {
                  if (value.first.trackstock == 1
                      ? value.first.stock! - qty >= -1
                      : 9999999 - qty >= -1) {
                    await ClassApi.updatePosDetail(
                            IafjrndtClass(
                              ratecostamt: widget.data.ratecostamt,
                              totalcost: widget.data.rateamtitem!*qty,
                                createdt: widget.data.createdt,
                                pricelist: widget.data.pricelist,
                                active: widget.data.active,
                                trdt: widget.data.trdt,
                                transno: widget.data.transno,
                                split: widget.data.split,
                                multiprice: widget.data.multiprice,
                                salestype: widget.data.salestype,
                                typ: widget.data.typ,
                                optioncode: widget.data.optioncode,
                                havecond: widget.data.havecond,
                                itemcode: widget.data.itemcode,
                                description: widget.editdesc.text,
                                qty: qty.toInt(),
                                rateamtitem: int.parse(widget.editamount.text),
                                discamt: discbyamount == true
                                    ? (discountamount.text == ''
                                        ? 0
                                        : qty.toInt() *
                                            num.parse(discountamount.text))
                                    : (qty.toInt() *
                                        (int.parse(widget.editamount.text) *
                                            num.parse(discountpct.text == ''
                                                ? '0'
                                                : discountpct.text) /
                                            100)),
                                discpct: discountpct.text == ''
                                    ? 0
                                    : num.parse(discountpct.text),
                                taxpct:
                                    tax.text == '' ? 0 : num.parse(tax.text),
                                svchgpct: service.text == ''
                                    ? 0
                                    : num.parse(service.text),
                                revenueamt: (qty.toInt() * int.parse(widget.editamount.text)) -
                                    (discbyamount == true
                                        ? (discountamount.text == ''
                                            ? 0
                                            : qty.toInt() *
                                                num.parse(discountamount.text))
                                        : (qty.toInt() *
                                            (int.parse(widget.editamount.text) *
                                                num.parse(discountpct.text == ''
                                                    ? '0'
                                                    : discountpct.text) /
                                                100))),
                                taxamt: ((qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) *
                                    (tax.text == ''
                                        ? 0
                                        : num.parse(tax.text) / 100),
                                serviceamt: ((qty.toInt() * int.parse(widget.editamount.text)) -
                                        (discbyamount == true
                                            ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text))
                                            : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) *
                                    (service.text == '' ? 0 : num.parse(service.text) / 100),
                                totalaftdisc: (qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100))) + ((qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) * (service.text == '' ? 0 : num.parse(service.text) / 100) + ((qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) * (tax.text == '' ? 0 : num.parse(tax.text) / 100),
                                id: widget.data.id),
                            pscd)
                        .whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Stok barang tidak sesuai",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Text(
                  'Simpan',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
        ],
      ),
    );
  }
}
