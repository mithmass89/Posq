import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classcahsiersummarydetail.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:toast/toast.dart';

class CashierSummary extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;

  CashierSummary(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder})
      : super(key: key);

  @override
  State<CashierSummary> createState() => _CashierSummaryState();
}

class _CashierSummaryState extends State<CashierSummary> {
  late DatabaseHandler handler;
  String? query = '';

  void initState() {
    super.initState();
    handler = DatabaseHandler();
    ToastContext().init(context);
  }

  void methodA() {
    setState(() {
      print(widget.fromdate); 
      print(widget.todate);
    });
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
          future: handler.cashierSummary(query, widget.fromdate, widget.todate),
          builder: (context, AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
            var x = snapshot.data ?? [];
            if (x.isNotEmpty) {
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
                    child: Text('Ringkasan'),
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
                        itemCount: x.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            title: Text(x[index].pymtmthd!),
                            subtitle: Text(CurrencyFormat.convertToIdr(
                                x[index].ftotamt, 0)),
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
