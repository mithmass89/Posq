import 'package:flutter/material.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class ClassDetailPelanggan extends StatefulWidget {
  final String? trno;
  const ClassDetailPelanggan({Key? key, required this.trno}) : super(key: key);

  @override
  State<ClassDetailPelanggan> createState() => _ClassDetailPelangganState();
}

class _ClassDetailPelangganState extends State<ClassDetailPelanggan> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: handler.retrieveGuestinfo(widget.trno!),
        builder: (BuildContext context,
            AsyncSnapshot<List<CostumersSavedManual>> snapshot) {
          var x = snapshot.data ??
              [
                CostumersSavedManual(
                    outletcd: '', nama: '', email: '', telp: '', alamat: ''),
              ];
          if (x.isNotEmpty) {
            return Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Nama'),
                    trailing: Text(x.first.nama!),
                  ),
                  ListTile(
                    title: Text('E-mail'),
                    trailing: Text(x.first.email!),
                  ),
                  ListTile(
                      title: Text('No Telp'), trailing: Text(x.first.telp!)),
                  ListTile(
                    title: Text('Alamat'),
                    trailing: Text(x.first.alamat!),
                  ),
                ],
              ),
            );
          }
          return Center(
              child: Container(
            child: Text('Tidak ada data'),
          ));
        });
  }
}
