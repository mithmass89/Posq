// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/profilemain.dart';

class Selectoutletmobile extends StatefulWidget {
  const Selectoutletmobile({Key? key}) : super(key: key);

  @override
  State<Selectoutletmobile> createState() => _SelectoutletmobileState();
}

class _SelectoutletmobileState extends State<Selectoutletmobile> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Outlet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: this.handler.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Outlet>> snapshot) {
          if (snapshot.hasData) {
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
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this.handler.deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(Outlet(
                        outletcd: snapshot.data![index].outletcd,
                        outletname: snapshot.data![index].outletname,
                        alamat: snapshot.data![index].alamat,
                        kodepos: snapshot.data![index].kodepos,
                        telp: snapshot.data![index].telp,
                        trnonext: snapshot.data![index].trnonext,
                        trnopynext: snapshot.data![index].trnopynext,
                      ));
                    },
                    child: Card(
                        child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text(snapshot.data![index].outletname!),
                      subtitle: Text(snapshot.data![index].alamat.toString()),
                    )),
                  ),
                );
              },
            );
          } else {
            return Center(child: Container());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          ).then((_) {
            setState(() {});
          });
        },
      ),
    );
  }
}
