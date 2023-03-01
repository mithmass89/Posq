// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

ClassApi? apicloud;

class CategoryList extends StatefulWidget {
  late int? index;
  late TabController? controller;
  CategoryList({Key? key, this.index, this.controller}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: ClassApi.getCTG(dbname),
        builder: (BuildContext context, AsyncSnapshot<List<Ctg>> snapshot) {
          var x = snapshot.data ?? [];
          if (x.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(x[index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await ClassApi.deleteCTG(pscd,x[index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(Ctg(
                            ctgcd: x[index].ctgcd, ctgdesc: x[index].ctgdesc));
                      },
                      child: Card(
                          child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(x[index].ctgdesc),
                      )),
                    ),
                  );
                });
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tidak ada kategori'),
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.controller!.animateTo(1);
                    });
                  },
                  child: Text('Buat kategori'))
            ],
          ));
        },
      ),
    );
  }
}

class CategoryListArscomp extends StatefulWidget {
  late int? index;
  late TabController? controller;
  CategoryListArscomp({Key? key, this.index, this.controller})
      : super(key: key);

  @override
  State<CategoryListArscomp> createState() => _CategoryListArscompState();
}

class _CategoryListArscompState extends State<CategoryListArscomp> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // future: handler.retrieveCtgArscomp(),
        builder: (BuildContext context, AsyncSnapshot<List<Ctg>> snapshot) {
          var x = snapshot.data ?? [];
          if (x.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(x[index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await handler.deleteCTG(x[index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(Ctg(
                            ctgcd: x[index].ctgcd, ctgdesc: x[index].ctgdesc));
                      },
                      child: Card(
                          child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(x[index].ctgdesc),
                      )),
                    ),
                  );
                });
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tidak ada kategori'),
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.controller!.animateTo(1);
                    });
                  },
                  child: Text('Buat kategori'))
            ],
          ));
        },
      ),
    );
  }
}
