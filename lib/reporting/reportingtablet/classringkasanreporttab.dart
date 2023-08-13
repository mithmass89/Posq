// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassRingkasantab extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  final List<CombineDataRingkasan> data;
  late List<String> listoutlets;

  ClassRingkasantab(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.data,
      required this.listoutlets})
      : super(key: key);

  @override
  State<ClassRingkasantab> createState() => _ClassRingkasantabState();
}

class _ClassRingkasantabState extends State<ClassRingkasantab> {
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
    for (var x in widget.listoutlets) {
      await ClassApi.getReportRingkasan(widget.fromdate, widget.todate, x, '')
          .then((value) {
        for (var z in value) {
          datatemp.add(CombineDataRingkasan(
              transno: z.transno == null ? 0 : z.transno,
              revenuegross: z.revenuegross == null ? 0 : z.revenuegross,
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
    num pajak =
        datatemp.fold(0, (previousValue, isi) => previousValue + isi.pajak!);
    num service =
        datatemp.fold(0, (previousValue, isi) => previousValue + isi.service!);
    num totalnett = datatemp.fold(
        0, (previousValue, isi) => previousValue + isi.totalnett!);
    num totalpayment = datatemp.fold(
        0, (previousValue, isi) => previousValue + isi.totalpayment!);
    data.add(CombineDataRingkasan(
        transno: transno,
        revenuegross: revenuegross,
        pajak: pajak,
        service: service,
        totalnett: totalnett,
        totalpayment: totalpayment));

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
          builder: (context, snapshot) {
            print(snapshot.data);
            var x = snapshot.data ?? [];
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
                    child: Text('Ringkasan'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 5 / 2,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1),
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
                          dense: true,
                          title: Text('Pendapatan Bersih'),
                          subtitle: Text(CurrencyFormat.convertToIdr(
                              data[0].revenuegross, 0)),
                        ),
                     data[0].pajak!=null?   ListTile(
                          dense: true,
                          title: Text('Pajak'),
                          subtitle: Text(
                              CurrencyFormat.convertToIdr(data[0].pajak, 0)),
                        ):Container(),
                        data[0].service!=null? ListTile(
                          dense: true,
                          title: Text('Service / gratitude'),
                          subtitle: Text(
                              CurrencyFormat.convertToIdr(data[0].service, 0)),
                        ):Container(),
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
