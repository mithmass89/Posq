import 'dart:io';

import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';

class LookUpDetailTrno extends StatefulWidget {
  final String trno;
  const LookUpDetailTrno({Key? key, required this.trno}) : super(key: key);

  @override
  State<LookUpDetailTrno> createState() => _LookUpDetailTrnoState();
}

class _LookUpDetailTrnoState extends State<LookUpDetailTrno> {
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
          'Detail Produk',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: this.handler.getDataDetailTrnoRRGrouped(widget.trno),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          var x = snapshot.data ?? [];
          if (x.isNotEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldMobile(
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
                            title: Text(x[index]['proddesc']),
                            trailing: Container(
                              width: MediaQuery.of(context).size.width * 0.17,
                              child: Row(
                                children: [
                                  Text('Qty : '),
                                  Text(x[index]['qtyremain'].toString()),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(x[index]);
                            },
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
                children: [],
              ),
            );
          }
        },
      ),
    );
  }
}
