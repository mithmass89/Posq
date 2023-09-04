// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/condiment/maincondiment.dart';
import 'package:posq/setting/generalsetting/generalsettingmobile.dart';
import 'package:posq/setting/kelolastock/kelolaproductmains.dart';

import 'package:posq/setting/menupackage/menupackagemainmobile.dart';
import 'package:posq/setting/product_master/productmain.dart';
import 'package:posq/setting/product_master/tabletclass/PaymentMasterTab.dart';
import 'package:posq/setting/tipetransaksi/maintipetransaksi.dart';
import 'package:posq/userinfo.dart';

class MainMenuProduct extends StatefulWidget {
  final String pscd;
  late Outlet? outletinfo;
  MainMenuProduct({Key? key, required this.pscd, required this.outletinfo})
      : super(key: key);

  @override
  State<MainMenuProduct> createState() => _MainMenuProductState();
}

class _MainMenuProductState extends State<MainMenuProduct> {
  List<String> menulist = [
    "Tambah produk",
    "Kelola Stok",
    "Condiment /  Topping",
    "Menu Paket",
    "Tipe Transaksi",
    "Table / Order No",
    "Payment Master",
    "General setting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Kelola Usaha'),
        ),
        body: ListView.builder(
            itemCount: menulist.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: menulist[index] == 'Tambah produk'
                            ? Image.asset('assets/addproduct.png')
                            : menulist[index] == 'Condiment /  Topping'
                                ? Image.asset('assets/condiment.png')
                                : menulist[index] == 'Tipe Transaksi'
                                    ? Image.asset('assets/transaction.png')
                                    : menulist[index] == 'Table / Order No'
                                        ? Image.asset('assets/round-table.png')
                                        : menulist[index] == 'Payment Master'
                                            ? Image.asset('assets/wallet.png')
                                            : menulist[index] ==
                                                    'General setting'
                                                ? Image.asset(
                                                    'assets/settings.png')
                                                : menulist[index] ==
                                                        'Kelola Stok'
                                                    ? Image.asset(
                                                        'assets/fifo.png')
                                                    : menulist[index] ==
                                                            'Menu Paket'
                                                        ? Image.asset(
                                                            'assets/package.png')
                                                        : Container(),
                      ),
                    ),
                    title: Text(menulist[index]),
                    onTap: () {
                      print(accesslist);
                      if (menulist[index] == 'Tambah produk') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Productmain(
                                    pscd: pscd,
                                  )),
                        );
                      } else if (menulist[index] == 'Condiment /  Topping') {
                        if (accesslist.contains('createcondiment') == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainCondiment(
                                      pscd: pscd,
                                    )),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Tidak punya akses condiment",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else if (menulist[index] == 'Tipe Transaksi') {
                        if (accesslist.contains('createtype') == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainTransaksiType(
                                      pscd: pscd,
                                    )),
                          );
                        }
                      } else if (menulist[index] == 'Payment Master') {
                        print(accesslist);
                        if (accesslist.contains('paymentmaster') == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentMasterTab(
                                      pscd: widget.outletinfo!.outletcd,
                                    )),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Tidak punya akses Payment Master",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else if (menulist[index] == 'General setting') {
                        print(accesslist);
                        if (accesslist.contains('generalsetting') == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GeneralSettingMobile(
                                      pscd: widget.outletinfo!.outletcd,
                                    )),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Tidak punya akses General Setting",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else if (menulist[index] == 'Menu Paket') {
                        print(accesslist);
                        if (accesslist.contains('itempackage') == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainMenuPackageMobile()),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Tidak punya akses Menu Setting",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else if (menulist[index] == 'Kelola Stok') {
                        print(accesslist);
                        if (accesslist.contains('kelolastock') == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KelolaMainsStock()),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Tidak punya akses Stock Setting",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Tidak punya akses tipe transaksi",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color.fromARGB(255, 11, 12, 14),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }),
              );
            }));
  }
}
