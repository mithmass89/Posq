// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_this, prefer_const_constructors, sized_box_for_whitespace, unnecessary_new, avoid_print, unused_field

import 'package:flutter/material.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/setting/classsetupprofilemobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/appsmobile.dart';
import 'package:intl/intl.dart';
import 'package:posq/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainapps extends StatefulWidget {
  final String? title;
  // final bool? newinstall;
  const Mainapps({
    Key? key,
    this.title,
    // this.newinstall,
  }) : super(key: key);

  @override
  State<Mainapps> createState() => _MainappsState();
}

class _MainappsState extends State<Mainapps> {
  late DatabaseHandler handler;
  DateTime currentTime = DateTime.now();
  String? time;
  String? date;
  bool? hasoutlet = false;
  Outlet? outletinfo;

  @override
  void initState() {
    super.initState();
    loadKey();
    checkSF().whenComplete(() {
      checkNewApp();
    });
  }

  loadKey() async {
    final midtranskey = await SharedPreferences.getInstance();
    serverkeymidtrans = midtranskey.getString('serverkey') == null
        ? ''
        : midtranskey.getString('serverkey')!;
  }

  Future<dynamic> checkSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dbpref = prefs.getString('database') ?? "";
    if (dbpref.isNotEmpty) {
      setState(() {
        databasename = dbpref;
      });
    }
  }

  checkNewApp() async {
    this.handler = DatabaseHandler();
    this.handler.initializeDB(databasename).whenComplete(() async {
      await handler.retrieveUsers().then((value) {
        if (value.isNotEmpty) {
          setState(() {
            hasoutlet = true;
            outletinfo = Outlet(
              outletcd: value.first.outletcd,
              outletname: value.first.outletname,
              telp: value.first.telp,
              alamat: value.first.alamat,
              kodepos: value.first.kodepos,
              trnonext: value.first.trnonext,
              trnopynext: value.first.trnopynext,
            );
          });
        } else {
          if (value.isEmpty) {
            setState(() {
              hasoutlet = false;
            });
          }
        }
      });
    });
  }

  todayDate() {
    setState(() {
      var now = new DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy');
      time = DateFormat('kk:mm:a').format(now);
      date = formatter.format(now);
    });

    print(time);
    print(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (
            context,
            BoxConstraints constraints,
          ) {
            if (constraints.maxWidth <= 480) {
              if (hasoutlet == false) {
                return ClassSetupProfileMobile();
              } else if (hasoutlet == true) {
                return AppsMobile(
                  profileusaha: Outlet(
                    outletcd: outletinfo!.outletcd,
                    outletname: outletinfo!.outletname,
                    telp: outletinfo!.telp,
                    alamat: outletinfo!.alamat,
                    kodepos: outletinfo!.kodepos,
                    trnonext: outletinfo!.trnonext,
                    trnopynext: outletinfo!.trnopynext,
                  ),
                );
              } else {
                return Container();
              }
            }
            return Container();
          },
        ));
  }
}
