import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/payment/paymentmainmobilev2.dart';
import 'package:posq/classui/payment/paymenttablet/dialogclasspayment.dart';
import 'package:posq/model.dart';

class DialogSplitTab extends StatefulWidget {
  final String trno;
  final String pscd;
  final String trdt;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final String guestname;

  const DialogSplitTab({
    Key? key,
    required this.trno,
    required this.outletinfo,
    required this.pscd,
    required this.trdt,
    required this.balance,
    this.outletname,
    required this.datatrans,
    required this.fromsaved,
    required this.guestname,
  }) : super(key: key);

  @override
  State<DialogSplitTab> createState() => _DialogSplitTabStateState();
}

class _DialogSplitTabStateState extends State<DialogSplitTab> {
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();

  List<bool> checkedValues = [];
  final List<IafjrndtClass> selected = [];
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  num totalSlsNett = 0;

  @override
  void initState() {
    checkedValues = List.filled(widget.datatrans.length, false);
    super.initState();
    formattedDate = formatter.format(now);
  }

  getSum(List<IafjrndtClass> selected) {
    totalSlsNett = selected.fold(
        0, (previousValue, isi) => previousValue + isi.totalaftdisc!);
    setState(() {});
    print(totalSlsNett);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      if (constraints.maxWidth >= 820) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
                Text('Split bill'),
                Spacer(),
                Text(
                  CurrencyFormat.convertToIdr(totalSlsNett, 0),
                ),
              ],
            ),
            content: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Text(
                      'Item yg akan di split',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Form(
                    key: _formKeys,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.48,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ListView.builder(
                        itemCount: widget.datatrans.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              widget.datatrans[index].condimenttype == ''
                                  ? CheckboxListTile(
                                      dense: true,
                                      subtitle: Row(
                                        children: [
                                          Text(widget.datatrans[index].qty
                                              .toString()),
                                          Text('X  '),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                widget.datatrans[index]
                                                    .totalaftdisc,
                                                0),
                                          ),
                                        ],
                                      ),
                                      title: widget.datatrans[index]
                                                  .condimenttype !=
                                              ''
                                          ? Text(
                                              widget.datatrans[index].itemdesc!)
                                          : Text(
                                              '*** ${widget.datatrans[index].itemdesc!}***'),
                                      value: checkedValues[index],
                                      onChanged: (newValue) {
                                        setState(() {
                                          checkedValues[index] = newValue!;
                                        });
                                        if (checkedValues[index] == true) {
                                          print(
                                              widget.datatrans[index].itemseq);
                                          for (var x in widget.datatrans.where(
                                              (element) =>
                                                  element.itemseq ==
                                                  widget.datatrans[index]
                                                      .itemseq)) {
                                            selected.add(x);
                                          }

                                          print(selected);
                                          getSum(selected);
                                        } else {
                                          selected.removeWhere((element) =>
                                              element ==
                                              widget.datatrans[index]);
                                          print(selected);
                                          getSum(selected);
                                        }
                                      },
                                    )
                                  : ListTile(
                                      dense: true,
                                      title: widget.datatrans[index]
                                                  .condimenttype ==
                                              ''
                                          ? Text(
                                              widget.datatrans[index].itemdesc!)
                                          : Text(
                                              '*** ${widget.datatrans[index].itemdesc!}***'),
                                      subtitle: Row(
                                        children: [
                                          Text(widget.datatrans[index].qty
                                              .toString()),
                                          Text('X  '),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                widget.datatrans[index]
                                                    .totalaftdisc,
                                                0),
                                          ),
                                        ],
                                      ),
                                    ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              )
                            ],
                          );
                        },
                      ),
                    )),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white // Background color
                      ),
                  onPressed: () async {},
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      'Print',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.primaryColor // Background color
                      ),
                  onPressed: () async {
                    final result = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => DialogPaymentTab(
                             guestname: widget.guestname,
                              fromsplit: true,
                              fromsaved: widget.fromsaved,
                              datatrans: selected,
                              outletinfo: widget.outletinfo,
                              balance: totalSlsNett,
                              pscd: widget.outletinfo!.outletcd,
                              trdt: formattedDate,
                              trno: widget.trno.toString(),
                              outletname: widget.outletinfo!.outletname,
                            )).then((_) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      'Split',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          );
        });
      } else if (constraints.maxWidth <= 480) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
                Text('Split bill'),
                Spacer(),
                Text(
                  CurrencyFormat.convertToIdr(totalSlsNett, 0),
                ),
              ],
            ),
            content: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Text(
                      'Item yg akan di split',
                      style: TextStyle(),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Form(
                    key: _formKeys,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.48,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ListView.builder(
                        itemCount: widget.datatrans.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              widget.datatrans[index].condimenttype == ''
                                  ? CheckboxListTile(
                                      dense: true,
                                      subtitle: Row(
                                        children: [
                                          Text(widget.datatrans[index].qty
                                              .toString()),
                                          Text('X  '),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                widget.datatrans[index]
                                                    .totalaftdisc,
                                                0),
                                          ),
                                        ],
                                      ),
                                      title: widget.datatrans[index]
                                                  .condimenttype ==
                                              ''
                                          ? Text(
                                              widget.datatrans[index].itemdesc!)
                                          : Text(
                                              '*** ${widget.datatrans[index].itemdesc!}***'),
                                      value: checkedValues[index],
                                      onChanged: (newValue) {
                                        setState(() {
                                          checkedValues[index] = newValue!;
                                        });
                                        if (checkedValues[index] == true) {
                                          print(
                                              widget.datatrans[index].itemseq);
                                          for (var x in widget.datatrans.where(
                                              (element) =>
                                                  element.itemseq ==
                                                  widget.datatrans[index]
                                                      .itemseq)) {
                                            selected.add(x);
                                          }

                                          print(selected);
                                          getSum(selected);
                                        } else {
                                          selected.removeWhere((element) =>
                                              element ==
                                              widget.datatrans[index]);
                                          print(selected);
                                          getSum(selected);
                                        }
                                      },
                                    )
                                  : ListTile(
                                      dense: true,
                                      title: widget.datatrans[index]
                                                  .condimenttype ==
                                              ''
                                          ? Text(
                                              widget.datatrans[index].itemdesc!)
                                          : Text(
                                              '*** ${widget.datatrans[index].itemdesc!}***'),
                                      subtitle: Row(
                                        children: [
                                          Text(widget.datatrans[index].qty
                                              .toString()),
                                          Text('X  '),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                widget.datatrans[index]
                                                    .totalaftdisc,
                                                0),
                                          ),
                                        ],
                                      ),
                                    ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              )
                            ],
                          );
                        },
                      ),
                    )),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white // Background color
                      ),
                  onPressed: () async {},
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      'Print',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.primaryColor // Background color
                      ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentV2MobileClass(
                                guestname: widget.guestname,
                                fromsplit: true,
                                fromsaved: widget.fromsaved,
                                datatrans: selected,
                                outletinfo: widget.outletinfo,
                                balance: totalSlsNett.toInt(),
                                pscd: widget.outletinfo!.outletcd,
                                trdt: formattedDate,
                                trno: widget.trno.toString(),
                                outletname: widget.outletinfo!.outletname,
                              )),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      'Split',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          );
        });
      }
      return Container();
    });
  }
}
