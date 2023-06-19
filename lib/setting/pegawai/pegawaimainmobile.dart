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
  final TextEditingController jabatan = TextEditingController();
  bool passwordisSame = false;
  bool isRegistered = false;
  final _formKey = GlobalKey<FormState>();
  List<Pegawai>? selectedRoles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Pegawai'),
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
                    hint: 'Pilih Jabatan',
                    controller: jabatan,
                    typekeyboard: TextInputType.none,
                    onChanged: (value) {},
                    ontap: () async {
                      selectedRoles = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogRoleStaff();
                          });
                      jabatan.text = selectedRoles![0].joblevel;
                      setState(() {});
                    }),
              ],
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.01,
              left: MediaQuery.of(context).size.height * 0.02,
              child: ButtonNoIcon2(
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
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email.text, password: password.text);
                      await ClassApi.insertRegisterUser(
                          email.text,
                          fullname.text,
                          password.text,
                          jabatan.text,
                          subscribtion,
                          paymentcheck);
                      await ClassApi.insertAccessOutlet(
                          pscd, fullname.text, dbname);
                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
