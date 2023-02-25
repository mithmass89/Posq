// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/retailmodul/classitemretailmobil.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/classcreateproduct.dart';

import '../userinfo.dart';

class ClassRetailProductMobile extends StatefulWidget {
  final String trno;
  final String? pscd;
  late final controller;
  ClassRetailProductMobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.controller})
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

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    getOutletItem = getItems(widget.controller.text);
  }

  getItems(query) {
    getitemOutlet(query);
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
          future: getitemOutlet(widget.controller.text),
          builder: (context, AsyncSnapshot<List<Item>> snapshot) {
            var x = snapshot.data ?? [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ShimmerLoading(
                        isLoading: !isLoading,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Text(''),
                        ));
                  });
            } else if (snapshot.hasError) {
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var _image = File(x[index].pathimage.toString());
                    return ShimmerLoading(
                      isLoading: isLoading,
                      child: ClassitemRetailMobile(
                        trno: widget.trno,
                        trdt: formattedDate,
                        item: snapshot.data![index],
                        image: _image,
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(snapshot.hasError.toString()),
                    TextButton(onPressed: () {}, child: Text('Buat Produk'))
                  ],
                ),
              );
            }
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
          }),
    );
  }
}
