import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';

class OutletAccess extends StatelessWidget {
  OutletAccess({Key? key}) : super(key: key);
  TextEditingController staff = TextEditingController(text: 'Pilih staff');
  TextEditingController outlet = TextEditingController(text: 'Pilih Outlet');
  SelectedPegawai? pegawai;
  List<Outlet>? outlets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akses Outlet'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Pilih Staff',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextFieldMobileButton(
              hint: 'Staff',
              controller: staff,
              typekeyboard: TextInputType.none,
              onChanged: (value) {},
              ontap: () async {
                pegawai = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListStaff();
                    });
              }),
          ListTile(
            title: Text(
              'Pilih Outlet',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextFieldMobileButton(
              hint: 'Outlet',
              controller: outlet,
              typekeyboard: TextInputType.none,
              onChanged: (value) {},
              ontap: () async {
                outlets = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogOutletStaff();
                    });
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Background color
                  ),
                  onPressed: () async {
                    EasyLoading.show(status: 'insert access...');
                    for (var x in outlets!) {
                      await ClassApi.insertAccessOutlet(
                          x.outletcd, pegawai!.email);
                    }
                    ;
                    EasyLoading.dismiss();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                  ),
                  onPressed: () {},
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.orange),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
