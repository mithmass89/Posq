import 'package:flutter/material.dart';
import 'package:posq/classui/classpromomobile.dart';

class DrawerWidgetMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItem(
              icon: Icons.folder,
              text: 'Laporan',
              onTap: () => print('Tap My Files')),
          _drawerItem(
              icon: Icons.money,
              text: 'Kelola Promo',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassPromoMobile()),
                );
              }),
          _drawerItem(
              icon: Icons.group,
              text: 'Informasi akun',
              onTap: () => print('Tap Shared menu')),
          _drawerItem(
              icon: Icons.lock_clock,
              text: 'Close kasir',
              onTap: () => print('Tap Recent menu')),
          _drawerItem(
              icon: Icons.settings,
              text: 'Setting',
              onTap: () => print('Tap Trash menu')),
          Divider(height: 25, thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Text("Labels",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
          ),
          _drawerItem(
              icon: Icons.devices_other,
              text: 'Others',
              onTap: () => print('Tap Family menu')),
        ],
      ),
    );
  }
}

Widget _drawerHeader() {
  return UserAccountsDrawerHeader(
    currentAccountPicture: ClipOval(
      child: Image(
          image: AssetImage('assets/images/orang2.jpeg'),
          errorBuilder: (context, error, stackTrace) {
            return Center(
                child: Text(
              'No Image',
              style: TextStyle(color: Colors.white),
            ));
          },
          fit: BoxFit.cover),
    ),
    accountName: Text('Admin'),
    accountEmail: Text('admin@gmail.com'),
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
