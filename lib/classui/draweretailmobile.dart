// ignore_for_file: unused_import

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/integrasipayment/classintegrasilist.dart';
import 'package:posq/login.dart';
import 'package:posq/model.dart';
import 'package:posq/moduledrawer/productmovement.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/reporting/classlaporanmobile.dart';
import 'package:posq/retailmodul/savedtransaction/classlisttransactionmobile.dart';
import 'package:posq/setting/customer/classcustomersmobile.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/printer/classprinterBluetooth.dart';
import 'package:posq/setting/product_master/mainmenuproduct.dart';
import 'package:posq/setting/promo/classpromomobile.dart';
import 'package:posq/minibackoffice/classtypeadjusmentstock.dart';
import 'package:posq/tokoonline.dart/tokoonline.dart';
import 'package:posq/userinfo.dart';

class DrawerRetailMain extends StatefulWidget {
  final String? outletname;
  final Outlet outletinfo;
  final bool fromsaved;
  const DrawerRetailMain(
      {Key? key,
      required this.outletname,
      required this.outletinfo,
      required this.fromsaved})
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
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        widget.outletname.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        // backgroundImage: AssetImage(
                        //   'assets/sheryl.png',
                        // ),
                        child: Text(
                          usercd.substring(0, 1),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Text(
                              usercd,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.2,
                          //   child: Text(
                          //     'SHIFT 1 ',
                          //     style: TextStyle(color: Colors.white, fontSize: 12),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.attach_money,
            ),
            title: Text('Kelola Promo'),
            onTap: accesslistuser.contains('kelolapromo') == true
                ? () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ClassPromoMobile();
                    }));
                  }
                : () {
                    print(accesslistuser);
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
            title: const Text('Transaksi hari ini'),
            onTap: accesslistuser.contains('riwayattrans') == true
                ? () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
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
                    print(listoutlets);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ClassSummaryReport(user: usercd);
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
            title: const Text('Kelola Produk'),
            onTap: accesslistuser.contains('setting') == true
                ? () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
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
              Icons.production_quantity_limits,
            ),
            title: const Text('Mutasi barang'),
            onTap: accesslistuser.contains('setting') == true
                ? () {
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //   return ProductMovement();
                    // }));
                    Fluttertoast.showToast(
                        msg: "Segera hadir",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ClassListCustomers();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopify_sharp,
            ),
            title: const Text('Toko Online'),
            onTap: accesslist.contains('tokoonline') == true
                ? () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TokoOnlineMain();
                    }));
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
                                // Fluttertoast.showToast(
                                //     msg: "Oops Sedang Maintenence",
                                //     toastLength: Toast.LENGTH_LONG,
                                //     gravity: ToastGravity.CENTER,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor:
                                //         Color.fromARGB(255, 11, 12, 14),
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);
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
