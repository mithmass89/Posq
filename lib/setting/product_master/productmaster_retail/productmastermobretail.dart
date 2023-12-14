import 'dart:async';

import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/product_master/productmaster_retail/createproduct_retail.dart';

class ProductMasterMainRetailMob extends StatefulWidget {
  final String pscd;
  const ProductMasterMainRetailMob({super.key, required this.pscd});

  @override
  State<ProductMasterMainRetailMob> createState() =>
      _ProductMasterMainRetailMobState();
}

class _ProductMasterMainRetailMobState
    extends State<ProductMasterMainRetailMob> {
  List<Item>? data;
  final search = TextEditingController();
  String query = '';
  Timer? debouncer;
  Timer? timer;
  List item = [];

  Future<List<Item>> getitemOutlet(query) async {
    data = await ClassApi.getItemList(widget.pscd, widget.pscd, query);
    print("ini data : $data");
    return data!;
  }

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
        backgroundColor: AppColors.secondaryColor,
        tooltip: 'Increment',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductMaster()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      appBar: AppBar(
        title: Text(
          'List Produk',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width * 0.02),
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.1,
            child: TextFieldMobile2(
              suffixIcon: search.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        search.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.close))
                  : Icon(Icons.search),
              hint: 'Cari',
              controller: search,
              onChanged: (v) {
                query = v;
                setState(() {});
              },
              typekeyboard: TextInputType.text,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.85,
            child: FutureBuilder(
                future: getitemOutlet(query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Item> x = snapshot.data!;
                    List<Item> dataprod = [];
                    if (x
                        .where((element) => element.moderetail == 1)
                        .isNotEmpty) {
                      dataprod.add(
                          x.where((element) => element.moderetail == 1).first);
                    }
                    ;
                    if (dataprod.isNotEmpty) {
                      return ListView.builder(
                          itemCount: dataprod.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {},
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.01),
                                leading:
                                    Image.network(dataprod[index].pathimage!),
                                title: Text(dataprod[index].itemdesc!),
                              ),
                            );
                          });
                    } else {
                      return Center(child: Container(child: Text('No data')));
                    }
                  } else {
                    return Center(child: Container(child: Text('No data')));
                  }
                }),
          ),
        ],
      ),
    );
  }
}
