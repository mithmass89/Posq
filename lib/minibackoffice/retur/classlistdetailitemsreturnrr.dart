import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/minibackoffice/retur/classeditretur.dart';
import 'package:posq/minibackoffice/Receiving/classedittransaksireceiving.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/classcreateproduct.dart';

class ClassListDetailReturnReceving extends StatefulWidget {
  final String? trno;
  final Outlet pscd;
  final Gntrantp trtpcd;
  const ClassListDetailReturnReceving(
      {Key? key, this.trno, required this.pscd, required this.trtpcd})
      : super(key: key);

  @override
  State<ClassListDetailReturnReceving> createState() =>
      _ClassListDetailReturnRecevingState();
}

class _ClassListDetailReturnRecevingState
    extends State<ClassListDetailReturnReceving> {
  final search = TextEditingController();
  String query = '';
  late DatabaseHandler handler;
  bool? hasitem = false;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    handler.initializeDB(databasename);
    handler.retrieveItems(query).then((value) {
      if (value.length != 0) {
        setState(() {
          hasitem = true;
        });
      } else {
        setState(() {
          hasitem = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Detail Transaksi Retur',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: this.handler.getDataDetailReturnRR(widget.trno!),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          var x = snapshot.data ?? [];
          if (x.isNotEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldMobile2(
                    hint: 'Example Menu Description',
                    label: 'Search',
                    controller: search,
                    onChanged: (value) async {
                      setState(() {
                        query = value;
                        print(value);
                      });
                    },
                    typekeyboard: TextInputType.text,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 1,
                  child: ListView.builder(
                    itemCount: x.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Text(x[index]['id'].toString()),
                            title: Text(x[index]['proddesc']),
                            subtitle: Container(
                              width: MediaQuery.of(context).size.width * 0.17,
                              child: Row(
                                children: [
                                  Text('Qty : '),
                                  Text(x[index]['qtyconv'].toString()),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text('Harga: '),
                                  Text(x[index]['totalprice'].toString()),
                                ],
                              ),
                            ),
                            trailing: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
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
                                        builder: (BuildContext context) {
                                          return ClassEditReturn(
                                            data: x[index],
                                            pscd: widget.pscd,
                                            trtpcd: widget.trtpcd,
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
                                            .activeZeroReceivingitemseq(
                                                x[index]['trno'],
                                                x[index]['itemseq'])
                                            .whenComplete(() async {});

                                        setState(() {});
                               
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(child: Text('Tidak ada produk')),
                  Container(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Createproduct()),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                          child: Text('Buat Produk'))),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
