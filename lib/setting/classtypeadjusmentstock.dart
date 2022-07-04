import 'package:flutter/material.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/minibackoffice/classlistpembelian.dart';
import 'package:posq/minibackoffice/classlistpengembalianbarang.dart';
import 'package:posq/minibackoffice/pembelianmob.dart';
import 'package:posq/model.dart';

class ClassAdjusmentType extends StatefulWidget {
  final Outlet pscd;
  const ClassAdjusmentType({Key? key, required this.pscd}) : super(key: key);

  @override
  State<ClassAdjusmentType> createState() => _ClassAdjusmentTypeState();
}

class _ClassAdjusmentTypeState extends State<ClassAdjusmentType> {
  late DatabaseHandler handler;
  String query = '';

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
        title: Text('List Transaksi'),
      ),
      body: FutureBuilder(
          future: handler.retrivegntranstp(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Gntrantp>> snapshot) {
            var x = snapshot.data ?? [];
            if (x.isNotEmpty) {
              return ListView.builder(
                  itemCount: x.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(x[index].ProgNm!),
                          trailing: Text(x[index].trtp),
                          onTap: () {
                            if (x[index].trtp == '7010') {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return ClassListPembelian(
                                  pscd: widget.pscd,
                                  trtpcd: x[index],
                                );
                              }));
                            }
                            if (x[index].trtp == '7081') {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return ClassListPengembalianPembelian(
                                  pscd: widget.pscd,
                                  trtpcd: x[index],
                                );
                              }));
                            }
                          },
                        ),
                        Divider()
                      ],
                    );
                  });
            }
            return Container(
              child: Center(
                child: Text('Tidak ada data!!'),
              ),
            );
          }),
    );
  }
}
