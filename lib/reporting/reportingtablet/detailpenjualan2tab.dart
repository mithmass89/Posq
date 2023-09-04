// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:toast/toast.dart';
import 'package:collection/collection.dart';

class DetailMenuTerjual2Tab extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  final List<String> listoutlets;

  DetailMenuTerjual2Tab(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.listoutlets})
      : super(key: key);

  @override
  State<DetailMenuTerjual2Tab> createState() => _DetailMenuTerjual2TabState();
}

class _DetailMenuTerjual2TabState extends State<DetailMenuTerjual2Tab> {
  late DatabaseHandler handler;
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> olahData() async {
    for (var x in widget.listoutlets) {
      await ClassApi.DetailMenuWithSize(
        widget.fromdate,
        widget.todate,
        x,
      ).then((value) {
        datatemp.addAll(value);
      });
    }
    ;
    Map<String, List<dynamic>> groupedData =
        groupBy(datatemp, (item) => item['itemdesc']);

    // Calculating the sum of 'qty' and 'nettrevenue' for each group

    groupedData.forEach((key, value) {
      int sumQty = value.fold(0, (previousValue, item) {
        return previousValue + (item['qty'] as int);
      });

      int sumNetRevenue = value.fold(0, (previousValue, item) {
        return previousValue + (item['totalaftdisc'] as int);
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
        "itemdesc": value['itemdesc'],
        "qty": value['sumQty'],
        "totalaftdisc": value["sumNetRevenue"]
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
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.55,
      child: FutureBuilder(
          future: olahData(),
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            var x = snapshot.data ?? [];
            if (x.isNotEmpty) {
              print(x);
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
                    child: Text('Detail Menu Terjual'),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.44,
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: ((context, index) {
                          return data[index]['qty'] != 0
                              ? ListTile(
                                  dense: true,
                                  title: Text(data[index]['itemdesc']),
                                  subtitle: Text(
                                      'Terjual X ${data[index]['qty'].toString()}'),
                                  trailing: Text(CurrencyFormat.convertToIdr(
                                      data[index]['totalaftdisc'], 0)),
                                )
                              : ListTile();
                        }),
                      )

                      // ),
                      )
                ],
              );
            }
            return Container();
          }),
    );
  }
}
