// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/classui/nontunaicreditcardmobile.dart';
import 'package:posq/classui/nontunaidebitcardmobile.dart';
import 'package:posq/classui/nontunaimobileewallet.dart';
import 'package:posq/classui/nontunaimobiletransfer.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:toast/toast.dart';

PaymentGate? paymentapi;

class NonTunaiMobile extends StatefulWidget {
  final TextEditingController amountcash;
  final num balance;
  final String? trno;
  final String? pscd;
  final Outlet outletinfo;
  late num result;
  late bool zerobill;
  final Function callback;
  final List<IafjrndtClass> datatrans;
  final bool midtransonline;

  NonTunaiMobile({
    Key? key,
    required this.amountcash,
    required this.balance,
    this.trno,
    this.pscd,
    required this.zerobill,
    required this.result,
    required this.outletinfo,
    required this.callback,
    required this.datatrans,required this.midtransonline,
  }) : super(key: key);

  @override
  State<NonTunaiMobile> createState() => _NonTunaiMobileState();
}

class _NonTunaiMobileState extends State<NonTunaiMobile> {
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  bool paymentsuccess = false;
  String compcd = '';
  String compdesc = '';
  String qr = '';
  List<Midtransitem> listitem = [];
  String email = 'mithmass2@gmail.com';
  String phone = '+6282221769478';
  String guestname = 'Nico Cahya Yunianto';

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        EWalletClassNonTunai(
          midtransonline:widget.midtransonline,
          datatrans: widget.datatrans,
          callback: widget.callback,
          zerobill: widget.zerobill,
          result: widget.result,
          outletinfo: widget.outletinfo,
          pscd: widget.pscd,
          trno: widget.trno,
          balance: widget.balance,
          amountcash: widget.amountcash,
        ),
        NonTunaiMobileTransfer(
          midtransonline:widget.midtransonline,
          datatrans: widget.datatrans,
          callback: widget.callback,
          zerobill: widget.zerobill,
          result: widget.result,
          outletinfo: widget.outletinfo,
          pscd: widget.pscd.toString(),
          trno: widget.trno.toString(),
          balance: widget.balance,
        ),
        PaymentMobileCreditCard(
          midtransonline:widget.midtransonline,
          datatrans: widget.datatrans,
          callback: widget.callback,
          zerobill: widget.zerobill,
          result: widget.result,
          outletinfo: widget.outletinfo,
          pscd: widget.pscd.toString(),
          trno: widget.trno.toString(),
          balance: widget.balance,
        ),
        PaymentDebitCardMobile(
            midtransonline:widget.midtransonline,
          datatrans: widget.datatrans,
          callback: widget.callback,
          zerobill: widget.zerobill,
          result: widget.result,
          outletinfo: widget.outletinfo,
          pscd: widget.pscd.toString(),
          trno: widget.trno.toString(),
          balance: widget.balance,
        )
      ],
    );
  }
}
