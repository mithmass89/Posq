import 'dart:math';

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class ClassCreateCustomerMobile extends StatefulWidget {
  const ClassCreateCustomerMobile({Key? key}) : super(key: key);

  @override
  State<ClassCreateCustomerMobile> createState() =>
      _ClassCreateCustomerMobileState();
}

class _ClassCreateCustomerMobileState extends State<ClassCreateCustomerMobile> {
  late DatabaseHandler handler;

  final compdesc = TextEditingController();
  final coaar = TextEditingController();
  final coapayment = TextEditingController(text: 'Pilih Kategori');
  final address = TextEditingController();
  final active = TextEditingController(text: '0');
  final kategory = TextEditingController(text: 'Pilih Kategori');
  final telp = TextEditingController();
  final email = TextEditingController();
  final pic = TextEditingController();

  String compcd = '';
  int maxid = 0;
  String? selectedctg;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<int> addCustomers() async {
    Costumers customers = Costumers(
      compcd: compcd,
      compdesc: compdesc.text,
      category: selectedctg,
      coaar: 'ARCOMPANY',
      coapayment: 'AR CLEARENCE',
      address: address.text,
      telp: telp.text,
      pic: pic.text,
      email: email.text,
      active: 1,
    );
    List<Costumers> listcustomers = [customers];
    return await handler.insertCustomers(listcustomers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Buat Customers'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.05,
            child: const Text('Informasi Customer'),
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
          ),
          TextFieldMobileButton(
              hint: 'Pilih Kategori',
              controller: kategory,
              typekeyboard: TextInputType.text,
              onChanged: (value) {},
              ontap: () async {
                final Ctg result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DialogTabArscompClass();
                    });
                setState(() {
                  selectedctg = result.ctgcd;
                  kategory.text = result.ctgdesc;
                });
              }),
          TextFieldMobile2(
            label: 'Nama perusahaan / perorangan',
            controller: compdesc,
            typekeyboard: TextInputType.text,
            onChanged: (value) {
              // print(value);
              var rng = Random();
              setState(() {
                compcd =
                    '${value.substring(0, 4).replaceAll(' ', '')}${rng.nextInt(100)}';
              });
              print(compcd);
            },
          ),
          TextFieldMobile2(
            label: 'Alamat',
            controller: address,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'No Telp',
            controller: telp,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'E-mail',
            controller: email,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'Nama Pic',
            controller: pic,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
          ),
          ButtonNoIcon(
              name: 'Save',
              color: Colors.blue,
              textcolor: Colors.white,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.95,
              onpressed: () async {
                await addCustomers().whenComplete(() {
                  Navigator.of(context).pop();
                });
              }),
        ],
      ),
    );
  }
}
