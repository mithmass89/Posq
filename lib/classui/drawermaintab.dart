import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/setting/promo/tablet/classpromotab.dart';
import 'package:posq/userinfo.dart';

class DrawerWidgetMainTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItem(
              icon: Icons.folder,
              text: 'Laporan',
              onTap: accesslist.contains('laporan') == true
                  ? () => print('Tap My Files')
                  : () {
                      Fluttertoast.showToast(
                          msg: "Tidak punya akses laporan",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }),
          _drawerItem(
              icon: Icons.money,
              text: 'Kelola Promo',
              onTap: accesslist.contains('kelolapromo') == true
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClassPromoTab()),
                      );
                    }
                  : () {
                      Fluttertoast.showToast(
                          msg: "Tidak punya akses Kelola promo",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }),
          _drawerItem(
              icon: Icons.group,
              text: 'Informasi akun',
              onTap: () => print('Tap Shared menu')),
          _drawerItem(
              icon: Icons.lock_clock,
              text: 'Tutup kasir',
              onTap: () => print('Tap Recent menu')),
          Divider(height: 25, thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Text("Others",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
          ),
          _drawerItem(
              icon: Icons.logout,
              text: 'Log Out',
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              }),
        ],
      ),
    );
  }
}

Widget _drawerHeader() {
  return UserAccountsDrawerHeader(
    decoration: BoxDecoration(color: AppColors.primaryColor),
    // currentAccountPicture: ClipOval(
    //   child: Image(
    //       image: AssetImage('assets/images/orang2.jpeg'),
    //       errorBuilder: (context, error, stackTrace) {
    //         return Center(
    //             child: Text(
    //           'No Image',
    //           style: TextStyle(color: Colors.white),
    //         ));
    //       },
    //       fit: BoxFit.cover),
    // ),
    accountName: Text(usercd),
    accountEmail: Text(emaillogin),
  );
}

Widget _drawerItem({IconData? icon, String? text, GestureTapCallback? onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(
            text!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}
