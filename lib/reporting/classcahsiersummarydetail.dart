import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
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

  void initState() {
    super.initState();
    handler = DatabaseHandler();
    ToastContext().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi')),
      body: Container(
        child: FutureBuilder(
            future: handler.cashierSummaryDetail(
                query, widget.fromdate, widget.todate),
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
                              leading: Text(x[index].trdt!),
                              title: Text(x[index].trno!),
                              subtitle: Text(x[index].pymtmthd!),
                              trailing: Text(CurrencyFormat.convertToIdr(
                                  x[index].ftotamt, 0))),
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
