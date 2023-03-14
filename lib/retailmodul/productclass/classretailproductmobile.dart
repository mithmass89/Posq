// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_typing_uninitialized_variables, prefer_const_constructors, unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/retailmodul/productclass/classitemretailmobil.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';
import 'package:collection/collection.dart';
import '../../userinfo.dart';

class ClassRetailProductMobile extends StatefulWidget {
  final String trno;
  final String? pscd;
  late final controller;
  final int itemseq;
  ClassRetailProductMobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.controller,
      required this.itemseq})
      : super(key: key);

  @override
  State<ClassRetailProductMobile> createState() =>
      _ClassRetailProductMobileState();
}

class _ClassRetailProductMobileState extends State<ClassRetailProductMobile> {
  final search = TextEditingController();
  String query = '';
  late DatabaseHandler handler;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  bool isLoading = true;
  Future? getOutletItem;
  Map<String, List<Map<String, dynamic>>> groupdata = {};
  List<String> keys = [];

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    getOutletItem = getItems(widget.controller.text);
  }

  getItems(query) async {
    await getitemOutlet(widget.controller.text);
  }

  Future<List<Item>> getitemOutlet(query) async {
    isLoading = true;
    List<Item> data =
        await ClassApi.getItemList(widget.pscd!, widget.pscd!, query);
    isLoading = false;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: MediaQuery.of(context).size.height * 0.60,
      width: MediaQuery.of(context).size.width * 1,
      child: FutureBuilder(
          future: ClassApi.getItemList(pscd, dbname, widget.controller.text),
          builder: (context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              isLoading == false;
            }
            var x = snapshot.data ?? [];
            if (x.isEmpty) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('tidak ada produk tersedia'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Createproduct(
                                      pscd: widget.pscd,
                                    )),
                          );
                        },
                        child: Text('Buat Produk'))
                  ],
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var _image = File(x[index].pathimage.toString());
                    return ShimmerLoading(
                      isLoading: isLoading,
                      child: ClassitemRetailMobile(
                        itemseq: widget.itemseq,
                        trno: widget.trno,
                        trdt: formattedDate,
                        item: snapshot.data![index],
                        image: _image,
                      ),
                    );
                  });
            }
          }),
    );
  }
}
