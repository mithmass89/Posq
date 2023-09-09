import 'dart:math';

import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';

class OptionCreate extends StatefulWidget {
  const OptionCreate({Key? key}) : super(key: key);

  @override
  State<OptionCreate> createState() => _OptionCreateState();
}

class _OptionCreateState extends State<OptionCreate> {
  List<OptionsCond> optionlist = [];
  late List<TextEditingController>? descriptionlist = [];
  late List<TextEditingController>? amountlist = [];
  late List<TextEditingController>? codelist = [];

  _addWidget() {
    descriptionlist!.add(TextEditingController());
    amountlist!.add(TextEditingController());
    codelist!.add(TextEditingController());
  }

  removeWidget(index) {
    setState(() {
      descriptionlist!.removeAt(index);
      amountlist!.removeAt(index);
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
          appBar: AppBar(
            title: Text('Option List',style: TextStyle(color: Colors.white),),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: descriptionlist!.length,
                      itemBuilder: ((context, index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFieldMobile2(
                                  label: 'Deskripsi',
                                  controller: descriptionlist![index],
                                  typekeyboard: TextInputType.text,
                                  onChanged: (value) {
                                    var rng = Random();
                                    for (var i = 0; i < 10; i++) {
                                      print(rng.nextInt(1000));
                                    }
                                    setState(() {
                                      codelist![index].text =
                                          '${descriptionlist![index].text.substring(0, 1)}'
                                                  '${rng.nextInt(10000)}'
                                              .replaceAll(' ', '');
                                    });
                                    print(codelist![index].text);
                                  }),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFieldMobile2(
                                  label: 'Amount',
                                  controller: amountlist![index],
                                  typekeyboard: TextInputType.text,
                                  onChanged: (value) {
                                    setState(
                                      () {},
                                    );
                                  }),
                            ),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                    onPressed: () {
                                      removeWidget(index);
                                    },
                                    icon: Icon(Icons.close)))
                          ],
                        );
                      })),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LoadingButton(
                      isLoading: false,
                      textcolor: Colors.white,
                      color: AppColors.primaryColor,
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.55,
                      name: 'Simpan',
                      onpressed: () async {
                        print(descriptionlist!.map((e) => e.text));
                        print(amountlist!.map((e) => e.text));
                        for (var x in descriptionlist!) {
                          optionlist.add(OptionsCond(
                            code: codelist![descriptionlist!.indexOf(x)].text,
                            description: x.text,
                            amount: num.parse(
                                amountlist![descriptionlist!.indexOf(x)].text),
                            qty: 0,
                          ));
                        }
                        print(optionlist);
                        Navigator.of(context).pop(optionlist);
                      },
                    ),
                    LoadingButton(
                      isLoading: false,
                      textcolor: Colors.white,
                      color: Color.fromARGB(255, 0, 164, 185),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.35,
                      name: 'Tambah Opsi',
                      onpressed: () async {
                        _addWidget();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else if (constraints.maxWidth >= 820) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Option List',style: TextStyle(color: Colors.white),),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: descriptionlist!.length,
                      itemBuilder: ((context, index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFieldMobile2(
                                  label: 'Deskripsi',
                                  controller: descriptionlist![index],
                                  typekeyboard: TextInputType.text,
                                  onChanged: (value) {
                                    var rng = Random();
                                    for (var i = 0; i < 10; i++) {
                                      print(rng.nextInt(1000));
                                    }
                                    setState(() {
                                      codelist![index].text =
                                          '${descriptionlist![index].text.substring(0, 1)}'
                                                  '${rng.nextInt(10000)}'
                                              .replaceAll(' ', '');
                                    });
                                    print(codelist![index].text);
                                  }),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFieldMobile2(
                                  label: 'Amount',
                                  controller: amountlist![index],
                                  typekeyboard: TextInputType.text,
                                  onChanged: (value) {
                                    setState(
                                      () {},
                                    );
                                  }),
                            ),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                    onPressed: () {
                                      removeWidget(index);
                                    },
                                    icon: Icon(Icons.close)))
                          ],
                        );
                      })),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoadingButton(
                      isLoading: false,
                      textcolor: Colors.white,
                      color: AppColors.primaryColor,
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.55,
                      name: 'Simpan',
                      onpressed: () async {
                        print(descriptionlist!.map((e) => e.text));
                        print(amountlist!.map((e) => e.text));
                        for (var x in descriptionlist!) {
                          optionlist.add(OptionsCond(
                            code: codelist![descriptionlist!.indexOf(x)].text,
                            description: x.text,
                            amount: num.parse(
                                amountlist![descriptionlist!.indexOf(x)].text),
                            qty: 0,
                          ));
                        }
                        print(optionlist);
                        Navigator.of(context).pop(optionlist);
                      },
                    ),
                    LoadingButton(
                      isLoading: false,
                      textcolor: AppColors.primaryColor,
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.35,
                      name: 'Tambah Opsi',
                      onpressed: () async {
                        _addWidget();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }
}
