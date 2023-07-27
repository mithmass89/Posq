import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classcahsiersummarydetail.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';
import 'package:collection/collection.dart';

class CashierSummary extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  late List<String> listoutlets;

  CashierSummary(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.listoutlets})
      : super(key: key);

  @override
  State<CashierSummary> createState() => _CashierSummaryState();
}

class _CashierSummaryState extends State<CashierSummary> {
  String? query = '';
  List<IafjrnhdClass> data = [];
  List<IafjrnhdClass> datatemp = [];
  List<IafjrnhdClass> detail = [];
  Map<String, int> sumByPymtmthd = {};

  void initState() {
    super.initState();

    data = [];
    datatemp = [];
    sumByPymtmthd = {};
    ToastContext().init(context);
  }

  void methodA() {
    detail = [];
    data = [];
    datatemp = [];
    sumByPymtmthd = {};
    // setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<List<IafjrnhdClass>> olahData() async {
    for (var x in widget.listoutlets) {
      await ClassApi.getCashierSummary(
        widget.fromdate,
        widget.todate,
        x,
      ).then((value) {
        datatemp.addAll(value);
        detail.addAll(value);
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
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.50,
      child: FutureBuilder(
          future: olahData(),
          builder: (context, snapshot) {
            if (data.isNotEmpty) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.03,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                    ),
                    child: Text('Cashier summary'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.35,
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
                            title: Text(data[index].pymtmthd!),
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
                            return ClassCashierSummaryDetail(
                              listoutlets: widget.listoutlets.isEmpty
                          ? listoutlets
                          : List.generate(widget.listoutlets.length,
                              (index) => widget.listoutlets[index]),
                              datatemp: detail,
                              fromdate: widget.fromdate,
                              todate: widget.todate,
                            );
                          }));
                        },
                        child: Text('lihat detail')),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
