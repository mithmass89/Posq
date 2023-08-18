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
  List<dynamic> detail = [];
  List<dynamic> data = [];
  List<dynamic> datatemp = [];
  Map<String, Map<String, dynamic>> sumsByItem = {};
  Future? olahdata;
  List<dynamic> outletnewlist = [];

  void initState() {
    super.initState();
    ToastContext().init(context);
    olahdata = olahData();
    var x = widget.listoutlets;
    outletnewlist = x.toSet().toList();
    print('total outlet: ${widget.listoutlets.length}');
  }

  void methodA() {
    detail = [];
    data = [];
    datatemp = [];
    sumsByItem = {};
    // setState(() {});
    print('data dari void $data');
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool areEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) {
      return false;
    }

    for (var key in map1.keys) {
      if (map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }

  List<dynamic> removeDuplicates(List<dynamic> dataList) {
    List<dynamic> uniqueList = [];

    for (var data in dataList) {
      if (data is Map<String, dynamic>) {
        bool isDuplicate = false;
        for (var uniqueData in uniqueList) {
          if (uniqueData is Map<String, dynamic> &&
              areEqual(data, uniqueData)) {
            isDuplicate = true;
            break;
          }
        }
        if (!isDuplicate) {
          uniqueList.add(data);
        }
      }
    }

    return uniqueList;
  }

  Future<List<dynamic>> olahData() async {
    int count = 0;
    datatemp = [];
    data = [];
    sumsByItem = {};

    print('new outletlist: $outletnewlist');
    for (var x in outletnewlist) {
      count++;
      print('pengulangan : $count');
      await ClassApi.getCashierSummary(
        widget.fromdate,
        widget.todate,
        x,
      ).then((value) {
        datatemp.addAll(value);
      });
    }
    ;

    print(datatemp);
    List<dynamic> uniqueDataList = removeDuplicates(datatemp);
    Map<String, List<dynamic>> groupedData =
        groupBy(uniqueDataList, (item) => item['pymtmthd']);
    print('ini unique data : $uniqueDataList');
    // Calculating the sum of 'qty' and 'nettrevenue' for each group
    groupedData.forEach((key, value) {
      int ftotamt = value.fold(0, (previousValue, item) {
        return previousValue + (item['ftotamt'] as int);
      });

      sumsByItem[key] = {
        'pymtmthd': key,
        'ftotamt': ftotamt,
      };
    });

    sumsByItem.forEach((key, value) {
      print('ftotamt: ${value['ftotamt']}');
      data.add({
        "pymtmthd": value['pymtmthd'],
        "ftotamt": value['ftotamt'],
      });
    });
    // print(sumsByItem);

    // print('ini datax $data');

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
      height: MediaQuery.of(context).size.height * 0.57,
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
                            title: Text(data[index]['pymtmthd']),
                            subtitle: Text(CurrencyFormat.convertToIdr(
                                data[index]['ftotamt'], 0)),
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
