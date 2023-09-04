import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class TabDetailTrno extends StatefulWidget {
  final String trno;
  final Outlet outletinfo;
  final String pscd;
  final String status;
  const TabDetailTrno({
    Key? key,
    required this.trno,
    required this.outletinfo,
    required this.pscd,
    required this.status,
  }) : super(key: key);

  @override
  State<TabDetailTrno> createState() => _TabDetailTrnoState();
}

class _TabDetailTrnoState extends State<TabDetailTrno> {
  late DatabaseHandler handler;
  List<IafjrnhdClass> data = [];
  bool haspayment = false;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    checkTransaction();
  }

  checkTransaction() {
    ClassApi.retriveListDetailPayment(widget.trno,dbname,'').then((value) {
      if (value.first.pymtmthd != null) {
        setState(() {
          haspayment = true;
        });
      } else {
        setState(() {
          haspayment = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: FutureBuilder(
          future: ClassApi.getTrnoDetail(widget.trno, pscd, ''),
          builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
            var x = snapshot.data ?? [];
            if (x.isNotEmpty) {
              return Column(
                children: [
                  Container(
                    height: x.length <= 4
                        ? MediaQuery.of(context).size.height *
                            0.06 *
                            double.parse(x.length.toString())
                        : MediaQuery.of(context).size.height * 0.06 * 4,
                    child: ListView.builder(
                        itemCount: x.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(vertical: -2), // t
                                leading: Text('${x[index].qty.toString()} X',style: TextStyle(color: x[index].split==1?Colors.black:Colors.red),),
                                title: Text(x[index].itemdesc.toString(),
                                    style: TextStyle(fontSize: 14,color: x[index].split==1?Colors.black:Colors.red)),
                                trailing: Text(
                                    '${CurrencyFormat.convertToIdr(x[index].totalaftdisc, 0)}',style: TextStyle(color: x[index].split==1?Colors.black:Colors.red)),
                              ),
                              Divider(
                                height: 2,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ],
                          );
                        }),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: FutureBuilder(
                          future: ClassApi.getSumTrans(widget.trno, pscd, ''),
                          builder: (context,
                              AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                            var x = snapshot.data ?? [];

                            if (x.isNotEmpty) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4), // to compact
                                      dense: true,
                                      title: Text('Total'),
                                      trailing: Text(
                                          '${CurrencyFormat.convertToIdr(x.first.revenueamt, 0)}'),
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4), // to compact
                                      dense: true,
                                      title: Text('Discount'),
                                      trailing: Text(
                                          '${CurrencyFormat.convertToIdr(x.first.discamt, 0)}'),
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4), // to compact
                                      dense: true,
                                      title: Text('Pajak'),
                                      trailing: Text(
                                          '${CurrencyFormat.convertToIdr(x.first.taxamt, 0)}'),
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4), // to compact
                                      dense: true,
                                      title: Text('Service'),
                                      trailing: Text(
                                          '${CurrencyFormat.convertToIdr(x.first.serviceamt, 0)}'),
                                    ),
                                    ListTile(
                                      visualDensity: VisualDensity(
                                          vertical: -4), // to compact
                                      dense: true,
                                      title: Text('Grand total'),
                                      trailing: Text(
                                          '${CurrencyFormat.convertToIdr(x.first.totalaftdisc, 0)}'),
                                    ),
                                    Divider(
                                      thickness: 2,
                                      height: 2,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Text(
                            ' Payment',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Text(
                            widget.status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.90,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: FutureBuilder(
                        future:
                            ClassApi.getDetailPayment(widget.trno, pscd, ''),
                        builder: (context,
                            AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
                          data = snapshot.data ?? [];
                          if (data != []) {
                            return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: VisualDensity(
                                        vertical: -4), // to compact
                                    dense: true,
                                    title:
                                        Text(data[index].pymtmthd.toString()),
                                    trailing: Text(
                                        '${CurrencyFormat.convertToIdr(data[index].totalamt, 0)}'),
                                  );
                                });
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                                Text('Belum Ada Pembayaran'),
                              ],
                            );
                          }
                        }),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
