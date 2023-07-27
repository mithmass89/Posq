import 'dart:async';

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/menupackage/classtab/createpackagetab.dart';
import 'package:posq/setting/menupackage/createpackagemobile.dart';
import 'package:posq/userinfo.dart';

class MainMenuPackageMobile extends StatefulWidget {
  const MainMenuPackageMobile({Key? key}) : super(key: key);

  @override
  State<MainMenuPackageMobile> createState() => _MainMenuPackageMobileState();
}

class _MainMenuPackageMobileState extends State<MainMenuPackageMobile> {
  List<Package> listpaket = [];
  String? query = '';
  TextEditingController search = TextEditingController();
  Timer? timer;
  Timer? debouncer;

  Future<List<Package>> getData() async {
    listpaket = await ClassApi.getPackageMenu(pscd, dbname, query!);
    return listpaket;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    timer?.cancel();
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer?.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Menu Package List'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 173, 150),
        foregroundColor: Colors.white,
        splashColor: Colors.yellow,
        hoverColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuatPaketMobile()),
          ).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFieldMobile(
              // hint: 'Cari paket',
              label: 'Cari paket',
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: FutureBuilder(
                future: getData(),
                builder: (context, AsyncSnapshot<List<Package>> snapshot) {
                  if (listpaket.isNotEmpty) {
                    listpaket = snapshot.data!;
                    return Container(
                      child: ListView.builder(
                          itemCount: listpaket.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                // trailing: IconButton(
                                //     onPressed: () async {
                                //       await showDialog(
                                //           context: context,
                                //           builder: (BuildContext context) {
                                //             return DialogDeactivePackage(
                                //               itemcode:
                                //                   listpaket[index].packagecd!,
                                //             );
                                //           });
                                //       await getData().then((value) {
                                //         setState(() {});
                                //       });
                                //     },
                                //     icon: Icon(Icons.close)),
                                title: Text(
                                  listpaket[index].packagedesc,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                    'Item / produk di dalam paket ${listpaket[index].qty}',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text('Tidak Ada paket'),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
