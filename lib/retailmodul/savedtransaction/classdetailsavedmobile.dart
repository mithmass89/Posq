import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/savedtransaction/classsaveddetailcustmob.dart';
import 'package:posq/retailmodul/savedtransaction/classtabdetailtrnomobile.dart';

class DetailSavedTransaction extends StatefulWidget {
  final String trno;
  final Outlet outletinfo;
  final String pscd;
  final IafjrnhdClass? datatransaksi;
  final String status;
  const DetailSavedTransaction(
      {Key? key,
      required this.trno,
      required this.outletinfo,
      required this.pscd,
      this.datatransaksi,
      required this.status})
      : super(key: key);

  @override
  State<DetailSavedTransaction> createState() => _DetailSavedTransactionState();
}

class _DetailSavedTransactionState extends State<DetailSavedTransaction>
    with SingleTickerProviderStateMixin {
  late DatabaseHandler handler;
  List<IafjrnhdClass> data = [];
  bool haspayment = false;
  TabController? _controller;
  num? amount = 0;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.trno),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.width * 0.12,
            child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                controller: _controller,
                tabs: [
                  Text('Detail Transaksi'),
                  Text('Detail Pelanggan'),
                ]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.width * 0.06,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.70,
            child: TabBarView(controller: _controller, children: [
              TabDetailTrno(
                status: 'Belum Lunas',
                trno: widget.trno,
                outletinfo: widget.outletinfo,
                pscd: widget.pscd,
              ),
              ClassDetailPelanggan(
                trno: widget.trno,
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonNoIcon(
                onpressed: () async {
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassRetailMainMobile(
                                fromsaved: true,
                                outletinfo: widget.outletinfo,
                                pscd: widget.pscd,
                                qty: 0,
                                trno: widget.trno,
                              )));
                },
                textcolor: Colors.white,
                color: Colors.orange,
                name: haspayment == true ? 'Reopen' : 'Selesaikan',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              ButtonNoIcon(
                onpressed: () {},
                textcolor: Colors.white,
                color: Colors.orange,
                name: 'Print',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              ButtonNoIcon(
                onpressed: () {},
                textcolor: Colors.white,
                color: Colors.orange,
                name: 'Kirim',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
