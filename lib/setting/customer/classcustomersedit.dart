// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class ClassEditCustomers extends StatefulWidget {
  final Costumers listdata;
  const ClassEditCustomers({Key? key, required this.listdata})
      : super(key: key);

  @override
  State<ClassEditCustomers> createState() => _ClassEditCustomersState();
}

class _ClassEditCustomersState extends State<ClassEditCustomers> {
  TextEditingController? customercd = TextEditingController();
  TextEditingController? fullname = TextEditingController();
  TextEditingController? title = TextEditingController();
  TextEditingController? phone = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? address = TextEditingController();
  TextEditingController? point = TextEditingController();
  TextEditingController? memberfrom = TextEditingController();

  @override
  void initState() {
    super.initState();
    customercd!.text = widget.listdata.customercd!;
    fullname!.text = widget.listdata.fullname;
    title!.text = widget.listdata.title!;
    phone!.text = widget.listdata.phone!;
    address!.text = widget.listdata.address!;
    email!.text = widget.listdata.email.toString();
    point!.text = widget.listdata.points!.toString();
    memberfrom!.text = widget.listdata.memberfrom!;
    email!.text = widget.listdata.email!;
  }

  updateCustomers() async {
    await ClassApi.updateCustomers(fullname!.text, title!.text, phone!.text,
        email!.text, address!.text, customercd!.text, dbname);
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
            label: 'Nama lengkap',
            controller: fullname!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobileButton(
              hint: 'gender',
              controller: title!,
              typekeyboard: TextInputType.text,
              onChanged: (value) {},
              ontap: () async {
                final String titles = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DialogTabArscompClass();
                    });

                title!.text = titles.isNotEmpty ? titles : 'Pilih Gender';
                setState(() {});
              }),
          TextFieldMobile2(
            label: 'Alamat',
            controller: address!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'Phone',
            controller: phone!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          TextFieldMobile2(
            label: 'E-mail',
            controller: email!,
            typekeyboard: TextInputType.text,
            onChanged: (value) {},
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
          ),
          ButtonNoIcon(
              name: 'Simpan',
              color: Colors.blue,
              textcolor: Colors.white,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.95,
              onpressed: () async {
                EasyLoading.show(status: 'loading...');
                await updateCustomers().whenComplete(() {
                  EasyLoading.dismiss();
                  Navigator.of(context).pop();
                });
              }),
        ],
      ),
    );
  }
}
