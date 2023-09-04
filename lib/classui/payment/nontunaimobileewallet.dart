// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/integrasipayment/classpaymentmidtrans.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

PaymentGate? paymentapi;

class EWalletClassNonTunai extends StatefulWidget {
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
  final bool fromsaved;
  final bool fromsplit;
  final void Function(String compcd, String compdesc, String methode)
      checkselected;
  final String guestname;
  EWalletClassNonTunai(
      {Key? key,
      required this.amountcash,
      required this.balance,
      this.trno,
      this.pscd,
      required this.outletinfo,
      required this.callback,
      required this.zerobill,
      required this.result,
      required this.midtransonline,
      required this.datatrans,
      this.compcode,
      this.compdescription,
      this.pymtmthd,
      required this.checkselected,
      required this.fromsaved,
      required this.fromsplit,
      required this.guestname})
      : super(key: key);

  @override
  State<EWalletClassNonTunai> createState() => _EWalletClassNonTunaiState();
}

class _EWalletClassNonTunaiState extends State<EWalletClassNonTunai> {
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
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    paymentapi = PaymentGate();
    formattedDate = formatter.format(now);

    List.generate(
        widget.datatrans.length,
        (index) => listitem.add(Midtransitem(
            id: '${widget.datatrans[index].itemcode}'.replaceAll(' ', ''),
            price: num.parse(
                '${widget.datatrans[index].totalaftdisc! / widget.datatrans[index].qty!}'),
            quantity: int.parse('${widget.datatrans[index].qty}'),
            name: '${widget.datatrans[index].description}')));
    print(' hasil : $listitem');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[100],
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                child:
                    Text('QRIS', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            // color: Colors.grey[100],
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.90,
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1.6,
                crossAxisCount: 3,
              ),
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.compdescription == 'QRIS'
                          ? Colors.blue
                          : Colors.transparent,
                    ),
                  ),
                  child: ButtonClassPayment(
                    name: '',
                    iconasset: 'assets/qris.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    onpressed: () async {
                      print(serverkeymidtrans);
                      if (widget.midtransonline == true && refundmode==false) {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogClassEwallet(
                                guestname: widget.guestname,
                                fromsplit: widget.fromsplit,
                                fromsaved: widget.fromsaved,
                                datatrans: widget.datatrans,
                                url: qr,
                                compcd: compcd,
                                compdesc: compdesc,
                                result: widget.result,
                                balance: widget.balance,
                                pscd: widget.outletinfo.outletcd,
                                trno: widget.trno.toString(),
                                outletinfo: widget.outletinfo,
                              );
                            });
                      } else {
                        setState(() {
                          compcd = 'QRIS';
                          compdesc = 'QRIS';
                        });

                        widget.checkselected(widget.compcode = 'QRIS',
                            widget.compdescription = 'QRIS', 'QRIS');
                      }
                      ;
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.yellow[100]),
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.88,
            child: Row(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(color: Colors.yellow[100]),
                    child: Text('Integrasi Pembayaran Online')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ClassPaymentMidtrans();
                      }));
                    },
                    child: Text('disini'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
