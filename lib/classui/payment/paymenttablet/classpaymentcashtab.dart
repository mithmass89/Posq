import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/payment/classpaymentsuccessmobile.dart';
import 'package:posq/classui/payment/paymenttablet/paymentsuccesstab.dart';
import 'package:posq/model.dart';

class PaymenCashTab extends StatefulWidget {
  final String trno;
  final String pscd;
  final String trdt;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  late TextEditingController controller;
  final Function? insertIafjrnhdRefund;
  final Function? insertIafjrnhd;
  final String pymtmthd;
  late num? result;
  final bool fromsplit;

  PaymenCashTab(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.trdt,
      required this.balance,
      this.outletname,
      this.outletinfo,
      required this.datatrans,
      required this.controller,
      required this.fromsaved,
      required this.result,
      this.insertIafjrnhdRefund,
      this.insertIafjrnhd,
      required this.pymtmthd,
      required this.fromsplit})
      : super(key: key);

  @override
  State<PaymenCashTab> createState() => _PaymenCashTabState();
}

class _PaymenCashTabState extends State<PaymenCashTab> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;

  List<double> paymentlist = [1000, 2000, 5000, 10000, 20000, 50000, 100000];

  String _formatValue(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  void initState() {
    super.initState();
    print('listdata from cashpayment ${widget.datatrans}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextFieldTab1(
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    setState(() {});
                  },
                )
              : null,
          label: 'Nominal',
          controller: widget.controller,
          onChanged: (value) {
            setState(() {});
          },
          typekeyboard: TextInputType.text,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.16,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white),
                  onPressed: () {
                    setState(() {
                      widget.controller.text =
                          _formatValue(widget.balance.toDouble()).toString();
                    });
                  },
                  child: Text(
                    'Uang pas',
                    style: TextStyle(color: Colors.orange),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.16,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.orange),
                  onPressed: () async {
                    //// jika amount lebih kecil dari amount akan otomatsi refund
                    await widget.insertIafjrnhd!().whenComplete(() async {
                      await ClassApi.getSumPyTrno(widget.trno.toString())
                          .then((value) {
                        setState(() {
                          widget.result = widget.balance - value[0]['totalamt'];
                        });
                      }).whenComplete(() {
                        if (widget.result!.isNegative) {
                          widget.insertIafjrnhdRefund!().whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassPaymetSucsessTabs(
                                          fromsplit: widget.fromsplit,
                                          fromsaved: widget.fromsaved,
                                          datatrans: widget.datatrans,
                                          frombanktransfer: false,
                                          cash: true,
                                          outletinfo: widget.outletinfo,
                                          outletname: widget.outletname,
                                          outletcd: widget.pscd,
                                          amount: NumberFormat.currency(
                                                  locale: 'id_ID', symbol: 'Rp')
                                              .parse(widget.controller.text)
                                              .toInt(),
                                          paymenttype: widget.pymtmthd,
                                          trno: widget.trno.toString(),
                                          trdt: formattedDate,
                                        )));
                          });
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClassPaymetSucsessTabs(
                                        fromsplit: widget.fromsplit,
                                        fromsaved: widget.fromsaved,
                                        datatrans: widget.datatrans,
                                        frombanktransfer: false,
                                        cash: true,
                                        outletinfo: widget.outletinfo,
                                        outletname: widget.outletname,
                                        outletcd: widget.pscd,
                                        amount: NumberFormat.currency(
                                                locale: 'id_ID', symbol: 'Rp')
                                            .parse(widget.controller.text)
                                            .toInt(),
                                        paymenttype: widget.pymtmthd,
                                        trno: widget.trno.toString(),
                                        trdt: formattedDate,
                                      )));
                        }
                      });
                    });
                    // await widget.callback();

                    setState(() {});
                  },
                  child: Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.03,
            child: Text(
              ' Saran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.39,
            height: MediaQuery.of(context).size.height * 0.41,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 110,
                      childAspectRatio: 4 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: paymentlist.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), //
                      )),
                      onPressed: () {
                        widget.controller.text =
                            _formatValue(paymentlist[index]).toString();
                        print(widget.controller.text);
                      },
                      child: Text(
                        _formatValue(paymentlist[index]),
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }),
            ))
      ]),
    );
  }
}
