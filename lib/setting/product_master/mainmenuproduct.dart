// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/condiment/maincondiment.dart';
import 'package:posq/setting/product_master/productmain.dart';
import 'package:posq/setting/tipetransaksi/maintipetransaksi.dart';

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
    "Tipe Transaksi"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kelola Produk'),
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
                                  : Container(),
                    ),
                  ),
                  title: Text(menulist[index]),
                  onTap: () {
                    if (menulist[index] == 'Tambah produk') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Productmain(
                                  pscd: widget.outletinfo!.outletcd,
                                )),
                      );
                    } else if (menulist[index] == 'Condiment /  Topping') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainCondiment(
                                  pscd: widget.outletinfo!.outletcd,
                                )),
                      );
                    } else if (menulist[index] == 'Tipe Transaksi') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainTransaksiType(
                                  pscd: widget.outletinfo!.outletcd,
                                )),
                      );
                    }
                  },
                ),
              );
            }));
  }
}
