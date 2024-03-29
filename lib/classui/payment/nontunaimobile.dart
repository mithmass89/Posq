// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/classui/payment/nontunaicreditcardmobile.dart';
import 'package:posq/classui/payment/nontunaidebitcardmobile.dart';
import 'package:posq/classui/payment/nontunaimobileewallet.dart';
import 'package:posq/classui/payment/nontunaimobiletransfer.dart';
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
  late String? compcode;
  late String? compdescription;
  late String? pymtmthd;
  final void Function(String compcd, String compdesc, String methode)
      checkselected;
  final bool fromsaved;
  final int lastsplit;
  final bool fromsplit;
  final String guestname;

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
    required this.datatrans,
    required this.midtransonline,
    this.compcode,
    this.compdescription,
    required this.checkselected,
    required this.pymtmthd,
    required this.fromsaved,
    required this.lastsplit,
    required this.fromsplit,
    required this.guestname,
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
  // String email = 'mithmass2@gmail.com';
  // String phone = '+6282221769478';
  // String guestname = 'Nico Cahya Yunianto';

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        EWalletClassNonTunai(
          guestname: widget.guestname,
          fromsplit: widget.fromsplit,
          fromsaved: widget.fromsaved,
          checkselected: widget.checkselected,
          compcode: widget.compcode,
          compdescription: widget.compdescription,
          midtransonline: widget.midtransonline,
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
            PaymentDebitCardMobile(
          guestname: widget.guestname,
          fromsplit: widget.fromsplit,
          fromsaved: widget.fromsaved,
          checkselected: widget.checkselected,
          compcode: widget.compcode,
          compdescription: widget.compdescription,
          midtransonline: widget.midtransonline,
          datatrans: widget.datatrans,
          callback: widget.callback,
          zerobill: widget.zerobill,
          result: widget.result,
          outletinfo: widget.outletinfo,
          pscd: widget.pscd.toString(),
          trno: widget.trno.toString(),
          balance: widget.balance,
        ),
        NonTunaiMobileTransfer(
          guestname: widget.guestname,
          fromsplit: widget.fromsplit,
          fromsaved: widget.fromsaved,
          checkselected: widget.checkselected,
          compcode: widget.compcode,
          compdescription: widget.compdescription,
          midtransonline: widget.midtransonline,
          datatrans: widget.datatrans,
          callback: widget.callback,
          zerobill: widget.zerobill,
          result: widget.result,
          outletinfo: widget.outletinfo,
          pscd: widget.pscd.toString(),
          trno: widget.trno.toString(),
          balance: widget.balance,
        ),
    
      ],
    );
  }
}
