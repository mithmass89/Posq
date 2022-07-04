import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/minibackoffice/pembelianmob.dart';
import 'package:posq/model.dart';

class PilihTransaksiReceiving extends StatefulWidget {
  final Outlet pscd;
  late Gntrantp trtpcd;
  PilihTransaksiReceiving({Key? key, required this.pscd, required this.trtpcd})
      : super(key: key);

  @override
  State<PilihTransaksiReceiving> createState() =>
      _PilihTransaksiReceivingState();
}

class _PilihTransaksiReceivingState extends State<PilihTransaksiReceiving> {
  late DatabaseHandler handler;
  String query = '';
  int? trnonext;

  @override
  void initState() {
    super.initState();

    this.handler = DatabaseHandler();
    handler.initializeDB(databasename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Pembelian'),
      ),
      body: Column(
        // overflow: Overflow.visible,
        children: [
          FutureBuilder(
              future: handler.getDataRR(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                var x = snapshot.data ?? [];
                print(snapshot.data);
                if (x.isNotEmpty) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.80,
                    child: ListView.builder(
                        itemCount: x.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                  title: Text(x[index]['supcd']),
                                  trailing: Text(CurrencyFormat.convertToIdr(
                                      x[index]['totalprice'], 0)),
                                  subtitle: Row(
                                    children: [
                                      Text(x[index]['trno'].toString()),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      Text('Total Item : '),
                                      Text(x[index]['qtyremain'].toString()),
                                    ],
                                  ),
                                  onTap: () {
                                    print(x[index]);
                                    Navigator.of(context).pop(x[index]);
                                  }),
                              Divider()
                            ],
                          );
                        }),
                  );
                }
                return Container(
                  child: Center(
                    child: Text('Tidak ada data!!'),
                  ),
                );
              }),
          ButtonNoIcon2(
              name: 'Buat Transaksi',
              textcolor: Colors.white,
              color: Colors.blue,
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
              onpressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ClassPembelianMobile(
                      pscd: widget.pscd,
                      trtpcd: widget.trtpcd,
                    );
                  },
                )).then((_) async {
                  await handler.getTrnoNextBO(widget.trtpcd.trtp).then((value) {
                    setState(() {
                      widget.trtpcd = value.first;
                    });
                  });
                });
              })
        ],
      ),
    );
  }
}
