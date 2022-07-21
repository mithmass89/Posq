import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classcahsiersummarydetail.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:toast/toast.dart';

class ClassRingkasan extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;

  ClassRingkasan(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder})
      : super(key: key);

  @override
  State<ClassRingkasan> createState() => _ClassRingkasanState();
}

class _ClassRingkasanState extends State<ClassRingkasan> {
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
          future: handler.ringkasanPenjualan(widget.fromdate, widget.todate),
          builder: (context, AsyncSnapshot<List<Ringkasan>> snapshot) {
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
                            title: Text(x[index].trdesc),
                            subtitle: Text(CurrencyFormat.convertToIdr(
                                x[index].amount, 0)),
                          );
                        }),
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
                ],
              );
            }
            return Container();
          }),
    );
  }
}
