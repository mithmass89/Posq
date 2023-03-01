// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors_in_immutables, must_be_immutable, prefer_generic_function_type_aliases, non_constant_identifier_names, prefer_const_constructors, avoid_print, unused_import, unused_local_variable

import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:flutter/material.dart';
import 'package:posq/appsmobile.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/customer/classcustomersmobile.dart';
import 'package:posq/setting/classselectoutletmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/product_master/productmain.dart';
import 'package:posq/setting/profilemain.dart';
import 'package:uuid/uuid.dart';

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

  deleteDatabase() async {
    print('oke');
  }

  @override
  void initState() {
    super.initState();
    print(widget.pscd);
    var uuid = Uuid();
    var random = uuid.v4();
    trno = random;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.2,
      child: GridView.count(
        crossAxisSpacing: 10,
        mainAxisSpacing: 1,
        crossAxisCount: 4,
        children: [
          ButtonClassAction(
            iconasset: 'retail.png',
            height: MediaQuery.of(context).size.height * 0.02,
            widht: MediaQuery.of(context).size.width * 0.40,
            onpressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClassRetailMainMobile(
                          trno: trno,
                          qty: 0,
                          pscd: widget.pscd.toString(),
                          outletinfo: widget.outletinfo!,
                        )),
              );
            },
            name: 'Retail ',
          ),
          ButtonClassAction(
            iconasset: 'resto.png',
            height: MediaQuery.of(context).size.height * 0.02,
            widht: MediaQuery.of(context).size.width * 0.40,
            onpressed: () {},
            name: 'Restaurant ',
          ),
          ButtonClassAction(
            iconasset: 'outlet.png',
            height: MediaQuery.of(context).size.height * 0.02,
            widht: MediaQuery.of(context).size.width * 0.40,
            onpressed: () async {
              final Outlet result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Selectoutletmobile()),
              );
              setState(() {});
              // callbackTitle(result);
              AppsMobile.of(context)!.string = result;
              print(result);
            },
            name: 'Outlet',
          ),
          ButtonClassAction(
            iconasset: 'pembeli.png',
            height: MediaQuery.of(context).size.height * 0.02,
            widht: MediaQuery.of(context).size.width * 0.40,
            onpressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClassListCustomers()),
              );
            },
            name: 'Customer',
          ),
          ButtonClassAction(
            iconasset: 'products.png',
            height: MediaQuery.of(context).size.height * 0.03,
            widht: MediaQuery.of(context).size.width * 0.42,
            onpressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Productmain(
                          pscd: widget.outletinfo!.outletcd,
                        )),
              );
            },
            name: 'Product',
          ),
          ButtonClassAction(
            iconasset: 'pegawai.png',
            height: MediaQuery.of(context).size.height * 0.02,
            widht: MediaQuery.of(context).size.width * 0.40,
            onpressed: () {},
            name: 'Pegawai',
          ),
          ButtonClassAction(
            iconasset: 'help.png',
            height: MediaQuery.of(context).size.height * 0.02,
            widht: MediaQuery.of(context).size.width * 0.40,
            onpressed: () async {
              // handler = DatabaseHandler();
              // await handler.upgradeDB();
            },
            name: 'Help',
          ),
        ],
      ),
    );
  }
}
