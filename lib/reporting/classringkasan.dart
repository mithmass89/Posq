// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassRingkasan extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  late List<String> listoutlets;

  ClassRingkasan(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.listoutlets})
      : super(key: key);

  @override
  State<ClassRingkasan> createState() => _ClassRingkasanState();
}

class _ClassRingkasanState extends State<ClassRingkasan> {
  String? query = '';
  List<IafjrnhdClass> data = [];
  List<IafjrnhdClass> datatemp = [];
  Map<String, int> sumByPymtmthd = {};

  void initState() {
    super.initState();
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
          future: ClassApi.getReportRingkasan(
              widget.fromdate, widget.todate, dbname, ''),
          builder:
              (context, AsyncSnapshot<List<CombineDataRingkasan>> snapshot) {
            print(snapshot.data);
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
                    height: MediaQuery.of(context).size.height * 0.44,
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          title: Text('Pendapatan Bersih'),
                          subtitle: Text(CurrencyFormat.convertToIdr(
                              x[0].revenuegross, 0)),
                        ),
                        ListTile(
                          dense: true,
                          title: Text('Pajak'),
                          subtitle:
                              Text(CurrencyFormat.convertToIdr(x[0].pajak, 0)),
                        ),
                        ListTile(
                          dense: true,
                          title: Text('Service / gratitude'),
                          subtitle: Text(
                              CurrencyFormat.convertToIdr(x[0].service, 0)),
                        ),
                        ListTile(
                          dense: true,
                          title: Text('Pendapatan kotor'),
                          subtitle: Text(
                              CurrencyFormat.convertToIdr(x[0].totalnett, 0)),
                        ),
                        ListTile(
                          dense: true,
                          title: Text('Total pembayaran di terima'),
                          subtitle: Text(CurrencyFormat.convertToIdr(
                              x[0].totalpayment, 0)),
                        ),
                      ],
                    ),
                    // Container(
                    //   margin: EdgeInsets.all(10),
                    //   width: MediaQuery.of(context).size.width * 0.9,
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    //   child: TextButton(
                    //       onPressed: () {
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (BuildContext context) {
                    //           return ClassCashierSummaryDetail(
                    //             fromdate: widget.fromdate,
                    //             todate: widget.todate,
                    //           );
                    //         }));
                    //       },
                    //       child: Text('lihat detail')),
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
