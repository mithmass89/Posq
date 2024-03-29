// ignore_for_file: unused_import

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/pengeluaran.dart';
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
    return SafeArea(
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: ListTile(
       
                  // leading: CircleAvatar(
                  //   radius: 100, // Adjust the size of the circle avatar
                  //   backgroundImage: NetworkImage(
                  //       'http://digims.online:3000/getlogo/20231016_012618_0000.png'), // Replace with your image URL
                  // ),
                  title: Text(
                    widget.outletname.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    usercd,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.width * 0.06,
                    ),
                  )),
            ),
            ListTile(
              leading: Icon(
                Icons.attach_money,
                size: 30,
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
                size: 30,
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
                size: 30,
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
                size: 30,
              ),
              title: const Text('Kelola Usaha'),
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
                Icons.wallet,
                size: 30,
              ),
              title: const Text('Pengeluaran'),
              onTap: accesslistuser.contains('laporan') == true
                  ? () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PengeluaranUang();
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
                size: 30,
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
                size: 30,
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
                size: 30,
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
                size: 30,
              ),
              title: const Text('Bantuan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(
                  Icons.logout,
                  size: 30,
                ),
                title: Text('Logout'),
                onTap: () {
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
                          leading: Icon(
                            Icons.settings,
                            size: 30,
                          ),
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
                          leading: Icon(
                            Icons.print,
                            size: 30,
                          ),
                          title: Text('Printer'),
                          onTap: accesslistuser.contains('settingprinter') ==
                                  true
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
      ),
    );
  }
}
