// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/payment/paymenttablet/paymentsuccesstab.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class PaymentDebitTabs extends StatefulWidget {
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
  final Function? selectedpayment;
  late String pymtmthd;
  final List<String> paymentlist;
  late num? result;
  final bool fromsplit;
  late String selectedpay;
  final String guestname;
  PaymentDebitTabs(
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
      required this.selectedpay,
      this.insertIafjrnhdRefund,
      this.insertIafjrnhd,
      required this.pymtmthd,
      required this.result,
      required this.paymentlist,
      required this.fromsplit,
      required this.selectedpayment,
      required this.guestname})
      : super(key: key);

  @override
  State<PaymentDebitTabs> createState() => _PaymentDebitTabsState();
}

class _PaymentDebitTabsState extends State<PaymentDebitTabs> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  String selected = '';

  @override
  void initState() {
    widget.debitcontroller.text = widget.balance.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.4,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: widget.paymentlist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = widget.paymentlist[index];
                      widget.pymtmthd = selected;
                    });
                  },
                  child: Card(
                    child: Container(
                        decoration: BoxDecoration(
                            color: selected == widget.paymentlist[index]
                                ? Color.fromARGB(255, 0, 147, 167)
                                : Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        alignment: Alignment.center,
                        child: Text(
                          widget.paymentlist[index],
                          style: TextStyle(
                              color: selected == widget.paymentlist[index]
                                  ? Colors.white
                                  : Colors.black),
                        )),
                  ),
                );
              }),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.36,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Info tambahan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.29,
                    child: TextFieldTab2(
                      hint: 'Card No',
                      controller: widget.cardno,
                      onChanged: (String value) {},
                      typekeyboard: null,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.29,
                    child: TextFieldTab2(
                      hint: 'Expired',
                      controller: widget.cardexp,
                      onChanged: (String value) {},
                      typekeyboard: null,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // <-- Radius
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor: AppColors.primaryColor
                              // Background color
                              ),
                          onPressed: () async {
                            widget.selectedpay = selected;
                            widget.selectedpayment!(selected);
                            await widget.insertIafjrnhd!()
                                .whenComplete(() async {
                              await ClassApi.getSumPyTrno(
                                      widget.trno.toString())
                                  .then((value) {
                                setState(() {
                                  widget.result =
                                      widget.balance - value[0]['totalamt'];
                                });
                              }).whenComplete(() {
                                if (widget.result!.isNegative) {
                                  if (refundmode == false) {
                                    widget.insertIafjrnhdRefund!()
                                        .whenComplete(() {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClassPaymetSucsessTabs(
                                                    guestname: widget.guestname,
                                                    fromsplit: widget.fromsplit,
                                                    fromsaved: widget.fromsaved,
                                                    datatrans: widget.datatrans,
                                                    frombanktransfer: false,
                                                    cash: true,
                                                    outletinfo:
                                                        widget.outletinfo,
                                                    outletname:
                                                        widget.outletname,
                                                    outletcd: widget.pscd,
                                                    amount:
                                                        NumberFormat.currency(
                                                                locale: 'id_ID',
                                                                symbol: 'Rp')
                                                            .parse(widget
                                                                .debitcontroller
                                                                .text)
                                                            .toInt(),
                                                    paymenttype:
                                                        widget.pymtmthd,
                                                    trno:
                                                        widget.trno.toString(),
                                                    trdt: formattedDate,
                                                  )));
                                    });
                                  } else {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClassPaymetSucsessTabs(
                                                  guestname: widget.guestname,
                                                  fromsplit: widget.fromsplit,
                                                  fromsaved: widget.fromsaved,
                                                  datatrans: widget.datatrans,
                                                  frombanktransfer: false,
                                                  cash: true,
                                                  outletinfo: widget.outletinfo,
                                                  outletname: widget.outletname,
                                                  outletcd: widget.pscd,
                                                  amount: NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: 'Rp')
                                                      .parse(widget
                                                          .debitcontroller.text)
                                                      .toInt(),
                                                  paymenttype: widget.pymtmthd,
                                                  trno: widget.trno.toString(),
                                                  trdt: formattedDate,
                                                )));
                                  }
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClassPaymetSucsessTabs(
                                                guestname: widget.guestname,
                                                fromsplit: widget.fromsplit,
                                                fromsaved: widget.fromsaved,
                                                datatrans: widget.datatrans,
                                                frombanktransfer: false,
                                                cash: true,
                                                outletinfo: widget.outletinfo,
                                                outletname: widget.outletname,
                                                outletcd: widget.pscd,
                                                amount: NumberFormat.currency(
                                                        locale: 'id_ID',
                                                        symbol: 'Rp')
                                                    .parse(widget
                                                        .debitcontroller.text)
                                                    .toInt(),
                                                paymenttype: widget.pymtmthd,
                                                trno: widget.trno.toString(),
                                                trdt: formattedDate,
                                              )));
                                }
                              });
                            });
                          },
                          child: Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
