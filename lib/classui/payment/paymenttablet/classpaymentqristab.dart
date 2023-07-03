// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/payment/paymenttablet/paymentsuccesstab.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClassPaymentQrisTab extends StatefulWidget {
  final String trno;
  final String pscd;
  final String trdt;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  late TextEditingController debitcontroller;
  late TextEditingController cardno;
  late TextEditingController cardexp;
  final List<IafjrndtClass> listdata = [];
  final Function? insertIafjrnhdRefund;
  final Function? insertIafjrnhd;
  late String pymtmthd;
  final List<String> paymentlist;
  late num? result;
  late String selectedpay;
  final Function? selectedpayment;
  late String qr;
  final List<Midtransitem> listitem;
  final String trnoqr;
  final bool fromsplit;
  final String guestname;

  ClassPaymentQrisTab(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.trdt,
      required this.balance,
      required this.debitcontroller,
      required this.cardno,
      required this.cardexp,
      this.outletname,
      this.outletinfo,
      required this.datatrans,
      required this.fromsaved,
      this.insertIafjrnhdRefund,
      this.insertIafjrnhd,
      required this.pymtmthd,
      required this.selectedpay,
      required this.result,
      required this.paymentlist,
      required this.selectedpayment,
      required this.qr,
      required this.listitem,
      required this.trnoqr,
      required this.fromsplit,
      required this.guestname})
      : super(key: key);

  @override
  State<ClassPaymentQrisTab> createState() => _ClassPaymentQrisTabState();
}

class _ClassPaymentQrisTabState extends State<ClassPaymentQrisTab> {
  bool pending = true;
  String? statustransaction = 'PENDING';
  var nows = DateTime.now();
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;

  ///payment kedouble karena stream

  @override
  void initState() {
    widget.debitcontroller.text = widget.balance.toString();
    super.initState();
  }

  Stream<String> _statustransaksi() async* {
    PaymentGate.getStatusTransaction(widget.trnoqr).then((value) {
      print(value);
      setState(() {
        statustransaction = value;
      });
    });
    if (statustransaction == 'expire') {
      //  reloadqr();
    } else if (statustransaction == 'settlement') {
      statustransaction = 'finish';
      setState(() {});
      await widget.insertIafjrnhd!();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ClassPaymetSucsessTabs(
                    guestname: widget.guestname,
                    fromsplit: widget.fromsplit,
                    fromsaved: widget.fromsaved,
                    datatrans: widget.datatrans,
                    frombanktransfer: false,
                    cash: true,
                    outletinfo: widget.outletinfo,
                    outletname: widget.outletname,
                    outletcd: widget.pscd,
                    amount: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                        .parse(widget.debitcontroller.text)
                        .toInt(),
                    paymenttype: widget.pymtmthd,
                    trno: widget.trno.toString(),
                    trdt: formattedDate,
                  )));
    } else {}
    ;
    // This loop will run forever because _running is always true
  }

  reloadqr() async {
    print(serverkeymidtrans);
    var nows = DateTime.now();
    await PaymentGate.goPayQris(
            'gopay',
            'guestname',
            'email',
            'phone',
            widget.trno.toString() + nows.toString(),
            widget.balance.toString(),
            widget.listitem.toList())
        .then((value) {
      print(value);
      print(widget.trno.toString() + nows.toString());
      if (value['status_code'] != '406') {
        List action = value['actions'];
        setState(() {
          widget.qr = action.first['url'];
        });
      } else {
        Fluttertoast.showToast(
            msg: "Check Intergrasi atau conflict transaksi",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 11, 12, 14),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _statustransaksi(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Status Transaksi: '),
                      Text(statustransaction!),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrImage(
                  data: widget.qr,
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.height * 0.50,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy),
                    iconSize: 20,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.qr.toString()));
                    },
                  ),
                  statustransaction != 'finish'
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await reloadqr();
                                    setState(() {});
                                  },
                                  child: Text('Reload QR'))),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await widget.insertIafjrnhd!()
                                        .whenComplete(() async {
                                      await ClassApi.getSumPyTrno(
                                              widget.trno.toString())
                                          .then((value) {
                                        setState(() {
                                          widget.result = widget.balance -
                                              value[0]['totalamt'];
                                        });
                                      }).whenComplete(() {
                                        if (widget.result!.isNegative) {
                                          widget.insertIafjrnhdRefund!()
                                              .whenComplete(() {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClassPaymetSucsessTabs(
                                                          guestname:
                                                              widget.guestname,
                                                          fromsplit:
                                                              widget.fromsplit,
                                                          fromsaved:
                                                              widget.fromsaved,
                                                          datatrans:
                                                              widget.datatrans,
                                                          frombanktransfer:
                                                              false,
                                                          cash: true,
                                                          outletinfo:
                                                              widget.outletinfo,
                                                          outletname:
                                                              widget.outletname,
                                                          outletcd: widget.pscd,
                                                          amount: NumberFormat
                                                                  .currency(
                                                                      locale:
                                                                          'id_ID',
                                                                      symbol:
                                                                          'Rp')
                                                              .parse(widget
                                                                  .debitcontroller
                                                                  .text)
                                                              .toInt(),
                                                          paymenttype:
                                                              widget.pymtmthd,
                                                          trno: widget.trno
                                                              .toString(),
                                                          trdt: formattedDate,
                                                        )));
                                          });
                                        } else {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClassPaymetSucsessTabs(
                                                        guestname:
                                                            widget.guestname,
                                                        fromsplit:
                                                            widget.fromsplit,
                                                        fromsaved:
                                                            widget.fromsaved,
                                                        datatrans:
                                                            widget.datatrans,
                                                        frombanktransfer: false,
                                                        cash: true,
                                                        outletinfo:
                                                            widget.outletinfo,
                                                        outletname:
                                                            widget.outletname,
                                                        outletcd: widget.pscd,
                                                        amount: NumberFormat
                                                                .currency(
                                                                    locale:
                                                                        'id_ID',
                                                                    symbol:
                                                                        'Rp')
                                                            .parse(widget
                                                                .debitcontroller
                                                                .text)
                                                            .toInt(),
                                                        paymenttype:
                                                            widget.pymtmthd,
                                                        trno: widget.trno
                                                            .toString(),
                                                        trdt: formattedDate,
                                                      )));
                                        }
                                      });
                                    });
                                  },
                                  child: Text('Seleisaikan transaksi'))),
                        ),
                ],
              )
            ],
          );
        });
  }
}
