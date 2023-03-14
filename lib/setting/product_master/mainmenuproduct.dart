// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/condiment/maincondiment.dart';
import 'package:posq/setting/product_master/productmain.dart';

class MainMenuProduct extends StatefulWidget {
  final String pscd;
  late Outlet? outletinfo;
  MainMenuProduct({Key? key, required this.pscd, required this.outletinfo})
      : super(key: key);

  @override
  State<MainMenuProduct> createState() => _MainMenuProductState();
}

class _MainMenuProductState extends State<MainMenuProduct> {
  List<String> menulist = ["Product Master", "Modifier Master"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Setting'),
        ),
        body: ListView.builder(
            itemCount: menulist.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(menulist[index]),
                  onTap: () {
                    if (menulist[index] == 'Product Master') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Productmain(
                                  pscd: widget.outletinfo!.outletcd,
                                )),
                      );
                    } else if (menulist[index] == 'Modifier Master') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainCondiment(
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
