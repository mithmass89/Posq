import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassCashierSummaryDetail extends StatefulWidget {
  final String fromdate;
  final String todate;
  final List<IafjrnhdClass> datatemp;
  late List<String> listoutlets;
  ClassCashierSummaryDetail(
      {Key? key,
      required this.fromdate,
      required this.listoutlets,
      required this.todate,
      required this.datatemp})
      : super(key: key);

  @override
  State<ClassCashierSummaryDetail> createState() =>
      _ClassCashierSummaryDetailState();
}

class _ClassCashierSummaryDetailState extends State<ClassCashierSummaryDetail> {
  late DatabaseHandler handler;
  String? query = '';
  var formatter2 = DateFormat('dd-MMM-yyyy');
  String? formattedDate;
  var now = DateTime.now();
  List<IafjrnhdClass> detail = [];

  void initState() {
    super.initState();
    handler = DatabaseHandler();
    ToastContext().init(context);
    formattedDate = formatter2.format(now);
    getDataDetail();
  }

  String formatDate(String dateString) {
    initializeDateFormatting('id', null);
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat =
        DateFormat('dd MMMM yyyy', 'id'); // 'id' for Indonesian language

    final date = inputFormat.parse(dateString);
    final formattedDate = outputFormat.format(date);

    return formattedDate;
  }

  getDataDetail() async {
    print('generate list : ${widget.listoutlets}');
    for (var x in widget.listoutlets) {
      await ClassApi.getSummaryCashierDetail(
              widget.fromdate, widget.todate, x, query!)
          .then((value) {
        print('test value : $value');
        detail.addAll(value);
      });
    }
    print('ini detail : $detail');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi')),
      body: Container(
          child: ListView.builder(
              itemCount: detail.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                        dense: true,
                        leading: Text(formatDate(detail[index].trdt!)),
                        title: Text(detail[index].transno!),
                        subtitle: Text(detail[index].pymtmthd!),
                        trailing: Text(CurrencyFormat.convertToIdr(
                            detail[index].totalamt, 0))),
                    Divider(),
                  ],
                );
              })),
    );
  }
}
