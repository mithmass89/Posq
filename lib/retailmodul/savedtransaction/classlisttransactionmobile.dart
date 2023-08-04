// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_this, avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/classdetailtrnomobile.dart';
import 'package:posq/userinfo.dart';

class Listtransaction extends StatefulWidget {
  final String? pscd;
  final Outlet outletinfo;
  final bool fromsaved;

  const Listtransaction({
    Key? key,
    this.pscd,
    required this.outletinfo,
    required this.fromsaved,
  }) : super(key: key);

  @override
  State<Listtransaction> createState() => _ListtransactionState();
}

class _ListtransactionState extends State<Listtransaction> {
  // late DatabaseHandler handler;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  int? pending;
  String? fromdate;
  String? todate;
  String? fromdatenamed;
  String? todatenamed;
  String? formatdate;
  String? query = '';
  String? periode;
  final TextEditingController search = TextEditingController();
  final TextEditingController _controllerdate = TextEditingController();
  @override
  void initState() {
    super.initState();
    // this.handler = DatabaseHandler();
    formattedDate = formatter.format(now);
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    periode = formaterprd.format(now);
    // checkPending();
    startDate();
    fromdatenamed = formattedDate;
    todatenamed = formattedDate;
    _controllerdate.text = '$fromdatenamed - $todatenamed';
  }

  var formatter2 = DateFormat('dd-MMM-yyyy');
  var formaterprd = DateFormat('yyyyMM');

  Setter() {
    setState(() {});
  }

  startDate() {
    setState(() {
      fromdate = formatdate;
      todate = formatdate;
    });
    print("ini formatdate sql $formatdate");
    print("ini from date$fromdate");
    print("ini todate $todate");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
        saveText: 'Done',
        context: context,
        // initialDate: now,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2201));
    if (result != null) {
      // Rebuild the UI
      // print(result.start.toString());

      setState(() {
        ///tanggal dan nama
        fromdatenamed = formatter2.format(result.start);
        todatenamed = formatter2.format(result.end);

        ///tanggal format database///
        fromdate = formatter.format(result.start);
        todate = formatter.format(result.end);
        _controllerdate.text = '$fromdatenamed - $todatenamed';
      });
    }
    // getDataReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Riwayat Transaksi'),
        actions: [],
      ),
      body: Column(
        children: [
          TextFieldMobile2(
            hint: 'Search',
            suffixIcon: Icon(
              Icons.search,
            ),
            controller: search,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            typekeyboard: TextInputType.text,
          ),
          Expanded(
              child: TextFieldMobileButton(
            suffixicone: Icon(Icons.date_range),
            controller: _controllerdate,
            onChanged: (value) {},
            ontap: () async {
              await _selectDate(context);
            },
            typekeyboard: TextInputType.text,
          )),
          FutureBuilder(
              future: ClassApi.getSummaryCashierDetail(
                  fromdate!, todate!, dbname, query!),
              builder: (context, AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
                var x = snapshot.data ?? [];
                if (x.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 1,
                        child: ListView.builder(
                            itemCount: x.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: DetailTrno(
                                  setter: Setter,
                                  fromsaved: widget.fromsaved,
                                  datatransaksi: IafjrnhdClass(
                                    pymtmthd: x[index].pymtmthd,
                                    totalamt: x[index].totalamt,
                                    trdt: x[index].trdt,
                                    transno1: x[index].transno1,
                                  ),
                                  trno: x[index].transno,
                                  outletinfo: widget.outletinfo,
                                  pscd: widget.pscd.toString(),
                                ),
                              );
                            }),
                      )
                    ],
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Nothing here')],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
