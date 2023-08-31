import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';

class OutletAccess extends StatelessWidget {
  OutletAccess({Key? key}) : super(key: key);
  TextEditingController staff = TextEditingController(text: 'Pilih staff');
  TextEditingController outlet = TextEditingController(text: 'Pilih Outlet');
  SelectedPegawai? pegawai;
  List outlets = [];

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
                staff.text = pegawai!.usercode.toString();
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
                outlet.text = outlets.toString();
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // Background color
                  ),
                  onPressed: () async {
                    EasyLoading.show(status: 'insert access...');
                    for (var x in outlets) {
                      await ClassApi.insertAccessOutlet(x, pegawai!.email);
                    }
                    ;
                    staff.text = 'Pilih Staff';
                    outlet.text = 'Pilih Outlet';
                    outlets = [];

                    EasyLoading.dismiss();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                  ),
                  onPressed: () {
                    staff.text = 'Pilih Staff';
                    outlet.text = 'Pilih Outlet';
                    outlets = [];
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Reset',
                        style: TextStyle(color: AppColors.primaryColor),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
