// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/classdetailtransactionmobile.dart';
import 'package:posq/userinfo.dart';

PaymentGate? paymentapi;

class DetailTrno extends StatefulWidget {
  final Outlet outletinfo;
  final String pscd;
  final String? trno;
  final IafjrnhdClass? datatransaksi;
  final bool fromsaved;
  final Function setter;

  const DetailTrno({
    Key? key,
    this.trno,
    this.datatransaksi,
    required this.outletinfo,
    required this.pscd,
    required this.fromsaved,
    required this.setter,
  }) : super(key: key);

  @override
  State<DetailTrno> createState() => _DetailTrnoState();
}

class _DetailTrnoState extends State<DetailTrno> {
  bool pending = true;
  String? statustransaction = 'PENDING';

  @override
  void initState() {
    super.initState();
    paymentapi = PaymentGate();
  }

  Stream<String> _statustransaksi() async* {
    if (widget.datatransaksi!.pymtmthd != 'CASH') {
      PaymentGate.getStatusTransaction(widget.datatransaksi!.docno!)
          .then((value) {
        print(value);
        setState(() {
          statustransaction = value;
        });
      });
    } else {
      setState(() {
        statustransaction = 'Lunas';
      });
    }
    // This loop will run forever because _running is always true
  }

  Color _getColorByEventtext(String event) {
    if (statustransaction == "Lunas") return Colors.green;
    if (statustransaction == "pending") return Colors.red;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _statustransaksi(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Column(
            children: [
              Card(
                child: ListTile(
                  dense: true,
                  leading: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.17,
                      child: Text(widget.datatransaksi!.pymtmthd == null
                          ? ' NT'
                          : widget.datatransaksi!.pymtmthd.toString())),
                  title: Text(widget.trno!),
                  subtitle: Text(widget.datatransaksi!.totalamt == null
                      ? '0'
                      : CurrencyFormat.convertToIdr(
                          widget.datatransaksi!.totalamt, 0)),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            statustransaction == null
                                ? 'No Settle yet'
                                : statustransaction.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getColorByEventtext(
                                    statustransaction.toString())),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: accesslistuser.contains('refund') ==
                                        true
                                    ? () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogRefund(
                                              fromsaved: widget.fromsaved,
                                              outletcd: pscd,
                                              outletinfo: widget.outletinfo,
                                              trno: widget.trno!,
                                            );
                                          },
                                        );

                                        widget.setter()!;
                                        setState(() {});
                                      }
                                    : () {
                                        Fluttertoast.showToast(
                                            msg: "Tidak punya access refund",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromARGB(255, 11, 12, 14),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      },
                                icon: Icon(Icons.money_off_csred))),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassDetailTransMobile(
                                fromsaved: widget.fromsaved,
                                status: statustransaction == null
                                    ? 'Belum Lunas'
                                    : statustransaction!,
                                datatransaksi: widget.datatransaksi,
                                trno: widget.trno.toString(),
                                outletinfo: widget.outletinfo,
                                pscd: widget.pscd,
                              )),
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}
