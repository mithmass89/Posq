import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/classlisttrnosavedmob.dart';

class ClassSavedTransactionMobile extends StatefulWidget {
  final String? pscd;
  final Outlet outletinfo;

  const ClassSavedTransactionMobile({
    Key? key,
    this.pscd,
    required this.outletinfo,
  }) : super(key: key);

  @override
  State<ClassSavedTransactionMobile> createState() =>
      _ClassSavedTransactionMobileState();
}

class _ClassSavedTransactionMobileState
    extends State<ClassSavedTransactionMobile> {
  late DatabaseHandler handler;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  int? pending;
  TextEditingController search = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Transaksi Tersimpan'),
        actions: [],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.08,
            child: TextFieldMobile2(
                suffixIcon: search.text.length != 0
                    ? IconButton(
                        icon: Icon(
                          Icons.close_outlined,
                        ),
                        iconSize: 20,
                        color: Colors.blue,
                        splashColor: Colors.purple,
                        onPressed: () {
                          setState(() {
                            search.clear();
                          });
                        },
                      )
                    : Icon(
                        Icons.search_outlined,
                        color: Colors.blue,
                        size: 20.0,
                      ),
                controller: search,
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
                typekeyboard: TextInputType.text),
          ),
          FutureBuilder(
              future: this.handler.retriveSavedTransaction2(query),
              builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                var x = snapshot.data ?? [];
                if (x.isNotEmpty) {
                  print(x);
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 1,
                        child: ListView.builder(
                            itemCount: x.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    ClassListSavedMobile(
                                      datatransaksi: snapshot.data![index],
                                      trno: x[index].transno,
                                      outletinfo: widget.outletinfo,
                                      pscd: widget.pscd.toString(),
                                    ),
                                    Divider()
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  );
                }
                return Container(
                     height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 1,
                  child: Center(child: Text('Tidak ada transaksi tersimpan')));
              }),
        ],
      ),
    );
  }
}
