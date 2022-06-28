// ignore_for_file: avoid_print, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:posq/appsmobile.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'dart:math';

class ClassSetupProfileMobile extends StatefulWidget {
  const ClassSetupProfileMobile({Key? key}) : super(key: key);

  @override
  State<ClassSetupProfileMobile> createState() =>
      _ClassSetupProfileMobileState();
}

class _ClassSetupProfileMobileState extends State<ClassSetupProfileMobile> {
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
    handler = DatabaseHandler();
  }

  Future<int> addOutlet() async {
    Outlet firstUser = Outlet(
      outletname: namaoutlet.toString(),
      telp: num.parse(telp.toString()),
      kodepos: kodepos.toString(),
      alamat: detail.toString(),
      outletcd: outletcd.text,
      trnonext: 1,
      trnopynext: 1,
    );
    List<Outlet> listOfUsers = [firstUser];
    return await handler.insertOutlet(listOfUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Buat Usahamu',
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
                      child: const Text('Informasi Usaha',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    // TextFieldMobile(
                    //   typekeyboard: TextInputType.text,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       namaoutlet = value;
                    //       print(namaoutlet);
                    //     });
                    //   },
                    //   controller: outletcd,
                    //   label: 'Outlet Code',
                    // ),
                    TextFieldMobile2(
                      typekeyboard: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          namaoutlet = value;
                          var rng = Random();
                          for (var i = 0; i < 10; i++) {
                            print(rng.nextInt(100));
                          }
                          setState(() {
                            outletcd.text = '${namaoutlet!.substring(0, 5)}'
                                 '${rng.nextInt(100)}-'
                                .replaceAll(' ', '');
                          });
                          print(outletcd.text);
                        });
                      },
                      controller: controllerNameOutlet,
                      label: 'Nama Outlet',
                    ),
                    TextFieldMobile2(
                      typekeyboard: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          telp = num.parse(value);
                        });
                        print(telp);
                      },
                      controller: controllerTelp,
                      label: 'Nomer Telpon',
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: const Text(
                        'Alamat Usaha',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFieldMobile2(
                      typekeyboard: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          detail = value;
                        });
                      },
                      controller: controllerDetail,
                      label: 'Detail Alamat',
                    ),
                    TextFieldMobile2(
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
                        setState(() {
                          databasename=outletcd.text;
                        });
                        handler = DatabaseHandler();
                        handler.initializeDB(databasename).whenComplete(() async {
                          await addOutlet().whenComplete(() async {
                            print(handler.retrieveUsers().then((value) {
                              print('${value.map((e) => e)}');
                            }));
                          });
                          setState(() {});
                        }).then((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppsMobile(
                                      profileusaha: Outlet(
                                        outletname: namaoutlet.toString(),
                                        telp: num.parse(telp.toString()),
                                        kodepos: kodepos.toString(),
                                        alamat: detail.toString(),
                                        outletcd: outletcd.text,
                                        trnonext: 1,
                                        trnopynext: 1,
                                      ),
                                    )),
                          );
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
