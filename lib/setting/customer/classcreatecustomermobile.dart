import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';

class ClassCreateCustomerMobile extends StatefulWidget {
  const ClassCreateCustomerMobile({Key? key}) : super(key: key);

  @override
  State<ClassCreateCustomerMobile> createState() =>
      _ClassCreateCustomerMobileState();
}

class _ClassCreateCustomerMobileState extends State<ClassCreateCustomerMobile> {
  final customercd = TextEditingController();
  final fullname = TextEditingController();
  final title = TextEditingController(text: 'Pilih Gender');
  final address = TextEditingController();
  final phone = TextEditingController();
  final kategory = TextEditingController(text: 'Pilih Kategori');
  final email = TextEditingController();
  final points = TextEditingController();
  final workkom = TextEditingController();
  final memberfrom = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String compcd = '';
  int maxid = 0;
  String? selectedctg;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    memberfrom.text = formattedDate;
  }

  Future<dynamic> addCustomers() async {
    await ClassApi.insertRegisterCustomer(
        customercd.text,
        fullname.text,
        title.text,
        phone.text,
        email.text,
        workkom.text,
        address.text,
        points.text,
        memberfrom.text);
  }

  bool validatePhoneNumber(String phoneNumber) {
    // Regular expression pattern for a 10-digit mobile phone number
    RegExp regExp = RegExp(r'^[0-9]{12}$');
    return regExp.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Buat Customers'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
              label: 'Nama Customer',
              controller: fullname,
              typekeyboard: TextInputType.text,
              onChanged: (value) {
                // print(value);
                var rng = Random();
                setState(() {
                  customercd.text =
                      '${value.substring(0, 4).replaceAll(' ', '')}${rng.nextInt(100)}';
                });
                print(customercd.text);
              },
            ),
            TextFieldMobileButton(
                hint: 'gender',
                controller: title,
                typekeyboard: TextInputType.text,
                onChanged: (value) {},
                ontap: () async {
                  final String titles = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const DialogTabArscompClass();
                      });

                  title.text = titles.isNotEmpty ? titles : 'Pilih Gender';
                  setState(() {});
                }),
            TextFieldMobile2(
              label: 'Alamat',
              controller: address,
              typekeyboard: TextInputType.text,
              onChanged: (value) {},
            ),
            TextFieldMobile2(
              hint: '08222176xxx',
              label: 'No Telp',
              controller: phone,
              typekeyboard: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a phone number.';
                }
                // Regular expression pattern for a 10-digit mobile phone number
                RegExp regExp = RegExp(r'^[0-9]{11,12}$');
                if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid 12-digit phone number.';
                }
                return null;
              },
              onChanged: (value) async {},
            ),
            TextFieldMobile2(
              label: 'E-mail',
              controller: email,
              typekeyboard: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an email address.';
                }
                // Regular expression pattern for email validation
                RegExp regExp = RegExp(
                    r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$');
                if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
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
                  await ClassApi.checkPhoneNumber(phone.text)
                      .then((value) async {
                    print(value);
                    if (value.isEmpty) {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await addCustomers().whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Nomer telp sudah terdaftar",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }
}
