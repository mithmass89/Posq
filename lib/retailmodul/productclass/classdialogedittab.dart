import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/payment/paymenttablet/dialogclasspayment.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class DialogEditTab extends StatefulWidget {
  final String? title;
  late TextEditingController editdesc;
  final TextEditingController editamount;
  final TextEditingController editqty;
  late TextEditingController note;
  final IafjrndtClass data;
  final Function? updatedata;
  DialogEditTab({
    Key? key,
    this.title,
    required this.editdesc,
    required this.editamount,
    required this.note,
    required this.editqty,
    required this.data,
    this.updatedata,
  }) : super(key: key);

  @override
  State<DialogEditTab> createState() => _DialogEditTabStateState();
}

class _DialogEditTabStateState extends State<DialogEditTab> {
  final GlobalKey<FormState> _formKeysedit = GlobalKey<FormState>();
  TextEditingController discountpct = TextEditingController(text: '0');
  TextEditingController discountamount = TextEditingController(text: '0');
  TextEditingController tax = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController biayalain = TextEditingController(text: '0');
  num qty = 0;

  late IafjrndtClass hasil;
  num pcttax = 0;
  num pctservice = 0;
  bool usetaxservice = false;
  bool discbyamount = true;

  @override
  void initState() {
    super.initState();
    qty = num.parse(widget.data.qty.toString());
    widget.editdesc.text = widget.data.itemdesc!;
    widget.editamount.text = widget.data.rateamtitem.toString();
    widget.editqty.text = qty.toString();

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

        discbyamount = false;
        discountamount.text = widget.data.discamt.toString();
        discountpct.text = widget.data.discpct.toString();
      });
    } else if (widget.data.discpct == 0 && widget.data.discamt != 0) {
      setState(() {
        discbyamount = true;
        discountamount.text = widget.data.discamt.toString();
        discountpct.text = widget.data.discpct.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            Text('Edit Barang'),
          ],
        ),
        content: Column(
          children: [
            Form(
                key: _formKeysedit,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.53,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
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
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              )),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.width * 0.09,
                            child: TextFieldMobile2(
                              maxline: 1,
                              controller: widget.editqty,
                              onChanged: (String value) {
                                qty = num.parse(widget.editqty.text);
                                widget.data.rateamtitem! *
                                    int.parse(widget.editqty.text);
                                setState(() {});
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
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              )),
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(
                                    (widget.data.rateamtitem! *
                                        int.parse(widget.editqty.text)),
                                    0),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextFieldMobile2(
                        maxline: 1,
                        label: 'Catatan',
                        controller: widget.note,
                        onChanged: (value) {
                          setState(() {});
                        },
                        typekeyboard: TextInputType.number,
                      ),
                      AnimatedContainer(
                        height: MediaQuery.of(context).size.height * 0.30,
                        curve: Curves.linear,
                        duration: Duration(milliseconds: 100),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                discbyamount == true
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.13,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
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
                                            MediaQuery.of(context).size.height *
                                                0.13,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
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
                                Spacer(),
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
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              // borderRadius:
                                              //     BorderRadius.all(Radius.circular(20)),
                                              color: discbyamount == true
                                                  ? AppColors.primaryColor
                                                  : Colors.white),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
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
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                color: discbyamount == false
                                                    ? AppColors.primaryColor
                                                    : Colors.white),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
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
                            //        SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.06,
                            //   width: MediaQuery.of(context).size.width * 0.01,
                            // ),

                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
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
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.primaryColor // Background color
                  ),
              onPressed: () async {
                print('oke');
                await ClassApi.checkStock(widget.data.itemcode!, dbname, '')
                    .then((value) async {
                  if (value.first.trackstock == 1
                      ? value.first.stock! - qty >= -1
                      : 9999999 - qty >= -1) {
                    await ClassApi.updatePosDetail(
                            IafjrndtClass(
                              ratecostamt: widget.data.ratecostamt,
                            totalcost:  qty.toInt()*widget.data.ratecostamt,
                                note: widget.note.text,
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
                                rateamtitem: int.parse(widget.editamount.text
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
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
                                revenueamt: (qty.toInt() *
                                        int.parse(widget.editamount.text)) -
                                    (discbyamount == true
                                        ? (discountamount.text == ''
                                            ? 0
                                            : qty.toInt() *
                                                num.parse(discountamount.text))
                                        : (qty.toInt() *
                                            (int.parse(widget.editamount.text) *
                                                num.parse(discountpct.text == '' ? '0' : discountpct.text) /
                                                100))),
                                taxamt: ((qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) * (tax.text == '' ? 0 : num.parse(tax.text) / 100),
                                serviceamt: ((qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) * (service.text == '' ? 0 : num.parse(service.text) / 100),
                                totalaftdisc: (qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100))) + ((qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) * (service.text == '' ? 0 : num.parse(service.text) / 100) + ((qty.toInt() * int.parse(widget.editamount.text)) - (discbyamount == true ? (discountamount.text == '' ? 0 : qty.toInt() * num.parse(discountamount.text)) : (qty.toInt() * (int.parse(widget.editamount.text) * num.parse(discountpct.text == '' ? '0' : discountpct.text) / 100)))) * (tax.text == '' ? 0 : num.parse(tax.text) / 100),
                                id: widget.data.id),
                            pscd)
                        .whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Stok tidak sesuai",
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
                width: MediaQuery.of(context).size.width * 0.1,
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      );
    });
  }
}
