import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class PegawaiMainMobile extends StatefulWidget {
  const PegawaiMainMobile({Key? key}) : super(key: key);

  @override
  State<PegawaiMainMobile> createState() => _PegawaiMainMobileState();
}

class _PegawaiMainMobileState extends State<PegawaiMainMobile> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController corporate = TextEditingController();
  final TextEditingController jabatan =
      TextEditingController(text: 'Pilih Role');
  final TextEditingController outlet =
      TextEditingController(text: 'Pilih Outlet');
  bool passwordisSame = false;
  bool isRegistered = false;
  final _formKey = GlobalKey<FormState>();
  List<Pegawai>? selectedRoles;
  List<dynamic>? selectedOutlet;
  List<dynamic> accesslist = [];
  List<AccessPegawai> accesspegawai = [];

  getAccessRole(List outlet) async {
    accesspegawai = [];
    print(outlet.length);
    accesslist =
        await ClassApi.getRoleAccessTemplate(selectedRoles![0].jobcode!, '');
    // print(accesslist);
    for (var x in accesslist) {
      for (var z in outlet) {
        accesspegawai.add(AccessPegawai(
            usercode: email.text,
            rolecode: x['jobcd'],
            roledesc: x['jobdesc'],
            accesscode: x['accesscode'],
            accessdesc: x['accessdesc'],
            outletcd: z['outletcode'],
            subscription: subscribtion));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Setting Pegawai'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                child: TextFieldMobile2(
                  hint: 'Nama Karyawan',
                  controller: fullname,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                child: TextFieldMobile2(
                  hint: 'E-mail',
                  controller: email,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) async {
                    await ClassApi.checkEmailExist(email.text).then((value) {
                      if (value.isNotEmpty) {
                        print(value);
                        isRegistered = true;
                        Fluttertoast.showToast(
                            msg: "Email sudah terdaftar",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        print(value);
                        isRegistered = false;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                child: TextFieldMobile2(
                  hint: 'password',
                  controller: password,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    if (confirmpassword.text == password.text) {
                      passwordisSame = true;
                    } else {
                      passwordisSame = false;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                child: TextFieldMobile2(
                  hint: 'confirm password',
                  controller: confirmpassword,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {
                    if (confirmpassword.text == password.text) {
                      passwordisSame = true;
                    } else {
                      passwordisSame = false;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldMobileButton(
                  hint: 'Pilih Role',
                  controller: jabatan,
                  typekeyboard: TextInputType.none,
                  onChanged: (value) {},
                  ontap: () async {
                    selectedRoles = [];
                    selectedRoles = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogRoleStaff();
                        });
                    jabatan.text = selectedRoles![0].joblevel;
                    await getAccessRole(selectedOutlet!);
                    setState(() {});
                  }),
              TextFieldMobileButton(
                  hint: 'Outlet',
                  controller: outlet,
                  typekeyboard: TextInputType.none,
                  onChanged: (value) {},
                  ontap: () async {
                    if (jabatan.text != 'Pilih Role') {
                      selectedOutlet = [];
                      selectedOutlet = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogOutletStaff();
                          });

                      outlet.text = selectedOutlet![0]['outletdesc']!;
                      if (selectedOutlet![0]['outletcode'] == 'All') {
                        selectedOutlet!.removeAt(0);
                      }
                      print(
                          'ini outlet terpilih ${selectedOutlet![0]['outletdesc']}');
                      // print(selectedOutlet);
                      for (var x in selectedOutlet!) {
                        for (var z in accesspegawai) {
                          z.outletcd = x['outletcode'];
                          z.usercode = email.text;
                        }
                      }
                      // accesspegawai=[];
                      print(accesspegawai.length);
                      await getAccessRole(selectedOutlet!);
                      setState(() {});
                    } else if (email.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "isi email karyawan dulu",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Pilih Role dulu",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              ButtonNoIcon2(
                color: Colors.orange,
                textcolor: Colors.white,
                name: 'Buat Staff',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                onpressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (isRegistered == true) {
                      Fluttertoast.showToast(
                          msg: "Email sudah terdaftar",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (confirmpassword.text != password.text) {
                      Fluttertoast.showToast(
                          msg: "password dan confirm tidak sama",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      EasyLoading.show(status: 'Registered Please wait...');

                      await ClassApi.insertRegisterUser(
                          email.text,
                          fullname.text,
                          password.text,
                          jabatan.text,
                          subscribtion,
                          paymentcheck,
                          corporate.text);
                      await ClassApi.Update7DayActive(
                          expireddate!, email.text, referrals, telp);
                      for (var x in selectedOutlet!) {
                        await ClassApi.insertAccessOutlet(
                            x['outletcd'], email.text);
                      }

                      await ClassApi.insertAccessUser(accesspegawai);

                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
