// ignore_for_file: prefer_const_constructors, unnecessary_this, sized_box_for_whitespace, iterable_contains_unrelated_type, avoid_print, unused_import, avoid_unnecessary_containers, prefer_is_empty

import 'dart:async';
import 'dart:io';
import 'dart:io' show Directory;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart' show join;
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
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
  List<Item>? data;
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
    data = await ClassApi.getItemList(widget.pscd, widget.pscd, query);
    print("ini data : $data");
    return data!;
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
        actions: [
          IconButton(
              onPressed: () async {
                bool download = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogCopyItem();
                    });
                if (download == true) {
                  EasyLoading.show(status: 'loading...');
                  await ClassApi.insertItemFromHO()
                      .onError((error, stackTrace) {
                    EasyLoading.dismiss();
                  });
                  EasyLoading.dismiss();
                  await getitemOutlet('').whenComplete(() {
                    setState(() {});
                  });
                }
              },
              icon: Icon(
                Icons.download,
                color: Colors.white,
              ))
        ],
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
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
                                                  0.15,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Image.network(
                                                data![index].pathimage!,
                                                filterQuality:
                                                    FilterQuality.medium,
                                                fit: BoxFit.scaleDown,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              )),
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
                                            child: Image.network(
                                              data![index].pathimage!,
                                              fit: BoxFit.fill,
                                              filterQuality:
                                                  FilterQuality.medium,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.network(
                                                  'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930',
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            )),
                                        contentPadding: EdgeInsets.all(8.0),
                                        title: Text(x[index].itemdesc!),
                                        subtitle: Text(
                                            CurrencyFormat.convertToIdr(
                                                x[index].slsnett, 0)),
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
                  color: Colors.orange,
                  textcolor: Colors.white,
                  name: 'Buat Produk',
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
