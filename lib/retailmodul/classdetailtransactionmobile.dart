import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/classtabdetailtrnomobile.dart';

class ClassDetailTransMobile extends StatefulWidget {
  final String trno;
  final Outlet outletinfo;
  final String pscd;
  final IafjrnhdClass? datatransaksi;
  final String status;
  const ClassDetailTransMobile(
      {Key? key,
      required this.trno,
      required this.outletinfo,
      required this.pscd,
      required this.datatransaksi,
      required this.status})
      : super(key: key);

  @override
  State<ClassDetailTransMobile> createState() => _ClassDetailTransMobileState();
}

class _ClassDetailTransMobileState extends State<ClassDetailTransMobile>
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
    handler.initializeDB();
    _controller = TabController(length: 2, vsync: this);
    checkTransaction();
  }

  checkTransaction() {
    handler.retriveListDetailPayment(widget.trno).then((value) {
      if (value.first.pymtmthd != null) {
        setState(() {
          haspayment = true;
        });
      } else {
        setState(() {
          haspayment = false;
        });
      }
    });
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
                trno: widget.trno,
                outletinfo: widget.outletinfo,
                pscd: widget.pscd,
              ),
              Container(),
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
                                outletinfo: widget.outletinfo,
                                pscd: widget.pscd,
                                qty: 0,
                                trno: widget.trno,
                              )));
                },
                textcolor: Colors.white,
                color: Colors.blue,
                name: haspayment == true ? 'Reopen' : 'Selesaikan',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              ButtonNoIcon(
                onpressed: () {},
                textcolor: Colors.white,
                color: Colors.blue,
                name: 'Reprint',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              ButtonNoIcon(
                onpressed: () {},
                textcolor: Colors.white,
                color: Colors.blue,
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
