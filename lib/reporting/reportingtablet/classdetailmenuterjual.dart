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
import 'package:collection/collection.dart';

class ClasMeuTerjualtab extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  final List<String> listoutlets;

  ClasMeuTerjualtab(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.listoutlets})
      : super(key: key);

  @override
  State<ClasMeuTerjualtab> createState() => _ClasMeuTerjualtabState();
}

class _ClasMeuTerjualtabState extends State<ClasMeuTerjualtab> {
  String? query = '';
  List<dynamic> data = [];
  List<dynamic> datatemp = [];
  Map<String, Map<String, dynamic>> sumsByItem = {};

  void initState() {
    super.initState();
    ToastContext().init(context);
    data = [];
    datatemp = [];
    sumsByItem = {};
  }

  void methodA() {
    data = [];
    datatemp = [];
    sumsByItem = {};
    setState(() {});
  }

  Future<List<dynamic>> olahData() async {
    for (var x in widget.listoutlets) {
      await ClassApi.DetailMenuItemTerjual(
        widget.fromdate,
        widget.todate,
        x,
      ).then((value) {
        datatemp.addAll(value);
      });
            print(datatemp);
    }
    ;
    Map<String, List<dynamic>> groupedData =
        groupBy(datatemp, (item) => item['itemdesc']);

    // Calculating the sum of 'qty' and 'nettrevenue' for each group

    groupedData.forEach((key, value) 
    {

      int sumQty = value.fold(0, (previousValue, item) {
        return previousValue + (item['qty'] as int);
      });

      int sumNetRevenue = value.fold(0, (previousValue, item) {
        return previousValue + (item['nettrevenue'] as int);
      });

      sumsByItem[key] = {
        'itemdesc': key,
        'sumQty': sumQty,
        'sumNetRevenue': sumNetRevenue,
      };
    });

    // Printing the sums for each item
    sumsByItem.forEach((key, value) {
      // print('Item: ${value['itemdesc']}');
      // print('Sum of qty: ${value['sumQty']}');
      // print('Sum of net revenue: ${value['sumNetRevenue']}');
      // print('------');
      data.add({
        "itemcode": value['itemcode'],
        "itemdesc": value['itemdesc'],
        "qty": value['sumQty'],
        "nettrevenue": value["sumNetRevenue"]
      });
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
          builder: (context, AsyncSnapshot snapshot) {
            print('ini ${snapshot.data}');
            if (data.isNotEmpty) {
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
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ClassCashierMenuSoldDetailTab(
                                    fromdate: widget.fromdate,
                                    todate: widget.todate,
                                    itemcode: data[index]['itemdesc']!,
                                  );
                                }));
                              },
                              leading: Text(
                                  'QTY : ${data[index]['qty'].toString()}'),
                              dense: true,
                              title: Text(
                                data[index]['itemdesc']!,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[index]['nettrevenue'], 0)),
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
