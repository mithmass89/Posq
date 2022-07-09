// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:url_launcher/url_launcher.dart';

PaymentGate? paymentapi;

class ClassPaymetSucsessMobile extends StatefulWidget {
  final bool frombanktransfer;
  final String? virtualaccount;
  final String trno;
  final num amount;
  final String paymenttype;
  final String? guestname;
  final String? trdt;
  final String? outletcd;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? cash;
  final List<IafjrndtClass> datatrans;

  const ClassPaymetSucsessMobile({
    Key? key,
    required this.trno,
    required this.amount,
    required this.paymenttype,
    this.guestname,
    this.trdt,
    this.outletcd,
    this.outletname,
    required this.outletinfo,
    required this.cash,
    this.virtualaccount,
    required this.frombanktransfer,
    required this.datatrans,
  }) : super(key: key);

  @override
  State<ClassPaymetSucsessMobile> createState() =>
      _ClassPaymetSucsessMobileState();
}

class _ClassPaymetSucsessMobileState extends State<ClassPaymetSucsessMobile> {
  late DatabaseHandler handler;
  int? trno;
  String? nexttrno;
  String? statustransaction = '';
  final bool pending = true;
  final TextEditingController _telp =
      TextEditingController(text: '82221769478');
  final TextEditingController _email = TextEditingController();
  List<String> string = [];
  List<String> summary = [];
  List<String> payment = [];
  num subtotal = 0;
  num discounts = 0;
  num total = 0;
  num tax = 0;
  num service = 0;
  num grantotal = 0;

  @override
  void initState() {
    super.initState();

    generateDataWA();
    removeDiscount();

    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    getSummary();
     getListPayament();
    checkTrno();
    if (widget.cash == false) {
      PaymentGate.getStatusTransaction(widget.trno).then((value) {
        setState(() {
          statustransaction = value;
        });
      });
    } else {
      setState(() {
        statustransaction = 'Settlement';
      });
    }
  }

  Stream<String> _getstatus() async* {
    if (widget.cash == false) {
      await PaymentGate.getStatusTransaction(widget.trno).then((value) {
        setState(() {
          statustransaction = value;
        });
      });
    }

    // This loop will run forever because _running is always true
  }

  checkTrno() async {
    await handler.getTrno(widget.outletcd.toString()).then((value) {
      setState(() {
        trno = value.first.trnonext;
      });
    });
    await updateTrnonext();
  }

  updateTrnonext() async {
    await handler.updateTrnoNext(
        Outlet(outletcd: widget.outletcd.toString(), trnonext: trno! + 1));
  }

  Color _getColorByEventtext(String event) {
    if (statustransaction == "settlement") return Colors.green;
    if (statustransaction == "pending") return Colors.red;

    return Colors.black;
  }

  getTrno() async {
    handler = DatabaseHandler();
    await handler.initializeDB(databasename);
    await handler.getTrno(widget.outletcd!).then((value) {
      setState(() {
        nexttrno = '${widget.outletcd}${value.first.trnonext}';
      });
    });
  }

  generateDataWA() {
    List.generate(widget.datatrans.length, (index) {
      string.add(
          '${widget.datatrans[index].trdesc.toString().padRight(23)}\n   ${widget.datatrans[index].qty.toString().padLeft(40)}X\t   ${widget.datatrans[index].nettamt.toString().padRight(10)}\n');
    });
  }

  removeDiscount() {
    string.removeWhere((element) => element.contains('Discount'));
  }

  getSummary() async {
    await handler.summarybill(widget.datatrans.first.trno!).then((value) {
   List.generate(value.length, (index) {
    summary.add('total'.padRight(16,'  ')+':'.padRight(2)+'${value[index].rvnamt.toString().padLeft(20)}\n'+'discount'.padRight(14,'  ')+':'.padRight(2)+'${value[index].discamt.toString().padLeft(20)}\n'+'pajak'.padRight(15,'  ')+':'.padRight(2)+'${value[index].taxamt.toString().padLeft(20)}\n'+'service'.padRight(15,'  ')+':'.padRight(2)+'${value[index].serviceamt.toString().padLeft(20)}\n'+'grand total'.padRight(15,'  ')+':'.padRight(2)+'${value[index].nettamt.toString().padLeft(20)}\n');
   });
    });
  }

  getListPayament() {
    handler.retriveListDetailPayment(widget.trno).then((value) {
      List.generate(value.length, (index) {
        payment.add('${value[index].compdesc.toString().padRight(15,'  ')}${value[index].ftotamt.toString().padLeft(23,' ')}\n');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: _getstatus(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 95,
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      'Transaksi Berhasil',
                      style: TextStyle(fontSize: 25, color: Colors.green),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.height * 0.14,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('correct.png'),
                        fit: BoxFit.fill,
                      )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  
                    TextFieldMobile2(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                        ),
                        iconSize: 20,
                        color: Colors.blue,
                        splashColor: Colors.purple,
                        onPressed: () {
                          String subtotal = 'subtotal';
                          String discount = 'Discount';
                          String taxs = 'Pajak';
                          String services = 'Service';
                          String grandtotal = 'Grand Total';
                          FocusManager.instance.primaryFocus?.unfocus();
                          var whatsappUrl =
                              "whatsapp://send?phone=${"+62" + _telp.text}" +
                                  "&text=" +
                                  '''
Outlet : ${widget.outletname}
Trx    : ${widget.trno}

item
-----------------------------------------          
${string.reduce((value, element) => value + element)}
-----------------------------------------
${summary.reduce((value, element) => value + element)}
-----------------------------------------
${payment.reduce((value, element) => value + element)}
''';
                          try {
                            launch(whatsappUrl);
                          } catch (e) {
                            //To handle error and display error message
                            print('gagal kirim $e');
                          }
                        },
                      ),
                      label: 'Whatsapp',
                      controller: _telp,
                      onChanged: (String value) {},
                      typekeyboard: TextInputType.text,
                    ),

                    TextFieldMobile2(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                        ),
                        iconSize: 20,
                        color: Colors.blue,
                        splashColor: Colors.purple,
                        onPressed: () {},
                      ),
                      label: 'E-mail',
                      controller: _email,
                      onChanged: (String value) {},
                      typekeyboard: TextInputType.text,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonNoIcon(
                          textcolor: Colors.white,
                          color: Colors.blue,
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.height * 0.18,
                          onpressed: () async {},
                          name: 'Print',
                        ),
                        ButtonNoIcon(
                          textcolor: Colors.white,
                          color: Colors.blue,
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.height * 0.18,
                          onpressed: () async {
                            await getTrno();

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ClassRetailMainMobile(
                                          pscd: widget.outletcd!,
                                          trno: nexttrno,
                                          outletinfo: widget.outletinfo!,
                                          qty: 0,
                                        )),
                                (Route<dynamic> route) => false);
                          },
                          name: 'TRANSAKSI BARU',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
