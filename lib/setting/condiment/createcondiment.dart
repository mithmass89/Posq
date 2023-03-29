import 'dart:math';
import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/condiment/optioncreate.dart';
import 'package:posq/userinfo.dart';

class CondimentCreate extends StatefulWidget {
  final String pscd;
  const CondimentCreate({Key? key, required this.pscd}) : super(key: key);

  @override
  State<CondimentCreate> createState() => _CondimentCreateState();
}

class _CondimentCreateState extends State<CondimentCreate> {
  final TextEditingController modifiername = TextEditingController();
  final TextEditingController amount = TextEditingController(text: '0');
  final TextEditingController taxpct = TextEditingController(text: '0');
  final TextEditingController servicepct = TextEditingController();
  final TextEditingController selectedset =
      TextEditingController(text: 'Pilih Set Menu');
  final TextEditingController opsi = TextEditingController(text: 'Opsi');
  final TextEditingController typeopse =
      TextEditingController(text: 'Tipe Modifier');

  List<OptionsCond> _selectedOption = [];
  List<Condiment> _listcondiment = [];
  List<Condiment_Map> selectedItem = [];
  List<String> optionList = [];
  String condimentcode = '';
  bool trackstock = false;
  TypeCondiment? choice;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    taxpct.text = '0';
    servicepct.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Modifier Creation'),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Detail Modifier',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            TextFieldMobile2(
              label: 'Modifier name',
              controller: modifiername,
              typekeyboard: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  var rng = Random();
                  for (var i = 0; i < 10; i++) {}
                  setState(() {
                    condimentcode = '${modifiername.text.substring(0, 1)}'
                            '${rng.nextInt(10000)}'
                        .replaceAll(' ', '');
                  });
                  if (_listcondiment.isNotEmpty) {
                    for (var x in _listcondiment) {
                      x.itemcode = condimentcode;
                    }
                  }
                });
              },
            ),
            ListTile(
              title: Text(
                'Tipe Modifier',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            TextFieldMobileButton(
                hint: 'Tipe Modifier',
                controller: typeopse,
                typekeyboard: TextInputType.text,
                onChanged: (value) {},
                ontap: () async {
                  choice = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return DialogTipeCondiment();
                      });
                  if (choice!.opsidesc.isNotEmpty) {
                    setState(() {
                      typeopse.text = choice!.opsidesc;
                    });
                  }
                  if (_listcondiment.isNotEmpty) {
                    for (var x in _listcondiment) {
                      x.condimenttype = choice!.opsitype;
                    }
                  }
                }),
            ListTile(
              title: Text(
                'Buat Opsi',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            TextFieldMobileButton(
                hint: 'Opsi',
                controller: opsi,
                typekeyboard: TextInputType.text,
                onChanged: (value) {},
                ontap: () async {
                  _selectedOption = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OptionCreate()));
                  print(_selectedOption);
                  for (var x in _selectedOption) {
                    _listcondiment.add(Condiment(
                        taxamount: taxpct.text != ''
                            ? num.parse(taxpct.text) * x.amount!
                            : 0,
                        serviceamount: servicepct.text != ''
                            ? num.parse(servicepct.text) * x.amount!
                            : 0,
                        taxpct: taxpct.text != '' ? num.parse(taxpct.text) : 0,
                        servicepct: servicepct.text != ''
                            ? num.parse(servicepct.text)
                            : 0,
                        itemcode: condimentcode,
                        condimentdesc: modifiername.text,
                        optioncode: x.code,
                        optiondesc: x.description,
                        amount: x.amount,
                        condimenttype: choice!.opsitype,
                        qty: x.qty,
                        nettamount: x.amount! +
                            num.parse(taxpct.text) * x.amount! +
                            num.parse(servicepct.text) * x.amount!));
                    setState(() {
                      optionList.add(x.description!);
                      opsi.text = optionList.toString();
                    });
                  }
                  print(_listcondiment);
                }),
            ListTile(
              title: Text(
                'Pilih Item yg Akan di masukan modifier',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            TextFieldMobileButton(
                hint: 'Pilih set menu',
                controller: selectedset,
                typekeyboard: TextInputType.text,
                onChanged: (value) {},
                ontap: () async {
                  var list = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return DialogSetMenu();
                      });
                  for (var x in list) {
                    selectedItem.add(Condiment_Map(
                        condimentcode: condimentcode, itemcode: x));
                  }
                  setState(() {
                    selectedset.text = list.toString();
                  });
                  print(selectedItem);
                }),
            ListTile(
              title: Text(
                'Pajak Dan Service',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFieldMobile2(
                    label: 'Persentasi Tax',
                    controller: taxpct,
                    typekeyboard: TextInputType.number,
                    onChanged: (value) {
                      _listcondiment.forEach((element) {
                        element.taxpct = num.parse(taxpct.text);
                        element.taxamount =
                            element.amount! * num.parse(taxpct.text)/100;
                      });
                      _listcondiment.forEach((element) {
                        element.nettamount !=
                            element.amount! +
                                element.taxamount! +
                                element.serviceamount!;
                      });
                      print(_listcondiment);
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: TextFieldMobile2(
                    label: 'Persentasi Service',
                    controller: servicepct,
                    typekeyboard: TextInputType.number,
                    onChanged: (value) {
                      _listcondiment.forEach((element) {
                        element.servicepct = num.parse(servicepct.text);
                        element.serviceamount =
                            element.amount! * num.parse(servicepct.text)/100;
                      });

                      print(_listcondiment);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  LoadingButton(
                    isLoading: isLoading,
                    textcolor: Colors.white,
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.955,
                    name: 'Simpan',
                    onpressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      _listcondiment.forEach((element) {
                        element.nettamount = element.amount! +
                            element.taxamount! +
                            element.serviceamount!;
                      });

                      await ClassApi.insertCondiment_Master(
                          dbname, _listcondiment);
                      await ClassApi.insertCondiment_Map(dbname, selectedItem);
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
