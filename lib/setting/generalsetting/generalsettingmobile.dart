import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class GeneralSettingMobile extends StatefulWidget {
  final String pscd;
  const GeneralSettingMobile({Key? key, required this.pscd}) : super(key: key);

  @override
  State<GeneralSettingMobile> createState() => _GeneralSettingMobileState();
}

class _GeneralSettingMobileState extends State<GeneralSettingMobile> {
  bool usestrict = false;
  SelectedPegawai? pegawai;
  TextEditingController usercode = TextEditingController(text: 'Pilih staff');
  TextEditingController code = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (strictuser == '1') {
      usestrict = true;
    } else {
      usestrict = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Setting'),
      ),
      body: Container(
          child: ListView(
        children: [
          ListTile(
            title: Text('Mode Strict'),
            subtitle: Text(
                'Mode yg di gunakan untuk membatasi akses cancel order dan delete untuk staff '),
            trailing: Switch(
              value: usestrict,
              onChanged: (val) async {
                usestrict = val;
                if (val == true) {
                  strictuser = '1';
                } else {
                  strictuser = '0';
                }
                await ClassApi.updateStrictUser(dbname, strictuser);
                setState(() {});
              },
            ),
          ),
          ListTile(
            title: Text('User yang bisa mengakses code'),
          ),
          TextFieldMobileButton(
              hint: 'Pilih user',
              controller: usercode,
              typekeyboard: TextInputType.none,
              onChanged: (value) {},
              ontap: () async {
                pegawai = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListStaff();
                    });
                usercode.text = pegawai!.usercode!;
                setState(() {});
              }),
          Container(
            height: MediaQuery.of(context).size.height * 0.09,
            child: TextFieldMobile2(
              hint: 'PIN',
              controller: password,
              typekeyboard: TextInputType.number,
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  if (usercode.text != 'Pilih staff' && password.text!='' ) {
                    await ClassApi.insertAccessCodeStrict(
                       usercode.text, password.text);
                  } else {
                    await Fluttertoast.showToast(
                        msg: "Staff dan PIN wajib di isi",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }

                  pegawai!.usercode = '';
                  password.text = '';
                                await Fluttertoast.showToast(
                        msg: "Sukses menambahkan access",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  setState(() {});
                },
                child: Text('Simpan')),
          )
        ],
      )),
    );
  }
}
