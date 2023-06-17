import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Pegawai'),
      ),
      body: Stack(
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
                  onChanged: (value) {},
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
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogRoleStaff();
                        });
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
                EasyLoading.show(status: 'Please wait...');
                await ClassApi.insertRegisterUser(email.text, fullname.text,
                    password.text, jabatan.text, subscribtion, paymentcheck);
                await ClassApi.insertAccessOutlet(pscd, email.text, dbname);
                EasyLoading.dismiss();
              },
            ),
          )
        ],
      ),
    );
  }
}
