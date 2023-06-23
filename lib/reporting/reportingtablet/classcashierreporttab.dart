import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classcahsiersummarydetail.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/reporting/reportingtablet/cashiersummarydetailtab.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';
import 'package:collection/collection.dart';

class CashierSummaryTab extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  late List<String> listoutlets;

  CashierSummaryTab(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.listoutlets})
      : super(key: key);

  @override
  State<CashierSummaryTab> createState() => _CashierSummaryTabState();
}

class _CashierSummaryTabState extends State<CashierSummaryTab> {
  String? query = '';
  List<IafjrnhdClass> data = [];
  List<IafjrnhdClass> datatemp = [];
  Map<String, int> sumByPymtmthd = {};

  void initState() {
    super.initState();
    ToastContext().init(context);
    data = [];
    datatemp = [];
    sumByPymtmthd = {};
  }

  void methodA() {
    data = [];
    datatemp = [];
    sumByPymtmthd = {};
    setState(() {});
    print('from voidmethod ${widget.listoutlets}');
  }

  Future<List<IafjrnhdClass>> olahData() async {
    for (var x in widget.listoutlets) {
      await ClassApi.getCashierSummary(
        widget.fromdate,
        widget.todate,
        x,
      ).then((value) {
        datatemp.addAll(value);
      });
    }
    ;
    // Grouping transactions by 'pymtmthd'
    Map<String, List<IafjrnhdClass>> groupedTransactions =
        groupBy(datatemp, (transaction) => transaction.pymtmthd!);

    // Calculating the sum of transaction amounts for each 'pymtmthd'

    groupedTransactions.forEach((key, value) {
      int sum = value.fold(0, (previousValue, transaction) {
        return previousValue + (transaction.ftotamt as int);
      });
      sumByPymtmthd[key] = sum;
    });

    // Printing the sums by 'pymtmthd'
    sumByPymtmthd.forEach((key, value) {
      print('pymtmthd: $key, sum: $value');
      data.add(IafjrnhdClass(transno1: '', pymtmthd: key, ftotamt: value));
    });
    print(data);
    return data;
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
          future: olahData(),
          builder: (context, snapshot) {
            print('ini ${snapshot.data}');
            if (data.isNotEmpty) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: Text(
                      'Cashier summary',
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
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            title: Text(
                              data[index].pymtmthd!,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(CurrencyFormat.convertToIdr(
                                data[index].ftotamt, 0)),
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
