// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/classsetupprofilemobile.dart';
import 'package:posq/userinfo.dart';

class Selectoutletmobile extends StatefulWidget {
  final String email;
  final String fullname;
  const Selectoutletmobile(
      {Key? key, required this.email, required this.fullname})
      : super(key: key);

  @override
  State<Selectoutletmobile> createState() => _SelectoutletmobileState();
}

class _SelectoutletmobileState extends State<Selectoutletmobile> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
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
        future: ClassApi.getOutlets(emaillogin),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(Outlet(
                      outletcd: snapshot.data![index]['outletcode'],
                      outletname: snapshot.data![index]['outletdesc'],
                      alamat: snapshot.data![index]['alamat'],
                      kodepos: snapshot.data![index]['kodepos'],
                      telp: num.parse(snapshot.data![index]['telp']),
                    ));

                    dbname = snapshot.data![index]['outletcode'];
                    pscd = snapshot.data![index]['outletcode'];
                    outletdesc = snapshot.data![index]['outletdesc'];
                    setState(() {});
                    print('terpilih ${snapshot.data![index]['outletcode']}');
                  },
                  child: Card(
                      child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index]['outletdesc']!),
                    subtitle: Text(snapshot.data![index]['alamat'].toString()),
                  )),
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
            MaterialPageRoute(
                builder: (context) => ClassSetupProfileMobile(
                      email: emaillogin,
                      fullname:usercd,
                    )),
          ).then((_) {
            setState(() {});
          });
        },
      ),
    );
  }
}
