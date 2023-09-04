// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classdialogvoidtab.dart';
import 'package:posq/classui/payment/classpaymentsuccessmobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class PaymentCashV2Mobile extends StatefulWidget {
  final TextEditingController amountcash;
  final num balance;
  final int lastsplit;
  final String? trno;
  final String? pscd;
  final Outlet outletinfo;
  late num result;
  late bool zerobill;
  final Function callback;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final bool fromsplit;
  final String guestname;

  PaymentCashV2Mobile(
      {Key? key,
      required this.amountcash,
      required this.balance,
      this.trno,
      this.pscd,
      required this.result,
      required this.zerobill,
      required this.outletinfo,
      required this.callback,
      required this.datatrans,
      required this.fromsaved,
      required this.lastsplit,
      required this.fromsplit,
      required this.guestname})
      : super(key: key);

  @override
  State<PaymentCashV2Mobile> createState() => _PaymentCashV2MobileState();
}

class _PaymentCashV2MobileState extends State<PaymentCashV2Mobile> {
  List amount = [];

  bool uangpas = false;
  late DatabaseHandler handler;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  bool paymentenable = true;
  generateSugestion(List Amount) {
    if (widget.balance >= 1000 && widget.balance <= 10000) {
      setState(() {
        amount.add([1000, 2000, 5000, 10000, 20000, 50000, 100000]);
      });
    } else if (widget.balance >= 10000 && widget.balance <= 10000) {
      setState(() {
        amount.add([10000, 20000, 50000, 100000]);
      });
    } else if (widget.balance >= 100000 && widget.balance <= 100000) {
      setState(() {
        amount.add([50000, 100000]);
      });
    }
  }

  functionCheckPayEnable() async {
    paymentenable = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.amountcash.addListener(() {});
    print(widget.datatrans);

    print(widget.balance);
    if (widget.balance > 25000) {
      amount = ['${widget.balance}', 25000, 30000];
    } else if (widget.balance > 75000) {
      amount = ['${widget.balance}', 80000, 100000];
    } else if (widget.balance > 55000) {
      amount = ['${widget.balance}', 55000, 100000];
    } else if (widget.balance > 25000) {
      amount = ['${widget.balance}', 30000, 35000];
    }
    print(widget.balance < 75000 && widget.balance > 80000);

    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    formattedDate = formatter.format(now);

    widget.result = widget.balance;
    checkcontroller();
  }

  checkcontroller() {
    print(widget.amountcash.selection.start);
    if (widget.amountcash.selection.start == 0 ||
        widget.amountcash.selection.start == -1) {
      setState(() {
        uangpas = true;
      });
    } else {
      setState(() {
        uangpas = false;
      });
    }
  }

  // ignore: unused_field
  bool _isButtonDisabled = false;

  // ignore: unused_element
  void _handleButtonTap() {
    setState(() {
      _isButtonDisabled = true;
    });
    // Perform the action that the button triggers here
  }

  pesanPaymentTersimpan() {
    Toast.show("Payment Tersimpan",
        duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  pesanResult() {
    Toast.show(widget.result.toString(),
        duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  Future<dynamic> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: widget.trno!,
        split: widget.lastsplit,
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: '',
        pax: '1',
        pymtmthd: 'CASH',
        ftotamt: double.parse(widget.amountcash.text),
        totalamt: double.parse(widget.amountcash.text),
        framtrmn: double.parse(widget.amountcash.text),
        amtrmn: double.parse(widget.amountcash.text),
        trdesc: 'Payment cash ',
        trdesc2: 'Payment cash',
        compcd: 'CASH',
        compdesc: 'CASH',
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, dbname);
  }

  Future<dynamic> insertIafjrnhdRefundMode() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: widget.trno!,
        split: widget.lastsplit,
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: '',
        pax: '1',
        pymtmthd: 'CASH',
        ftotamt: double.parse(widget.amountcash.text),
        totalamt: double.parse(widget.amountcash.text),
        framtrmn: double.parse(widget.amountcash.text),
        amtrmn: double.parse(widget.amountcash.text),
        trdesc: 'refund mode',
        trdesc2: 'refund mode',
        compcd: 'CASH',
        compdesc: 'CASH',
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, dbname);
  }

  Future<dynamic> insertIafjrnhdRefund() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: widget.trno!,
        split: widget.lastsplit,
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: '',
        pax: '1',
        pymtmthd: 'REFUND',
        ftotamt: widget.result.toDouble(),
        totalamt: widget.result.toDouble(),
        framtrmn: widget.result.toDouble(),
        amtrmn: widget.result.toDouble(),
        compcd: 'REFUND',
        compdesc: 'REFUND',
        trdesc: 'Refund cash ',
        trdesc2: 'Refund cash ',
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, dbname);
  }

  Future<dynamic> insertIafjrnhdRefundRefunMode() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: widget.trno!,
        split: widget.lastsplit,
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: '',
        pax: '1',
        pymtmthd: 'REFUND',
        ftotamt: -widget.result.toDouble(),
        totalamt: -widget.result.toDouble(),
        framtrmn: -widget.result.toDouble(),
        amtrmn: -widget.result.toDouble(),
        compcd: 'REFUND',
        compdesc: 'REFUND',
        trdesc: 'refund mode',
        trdesc2: 'Refund cash ',
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, dbname);
  }

  String formatToIDR(String value) {
    var amount = double.tryParse(value);
    if (amount != null) {
      var formatter = NumberFormat.currency(
        locale: 'id_IDR',
        symbol: 'Rp',
        decimalDigits: 0,
      );

      formatter = NumberFormat('#,###', 'id_IDR');

      return formatter.format(amount);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
          width: MediaQuery.of(context).size.width * 0.80,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: TextFieldMobile2(
            label: 'Nominal',
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.07,
            typekeyboard: TextInputType.number,
            controller: widget.amountcash,
            onChanged: (String value) {
              checkcontroller();
              setState(() {
                widget.result = widget.balance - num.parse(value);
              });
              print(widget.result);
              pesanResult();
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
          width: MediaQuery.of(context).size.width * 0.80,
        ),
        uangpas == true
            ? ButtonNoIcon(
                width: MediaQuery.of(context).size.height * 0.39,
                height: MediaQuery.of(context).size.height * 0.05,
                textcolor: Colors.white,
                name: 'Uang Pas',
                color: AppColors.primaryColor,
                onpressed: () {
                  checkcontroller();
                  setState(() {
                    widget.amountcash.text = widget.balance.toString();
                    widget.amountcash.selection.start;
                    uangpas = false;
                  });
                },
              )
            : ButtonNoIcon(
                width: MediaQuery.of(context).size.height * 0.39,
                height: MediaQuery.of(context).size.height * 0.05,
                textcolor: Colors.white,
                name: 'Terima',
                color: AppColors.primaryColor,
                //// checking balance //////
                onpressed: paymentenable == true ||
                        widget.result <= 0 ||
                        widget.result == 0
                    ? () async {
                        // await functionCheckPayEnable();
                        if (refundmode == false) {
                          if (paymentenable == true) {
                            paymentenable = false;
                            await insertIafjrnhd().whenComplete(() {
                              setState(() {});
                            });
                          }
                        } else {
                          await insertIafjrnhdRefundMode().whenComplete(() {
                            setState(() {});
                          });
                        }

                        pesanPaymentTersimpan();
                        if (widget.result == 0) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassPaymetSucsessMobile(
                                      guestname: widget.guestname,
                                      fromsplit: widget.fromsplit,
                                      fromsaved: widget.fromsaved,
                                      datatrans: widget.datatrans,
                                      frombanktransfer: false,
                                      cash: true,
                                      outletinfo: widget.outletinfo,
                                      outletname: widget.outletinfo.outletname,
                                      outletcd: widget.pscd,
                                      amount:
                                          double.parse(widget.amountcash.text),
                                      paymenttype: 'Cash',
                                      trno: widget.trno.toString(),
                                      trdt: formattedDate,
                                    )),
                          );
                        }

                        await widget.callback();
                        if (widget.result < 0) {
                          //// jika amount lebih kecil dari amount akan otomatsi refund

                          if (strictuser == '1') {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Builder(builder: (context) {
                                  return PasswordDialog(
                                    guestname: widget.guestname,
                                    frompaymentmobile: true,
                                    outletcd: pscd,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletinfo.outletname,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    fromsplit: widget.fromsplit,
                                    trno: widget.trno,
                                    balance: widget.balance,
                                    result: widget.result,
                                    insertIafjrnhd: insertIafjrnhd,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    frompayment: true,
                                    dialogcancel: false,
                                    pymtmthd: 'CASH',
                                    controller: widget.amountcash,
                                    onPasswordEntered: (String password) async {
                                      print('Entered password: $password');
                                      // await insertIafjrnhdRefund()
                                      //     .then((_) async {});
                                      await ClassApi.getSumPyTrno(
                                              widget.trno.toString())
                                          .then((value) {
                                        setState(() {
                                          widget.result = value[0]['totalamt'];
                                        });
                                      });
                                      // Lakukan sesuatu dengan password yang dimasukkan di sini
                                    },
                                  );
                                });
                              },
                            );
                          } else {
                            if (refundmode == false) {
                              insertIafjrnhdRefund();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassPaymetSucsessMobile(
                                          guestname: widget.guestname,
                                          fromsplit: widget.fromsplit,
                                          fromsaved: widget.fromsaved,
                                          datatrans: widget.datatrans,
                                          frombanktransfer: false,
                                          cash: true,
                                          outletinfo: widget.outletinfo,
                                          outletname:
                                              widget.outletinfo.outletname,
                                          outletcd: widget.pscd,
                                          amount: double.parse(
                                              widget.amountcash.text),
                                          paymenttype: 'CASH',
                                          trno: widget.trno.toString(),
                                          trdt: formattedDate,
                                        )),
                              );
                            } else {
                              insertIafjrnhdRefundRefunMode();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassPaymetSucsessMobile(
                                          guestname: widget.guestname,
                                          fromsplit: widget.fromsplit,
                                          fromsaved: widget.fromsaved,
                                          datatrans: widget.datatrans,
                                          frombanktransfer: false,
                                          cash: true,
                                          outletinfo: widget.outletinfo,
                                          outletname:
                                              widget.outletinfo.outletname,
                                          outletcd: widget.pscd,
                                          amount: double.parse(
                                              widget.amountcash.text),
                                          paymenttype: 'CASH',
                                          trno: widget.trno.toString(),
                                          trdt: formattedDate,
                                        )),
                              );
                            }
                          }

                          await widget.callback();
                          setState(() {});
                        }

                        print('oke');
                      }
                    : null,
              ),
        // Container(
        //   height: MediaQuery.of(context).size.height * 0.2,
        //   width: MediaQuery.of(context).size.width * 0.80,
        //   child: GridView.builder(
        //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        //           maxCrossAxisExtent: 80,
        //           childAspectRatio: 3 / 2,
        //           crossAxisSpacing: 5,
        //           mainAxisSpacing: 5),
        //       itemCount: amount.length,
        //       itemBuilder: (BuildContext ctx, index) {
        //         return Container(
        //           alignment: Alignment.center,
        //           child: Text(
        //             amount[index].toString(),
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           decoration: BoxDecoration(
        //               color: AppColors.primaryColor,
        //               borderRadius: BorderRadius.circular(15)),
        //         );
        //       }),
        // ),
      ],
    );
  }
}
