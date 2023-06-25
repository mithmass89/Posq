import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class PegawaiMainTab extends StatefulWidget {
  const PegawaiMainTab({Key? key}) : super(key: key);

  @override
  State<PegawaiMainTab> createState() => _PegawaiMainTabState();
}

class _PegawaiMainTabState extends State<PegawaiMainTab> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController jabatan =
      TextEditingController(text: 'Pilih Role');
  final TextEditingController outlet =
      TextEditingController(text: 'Pilih Outlet');
  bool passwordisSame = false;
  List<Pegawai>? selectedRoles;
  bool isRegistered = false;
  final _formKey = GlobalKey<FormState>();
  List<dynamic>? selectedOutlet;
  List<dynamic> accesslist = [];
  List<AccessPegawai> accesspegawai = [];

  @override
  void initState() {
    super.initState();
  }

  getAccessRole() async {
    accesslist =
        await ClassApi.getRoleAccessTemplate(selectedRoles![0].jobcode!, '');
    // print(accesslist);
    for (var x in accesslist) {
      accesspegawai.add(AccessPegawai(
          usercode: usercd,
          rolecode: x['jobcd'],
          roledesc: x['jobdesc'],
          accesscode: x['accesscode'],
          accessdesc: x['accessdesc'],
          outletcd: 'outlet',
          subscription: subscribtion));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Pegawai'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 173, 150),
        foregroundColor: Colors.white,
        splashColor: Colors.yellow,
        hoverColor: Colors.red,
        onPressed: () async {
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
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email.text, password: password.text);
              await ClassApi.insertRegisterUser(email.text, fullname.text,
                  password.text, jabatan.text, subscribtion, paymentcheck);
              await ClassApi.insertAccessUser(accesspegawai);
              await ClassApi.insertAccessOutlet(pscd, fullname.text);
              EasyLoading.dismiss();
              Navigator.of(context).pop();
            }
          }
        },
        child: Icon(Icons.save),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFieldMobile2(
                        hint: 'Nama Karyawan',
                        controller: fullname,
                        typekeyboard: TextInputType.text,
                        onChanged: (value) {},
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFieldMobile2(
                          hint: 'E-mail',
                          controller: email,
                          typekeyboard: TextInputType.text,
                          onChanged: (value) async {
                            await ClassApi.checkEmailExist(email.text)
                                .then((value) {
                              if (value.isNotEmpty) {
                                print(value);
                                isRegistered = true;
                                Fluttertoast.showToast(
                                    msg: "Email sudah terdaftar",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 12, 14),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                print(value);
                                isRegistered = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFieldMobile2(
                        hint: 'password',
                        controller: password,
                        typekeyboard: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'password tidak boleh kosong';
                          }
                        },
                        onChanged: (value) {
                          if (confirmpassword.text == password.text) {
                            passwordisSame = true;
                          } else {
                            passwordisSame = false;
                          }
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFieldMobile2(
                        hint: 'confirm password',
                        controller: confirmpassword,
                        typekeyboard: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'confirm password tidak boleh kosong';
                          }
                          if (confirmpassword.text != password.text) {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (confirmpassword.text == password.text) {
                            passwordisSame = true;
                          } else {
                            passwordisSame = false;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFieldMobileButton(
                          hint: 'Pilih Jabatan',
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
                            await getAccessRole();
                            setState(() {});
                          }),
                    ),
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
                            selectedOutlet!.removeAt(0);
                            // print(selectedOutlet);
                            for (var x in selectedOutlet!) {
                              for (var z in accesspegawai) {
                                z.outletcd = x['outletcode'];
                                z.usercode = fullname.text;
                              }
                            }
                            print(accesspegawai);
                            setState(() {});
                          } else if (fullname.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "isi nama karyawan dulu",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(255, 11, 12, 14),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Pilih Role dulu",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(255, 11, 12, 14),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
