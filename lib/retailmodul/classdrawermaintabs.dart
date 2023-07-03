// ignore_for_file: unused_import

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/integrasipayment/classintegrasilist.dart';
import 'package:posq/login.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/reporting/classlaporanmobile.dart';
import 'package:posq/reporting/reportingtablet/classsummaryreporttab.dart';
import 'package:posq/retailmodul/savedtransaction/classlisttransactionmobile.dart';
import 'package:posq/setting/customer/classcustomersmobile.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/printer/classprinterBluetooth.dart';
import 'package:posq/setting/promo/classpromomobile.dart';
import 'package:posq/minibackoffice/classtypeadjusmentstock.dart';
import 'package:posq/setting/product_master/mainmenuproduct.dart';
import 'package:posq/setting/promo/tablet/classcreatepromotab.dart';
import 'package:posq/setting/promo/tablet/classpromotab.dart';
import 'package:posq/userinfo.dart';

class DrawerRetailMainTabs extends StatefulWidget {
  final String? outletname;
  final Outlet outletinfo;
  final bool fromsaved;
  const DrawerRetailMainTabs(
      {Key? key,
      required this.outletname,
      required this.outletinfo,
      required this.fromsaved})
      : super(key: key);

  @override
  State<DrawerRetailMainTabs> createState() => _DrawerRetailMainTabsState();
}

class _DrawerRetailMainTabsState extends State<DrawerRetailMainTabs> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.

        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.26,
                      decoration: BoxDecoration(),
                      child: Wrap(
                        children: [
                          Text(
                            widget.outletname.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Icon(
                            Icons.arrow_right_outlined,
                            color: Colors.white,
                            size: 30.0,
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
                    imageurl == ''
                        ? CircleAvatar(
                            radius: 30,
                            // backgroundImage: AssetImage(
                            //   'assets/sheryl.png',
                            // ),
                            child: Text(
                              usercd.substring(0, 1),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(imageurl),
                          ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.17,
                          child: Text(
                            usercd,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.17,
                          // child: Text(
                          //   'SHIFT 1 ',
                          //   style: TextStyle(color: Colors.white, fontSize: 12),
                          // ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.attach_money,
                  ),
                  title: Text('Kelola Promo'),
                  onTap: accesslistuser.contains('kelolapromo') == true
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ClassPromoTab();
                          }));
                        }
                      : () {
                          Fluttertoast.showToast(
                              msg: "Tidak punya akses kelola promo",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_money,
                  ),
                  title: Text('Refund / Retur'),
                  onTap: accesslistuser.contains('kelolapromo') == true
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ClassPromoTab();
                          }));
                        }
                      : () {
                          Fluttertoast.showToast(
                              msg: "Tidak punya akses kelola promo",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                ),
                ListTile(
                  leading: Icon(
                    Icons.history_outlined,
                  ),
                  title: const Text('Riwayat Transaksi'),
                  onTap: accesslistuser.contains('riwayattrans') == true
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Listtransaction(
                              fromsaved: widget.fromsaved,
                              pscd: widget.outletinfo.outletcd,
                              outletinfo: widget.outletinfo,
                            );
                          }));
                        }
                      : () {
                          Fluttertoast.showToast(
                              msg: "Tidak punya access riwayat",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_chart_outlined,
                  ),
                  title: const Text('Laporan'),
                  onTap: accesslistuser.contains('laporan') == true
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ClassSummaryReportTab(user: usercd);
                          }));
                        }
                      : () {
                          Fluttertoast.showToast(
                              msg: "Tidak punya access laporan",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_box,
                  ),
                  title: const Text('Kelola usaha'),
                  onTap: accesslistuser.contains('setting') == true
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return MainMenuProduct(
                              pscd: pscd,
                              outletinfo: widget.outletinfo,
                            );
                          }));
                        }
                      : () {
                          Fluttertoast.showToast(
                              msg: "Tidak punya access laporan",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                ),
                ListTile(
                  leading: Icon(
                    Icons.people_outline_outlined,
                  ),
                  title: const Text('Pelanggan'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ClassListCustomers();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopify_sharp,
                  ),
                  title: const Text('Toko Online'),
                  onTap: accesslistuser.contains('tokoonline') == true
                      ? () {
                          Navigator.pop(context);
                        }
                      : () {
                          Fluttertoast.showToast(
                              msg: "Tidak punya access Toko Online",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
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
                ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      LogOut.signOut(context: context);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    }),
              ],
            ),
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Integrasi '),
                        onTap: accesslistuser.contains('integrasi') == true
                            ? () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ClassListIntegrasi();
                                }));
                              }
                            : () {
                                Fluttertoast.showToast(
                                    msg: "Tidak punya access Integrasi",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 12, 14),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                      ),
                      ListTile(
                        leading: Icon(Icons.print),
                        title: Text('Printer'),
                        onTap: accesslistuser.contains('settingprinter') == true
                            ? () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ClassMainPrinter();
                                }));
                              }
                            : () {
                                Fluttertoast.showToast(
                                    msg: "Tidak punya access Printer",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 12, 14),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
