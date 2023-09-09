import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/setting/pegawai/pegawaimainmobile.dart';
import 'package:posq/setting/pegawai/pegawaimaintab.dart';
import 'package:posq/setting/pegawai/reviewakses.dart';
import 'package:posq/setting/pegawai/settingoutletpegawai.dart';

class MainPagePegawai extends StatelessWidget {
  const MainPagePegawai({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Pegawai',style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(builder: (
        context,
        BoxConstraints constraints,
      ) {
        if (constraints.maxWidth <= 480) {
          return Container(
              child: ListView(
            children: [
              Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PegawaiMainMobile()),
                  );
                },
                title: Text('Buat Pegawai'),
              )),
              Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OutletAccess()),
                  );
                },
                title: Text('Outlet Pegawai'),
              )),
              Card(
                  child: ListTile(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Segera Hadir",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color.fromARGB(255, 11, 12, 14),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                title: Text('Absensi'),
              )),
              Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewAksesStaf(
                      
                    )),
                  );
                },
                title: Text('Akses review'),
              )),
            ],
          ));
        } else {
          return Container(
              child: ListView(
            children: [
              Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PegawaiMainTab()),
                  );
                },
                title: Text('Buat Pegawai'),
              )),
              Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OutletAccess()),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => OutletAccess()),
                  // );
                },
                title: Text('Outlet Pegawai'),
              )),
              Card(
                  child: ListTile(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Segera Hadir",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color.fromARGB(255, 11, 12, 14),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                title: Text('Absensi'),
              )),
              Card(
                  child: ListTile(
                onTap: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewAksesStaf(
                      
                    )),
                  );
                },
                title: Text('Akses review'),
              )),
            ],
          ));
        }
      }),
    );
  }
}
