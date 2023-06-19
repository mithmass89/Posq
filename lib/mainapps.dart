// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_this, prefer_const_constructors, sized_box_for_whitespace, unnecessary_new, avoid_print, unused_field

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/setting/classsetupprofilemobile.dart';
import 'package:posq/appsmobile.dart';
import 'package:intl/intl.dart';
import 'package:posq/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'userinfo.dart';

ClassApi? apicloud;

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
  DateTime currentTime = DateTime.now();
  String? time;
  String? date;
  String? date1;
  bool? hasoutlet = false;
  Outlet? outletinfo;
  List todaysales = [
    {'totalaftdisc': 0}
  ];
  List monthlysales = [
    {'totalaftdisc': 0}
  ];
  List penjualanratarata = [
    {'totalaftdisc': 0}
  ];
  List chartdata = [];
  Future<dynamic>? checkapps;

  @override
  void initState() {
    super.initState();
    loadKey();
    checkapps = checkingApps();
    // checkNewApp();
  }

  loadKey() async {
    final midtranskey = await SharedPreferences.getInstance();
    serverkeymidtrans = midtranskey.getString('serverkey') == null
        ? ''
        : midtranskey.getString('serverkey')!;
  }

  Future<dynamic> checkNewApp() async {
    await getOutlet(usercd);
    await getSelesToday();
  }

  checkingApps() async {
    await checkNewApp();
  }

  getOutlet(String usercd) async {
    await ClassApi.getOutlets(usercd).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          pscd = value.first['outletcd'];
          dbname = value.first['outletcd'];
          hasoutlet = true;
          outletinfo = Outlet(
              outletcd: value.first['outletcd'],
              outletname: value.first['outletdesc'],
              alamat: value.first['alamat'],
              telp: num.parse(value.first['telp']),
              kodepos: value.first['kodepos'].toString(),
              profile: value.first['profile'],
              trnonext: value.first['billnext']);
        });
      }
    });
  }

  todayDate() {
    setState(() {
      var now = new DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy');
      var formatter1 = new DateFormat('yyyy-MM-dd');
      time = DateFormat('kk:mm:a').format(now);
      date = formatter.format(now);
      date1 = formatter1.format(now);
    });
  }

  getSelesToday() async {
    todayDate();
    todaysales = await ClassApi.getTodaySales(date1!, dbname);
    monthlysales = await ClassApi.monthlysales(date1!, dbname);
    chartdata = await ClassApi.listdataChart(date1!, dbname);
    penjualanratarata = await ClassApi.getPenjualanRataRata(date1!, dbname);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkapps,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: CircularProgressIndicator()),
              ),
            );
          } else {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                body: LayoutBuilder(
                  builder: (
                    context,
                    BoxConstraints constraints,
                  ) {
                    if (constraints.maxWidth <= 480) {
                      switch (hasoutlet) {
                        case false:
                          return ClassSetupProfileMobile(
                            username: '',
                          );
                        case true:
                          // do something else
                          return AppsMobile(
                            penjualanratarata: penjualanratarata,
                            todaysale: todaysales.isNotEmpty
                                ? todaysales
                                : [
                                    {'trdt': '2023-01-01'},
                                    {'totalaftdisc': 0}
                                  ],
                            monthlysales: monthlysales,
                            chartdata: chartdata,
                            profileusaha: Outlet(
                              outletcd: outletinfo!.outletcd,
                              outletname: outletinfo!.outletname,
                              telp: outletinfo!.telp,
                              alamat: outletinfo!.alamat,
                              kodepos: outletinfo!.kodepos,
                            ),
                          );
                      }
                    }
                    switch (hasoutlet) {
                      case false:
                        return ClassSetupProfileMobile(
                          username: '',
                        );
                      case true:
                        // do something else
                        return AppsMobile(
                          penjualanratarata: penjualanratarata,
                          chartdata: chartdata,
                          todaysale: todaysales,
                          monthlysales: monthlysales,
                          profileusaha: Outlet(
                            outletcd: outletinfo!.outletcd,
                            outletname: outletinfo!.outletname,
                            telp: outletinfo!.telp,
                            alamat: outletinfo!.alamat,
                            kodepos: outletinfo!.kodepos,
                          ),
                        );
                    }
                    return Container();
                  },
                ));
          }
        });
  }
}
