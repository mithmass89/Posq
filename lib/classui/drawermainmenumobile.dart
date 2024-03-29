import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/promo/classpromomobile.dart';
import 'package:posq/systeminfo.dart';
import 'package:posq/userinfo.dart';

class DrawerWidgetMain extends StatelessWidget {
  final String? today;
  final num? endings;

  const DrawerWidgetMain({Key? key, required this.today, required this.endings})
      : super(key: key);

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
                  ? () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ClassSummaryReport(user: usercd);
                      }))
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
                            builder: (context) => ClassPromoMobile()),
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
              onTap: () async {
                await ClassApi.insertOpenCashier(
                    OpenCashier(
                        type: 'CLOSE',
                        trdt: today,
                        amount: endings,
                        usercd: usercd),
                    dbname);
              }),
          _drawerItem(
              icon: Icons.print,
              text: 'Printer',
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClassMainPrinter()),
                );
              }),
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Version : $versions.$builds'),
          ),
        ],
      ),
    );
  }
}

Widget _drawerHeader() {
  return UserAccountsDrawerHeader(
    decoration: BoxDecoration(color: AppColors.primaryColor),
    currentAccountPicture: ClipOval(
      // child: Image.network(
      //   'https://quarantine.doh.gov.ph/wp-content/uploads/2016/12/no-image-icon-md.png', // Replace with your image URL
      //   loadingBuilder: (BuildContext context, Widget child,
      //       ImageChunkEvent? loadingProgress) {
      //     if (loadingProgress == null) {
      //       return child;
      //     } else {
      //       return CircularProgressIndicator(
      //         value: loadingProgress.expectedTotalBytes != null
      //             ? loadingProgress.cumulativeBytesLoaded /
      //                 loadingProgress.expectedTotalBytes!
      //             : null,
      //       );
      //     }
      //   },
      // ),
    ),
    accountName: Text(usercd),
    accountEmail: Text(emaillogin),
  );
}

Widget _drawerItem({IconData? icon, String? text, GestureTapCallback? onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          size: 30,
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(
            text!,
            style: TextStyle(
                // fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}
