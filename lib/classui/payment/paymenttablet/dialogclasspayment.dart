// ignore_for_file: unused_field

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/payment/paymentsugestionclass.dart';
import 'package:posq/classui/payment/paymenttablet/classpaymentbanktrftab.dart';
import 'package:posq/classui/payment/paymenttablet/classpaymentcashtab.dart';
import 'package:posq/classui/payment/paymenttablet/classpaymentdebitcard.dart';
import 'package:posq/classui/payment/paymenttablet/classpaymentewallet.dart';
import 'package:posq/classui/payment/paymenttablet/classpaymentlainlaintab.dart';
import 'package:posq/classui/payment/paymenttablet/classpaymentpiutangtab.dart';
import 'package:posq/classui/payment/paymenttablet/classpaymentqristab.dart';
import 'package:posq/integrasipayment/classintegrasilist.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class DialogPaymentTab extends StatefulWidget {
  final String trno;
  final String pscd;
  final String trdt;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final bool fromsplit;

  const DialogPaymentTab({
    Key? key,
    required this.trno,
    required this.outletinfo,
    required this.pscd,
    required this.trdt,
    required this.balance,
    this.outletname,
    required this.datatrans,
    required this.fromsaved,
    required this.fromsplit,
  }) : super(key: key);

  @override
  State<DialogPaymentTab> createState() => _DialogPaymentTabStateState();
}

class _DialogPaymentTabStateState extends State<DialogPaymentTab> {
  PaymentAmountSuggestion _suggestion = PaymentAmountSuggestion();
  TextEditingController controller = TextEditingController(text: '0');
  TextEditingController debitcontroller = TextEditingController();
  TextEditingController cardno = TextEditingController();
  TextEditingController cardexp = TextEditingController();
  String selectedpy = '';
  int _currentAmount = 5000;
  num? result = 0;
  bool zerobill = false;
  List<IafjrnhdClass> data = [];
  String selectedpay = '';
  List<double> paymentlist = [
    1000,
    2000,
    5000,
    10000,
    15000,
    20000,
    50000,
    100000
  ];

  List<String> listdebitcard = [
    'BCA',
    'BNI',
    'BRI',
    'MANDIRI',
    'PERMATA',
    'Other'
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  List<IafjrndtClass> listdata = [];
  List<IafjrndtClass> listdatabill = [];
  String serverkeymidtrans = '';
  bool midtransonline = false;
  String pymtmthd = '';
  String compcode = '';
  String compdescription = '';
  int lastsplit = 1;
  List<PaymentMaster> companylist = [];

  @override
  void initState() {
    super.initState();
    _currentAmount += 100000;
    result = widget.balance;
    checkbalance();
    _formatValue(double.parse(controller.text));
    selectedpy = 'Cash';
    pymtmthd = 'Cash';
    formattedDate = formatter.format(now);

    if (widget.fromsplit == true) {
      ClassApi.checkLastSplit(dbname, widget.trno).then((value) {
        lastsplit = value[0]['split'] + 1;
      });
    } else {
      lastsplit = 1;
    }

    getPaymentMaster();
  }

  String _formatValue(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  Future<dynamic> checkbalance() async {
    await ClassApi.getSumPyTrno(widget.trno).then((value) {
      print(value[0]['totalamt']);
      if (value[0]['totalamt'] != null) {
        setState(() {
          result = widget.balance - value[0]['totalamt']!;
        });
        if (result == 0) {
          setState(() {
            zerobill = true;
          });
        }
      } else {
        setState(() {
          zerobill = false;
        });
      }
    });
  }

  getPaymentList() async {
    data = await ClassApi.getDetailPayment(widget.trno, dbname, '');
  }

  setSelected(String value) {
    selectedpay = value;
  }

  getPaymentMaster() async {
    await ClassApi.getPaymentMaster('').then((isi) {
      print(List.generate(isi.length, (index) => isi[index].id));
      setState(() {
        companylist = isi;
      });
    });
  }

  Future<dynamic> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: '${widget.trno}',
        split: lastsplit,
        pscd: '${widget.pscd}',
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: '',
        pax: '1',
        pymtmthd: pymtmthd,
        ftotamt: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(controller.text)
            .toInt(),
        totalamt: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(controller.text)
            .toInt(),
        framtrmn: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(controller.text)
            .toInt(),
        amtrmn: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(controller.text)
            .toInt(),
        trdesc: '$pymtmthd ${widget.trno}',
        trdesc2: '$pymtmthd ${widget.trno}',
        compcd: compcode,
        compdesc: selectedpay,
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd);
  }

  Future<Null> insertIafjrnhdEDC() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: '${widget.trno}',
        split: lastsplit,
        pscd: '${widget.pscd}',
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: '',
        pax: '1',
        pymtmthd: pymtmthd,
        ftotamt: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        totalamt: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        framtrmn: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        amtrmn: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        trdesc: '$pymtmthd ${widget.trno}',
        trdesc2: '$pymtmthd ${widget.trno}',
        compcd: compcode,
        compdesc: selectedpay,
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd).then((_) {
      setState(() {});
    });
  }

  Future<Null> insertIafjrnhdEwallet() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: '${widget.trno}',
        split: lastsplit,
        pscd: '${widget.pscd}',
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: '',
        pax: '1',
        pymtmthd: pymtmthd,
        ftotamt: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        totalamt: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        framtrmn: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        amtrmn: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
            .parse(debitcontroller.text)
            .toInt(),
        trdesc: '$pymtmthd ${widget.trno}',
        trdesc2: '$pymtmthd ${widget.trno}',
        compcd: compcode,
        compdesc: selectedpay,
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd).then((_) {
      setState(() {});
    });
  }

  Future<dynamic> insertIafjrnhdRefund() async {
    await checkbalance();
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: widget.trno,
        split: lastsplit,
        pscd: '${widget.pscd}',
        trtm: '00:00',
        disccd: '',
        pax: '1',
        pymtmthd: pymtmthd,
        ftotamt: result!.toDouble(),
        totalamt: result!.toDouble(),
        framtrmn: result!.toDouble(),
        amtrmn: result!.toDouble(),
        compcd: compcode,
        compdesc: 'REFUND',
        trdesc: 'Refund cash ${widget.trno}',
        trdesc2: 'Refund cash ${widget.trno}',
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, dbname);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final int itemCount = data.length;
    final double itemHeight = screenHeight / itemCount;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back_ios_new)),
                        // Spacer(),
                        Container(
                            child: Text(
                          'Pembayaran',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 143, 168)),
                        )),
                        Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(5), // <-- Radius
                                  ),
                                  padding: EdgeInsets.zero,
                                  backgroundColor:
                                      Colors.orange // Background color
                                  ),
                              onPressed: () {},
                              child: Text(
                                'Selesaikan',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.68,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Container(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: selectedpy ==
                                                    'Cash'
                                                ? Colors.white
                                                : Colors
                                                    .orange // Background color
                                            ),
                                        onPressed: () {
                                          selectedpy = 'Cash';
                                          pymtmthd = 'Cash';
                                          compcode = pymtmthd;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Cash',
                                          style: TextStyle(
                                              color: selectedpy == 'Cash'
                                                  ? Colors.orange
                                                  : Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: selectedpy == 'EDC'
                                                ? Colors.white
                                                : Colors
                                                    .orange // Background color
                                            ),
                                        onPressed: () {
                                          selectedpy = 'EDC';
                                          pymtmthd = 'EDC';
                                          compcode = pymtmthd;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'EDC',
                                          style: TextStyle(
                                              color: selectedpy == 'EDC'
                                                  ? Colors.orange
                                                  : Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: selectedpy ==
                                                    'QRIS'
                                                ? Colors.white
                                                : Colors
                                                    .orange // Background color
                                            ),
                                        onPressed: () {
                                          selectedpy = 'QRIS';
                                          pymtmthd = 'QRIS';
                                          compcode = pymtmthd;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'QRIS',
                                          style: TextStyle(
                                              color: selectedpy == 'QRIS'
                                                  ? Colors.orange
                                                  : Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: selectedpy ==
                                                    'E-wallet'
                                                ? Colors.white
                                                : Colors
                                                    .orange // Background color
                                            ),
                                        onPressed: () {
                                          selectedpy = 'E-wallet';
                                          pymtmthd = 'E-wallet';
                                          compcode = pymtmthd;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'E-wallet',
                                          style: TextStyle(
                                              color: selectedpy == 'E-wallet'
                                                  ? Colors.orange
                                                  : Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: selectedpy ==
                                                    'Bank transfer'
                                                ? Colors.white
                                                : Colors
                                                    .orange // Background color
                                            ),
                                        onPressed: () {
                                          selectedpy = 'Bank transfer';
                                          pymtmthd = 'Bank transfer';
                                          compcode = pymtmthd;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Bank transfer',
                                          style: TextStyle(
                                              color:
                                                  selectedpy == 'Bank transfer'
                                                      ? Colors.orange
                                                      : Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: selectedpy ==
                                                    'Piutang'
                                                ? Colors.white
                                                : Colors
                                                    .orange // Background color
                                            ),
                                        onPressed: () {
                                          selectedpy = 'Piutang';
                                          pymtmthd = 'Piutang';
                                          compcode = pymtmthd;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Piutang',
                                          style: TextStyle(
                                              color: selectedpy == 'Piutang'
                                                  ? Colors.orange
                                                  : Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: selectedpy ==
                                                    'Lain lain'
                                                ? Colors.white
                                                : Colors
                                                    .orange // Background color
                                            ),
                                        onPressed: () {
                                          selectedpy = 'Lain lain';
                                          pymtmthd = 'Lain lain';
                                          compcode = pymtmthd;
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Lain lain',
                                          style: TextStyle(
                                              color: selectedpy == 'Lain lain'
                                                  ? Colors.orange
                                                  : Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // <-- Radius
                                            ),
                                            padding: EdgeInsets.zero,
                                            backgroundColor:
                                                Color.fromARGB(255, 0, 159, 170)
                                            // Background color
                                            ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassListIntegrasi()),
                                          );
                                        },
                                        child: Text(
                                          'Integrasi',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.68,
                        width: MediaQuery.of(context).size.width * 0.37,
                        child: Container(
                            color: Colors.grey[200],
                            child: Builder(builder: (context) {
                              switch (selectedpy) {
                                case 'Cash':
                                  return PaymenCashTab(
                                    fromsplit: widget.fromsplit,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    insertIafjrnhd: insertIafjrnhd,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    balance: widget.balance,
                                    controller: controller,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    pscd: widget.pscd,
                                    pymtmthd: pymtmthd,
                                    result: result,
                                    trdt: formattedDate,
                                    trno: widget.trno,
                                  );
                                case 'EDC':
                                  return PaymentDebitTabs(
                                    selectedpayment: setSelected,
                                    selectedpay: selectedpay,
                                    fromsplit: widget.fromsplit,
                                    cardno: cardno,
                                    cardexp: cardexp,
                                    debitcontroller: debitcontroller,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    insertIafjrnhd: insertIafjrnhdEDC,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    balance: widget.balance,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    pscd: widget.pscd,
                                    pymtmthd: pymtmthd,
                                    result: result,
                                    trdt: formattedDate,
                                    trno: widget.trno,
                                    paymentlist: [
                                      'BCA',
                                      'BNI',
                                      'BRI',
                                      'MANDIRI',
                                      'PERMATA',
                                      'OTHER'
                                    ],
                                  );
                                case 'QRIS':
                                  return ClassPaymentQrisTab(
                                    selectedpayment: setSelected,
                                    selectedpay: selectedpay,
                                    cardno: cardno,
                                    cardexp: cardexp,
                                    debitcontroller: debitcontroller,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    insertIafjrnhd: insertIafjrnhdEDC,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    balance: widget.balance,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    pscd: widget.pscd,
                                    pymtmthd: pymtmthd,
                                    result: result,
                                    trdt: formattedDate,
                                    trno: widget.trno,
                                    paymentlist: [
                                      'BCA',
                                      'BNI',
                                      'BRI',
                                      'MANDIRI',
                                      'PERMATA',
                                      'OTHER'
                                    ],
                                  );
                                case 'E-wallet':
                                  return PaymentEwalletTab(
                                    selectedpayment: setSelected,
                                    selectedpay: selectedpay,
                                    fromsplit: widget.fromsplit,
                                    cardno: cardno,
                                    cardexp: cardexp,
                                    debitcontroller: debitcontroller,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    insertIafjrnhd: insertIafjrnhdEDC,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    balance: widget.balance,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    pscd: widget.pscd,
                                    pymtmthd: pymtmthd,
                                    result: result,
                                    trdt: formattedDate,
                                    trno: widget.trno,
                                    paymentlist: [
                                      'DANA',
                                      'GOPAY',
                                      'OVO',
                                      'SHOPEPAY',
                                      'LINKAJA',
                                      'OTHER'
                                    ],
                                  );
                                case 'Bank transfer':
                                  return PaymentTrfTabs(
                                    selectedpayment: setSelected,
                                    selectedpay: selectedpay,
                                    fromsplit: widget.fromsplit,
                                    cardno: cardno,
                                    cardexp: cardexp,
                                    debitcontroller: debitcontroller,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    insertIafjrnhd: insertIafjrnhdEDC,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    balance: widget.balance,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    pscd: widget.pscd,
                                    pymtmthd: pymtmthd,
                                    result: result,
                                    trdt: formattedDate,
                                    trno: widget.trno,
                                    paymentlist: [
                                      'BCA',
                                      'BNI',
                                      'BRI',
                                      'MANDIRI',
                                      'PERMATA',
                                      'OTHER'
                                    ],
                                  );
                                case 'Piutang':
                                  return PaymentPiutangTabs(
                                    selectedpayment: setSelected,
                                    selectedpay: selectedpay,
                                    fromsplit: widget.fromsplit,
                                    cardno: cardno,
                                    cardexp: cardexp,
                                    debitcontroller: debitcontroller,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    insertIafjrnhd: insertIafjrnhdEDC,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    balance: widget.balance,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    pscd: widget.pscd,
                                    pymtmthd: pymtmthd,
                                    result: result,
                                    trdt: formattedDate,
                                    trno: widget.trno,
                                    paymentlist: companylist,
                                  );
                                case 'Lain lain':
                                  return PaymentLainLainTabs(
                                    selectedpayment: setSelected,
                                    selectedpay: selectedpay,
                                    fromsplit: widget.fromsplit,
                                    cardno: cardno,
                                    cardexp: cardexp,
                                    debitcontroller: debitcontroller,
                                    outletinfo: widget.outletinfo,
                                    outletname: widget.outletname,
                                    insertIafjrnhd: insertIafjrnhdEDC,
                                    insertIafjrnhdRefund: insertIafjrnhdRefund,
                                    balance: widget.balance,
                                    datatrans: widget.datatrans,
                                    fromsaved: widget.fromsaved,
                                    pscd: widget.pscd,
                                    pymtmthd: pymtmthd,
                                    result: result,
                                    trdt: formattedDate,
                                    trno: widget.trno,
                                    paymentlist: [
                                      'OWNER',
                                      'ENTERTAINT',
                                      'COMPLIMENT',
                                      'OFFICER',
                                      'OTHER'
                                    ],
                                  );
                              }
                              return Container();
                            })),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.68,
                        width: MediaQuery.of(context).size.width * 0.29,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Detail',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              Row(
                                children: [
                                  Text('Tagihan'),
                                  Spacer(),
                                  Text(_formatValue(widget.balance.toDouble())),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.29,
                                child: FutureBuilder(
                                    future: ClassApi.getDetailPayment(
                                        widget.trno, dbname, ''),
                                    builder: (context,
                                        AsyncSnapshot<List<IafjrnhdClass>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: ((context, index) {
                                              return Row(
                                                children: [
                                                  Text(snapshot
                                                      .data![index].pymtmthd!),
                                                  Spacer(),
                                                  Text(_formatValue(snapshot
                                                      .data![index].totalamt!
                                                      .toDouble())),
                                                  TextButton(
                                                      style: TextButton.styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          minimumSize:
                                                              Size(10, 10),
                                                          tapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          alignment: Alignment
                                                              .centerLeft),
                                                      onPressed: () async {
                                                        await ClassApi
                                                                .deletePayment(
                                                                    dbname,
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id!)
                                                            .whenComplete(
                                                                () async {
                                                          await ClassApi
                                                                  .getSumPyTrno(
                                                                      widget
                                                                          .trno
                                                                          .toString())
                                                              .then((value) {
                                                            if (value[0][
                                                                    'totalamt'] !=
                                                                null) {
                                                              setState(() {
                                                                result = widget
                                                                        .balance -
                                                                    value[0][
                                                                        'totalamt'];
                                                              });
                                                            }
                                                            result =
                                                                widget.balance;
                                                            setState(() {});
                                                          });
                                                        });
                                                      },
                                                      child: Text(' X'))
                                                ],
                                              );
                                            }));
                                      }
                                      return Container();
                                    }),
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                                thickness: 1,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.29,
                                child: Row(
                                  children: [
                                    Text(
                                      'Sisa',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Text(
                                      _formatValue(result!.toDouble()),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
        actions: <Widget>[],
      );
    });
  }
}
