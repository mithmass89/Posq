// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class ClassEditCustomers extends StatefulWidget {
  final Costumers listdata;
  const ClassEditCustomers({Key? key, required this.listdata})
      : super(key: key);

  @override
  State<ClassEditCustomers> createState() => _ClassEditCustomersState();
}

class _ClassEditCustomersState extends State<ClassEditCustomers> {
  late DatabaseHandler handler;
  TextEditingController? compcd = TextEditingController();
  TextEditingController? compdesc= TextEditingController();
  TextEditingController? coaar= TextEditingController();
  TextEditingController? coapayment=TextEditingController();
  TextEditingController? address=TextEditingController();
  TextEditingController? active=TextEditingController();
  TextEditingController? kategory=TextEditingController();
  TextEditingController? telp=TextEditingController();
  TextEditingController? email=TextEditingController();
  TextEditingController? pic=TextEditingController();

  @override
  void initState() {
    super.initState();
    compcd!.text = widget.listdata.compcd;
    compdesc!.text = widget.listdata.compdesc!;
    coaar!.text = widget.listdata.coaar!;
    coapayment!.text = widget.listdata.coapayment!;
    address!.text = widget.listdata.address!;
    active!.text = widget.listdata.active.toString();
    kategory!.text = widget.listdata.category!;
    telp!.text = widget.listdata.telp!;
    email!.text = widget.listdata.email!;
    pic!.text = widget.listdata.pic!;
    this.handler = DatabaseHandler();
    handler.initializeDB(databasename);
  }

  updateCustomers() async {
    await handler.initializeDB(databasename);
    handler.updateArscomp(Costumers(
        compdesc: compdesc!.text,
        address: address!.text,
        email: email!.text,
        telp: telp!.text,
        pic: pic!.text,
        active: 1,
        compcd: widget.listdata.compcd));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Customers'),
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
          TextFieldMobile2(
            label: 'Nama perusahaan / perorangan',
            controller: compdesc!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'Alamat',
            controller: address!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'No Telp',
            controller: telp!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'E-mail',
            controller: email!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'Nama Pic',
            controller: pic!,
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
                await updateCustomers().whenComplete(() {
                  Navigator.of(context).pop();
                });
              }),
        ],
      ),
    );
  }
}
