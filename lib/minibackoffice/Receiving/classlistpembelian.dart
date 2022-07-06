import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/minibackoffice/Receiving/classlistdetailtransaksireceiving.dart';
import 'package:posq/minibackoffice/Receiving/formpembelianmob.dart';
import 'package:posq/minibackoffice/lookupdetailproduct.dart';
import 'package:posq/model.dart';

class ClassListPembelian extends StatefulWidget {
  final Outlet pscd;
  late Gntrantp trtpcd;
  ClassListPembelian({Key? key, required this.pscd, required this.trtpcd})
      : super(key: key);

  @override
  State<ClassListPembelian> createState() => _ClassListPembelianState();
}

class _ClassListPembelianState extends State<ClassListPembelian> {
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
                          return Container(
                            child: Column(
                              children: [
                                ListTile(
                                    title: Text(x[index]['supcd']),
                                    trailing: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                            ),
                                            iconSize: 20,
                                            color: Colors.blue,
                                            splashColor: Colors.transparent,
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return ClassListDetailReceving(
                                                   trtpcd: widget.trtpcd,
                                                    trno: x[index]['trno'],
                                                    pscd: widget.pscd,
                                                  
                                                  );
                                                },
                                              )).then((_) {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                            ),
                                            iconSize: 20,
                                            color: Colors.red,
                                            splashColor: Colors.transparent,
                                            onPressed: () async {
                                              await handler
                                                  .activeZeroGlftrdt(
                                                      x[index]['trno'])
                                                  .whenComplete(() {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(x[index]['trno'].toString()),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        Text(CurrencyFormat.convertToIdr(
                                            x[index]['totalprice'], 0)),
                                      ],
                                    ),
                                    onTap: () {}),
                                Divider()
                              ],
                            ),
                          );
                        }),
                  );
                }
                return Container(
                  height: MediaQuery.of(context).size.height * 0.80,
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
