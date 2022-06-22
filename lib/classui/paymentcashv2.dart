import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classpaymentsuccessmobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:toast/toast.dart';

class PaymentCashV2Mobile extends StatefulWidget {
  final TextEditingController amountcash;
  final num balance;
  final String? trno;
  final String? pscd;
  final Outlet outletinfo;
  late num result;
  late bool zerobill;
  final Function callback;

  PaymentCashV2Mobile(
      {Key? key,
      required this.amountcash,
      required this.balance,
      this.trno,
      this.pscd,
      required this.result,
      required this.zerobill,
      required this.outletinfo,
      required this.callback})
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

  // checkbalance() async {
  //   await handler.summaryPayment(widget.trno.toString()).then((value) {
  //     if (value.first.totalamt==null) {
  //       setState(() {
  //         widget.result = widget.balance - value.first.totalamt!;
  //       });
  //     }
  //     if (widget.result == 0 || widget.result < 0) {
  //       setState(() {
  //         widget.zerobill = true;
  //       });
  //     } else {
  //       setState(() {
  //         widget.zerobill = false;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    widget.amountcash.addListener(() {});

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
    handler.initializeDB();
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

  pesanPaymentTersimpan() {
    Toast.show("Payment Tersimpan",
        duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  pesanResult() {
    Toast.show(widget.result.toString(),
        duration: Toast.lengthShort, gravity: Toast.bottom);
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        trno: '${widget.trno}',
        split: 'A',
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: '',
        pax: '1',
        pymtmthd: 'CASH',
        ftotamt: double.parse(widget.amountcash.text),
        totalamt: double.parse(widget.amountcash.text),
        framtrmn: double.parse(widget.amountcash.text),
        amtrmn: double.parse(widget.amountcash.text),
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

  Future<int> insertIafjrnhdRefund() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        trno: '${widget.trno}',
        split: 'A',
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: '',
        pax: '1',
        pymtmthd: 'CASH',
        ftotamt: widget.result.toDouble(),
        totalamt: widget.result.toDouble(),
        framtrmn: widget.result.toDouble(),
        amtrmn: widget.result.toDouble(),
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
                color: Colors.blue,
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
                color: Colors.blue,
                //// checking balance //////
                onpressed: widget.result <= 0 || widget.result == 0
                    ? () async {
                        if ( widget.result == 0)
                          await insertIafjrnhd().whenComplete(() {
                            setState(() {});
                          });
                        pesanPaymentTersimpan();
                        if (widget.result == 0) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassPaymetSucsessMobile(
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
                          await insertIafjrnhd().whenComplete(() async {
                            await insertIafjrnhdRefund().then((_) {}).then((_) {
                              handler
                                  .summaryPayment(widget.trno.toString())
                                  .then((value) {
                                setState(() {
                                  widget.result = value.first.totalamt!;
                                });
                              });
                            });
                          });
                          await widget.callback();
                          setState(() {});
                        }

                        print('oke');
                      }
                    : null,
              ),
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.80,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemCount: amount.length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    amount[index].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                );
              }),
        ),
      ],
    );
  }
}
