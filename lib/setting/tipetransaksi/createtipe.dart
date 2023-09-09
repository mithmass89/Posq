import 'dart:math';

import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class CreateTipeTransaksi extends StatefulWidget {
  final String pscd;
  const CreateTipeTransaksi({Key? key, required this.pscd}) : super(key: key);

  @override
  State<CreateTipeTransaksi> createState() => _CreateTipeTransaksiState();
}

class _CreateTipeTransaksiState extends State<CreateTipeTransaksi> {
  final TextEditingController code = TextEditingController();
  final TextEditingController deskripsi = TextEditingController();
  late List<TextEditingController>? descriptionlist = [];
  late List<TransactionTipe> listtipe = [];
  bool _isloading = false;
  @override
  void initState() {
    super.initState();
  }

  _addWidget() {
    descriptionlist!.add(TextEditingController());
    listtipe.add(TransactionTipe());
  }

  removeWidget(index) {
    setState(() {
      descriptionlist!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 480) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Buat Tipe Transaksi',style: TextStyle(color: Colors.white),),
            actions: [
              Container(
                child: IconButton(
                  onPressed: () {
                    descriptionlist = [];
                    setState(() {});
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              )
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                    itemCount: descriptionlist!.length,
                    itemBuilder: (context, index) {
                      return Row(children: [
                        Expanded(
                          flex: 5,
                          child: TextFieldMobile2(
                              label: 'Transaksi tipe',
                              controller: descriptionlist![index],
                              typekeyboard: TextInputType.text,
                              onChanged: (value) {
                                var rng = Random();
                                for (var i = 0; i < 10; i++) {
                                  // print(rng.nextInt(1000));
                                }
                                listtipe[index].transtype =
                                    rng.nextInt(1000).toString();
                                listtipe[index].transdesc =
                                    descriptionlist![index].text;
                                print(listtipe);
                              }),
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                removeWidget(index);
                              },
                              icon: Icon(Icons.close),
                              color: Colors.red,
                              iconSize: 17,
                            )),
                      ]);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    LoadingButton(
                        isLoading: _isloading,
                        color: AppColors.primaryColor,
                        textcolor: Colors.white,
                        name: 'Simpan',
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
                        onpressed: _isloading == false
                            ? () async {
                                _isloading = true;
                                await ClassApi.insert_TransactionType(
                                    dbname, listtipe);
                                setState(() {});
                                _isloading = false;
                                Navigator.of(context).pop();
                              }
                            : null),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ButtonNoIcon(
                      textcolor: AppColors.primaryColor,
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.6,
                      name: 'Tambah Tipe',
                      onpressed: () async {
                        _addWidget();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (constraints.maxWidth >= 820) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Buat Tipe Transaksi',style: TextStyle(color: Colors.white),),
            actions: [
              Container(
                child: IconButton(
                  onPressed: () async {
                    await ClassApi.insert_TransactionType(dbname, listtipe);
                    setState(() {});

                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.save,
                    size: 40,
                  ),
                  color: AppColors.primaryColor,
                ),
              ),
              Container(
                child: IconButton(
                  onPressed: () {
                    descriptionlist = [];
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 40,
                  ),
                  color: Colors.red,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            splashColor: Colors.yellow,
            hoverColor: Colors.red,
            onPressed: () {
              _addWidget();
              setState(() {});
            },
            child: Icon(Icons.add),
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: ListView.builder(
                    itemCount: descriptionlist!.length,
                    itemBuilder: (context, index) {
                      return Row(children: [
                        Expanded(
                          flex: 5,
                          child: TextFieldMobile2(
                              label: 'Transaksi tipe',
                              controller: descriptionlist![index],
                              typekeyboard: TextInputType.text,
                              onChanged: (value) {
                                var rng = Random();
                                for (var i = 0; i < 10; i++) {
                                  // print(rng.nextInt(1000));
                                }
                                listtipe[index].transtype =
                                    rng.nextInt(1000).toString();
                                listtipe[index].transdesc =
                                    descriptionlist![index].text;
                                print(listtipe);
                              }),
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                removeWidget(index);
                              },
                              icon: Icon(Icons.close),
                              color: Colors.red,
                              iconSize: 17,
                            )),
                      ]);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}
