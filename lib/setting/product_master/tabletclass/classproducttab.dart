// ignore_for_file: prefer_const_constructors, unnecessary_this, sized_box_for_whitespace, iterable_contains_unrelated_type, avoid_print, unused_import, avoid_unnecessary_containers, prefer_is_empty

import 'dart:async';
import 'dart:io';
import 'dart:io' show Directory;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart' show join;
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/model.dart';
import 'package:flutter/material.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';
import 'package:posq/setting/product_master/classeditproductmobile.dart';
import 'package:posq/classui/searchwidget.dart';
import 'package:posq/setting/product_master/tabletclass/classeditproducttab.dart';
import 'package:posq/setting/product_master/classeditproductv2mob.dart';
import 'package:posq/setting/product_master/tabletclass/createproducttab.dart';
import 'package:posq/userinfo.dart';

ClassApi? apicloud;

class ClassproductTab extends StatefulWidget {
  const ClassproductTab({Key? key, required this.pscd}) : super(key: key);
  final String pscd;
  @override
  State<ClassproductTab> createState() => _ClassproductTabState();
}

class _ClassproductTabState extends State<ClassproductTab> {
  final search = TextEditingController();
  String query = '';
  Timer? debouncer;
  bool? hasitem = false;
  bool isloading = true;
  Timer? timer;
  List<Item> data = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    debouncer?.cancel();
    super.dispose();
    getitemOutlet('');
  }

  Future<List<Item>> getitemOutlet(query) async {
    data = await ClassApi.getItemList(widget.pscd, widget.pscd, query);
    print("ini data : $data");
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 173, 150),
        foregroundColor: Colors.white,
        splashColor: Colors.yellow,
        hoverColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Createproducttab(
                      productcode: Item(
                          packageflag: 0,
                          pathimage:
                              'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930',
                          multiprice: 0),
                      pscd: widget.pscd,
                    )),
          ).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: false,
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
        title: Text(
          'List produk',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          corporatecode != ''
              ? IconButton(
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
              : Container()
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFieldMobile(
              maxline: 1,
              label: 'Cari Produk',
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
                            height: MediaQuery.of(context).size.height * 0.70,
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
                                          (DismissDirection direction) async {},
                                      child: Card(
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditproductTab(
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
                          height: MediaQuery.of(context).size.height * 0.70,
                          width: MediaQuery.of(context).size.width * 1,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: x.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditproductTab(
                                                    productcode: x[index],
                                                  )),
                                        ).then((_) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          child: Image.network(
                                            x[index].pathimage!,
                                            fit: BoxFit.fill,
                                            errorBuilder: (BuildContext context,
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
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(x[index].itemdesc!))
                                  ],
                                ),
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
                          // Container(
                          //     child: TextButton(
                          //         onPressed: () {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => Createproduct(
                          //                       pscd: widget.pscd,
                          //                     )),
                          //           ).then((_) {
                          //             setState(() {});
                          //           });
                          //         },
                          //         child: Text('Buat Produk'))),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
