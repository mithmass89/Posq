// ignore_for_file: prefer_const_constructors, unnecessary_this, sized_box_for_whitespace, iterable_contains_unrelated_type, avoid_print, unused_import, avoid_unnecessary_containers, prefer_is_empty

import 'dart:async';
import 'dart:io';
import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/model.dart';
import 'package:flutter/material.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';
import 'package:posq/setting/product_master/classeditproductmobile.dart';
import 'package:posq/classui/searchwidget.dart';
import 'package:posq/setting/product_master/classeditproductv2mob.dart';
import 'package:posq/userinfo.dart';

ClassApi? apicloud;

class Classproductmobile extends StatefulWidget {
  const Classproductmobile({Key? key, required this.pscd}) : super(key: key);
  final String pscd;
  @override
  State<Classproductmobile> createState() => _ClassproductmobileState();
}

class _ClassproductmobileState extends State<Classproductmobile> {
  final search = TextEditingController();
  String query = '';
  Timer? debouncer;
  bool? hasitem = false;
  bool isloading = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    debouncer?.cancel();
    super.dispose();
  }

  Future<List<Item>> getitemOutlet(query) async {
    List<Item> data =
        await ClassApi.getItemList(widget.pscd, widget.pscd, query);
    return data;
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer?.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFieldMobile(
              hint: 'Example Menu Description',
              label: 'Search',
              controller: search,
              onChanged: (value) async {
                setState(() {
                  query = value;
                  print(value);
                });
              },
              typekeyboard: TextInputType.text,
            ),
          ),
          Stack(
            children: [
              FutureBuilder(
                future: getitemOutlet(query),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                  var x = snapshot.data ?? [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        ShimmerLoading(
                          isLoading: isloading,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView.builder(
                              itemCount: x.length,
                              itemBuilder: (BuildContext context, int index) {
                                var _image =
                                    File(x[index].pathimage.toString());
                                return Column(
                                  children: [
                                    Dismissible(
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: Colors.grey[100],
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Icon(Icons.close),
                                      ),
                                      key: ValueKey<int>(x[index].id!),
                                      onDismissed:
                                          (DismissDirection direction) async {
                                        await ClassApi.deleteItem(
                                            pscd, x[index].id!);
                                        setState(() {
                                          x.remove(x[index]);
                                        });
                                      },
                                      child: Card(
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Editproduct(
                                                        productcode: x[index],
                                                      )),
                                            ).then((_) {
                                              setState(() {});
                                            });
                                          },
                                          leading: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Image.file(
                                              _image,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Center(
                                                    child:
                                                        const Text('No Image'));
                                              },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(8.0),
                                          title: Text(x[index].itemdesc!),
                                          subtitle:
                                              Text(x[index].slsnett.toString()),
                                          trailing: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: x[index].trackstock == 1
                                                ? Row(
                                                    children: [
                                                      Text('Stok :'),
                                                      Text(x[index]
                                                          .stock
                                                          .toString()),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  print(snapshot.connectionState);
                  if (x.isNotEmpty) {
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width * 1,
                          child: ListView.builder(
                            itemCount: x.length,
                            itemBuilder: (BuildContext context, int index) {
                              var _image = File(x[index].pathimage.toString());
                              return Column(
                                children: [
                                  Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Icon(Icons.close),
                                    ),
                                    key: ValueKey<int>(x[index].id!),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      await ClassApi.deleteItem(
                                          pscd, x[index].id!);
                                      setState(() {
                                        x.remove(x[index]);
                                      });
                                    },
                                    child: Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Editproduct(
                                                      productcode: x[index],
                                                    )),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        },
                                        leading: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0.5,
                                            ),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Image.file(
                                            _image,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Center(
                                                  child:
                                                      const Text('No Image'));
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(8.0),
                                        title: Text(x[index].itemdesc!),
                                        subtitle:
                                            Text(x[index].slsnett.toString()),
                                        trailing: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: x[index].trackstock == 1
                                              ? Row(
                                                  children: [
                                                    Text('Stok :'),
                                                    Text(x[index]
                                                        .stock
                                                        .toString()),
                                                  ],
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.65,
                              ),
                          Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: Text('Tidak ada produk')),
                          Container(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Createproduct(
                                                pscd: widget.pscd,
                                              )),
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text('Buat Produk'))),
                        ],
                      ),
                    );
                  }
                },
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.01,
                left: MediaQuery.of(context).size.height * 0.02,
                child: ButtonNoIcon2(
                  color: Colors.blue,
                  textcolor: Colors.white,
                  name: 'Add Product',
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.9,
                  onpressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Createproduct(
                                pscd: widget.pscd,
                              )),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
