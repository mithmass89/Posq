import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/classdetailtrnomobile.dart';
import 'package:posq/retailmodul/classdetailtrnosavedmob.dart';

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

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi Tersimpan'),
        actions: [],
      ),
      body: FutureBuilder(
          future: this.handler.retriveSavedTransaction(),
          builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
            var x = snapshot.data ?? [];
            if (x.isNotEmpty) {
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
                                ClassDetailSavedMobile(
                        
                                  datatransaksi: snapshot.data![index],
                                  trno: x[index].trno,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Tidak ada transaksi tersimpan')],
              ),
            );
          }),
    );
  }
}
