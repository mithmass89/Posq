import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/tipetransaksi/createtipe.dart';
import 'package:posq/userinfo.dart';

class MainTransaksiType extends StatefulWidget {
  final String pscd;
  const MainTransaksiType({Key? key, required this.pscd}) : super(key: key);

  @override
  State<MainTransaksiType> createState() => _MainTransaksiTypeState();
}

class _MainTransaksiTypeState extends State<MainTransaksiType> {
  final TextEditingController search = TextEditingController();
  String query = '';
  List<TransactionTipe> data = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 480) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Tipe Transaksi',
            ),
          ),
          body: Container(
            child: Column(
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.71,
                  child: FutureBuilder<List<TransactionTipe>?>(
                      future: ClassApi.getTransactionTipe(pscd, dbname, query),
                      builder: (context, snapshot) {
                        data = snapshot.data ?? [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          print(snapshot);
                          return ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return ShimmerLoading(
                                  isLoading: true,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(''),
                                      onTap: () {},
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.71,
                            child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Icon(Icons.close),
                                    ),
                                    key: ValueKey<String>(
                                        data[index].transtype!),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      await ClassApi.deactiveTipeTrans(
                                          data[index].id!, pscd);
                                      setState(() {
                                        data.remove(data[index]);
                                      });
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text(data[index].transdesc!,
                                            style: data[index].active == 0
                                                ? TextStyle(
                                                    color: Colors.red,
                                                    decoration: TextDecoration
                                                        .lineThrough)
                                                : null),
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                      }),
                ),
                ButtonNoIcon2(
                  color: Colors.orange,
                  textcolor: Colors.white,
                  name: 'Tambah Tipe',
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.9,
                  onpressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateTipeTransaksi(
                                pscd: widget.pscd,
                              )),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        );
      } else if (constraints.maxWidth >= 820) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            splashColor: Colors.yellow,
            hoverColor: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTipeTransaksi(
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
            title: Text(
              'Tipe Transaksi',
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: FutureBuilder<List<TransactionTipe>?>(
                      future: ClassApi.getTransactionTipe(pscd, dbname, query),
                      builder: (context, snapshot) {
                        data = snapshot.data ?? [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          print(snapshot);
                          return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return ShimmerLoading(
                                  isLoading: true,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(''),
                                      onTap: () {},
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Icon(Icons.close),
                                    ),
                                    key: ValueKey<String>(
                                        data[index].transtype!),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      await ClassApi.deactiveTipeTrans(
                                          data[index].id!, pscd);
                                      setState(() {
                                        data.remove(data[index]);
                                      });
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text(data[index].transdesc!,
                                            style: data[index].active == 0
                                                ? TextStyle(
                                                    color: Colors.red,
                                                    decoration: TextDecoration
                                                        .lineThrough)
                                                : null),
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                      }),
                ),
           
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }
}
