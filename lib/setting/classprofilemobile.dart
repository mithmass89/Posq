// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, unused_local_variable, avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class Profilemobile extends StatefulWidget {
  const Profilemobile({Key? key}) : super(key: key);

  @override
  State<Profilemobile> createState() => _ProfilemobileState();
}

class _ProfilemobileState extends State<Profilemobile> {
  late DatabaseHandler handler;
  final outletcd = TextEditingController();
  final controllerNameOutlet = TextEditingController();
  final controllerTelp = TextEditingController();
  final controllerDetail = TextEditingController();
  final controllerKodepos = TextEditingController();
  String? namaoutlet;
  num? telp;
  String? detail;
  num? kodepos;
  String? maxid;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
  }

  Future<int> addOutlet() async {
    Outlet firstUser = Outlet(
      outletname: namaoutlet.toString(),
      telp: num.parse(telp.toString()),
      kodepos: kodepos.toString(),
      alamat: detail.toString(),
      outletcd: outletcd.toString(),
      trnonext: 1,
      trnopynext: 1,
    );
    List<Outlet> listOfUsers = [firstUser];
    return await this.handler.insertOutlet(listOfUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Profile Settings',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Container(
                      child: Text('Informasi Outlet',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    TextFieldMobile(
                      typekeyboard: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          namaoutlet = value;
                          print(namaoutlet);
                        });
                      },
                      controller: outletcd,
                      label: 'Outlet Code',
                    ),
                    TextFieldMobile(
                      typekeyboard: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          handler.queryCheckOutlet().then((value) {
                            setState(() {
                              maxid = value.toString();
                            });
                            print(namaoutlet!.substring(0, 5) + '$maxid');
                          });
                          namaoutlet = value;
                          setState(() {
                            outletcd.text =
                                namaoutlet!.substring(0, 5) + '$maxid';
                          });
                        });
                      },
                      controller: controllerNameOutlet,
                      label: 'Nama Outlet',
                    ),
                    TextFieldMobile(
                      typekeyboard: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          telp = num.parse(value);
                        });
                      },
                      controller: controllerTelp,
                      label: 'Nomer Telpon',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: Text(
                        'Alamat Outlet',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFieldMobile(
                      typekeyboard: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          detail = value;
                        });
                      },
                      controller: controllerDetail,
                      label: 'Detail Alamat',
                    ),
                    TextFieldMobile(
                      typekeyboard: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          kodepos = num.parse(value);
                        });
                        print(kodepos);
                      },
                      controller: controllerKodepos,
                      label: 'Kode Pos',
                    ),
                  ],
                ),
                Column(
                  children: [
                    ButtonNoIcon(
                      color: Colors.blue,
                      textcolor: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      onpressed: () {
                        handler = DatabaseHandler();
                        handler.initializeDB(databasename).whenComplete(() async {
                          await addOutlet().whenComplete(() async {
                            print(handler.retrieveUsers().then((value) {
                              print('${value.map((e) => e.outletname)}');
                            }));
                          });
                          setState(() {});
                        }).then((_) {
                          Navigator.of(context).pop(context);
                        });

                        print('sudah terlaksana');
                      },
                      name: 'Save',
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
