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

class RefundTransaksi extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  late List<String> listoutlets;

  RefundTransaksi(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.builder,
      required this.listoutlets})
      : super(key: key);

  @override
  State<RefundTransaksi> createState() => _RefundTransaksiState();
}

class _RefundTransaksiState extends State<RefundTransaksi> {
  String? query = '';
  List<IafjrndtClass> data = [];
  List<IafjrndtClass> datatemp = [];
  Map<String, int> sumByPymtmthd = {};

  void initState() {
    super.initState();
    data = [];
    datatemp = [];
    sumByPymtmthd = {};
    ToastContext().init(context);
  }

  void methodA() {
    data = [];
    datatemp = [];
    sumByPymtmthd = {};
    setState(() {});
    print('from voidmethod ${widget.listoutlets}');
  }

  Future<List<IafjrndtClass>> olahData() async {
    for (var x in widget.listoutlets) {
      await ClassApi.getRefundTransaksi(widget.fromdate, widget.todate, x, '')
          .then((value) {
        data.addAll(value);
      });
    }
    ;
  print('ini data : $data');
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
      height: MediaQuery.of(context).size.height * 0.50,
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
                    child: Text('Refund transaksi'),
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
                            title: Text(data[index].transno!.isEmpty?'?':data[index].transno!),
                            subtitle: Text(data[index].reason!.isEmpty?'No reason':data[index].reason!),
                          );
                        }),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
