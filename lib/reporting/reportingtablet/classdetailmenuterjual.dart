import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classcahsiersummarydetail.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/reporting/reportingtablet/cashiersummarydetailtab.dart';
import 'package:posq/reporting/reportingtablet/classdetailitemmenusoldtab.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClasMeuTerjualtab extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;

  ClasMeuTerjualtab(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder})
      : super(key: key);

  @override
  State<ClasMeuTerjualtab> createState() => _ClasMeuTerjualtabState();
}

class _ClasMeuTerjualtabState extends State<ClasMeuTerjualtab> {
  String? query = '';
  List<IafjrnhdClass> data = [];

  void initState() {
    super.initState();
    ToastContext().init(context);
    getSummary();
  }

  void methodA() {
    setState(() {
      print(widget.fromdate);
      print(widget.todate);
    });
  }

  Future<dynamic> getSummary() async {
    data = await ClassApi.getCashierSummary(
        widget.fromdate, widget.todate, dbname);
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, methodA);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.6,
      child: FutureBuilder(
          future: ClassApi.getReportDetailMenuSold(
              widget.fromdate, widget.todate, dbname, ''),
          builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
            var x = snapshot.data ?? [];
            print('ini ${snapshot.data}');
            if (x.isNotEmpty) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: Text(
                      'Ringkasan Detail Penjualan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 5 / 2,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1),
                        itemCount: x.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ClassCashierMenuSoldDetailTab(
                                    fromdate: widget.fromdate,
                                    todate: widget.todate,
                                    itemcode: x[index].itemcode!,
                                  );
                                }));
                              },
                              leading: Text('QTY : ${x[index].qty.toString()}'),
                              dense: true,
                              title: Text(
                                x[index].itemdesc!,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  x[index].revenueamt, 0)),
                            ),
                          );
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ClassCashierSummaryDetailTab(
                              fromdate: widget.fromdate,
                              todate: widget.todate,
                            );
                          }));
                        },
                        child: Text(
                          'lihat detail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 155, 160),
                          ),
                        )),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
