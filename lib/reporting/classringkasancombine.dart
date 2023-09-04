// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:toast/toast.dart';

class ClassRingkasanAll extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  final List<CombineDataRingkasan> data;
  late List<String> listoutlets;

  ClassRingkasanAll(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.data,
      required this.listoutlets})
      : super(key: key);

  @override
  State<ClassRingkasanAll> createState() => _ClassRingkasanAllState();
}

class _ClassRingkasanAllState extends State<ClassRingkasanAll> {
  late DatabaseHandler handler;
  String? query = '';
  List<CombineDataRingkasan> data = [];

  void initState() {
    super.initState();
    handler = DatabaseHandler();
    ToastContext().init(context);
  }

  void methodA() {
    data = [];
    setState(() {});
  }

  Future<List<CombineDataRingkasan>> olahData() async {
    List<CombineDataRingkasan> datatemp = [];
    for (var x in widget.listoutlets) {
      await ClassApi.getReportRingkasan(widget.fromdate, widget.todate, x, '')
          .then((value) {
        for (var z in value) {
          datatemp.add(CombineDataRingkasan(
              transno: z.transno == null ? 0 : z.transno,
              revenuegross: z.revenuegross == null ? 0 : z.revenuegross,
              totalcost: z.totalcost == null ? 0 : z.totalcost,
              pajak: z.pajak == null ? 0 : z.pajak,
              service: z.service == null ? 0 : z.service,
              totalnett: z.totalnett == null ? 0 : z.totalnett,
              totalpayment: z.totalpayment == null ? 0 : z.totalpayment));
        }
      });
    }
    ;
    num transno =
        datatemp.fold(0, (previousValue, isi) => previousValue + isi.transno!);
    num revenuegross = datatemp.fold(
        0, (previousValue, isi) => previousValue + isi.revenuegross!);
    num totalcost = datatemp.fold(
        0, (previousValue, isi) => previousValue + isi.totalcost!);
    num pajak =
        datatemp.fold(0, (previousValue, isi) => previousValue + isi.pajak!);
    num service =
        datatemp.fold(0, (previousValue, isi) => previousValue + isi.service!);
    num totalnett = datatemp.fold(
        0, (previousValue, isi) => previousValue + isi.totalnett!);
    num totalpayment = datatemp.fold(
        0, (previousValue, isi) => previousValue + isi.totalpayment!);
    data.add(CombineDataRingkasan(
        revenuegross: revenuegross,
        transno: transno,
        pajak: pajak,
        totalcost: totalcost,
        service: service,
        totalnett: totalnett,
        totalpayment: totalpayment));

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
            height: MediaQuery.of(context).size.height * 0.6,
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
                  child: Text('Ringkasan'),
                ),
                data.isNotEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            data[0].transno != null
                                ? ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Text('Total Transaksi'),
                                    subtitle: Text(data[0].transno.toString()),
                                  )
                                : Container(),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text('Pendapatan Bersih'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].revenuegross, 0)),
                            ),
                            ListTile(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //   return DetailTransaksiCogs();
                                // }));
                              },
                              dense: true,
                              title: Text('Harga dasar'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].totalcost, 0)),
                            ),
                            data[0].pajak != 0
                                ? ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Text('Pajak'),
                                    subtitle: Text(CurrencyFormat.convertToIdr(
                                        data[0].pajak, 0)),
                                  )
                                : Container(),
                            data[0].service != 0
                                ? ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Text('Service / gratitude'),
                                    subtitle: Text(CurrencyFormat.convertToIdr(
                                        data[0].service, 0)),
                                  )
                                : Container(),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text('Pendapatan kotor'),
                              subtitle: Text(CurrencyFormat.convertToIdr(
                                  data[0].totalnett, 0)),
                            ),
                            ListTile(
                              onTap: () {},
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
