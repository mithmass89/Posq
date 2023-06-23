// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassRingkasanAllTab extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;

  ClassRingkasanAllTab({
    Key? key,
    required this.fromdate,
    required this.todate,
    required this.builder,
  }) : super(key: key);

  @override
  State<ClassRingkasanAllTab> createState() => _ClassRingkasanAllState();
}

class _ClassRingkasanAllState extends State<ClassRingkasanAllTab> {
  String? query = '';
  List<CombineDataRingkasan> data = [];

  void initState() {
    super.initState();
    ToastContext().init(context);
  }

  void methodA() {
    data = [];
    setState(() {});
  }

  Future<List<CombineDataRingkasan>> olahData() async {
    List<CombineDataRingkasan> datatemp = [];
    for (var x in listoutlets) {
      await ClassApi.getReportRingkasan(widget.fromdate, widget.todate, x, '')
          .then((value) {
        for (var z in value) {
          datatemp.add(CombineDataRingkasan(
              revenuegross: z.revenuegross == null ? 0 : z.revenuegross,
              pajak: z.pajak == null ? 0 : z.pajak,
              service: z.service == null ? 0 : z.service,
              totalnett: z.totalnett == null ? 0 : z.totalnett,
              totalpayment: z.totalpayment == null ? 0 : z.totalpayment));
        }
      });
      num revenuegross = datatemp.fold(
          0, (previousValue, isi) => previousValue + isi.revenuegross!);
      num pajak =
          datatemp.fold(0, (previousValue, isi) => previousValue + isi.pajak!);
      num service = datatemp.fold(
          0, (previousValue, isi) => previousValue + isi.service!);
      num totalnett = datatemp.fold(
          0, (previousValue, isi) => previousValue + isi.totalnett!);
      num totalpayment = datatemp.fold(
          0, (previousValue, isi) => previousValue + isi.totalpayment!);
      data.add(CombineDataRingkasan(
          revenuegross: revenuegross,
          pajak: pajak,
          service: service,
          totalnett: totalnett,
          totalpayment: totalpayment));
    }
    ;
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, methodA);
    return FutureBuilder(
        future: olahData(),
        builder: (context, snapshot) {
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
            child: Column(
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
                  child: Text('Ringkasan semua outlet'),
                ),
                data.isNotEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.44,
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 5 / 2,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 1),
                          children: [
                            ListTile(
                              dense: true,
                              title: Text('Pendapatan Bersih'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].revenuegross, 0)),
                            ),
                            ListTile(
                              dense: true,
                              title: Text('Pajak'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].pajak, 0)),
                            ),
                            ListTile(
                              dense: true,
                              title: Text('Service / gratitude'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].service, 0)),
                            ),
                            ListTile(
                              dense: true,
                              title: Text('Pendapatan kotor'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].totalnett, 0)),
                            ),
                            ListTile(
                              dense: true,
                              title: Text('Total pembayaran di terima'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].totalpayment, 0)),
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          );
        });
  }
}
