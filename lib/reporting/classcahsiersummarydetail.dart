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
  const ClassCashierSummaryDetail(
      {Key? key, required this.fromdate, required this.todate})
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

  void initState() {
    super.initState();
    handler = DatabaseHandler();
    ToastContext().init(context);
    formattedDate = formatter2.format(now);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi')),
      body: Container(
        child: FutureBuilder(
            future: ClassApi.getSummaryCashierDetail(
                widget.fromdate, widget.todate, dbname, query!),
            builder: (context, AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
              var x = snapshot.data ?? [];
              if (x.isNotEmpty) {
                return ListView.builder(
                    itemCount: x.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                              dense: true,
                              leading: Text(formatDate(x[index].trdt!)),
                              title: Text(x[index].transno!),
                              subtitle: Text(x[index].pymtmthd!),
                              trailing: Text(CurrencyFormat.convertToIdr(
                                  x[index].totalamt, 0))),
                          Divider(),
                        ],
                      );
                    });
              }
              return Container();
            }),
      ),
    );
  }
}
