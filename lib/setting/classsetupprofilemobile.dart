// ignore_for_file: avoid_print, avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/appsmobile.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'dart:math';
import 'dart:io';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

ClassApi? apicloud;

class ClassSetupProfileMobile extends StatefulWidget {
  final String username;
  const ClassSetupProfileMobile({Key? key, required this.username})
      : super(key: key);

  @override
  State<ClassSetupProfileMobile> createState() =>
      _ClassSetupProfileMobileState();
}

class _ClassSetupProfileMobileState extends State<ClassSetupProfileMobile> {
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
  bool connect = false;
  bool _isloading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    apicloud = ClassApi();
    if (kIsWeb == false) {
      checkInternet();
    }
  }

  /// create outlet for first time///
  Future<void> _createProfile(Outlet data) async {
    final request = await ClassApi.insertOutlet(Outlet(
        outletcd: data.outletcd,
        outletname: data.outletname,
        telp: data.telp,
        alamat: data.alamat,
        kodepos: data.kodepos,
        profile: data.profile,
        slstp: data.slstp));
  }

  //// create user access to outlet they have/////

  /// create GNTRANP ///
  // Future<void> _insertGntrantp(String profile) async {
  //   List<List> datatrtp = [
  //     ["1001", "Receiving", "RR-", outletcd.text, 0],
  //     ["1002", "Store Request", "SR-", outletcd.text, 0],
  //     ["1003", "Stock Opname", "ST-", outletcd.text, 0],
  //     ["1004", "Return Receiving", "RNR-", outletcd.text, 0],
  //     ["1005", "Return Store", "RSR-", outletcd.text, 0],
  //     ["2001", "Account Payable", "AP-", outletcd.text, 0],
  //     ["2003", "Account Receivable", "AR-", outletcd.text, 0],
  //     ["3001", "Cash & Bank In", "CB-IN-", outletcd.text, 0],
  //     ["3002", "Cash & Bank Out", "CB-OUT-", outletcd.text, 0]
  //   ];

  //   await ClassApi.insertTranstype(datatrtp, outletcd.text);
  // }

  ///save data profile for later ///

//// check internet connection ///
  Future<dynamic> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('$api');
      print("ini result : ${result.first}");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        setState(() {
          connect = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connect = false;
      });
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Buat Usahamu $usercd',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 480) {
          return Form(
            key: formKey,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
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
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.centerLeft,
                                child: const Text('Informasi Usaha',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              TextFieldMobile2(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                typekeyboard: TextInputType.text,
                                onChanged: (value) {
                                  setState(() {
                                    namaoutlet = value;
                                    var rng = Random();
                                    for (var i = 0; i < 10; i++) {
                                      print(rng.nextInt(1000));
                                    }
                                    setState(() {
                                      outletcd.text =
                                          '${namaoutlet!.substring(0, 5)}'
                                                  '${rng.nextInt(10000)}'
                                              .replaceAll(' ', '');
                                    });
                                    print(outletcd.text);
                                  });
                                },
                                controller: controllerNameOutlet,
                                label: 'Nama Outlet',
                              ),
                              TextFieldMobile2(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
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
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Alamat Usaha',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextFieldMobile2(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              LoadingButton(
                                isLoading: _isloading,
                                color: Colors.orange,
                                textcolor: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.9,
                                onpressed: _isloading == false
                                    ? () async {
                                        if (formKey.currentState!.validate()) {
                                          usercd = widget.username;
                                          setState(() {
                                            _isloading = true;
                                          });
                                          if (outletcd.text == '') {
                                            print('Empty code outlet');
                                          } else {
                                            EasyLoading.show(
                                                status: 'loading...');
                                            await _createProfile(Outlet(
                                                outletname:
                                                    namaoutlet.toString(),
                                                telp:
                                                    num.parse(telp.toString()),
                                                kodepos: kodepos.toString(),
                                                alamat: controllerDetail.text,
                                                outletcd: outletcd.text,
                                                profile: outletcd.text));
                                            await ClassApi.insertOutletUser(
                                                outletcd.text, usercd);
                                            // await _insertGntrantp(outletcd.text);
                                            setState(() {
                                              _isloading = false;
                                              pscd = outletcd.text;
                                              dbname = outletcd.text;
                                            });
                                            await ClassApi.getAccessUser(usercd)
                                                .then((valueds) {
                                              for (var x in valueds) {
                                                accesslist.add(x['access']);
                                              }
                                            });
                                            await ClassApi
                                                    .getAccessSettingsUser()
                                                .then((valuess) {
                                              strictuser = valuess[0]
                                                      ['strictuser']
                                                  .toString();
                                            });
                                            EasyLoading.dismiss();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppsMobile(
                                                        chartdata: [],
                                                        monthlysales: [],
                                                        todaysale: [],
                                                        profileusaha: Outlet(
                                                          outletname: namaoutlet
                                                              .toString(),
                                                          telp: num.parse(
                                                              telp.toString()),
                                                          kodepos: kodepos
                                                              .toString(),
                                                          alamat:
                                                              detail.toString(),
                                                          outletcd:
                                                              outletcd.text,
                                                          trnonext: 1,
                                                          trnopynext: 1,
                                                        ),
                                                      )),
                                            );
                                          }
                                        }
                                      }
                                    : null,
                                name: 'Simpan',
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (constraints.maxWidth >= 800) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.65,
                child: Form(
                  key: formKey,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SingleChildScrollView(
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
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.centerLeft,
                                      child: const Text('Informasi Usaha',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    TextFieldMobile2(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      typekeyboard: TextInputType.text,
                                      onChanged: (value) {
                                        setState(() {
                                          namaoutlet = value;
                                          var rng = Random();
                                          for (var i = 0; i < 10; i++) {
                                            print(rng.nextInt(1000));
                                          }
                                          setState(() {
                                            outletcd.text =
                                                '${namaoutlet!.substring(0, 5)}'
                                                        '${rng.nextInt(10000)}'
                                                    .replaceAll(' ', '');
                                          });
                                          print(outletcd.text);
                                        });
                                      },
                                      controller: controllerNameOutlet,
                                      label: 'Nama Outlet',
                                    ),
                                    TextFieldMobile2(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
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
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Alamat Usaha',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextFieldMobile2(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
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
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
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
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    LoadingButton(
                                      isLoading: _isloading,
                                      color: Colors.orange,
                                      textcolor: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      onpressed: _isloading == false
                                          ? () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                usercd = widget.username;
                                                setState(() {
                                                  _isloading = true;
                                                });
                                                if (outletcd.text == '') {
                                                  print('Empty code outlet');
                                                } else {
                                                  EasyLoading.show(
                                                      status: 'loading...');
                                                  await _createProfile(Outlet(
                                                      outletname:
                                                          namaoutlet.toString(),
                                                      telp: num.parse(
                                                          telp.toString()),
                                                      kodepos:
                                                          kodepos.toString(),
                                                      alamat:
                                                          controllerDetail.text,
                                                      outletcd: outletcd.text,
                                                      profile: outletcd.text));
                                                  await ClassApi
                                                      .insertOutletUser(
                                                          outletcd.text,
                                                          usercd);
                                                  // await _insertGntrantp(outletcd.text);
                                                  setState(() {
                                                    _isloading = false;
                                                    pscd = outletcd.text;
                                                    dbname = outletcd.text;
                                                  });
                                                  await ClassApi.getAccessUser(
                                                          usercd)
                                                      .then((valueds) {
                                                    for (var x in valueds) {
                                                      accesslist
                                                          .add(x['access']);
                                                    }
                                                  });
                                                  await ClassApi
                                                          .getAccessSettingsUser()
                                                      .then((valuess) {
                                                    strictuser = valuess[0]
                                                            ['strictuser']
                                                        .toString();
                                                  });
                                                  EasyLoading.dismiss();
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AppsMobile(
                                                              chartdata: [],
                                                              monthlysales: [],
                                                              todaysale: [],
                                                              profileusaha:
                                                                  Outlet(
                                                                outletname:
                                                                    namaoutlet
                                                                        .toString(),
                                                                telp: num.parse(
                                                                    telp.toString()),
                                                                kodepos: kodepos
                                                                    .toString(),
                                                                alamat: detail
                                                                    .toString(),
                                                                outletcd:
                                                                    outletcd
                                                                        .text,
                                                                trnonext: 1,
                                                                trnopynext: 1,
                                                              ),
                                                            )),
                                                  );
                                                }
                                              }
                                            }
                                          : null,
                                      name: 'Simpan',
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      }),
    );
  }
}
