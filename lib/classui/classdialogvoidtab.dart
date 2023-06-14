import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/payment/classpaymentsuccessmobile.dart';
import 'package:posq/classui/payment/paymenttablet/paymentsuccesstab.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PasswordDialog extends StatefulWidget {
  final bool frompaymentmobile;
  final bool dialogcancel;
  final Function(String password) onPasswordEntered;
  final String? trno;
  final String? outletcd;
  final Outlet? outletinfo;
  final bool? fromsaved;
  final bool frompayment;
  final Function? insertIafjrnhdRefund;
  final Function? insertIafjrnhd;
  late num? result;
  late num? balance;
  final bool? fromsplit;
  final String? pymtmthd;
  final String? outletname;
  final List<IafjrndtClass>? datatrans;
  late TextEditingController? controller;

  PasswordDialog(
      {required this.onPasswordEntered,
      required this.dialogcancel,
      this.trno,
      this.outletcd,
      this.outletinfo,
      this.fromsaved,
      required this.frompayment,
      this.insertIafjrnhdRefund,
      this.insertIafjrnhd,
      this.result,
      this.balance,
      this.fromsplit,
      this.pymtmthd,
      this.datatrans,
      this.controller,
      this.outletname,
      required this.frompaymentmobile});

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  late TextEditingController _passwordController;
  int? trno;
  String? trnolanjut;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  checkTrno() async {
    var transno = await ClassApi.checkTrno();
    trnolanjut = widget.outletcd! + '-' + transno[0]['transnonext'].toString();
    print(trno);
  }

  updateTrno() async {
    if (widget.fromsaved == true) {
      print('trno not update');
      await checkTrno();
    } else {
      await ClassApi.updateTrno(dbname);
      await checkTrno();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Password'),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(hintText: 'Password'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () async {
            if (widget.dialogcancel == true) {
              await ClassApi.getAccessCodevoid(_passwordController.text)
                  .then((value) async {
                if (value.isNotEmpty) {
                  await ClassApi.deactivePosdetailtrans(widget.trno!, dbname);
                  await ClassApi.deactivePosPaymenttrans(widget.trno!, dbname);
                  await ClassApi.deactivePromoTrno(widget.trno!, dbname);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('savecostmrs');
                  await updateTrno();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ClassRetailMainMobile(
                                pscd: widget.outletcd!,
                                fromsaved: widget.fromsaved,
                                trno: trnolanjut,
                                outletinfo: widget.outletinfo!,
                                qty: 0,
                              )),
                      (Route<dynamic> route) => false);
                } else {
                  Toast.show("Access kode salah",
                      duration: Toast.lengthLong, gravity: Toast.center);
                }
              });
            } else if (widget.frompayment == true) {
              await ClassApi.getAccessCodevoid(_passwordController.text)
                  .then((value) async {
                if (value.isNotEmpty) {
                  await ClassApi.getSumPyTrno(widget.trno.toString())
                      .then((value) {
                    print('ini value sum dalam dialog $value');
                    setState(() {
                      widget.result = widget.balance! - value[0]['totalamt'];
                    });
                  }).whenComplete(() async {
                    if (widget.result!.isNegative) {
                      widget.insertIafjrnhdRefund!().whenComplete(() async {
                        widget.frompaymentmobile == false
                            ? await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassPaymetSucsessTabs(
                                          fromsplit: widget.fromsplit!,
                                          fromsaved: widget.fromsaved!,
                                          datatrans: widget.datatrans!,
                                          frombanktransfer: false,
                                          cash: true,
                                          outletinfo: widget.outletinfo,
                                          outletname: widget.outletname,
                                          outletcd: pscd,
                                          amount: NumberFormat.currency(
                                                  locale: 'id_ID', symbol: 'Rp')
                                              .parse(widget.controller!.text)
                                              .toInt(),
                                          paymenttype: widget.pymtmthd!,
                                          trno: widget.trno.toString(),
                                          trdt: formattedDate,
                                        )))
                            : await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassPaymetSucsessMobile(
                                          fromsplit: widget.fromsplit!,
                                          fromsaved: widget.fromsaved!,
                                          datatrans: widget.datatrans!,
                                          frombanktransfer: false,
                                          cash: true,
                                          outletinfo: widget.outletinfo,
                                          outletname: widget.outletname,
                                          outletcd: pscd,
                                          amount: NumberFormat.currency(
                                                  locale: 'id_ID', symbol: 'Rp')
                                              .parse(widget.controller!.text)
                                              .toInt(),
                                          paymenttype: widget.pymtmthd!,
                                          trno: widget.trno.toString(),
                                          trdt: formattedDate,
                                        )));
                      });
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClassPaymetSucsessTabs(
                                    fromsplit: widget.fromsplit!,
                                    fromsaved: widget.fromsaved!,
                                    datatrans: widget.datatrans!,
                                    frombanktransfer: false,
                                    cash: true,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    outletcd: pscd,
                                    amount: NumberFormat.currency(
                                            locale: 'id_ID', symbol: 'Rp')
                                        .parse(widget.controller!.text)
                                        .toInt(),
                                    paymenttype: widget.pymtmthd!,
                                    trno: widget.trno.toString(),
                                    trdt: formattedDate,
                                  )));
                    }
                  });
                } else {
                  Toast.show("Access kode salah",
                      duration: Toast.lengthLong, gravity: Toast.center);
                }
              });

              // await widget.callback();

              setState(() {});
            } else {
              String password = _passwordController.text;
              widget.onPasswordEntered(password);
              Navigator.of(context).pop(password);
            }
          },
        ),
      ],
    );
  }
}
