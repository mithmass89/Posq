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
  final TextEditingController amount = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Modifier Creation'),
      ),
      body: Column(
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
                      itemcode: condimentcode,
                      condimentdesc: modifiername.text,
                      optioncode: x.code,
                      optiondesc: x.description,
                      amount: x.amount,
                      condimenttype: choice!.opsitype,
                      qty: x.qty));
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
                  selectedItem.add(
                      Condiment_Map(condimentcode: condimentcode, itemcode: x));
                }
                setState(() {
                  selectedset.text = list.toString();
                });
                print(selectedItem);
              }),
          Spacer(),
          ButtonNoIcon(
            textcolor: Colors.white,
            color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.6,
            name: 'Simpan',
            onpressed: () async {
              await ClassApi.insertCondiment_Master(dbname, _listcondiment);
              await ClassApi.insertCondiment_Map(dbname, selectedItem);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
        ],
      ),
    );
  }
}
