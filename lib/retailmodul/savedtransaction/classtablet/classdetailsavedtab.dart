import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/savedtransaction/classsaveddetailcustmob.dart';
import 'package:posq/retailmodul/savedtransaction/classtabdetailtrnomobile.dart';
import 'package:posq/retailmodul/savedtransaction/classtablet/classtabdetailtrnotab.dart';

class DetailSavedTransactionTab extends StatefulWidget {
  final String trno;
  final Outlet outletinfo;
  final String pscd;
  final IafjrnhdClass? datatransaksi;
  final String status;
  const DetailSavedTransactionTab(
      {Key? key,
      required this.trno,
      required this.outletinfo,
      required this.pscd,
      this.datatransaksi,
      required this.status})
      : super(key: key);

  @override
  State<DetailSavedTransactionTab> createState() =>
      _DetailSavedTransactionTabState();
}

class _DetailSavedTransactionTabState extends State<DetailSavedTransactionTab>
    with SingleTickerProviderStateMixin {
  late DatabaseHandler handler;
  List<IafjrnhdClass> data = [];
  bool haspayment = false;
  TabController? _controller;
  num? amount = 0;

  @override
  void initState() {
    super.initState();
    // handler = DatabaseHandler();
    // handler.initializeDB(databasename);
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.print)),
          IconButton(onPressed: () {}, icon: Icon(Icons.send)),
          ButtonNoIcon(
            onpressed: () async {},
            textcolor: Colors.white,
            color: Colors.orange,
            name: haspayment == true ? 'Reopen' : 'Selesaikan',
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          )
        ],
        title: Column(
          children: [
            Text(widget.trno),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.95,
          //   height: MediaQuery.of(context).size.width * 0.01,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.82,
              child: Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.74,
                  child: Column(
                    children: [
                      Text('Detail Transaksi'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      TabDetailTrnoTab(
                        status: 'Belum Lunas',
                        trno: widget.trno,
                        outletinfo: widget.outletinfo,
                        pscd: widget.pscd,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: Column(
                    children: [
                      Text('Detail Info Pelanggan'),
                      ClassDetailPelanggan(
                        trno: widget.trno,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
