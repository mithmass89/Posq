import 'dart:math';

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';
import 'package:posq/classui/classtextfield.dart';

class CreatePaymentTab extends StatefulWidget {
  final String pscd;
  const CreatePaymentTab({Key? key, required this.pscd}) : super(key: key);

  @override
  State<CreatePaymentTab> createState() => _CreatePaymentTabState();
}

class _CreatePaymentTabState extends State<CreatePaymentTab> {
  TextEditingController description = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telp = TextEditingController();
  TextEditingController pic = TextEditingController();
  TextEditingController tempo = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController limit = TextEditingController();
  TextEditingController npwp = TextEditingController();
String companycode='';
  final GlobalKey<FormState> _validation = GlobalKey<FormState>();

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address';
    }

    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return 'false';
  }

  String _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter a phone number';
    }

    final RegExp phoneRegex = RegExp(
      r'^\+?(\d{1,3})?[-. ]?\(?\d{3}\)?[-. ]?\d{3}[-. ]?\d{4}$',
    );

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return '';
  }

  void _submitFormemail() {
    if (_validation.currentState!.validate()) {
      // Valid form submission
      final String emails = email.text;
      print('Email: $emails');
    }
  }

  void _submitphone() {
    if (_validation.currentState!.validate()) {
      // Valid form submission
      final String phoneNumber = telp.text;
      print('Phone number: $phoneNumber');
    }
  }

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Company'),
      ),
      body: Form(
        key: _validation,
        child: ListView(children: [
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'Nama Perusahaan',
                  controller: description,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                    Random random = new Random();
                    int randomNumber =
                        random.nextInt(1000); // from 0 upto 99 included
                     companycode= '${description.text.substring(3)+randomNumber.toString()}';
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'E-mail',
                  controller: email,
                  typekeyboard: TextInputType.text,
                  validator: (value) {
                    _validateEmail(email.text);
                  },
                  onChanged: (value) {
                    print(_validateEmail(email.text));
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'Alamat',
                  controller: alamat,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'No Telp',
                  controller: telp,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'Tempo',
                  controller: tempo,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'PIC',
                  controller: pic,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'Limit',
                  controller: limit,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldMobile2(
                  label: 'NPWP',
                  controller: npwp,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor:
                        Color.fromARGB(255, 0, 160, 147), // Background color
                  ),
                  onPressed: () {
                    _submitFormemail();
                    _submitphone();
                    if (_validateEmail(email.text) ==
                            'Please enter a valid email address' ||
                        email.text == '') {
                      Toast.show("Invalid email",
                          duration: Toast.lengthLong, gravity: Toast.center);
                    }
                    if (_validatePhoneNumber(telp.text) ==
                            'Please enter a valid phone number' ||
                        telp.text == '') {
                      Toast.show("Invalid phone",
                          duration: Toast.lengthLong, gravity: Toast.center);
                    }

                    if (_validateEmail(email.text) !=
                            'Please enter a valid email address' ||
                        email.text != '' &&
                            _validatePhoneNumber(telp.text) !=
                                'Please enter a valid phone number' ||
                        telp.text != '') {
                      ClassApi.createCompany(
                          PaymentMaster(
                            paymentcd: companycode,
                            paymentdesc: description.text,
                            typ: '1',
                            coacomp: 'Account Receivable',
                            coapayment: 'Clearence',
                            clactive: '1',
                            email: email.text,
                            telp: telp.text,
                            pic: pic.text,
                            limits: num.parse(limit.text),
                          ),
                          dbname).whenComplete(() {
                            Navigator.of(context).pop();
                          });
                    }
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Simpan',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white, // Background color
                  ),
                  onPressed: () {
                    description.clear();
                    email.clear();
                    limit.clear();
                    telp.clear();
                    tempo.clear();
                    pic.clear();
                    npwp.clear();
                    setState(() {});
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Reset',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 160, 147)),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
