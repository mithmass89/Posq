// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors_in_immutables, must_be_immutable, prefer_generic_function_type_aliases, non_constant_identifier_names, prefer_const_constructors, avoid_print, unused_import, unused_local_variable

import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:flutter/material.dart';
import 'package:posq/appsmobile.dart';
import 'package:posq/classfungsi/dialogattendance.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/condiment/maincondiment.dart';
import 'package:posq/setting/customer/classcustomersmobile.dart';
import 'package:posq/setting/classselectoutletmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/pegawai/listpegawai.dart';
import 'package:posq/setting/pegawai/pegawaimain.dart';
import 'package:posq/setting/pegawai/pegawaimainmobile.dart';
import 'package:posq/setting/product_master/mainmenuproduct.dart';
import 'package:posq/setting/product_master/productmain.dart';
import 'package:posq/setting/profilemain.dart';
import 'package:posq/userinfo.dart';
import 'package:uuid/uuid.dart';
import 'package:posq/classui/api.dart';

import 'setting/pegawai/pegawaimaintab.dart';

typedef void StringCallback(Outlet val);

///callbackstring//

class MenuMain extends StatefulWidget {
  final StringCallback callback;
  late Outlet? outletinfo;
  late final String pscd;

  MenuMain(
      {Key? key,
      required this.outletinfo,
      required this.callback,
      required this.pscd})
      : super(key: key);

  @override
  State<MenuMain> createState() => _MenuMainState();
}

class _MenuMainState extends State<MenuMain> {
  String? trno = '';
  bool selected = false;
  DateTime now = DateTime.now();
  // Format the date as "yyyy-MM-dd" (e.g., 2023-07-01)
  String? formattedDate;
  String? datetime;

  deleteDatabase() async {
    print('oke');
  }

  void showAttendanceDialog(BuildContext context) async {
    String selectedOption = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AttendanceDialog();
      },
    );

    if (selectedOption != null) {
      // Lakukan sesuatu berdasarkan opsi yang dipilih.
      switch (selectedOption) {
        case 'Check-in':
          statusabsen = 'Check-in';
          setState(() {});
          await ClassApi.insertAbsensi(
              formattedDate!, emaillogin, 'Check-in', datetime!, false);
          // Lakukan logika untuk Check-in.
          break;
        case 'Breakout':
          // Lakukan logika untuk Breakout.
          statusabsen = 'Breakout';

          await ClassApi.insertAbsensi(
              formattedDate!, emaillogin, 'Breakout', datetime!, false);
          setState(() {});
          break;
        case 'Break In':
          statusabsen = 'Break In';
          // Lakukan logika untuk Breakout.
          await ClassApi.insertAbsensi(
              formattedDate!, emaillogin, 'Breakout', datetime!, false);
          setState(() {});
          break;
        case 'Checkout':
          statusabsen = 'Checkout';
          // Lakukan logika untuk Checkout.
          await ClassApi.insertAbsensi(
              formattedDate!, emaillogin, 'Checkout', datetime!, false);
          setState(() {});
          break;
        default:
          // Opsi tidak valid.
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.pscd);

    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    datetime = DateFormat('HH:mm:ss').format(now);
    checkTrno();
  }

  checkTrno() async {
    var transno = await ClassApi.checkTrno();
    trno = widget.outletinfo!.outletcd +
        '-' +
        transno[0]['transnonext'].toString();
    print(trno);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 480) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                splash: selected,
                iconasset: 'assets/cart1.png',
                height: MediaQuery.of(context).size.height * 0.04,
                widht: MediaQuery.of(context).size.width * 0.19,
                onpressed: () async {
                  setState(() {
                    selected = !selected;
                  });
                  var x = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassRetailMainMobile(
                              fromsaved: false,
                              trno: trno,
                              qty: 0,
                              pscd: widget.pscd.toString(),
                              outletinfo: widget.outletinfo!,
                            )),
                  );
                
                },
                name: 'Transaksi ',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                splash: selected,
                iconasset: 'assets/outlet1.png',
                height: MediaQuery.of(context).size.height * 0.04,
                widht: MediaQuery.of(context).size.width * 0.19,
                onpressed: accesslistuser.contains('selectoutlet') == true
                    ? () async {
                        setState(() {
                          selected = !selected;
                        });
                        final Outlet? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Selectoutletmobile(
                                    email: emaillogin,
                                    fullname: usercd,
                                  )),
                        );
                        // callbackTitle(result);
                          await checkTrno();
                        AppsMobile.of(context)!.string = result;
                        print('ini result : $result');
                      }
                    : () {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses outlet",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                name: 'Outlet',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                splash: selected,
                iconasset: 'assets/investor.png',
                height: MediaQuery.of(context).size.height * 0.04,
                widht: MediaQuery.of(context).size.width * 0.19,
                onpressed: accesslistuser.contains('createcostumer') == true
                    ? () {
                        selected = !selected;
                        setState(() {});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClassListCustomers()),
                        );
                      }
                    : () {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses customer",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                name: 'Customer',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                splash: selected,
                iconasset: 'assets/fingerprint.png',
                height: MediaQuery.of(context).size.height * 0.04,
                widht: MediaQuery.of(context).size.width * 0.19,
                onpressed: () async {
                  showAttendanceDialog(context);
                },
                name: 'Absen',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                splash: selected,
                iconasset: 'assets/settings.png',
                height: MediaQuery.of(context).size.height * 0.04,
                widht: MediaQuery.of(context).size.width * 0.19,
                onpressed: accesslistuser.contains('setting') == true
                    ? () {
                        selected = !selected;
                        setState(() {});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainMenuProduct(
                                    pscd: widget.outletinfo!.outletcd,
                                    outletinfo: widget.outletinfo!,
                                  )),
                        );
                      }
                    : () {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses kelola",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                name: 'Kelola',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                splash: selected,
                iconasset: 'assets/staff.png',
                height: MediaQuery.of(context).size.height * 0.04,
                widht: MediaQuery.of(context).size.width * 0.19,
                onpressed: accesslistuser.contains('pegawai') == true
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPagePegawai()),
                        );
                        selected = !selected;
                        setState(() {});
                      }
                    : () {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses pegawai",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                name: 'Pegawai',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                splash: selected,
                iconasset: 'assets/support.png',
                height: MediaQuery.of(context).size.height * 0.04,
                widht: MediaQuery.of(context).size.width * 0.19,
                onpressed: () async {
                  selected = !selected;
                  setState(() {});
                  Fluttertoast.showToast(
                      msg: "Cooming soon",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color.fromARGB(255, 11, 12, 14),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                name: 'Help',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ],
          ),
        );
      } else if (constraints.maxWidth >= 820) {
        // diatas 480P ///
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                iconasset: 'assets/cart1.png',
                height: MediaQuery.of(context).size.height * 0.02,
                widht: MediaQuery.of(context).size.width * 0.08,
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassRetailMainMobile(
                              fromsaved: false,
                              trno: trno,
                              qty: 0,
                              pscd: widget.pscd.toString(),
                              outletinfo: widget.outletinfo!,
                            )),
                  );
                },
                name: 'Transaksi ',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                iconasset: 'assets/outlet1.png',
                height: MediaQuery.of(context).size.height * 0.02,
                widht: MediaQuery.of(context).size.width * 0.08,
                onpressed: () async {
                  final Outlet? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Selectoutletmobile(
                              email: '',
                              fullname: '',
                            )),
                  );
                  setState(() {});
                  // callbackTitle(result);
                    await checkTrno();
                  AppsMobile.of(context)!.string = result;

                  print(result);
                },
                name: 'Outlet',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                iconasset: 'assets/investor.png',
                height: MediaQuery.of(context).size.height * 0.02,
                widht: MediaQuery.of(context).size.width * 0.08,
                onpressed: accesslistuser.contains('setting') == true
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClassListCustomers()),
                        );
                      }
                    : () {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses Customer",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                name: 'Customer',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                iconasset: 'assets/fingerprint.png',
                height: MediaQuery.of(context).size.height * 0.02,
                widht: MediaQuery.of(context).size.width * 0.08,
                onpressed: () {
                  showAttendanceDialog(context);
                },
                name: 'Absen',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                iconasset: 'assets/settings.png',
                height: MediaQuery.of(context).size.height * 0.02,
                widht: MediaQuery.of(context).size.width * 0.08,
                onpressed: accesslistuser.contains('setting') == true
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainMenuProduct(
                                    pscd: widget.outletinfo!.outletcd,
                                    outletinfo: widget.outletinfo!,
                                  )),
                        );
                      }
                    : () {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses Setting",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                name: 'Kelola',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                iconasset: 'assets/staff.png',
                height: MediaQuery.of(context).size.height * 0.02,
                widht: MediaQuery.of(context).size.width * 0.08,
                onpressed: accesslistuser.contains('pegawai') == true
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPagePegawai()),
                        );
                        selected = !selected;
                        setState(() {});
                      }
                    : () {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses pegawai",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                name: 'Pegawai',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ButtonClassAction(
                iconasset: 'assets/support.png',
                height: MediaQuery.of(context).size.height * 0.02,
                widht: MediaQuery.of(context).size.width * 0.08,
                onpressed: () async {
                  Fluttertoast.showToast(
                      msg: "Cooming soon",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color.fromARGB(255, 11, 12, 14),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                name: 'Help',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}
