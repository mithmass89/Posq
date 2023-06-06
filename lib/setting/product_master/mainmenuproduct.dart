// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/condiment/maincondiment.dart';
import 'package:posq/setting/product_master/productmain.dart';
import 'package:posq/setting/product_master/tabletclass/PaymentMasterTab.dart';
import 'package:posq/setting/tablesettings/tablesettings.dart';
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
    "Condiment /  Topping",
    "Tipe Transaksi",
    "Table / Order No",
    "Payment Master",
    "General setting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                            ? Image.asset('addproduct.png')
                            : menulist[index] == 'Condiment /  Topping'
                                ? Image.asset('condiment.png')
                                : menulist[index] == 'Tipe Transaksi'
                                    ? Image.asset('transaction.png')
                                    : menulist[index] == 'Table / Order No'
                                        ? Image.asset('round-table.png')
                                        : menulist[index] == 'Payment Master'
                                            ? Image.asset('wallet.png')
                                            : menulist[index] ==
                                                    'General setting'
                                                ? Image.asset('settings.png')
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
                                    pscd: widget.outletinfo!.outletcd,
                                  )),
                        );
                      } else if (menulist[index] == 'Condiment /  Topping') {
                        if (accesslist.contains('createcondiment') == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainCondiment(
                                      pscd: widget.outletinfo!.outletcd,
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
                                      pscd: widget.outletinfo!.outletcd,
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
