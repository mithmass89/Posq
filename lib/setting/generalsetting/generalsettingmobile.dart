import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingMobile extends StatefulWidget {
  final String pscd;
  const GeneralSettingMobile({Key? key, required this.pscd}) : super(key: key);

  @override
  State<GeneralSettingMobile> createState() => _GeneralSettingMobileState();
}

class _GeneralSettingMobileState extends State<GeneralSettingMobile> {
  bool usestrict = false;
  bool usekitchens = false;
  SelectedPegawai? pegawai;
  bool retailmode = false;
  TextEditingController usercode = TextEditingController(text: 'Pilih staff');
  TextEditingController code = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  void initState() {
    super.initState();
    getBooleanValue();
    getRetailMode();
    if (strictuser == '1') {
      usestrict = true;
    } else {
      usestrict = false;
    }
  }

  Future<dynamic> saveUseKitchen() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'useKitchen';
    final value = usekitchens; // Replace with your boolean value
    prefs.setBool(key, value);
    return value;
  }

  Future<dynamic> saveRetailMode() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'retailmode';
    final value = retailmode; // Replace with your boolean value
    prefs.setBool(key, value);
    return value;
  }

  Future<bool> getBooleanValue() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'useKitchen';
    final value = prefs.getBool(key) ??
        false; // Replace false with a default value if needed
    usekitchens = value;
    usekitchen = value;
    setState(() {});
    print(value);
    return value;
  }

  Future<bool> getRetailMode() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'retailmode';
    final value = prefs.getBool(key) ??
        false; // Replace false with a default value if needed
    retailmode = value;
    retailmodes = value;
    setState(() {});
    print(value);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'General Setting',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          child: ListView(
        children: [
          ListTile(
            title: Text(
              'Retail Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Mode yg di gunakan untuk Memilih tipe oultet '),
            trailing: Switch(
              value: retailmode,
              onChanged: (val) async {
                retailmode = val;
                if (val == true) {
                  retailmodes = true;
                } else {
                  retailmodes = false;
                }
                saveRetailMode();
                // await ClassApi.updateStrictUser(dbname, strictuser);
                setState(() {});
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Mode Strict',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                'Mode yg di gunakan untuk membatasi akses cancel order da`n delete untuk staff '),
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
          Divider(),
          ListTile(
            title: Text(
              'Printer kitchen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Jika di aktifkan berarti memakai printer kitchen'),
            trailing: Switch(
              value: usekitchens,
              onChanged: (val) async {
                usekitchens = val;
                usekitchen = val;
                print(usekitchens);
                // await ClassApi.updateUseKitchen(dbname, usekitchen);
                await saveUseKitchen()
                    .then((value) => print('ini value : $value'));
                setState(() {});
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'User yang bisa mengakses code',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                  if (usercode.text != 'Pilih staff' && password.text != '') {
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
