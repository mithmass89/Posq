// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/classpaymentsuccessmobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class PaymentCashMobile extends StatefulWidget {
  final Outlet outletinfo;
  final TextEditingController amount;
  late TextEditingController discountamount;
  late TextEditingController discpct;
  late bool? balancenotzero;
  late num? result;
  final String? trno;
  final String? pscd;
  final String? guestname;
  final bool? discbyamount;
  late num? hasildiscpct;
  final int? balance;
  final String? outletname;

  PaymentCashMobile({
    Key? key,
    this.balance,
    this.balancenotzero,
    this.result,
    required this.discpct,
    required this.amount,
    required this.discountamount,
    required this.trno,
    required this.pscd,
    this.guestname,
    this.discbyamount,
    this.hasildiscpct,
    required this.outletname,
    required this.outletinfo,
  }) : super(key: key);

  @override
  State<PaymentCashMobile> createState() => _PaymentCashMobileState();
}

class _PaymentCashMobileState extends State<PaymentCashMobile> {
  List recomendation = ['10000', '15000', '20000', '50000'];
  bool uangpas = true;
  num discount = 0;
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  bool paymentsuccess = false;

  @override
  void initState() {
    widget.amount.addListener(() {});
    widget.discountamount.addListener(() {});
    widget.discpct.addListener(() {});
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    formattedDate = formatter.format(now);
  }

  //   @override
  // void dispose() {
  //   widget.amount.dispose();
  //   // _pc.close();
  //   super.dispose();
  // }

  checkDiscount() {
    if (widget.discountamount.text == '') {
      setState(() {
        widget.discountamount.text = discount.toString();
      });
    }
  }

  checkcontroller() {
    if (widget.amount.selection.start == 0 ||
        widget.amount.selection.start == -1) {
      setState(() {
        uangpas = true;
      });
    } else {
      setState(() {
        uangpas = false;
      });
    }
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        trno: '${widget.trno}',
        split: 'A',
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
        pax: '1',
        pymtmthd: 'CASH',
        ftotamt: double.parse(widget.amount.text),
        totalamt: double.parse(widget.amount.text),
        framtrmn: double.parse(widget.amount.text),
        amtrmn: double.parse(widget.amount.text),
        trdesc: 'Payment cash ${widget.trno}',
        trdesc2: 'Payment cash ${widget.trno}',
        compcd: 'CASH',
        compdesc: 'CASH',
        active: '1',
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    List<IafjrnhdClass> listiafjrnhd = [iafjrnhd];
    print(iafjrnhd);
    return await handler.insertIafjrnhd(listiafjrnhd);
  }

  Pesangagal() {
    Toast.show("Payment and balance not match",
        duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  Future<int> insertIafjrnhdRefund() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        trno: '${widget.trno}',
        split: 'A',
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: widget.discbyamount == true ? 'REFUND' : 'REFUND',
        pax: '1',
        pymtmthd: 'CASH',
        ftotamt: widget.result!.toDouble(),
        totalamt: widget.result!.toDouble(),
        framtrmn: widget.result!.toDouble(),
        amtrmn: widget.result!.toDouble(),
        compcd: 'CASH',
        compdesc: 'REFUND',
        trdesc: 'Refund cash ${widget.trno}',
        trdesc2: 'Refund cash ${widget.trno}',
        active: '1',
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    List<IafjrnhdClass> listiafjrnhd = [iafjrnhd];
    return await handler.insertIafjrnhd(listiafjrnhd);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
          width: MediaQuery.of(context).size.width * 0.85,
        ),
        // Center(
        //   child: SizedBox(
        //     height: MediaQuery.of(context).size.height * 0.03,
        //     // width: MediaQuery.of(context).size.width * 0.85,
        //     child: const Text('Uang Diterima',
        //         style: TextStyle(color: Colors.blue, fontSize: 20)),
        //   ),
        // ),
        Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            child: TextFieldMobileCustome(
              maxline: 1,
              outline: 0,
              label: 'Uang Diterima',
              validator: (value) {
                if (widget.discbyamount == true) {
                  checkcontroller();

                  setState(() {
                    widget.result = widget.balance! -
                        int.parse(value) -
                        int.parse(widget.discountamount.text);
                  });
                } else {
                  checkcontroller();
                  setState(() {
                    widget.result = widget.balance! -
                        (widget.balance! *
                            int.parse(widget.discpct.text) /
                            100) -
                        int.parse(value);
                  });
                }
              },
              controller: widget.amount,
              onChanged: (String value) {
                if (widget.discbyamount == true) {
                  checkcontroller();
                  setState(() {
                    widget.result = widget.balance! -
                        int.parse(value) -
                        int.parse(widget.discountamount.text);
                  });
                } else if (widget.discbyamount == false) {
                  checkcontroller();
                  setState(() {
                    widget.result = widget.balance! -
                        (widget.balance! *
                            int.parse(widget.discpct.text) /
                            100) -
                        int.parse(value);
                  });
                }
                print(widget.result);
                print(widget.discountamount.text);
              },
              // onSumbit: null,
              // onsave: null,
              typekeyboard: TextInputType.number,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
          width: MediaQuery.of(context).size.width * 0.85,
        ),
        uangpas == true
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    widget.amount.text = widget.balance.toString();
                    uangpas = false;
                    widget.result = 0;
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent),
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      'Uang Pas',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )))
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.result! == 0 || widget.result! <= 0
                    // widget.balance == widget.result ||
                    // widget.result! >= widget.balance!
                    ? () async {
                        if (widget.result! == 0) {
                          await insertIafjrnhd().whenComplete(() {
                            print('tanpa refund');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClassPaymetSucsessMobile(
                                
                                        frombanktransfer: false,
                                        cash: true,
                                        outletinfo: widget.outletinfo,
                                        outletname: widget.outletname,
                                        outletcd: widget.pscd,
                                        amount:
                                            double.parse(widget.amount.text),
                                        paymenttype: 'Cash',
                                        trno: widget.trno.toString(),
                                        trdt: formattedDate,
                                      )),
                            );
                          });
                        } else if (widget.result! <= 0) {
                          await insertIafjrnhd().whenComplete(() async {
                            await insertIafjrnhdRefund();
                            print('refund transaksi');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClassPaymetSucsessMobile(
                                  
                                        frombanktransfer: false,
                                        cash: true,
                                        outletinfo: widget.outletinfo,
                                        outletname: widget.outletname,
                                        outletcd: widget.pscd,
                                        amount:
                                            double.parse(widget.amount.text),
                                        paymenttype: 'Cash',
                                        trno: widget.trno.toString(),
                                        trdt: formattedDate,
                                      )),
                            );
                          });
                        }
                      }
                    : null,
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent),
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      'Terima',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))),
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.80,
          child: GridView.builder(
              itemCount: recomendation.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 6 / 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1),
              itemBuilder: (context, index) {
                return Container(
                  child: TextButton(
                      onPressed: () {}, child: Text(recomendation[index])),
                );
              }),
        )
      ],
    );
  }
}
