import 'package:flutter/material.dart';
import 'package:posq/integrasipayment/classintegrasilist.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/reporting/classlaporanmobile.dart';
import 'package:posq/retailmodul/classlisttransactionmobile.dart';
import 'package:posq/setting/classcustomersmobile.dart';
import 'package:posq/setting/classpromomobile.dart';
import 'package:posq/minibackoffice/classtypeadjusmentstock.dart';

class DrawerRetailMain extends StatefulWidget {
  final String? outletname;
  final Outlet outletinfo;
  const DrawerRetailMain(
      {Key? key, required this.outletname, required this.outletinfo})
      : super(key: key);

  @override
  State<DrawerRetailMain> createState() => _DrawerRetailMainState();
}

class _DrawerRetailMainState extends State<DrawerRetailMain> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.outletname.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_right_outlined,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: const Text('Profile'),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.shop_outlined,
            ),
            title: Text('Kelola Promo'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ClassPromoMobile();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history_outlined,
            ),
            title: const Text('Riwayat Transaksi'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return Listtransaction(
                  pscd: widget.outletinfo.outletcd,
                  outletinfo: widget.outletinfo,
                );
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_chart_outlined,
            ),
            title: const Text('Laporan'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ClassSummaryReport(user: 'Admin');
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_box_outlined,
            ),
            title: const Text('Kelola Produk'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ClassAdjusmentType(
                  pscd: widget.outletinfo,
                );
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people_outline_outlined,
            ),
            title: const Text('Pelanggan'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ClassListCustomers();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shop_two_outlined,
            ),
            title: const Text('Toko Online'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.help_center,
            ),
            title: const Text('Bantuan'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Integrasi '),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ClassListIntegrasi();
                          }));
                        },
                      ),
                      ListTile(
                          leading: Icon(Icons.help), title: Text('Instagram'))
                    ],
                  ))),
        ],
      ),
    );
  }
}
