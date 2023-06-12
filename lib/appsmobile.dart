// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_field, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/chart.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/drawermainmenumobile.dart';
import 'package:posq/classui/drawermaintab.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/menu.dart';
import 'package:posq/classsummarytodaymobile.dart';
import 'package:posq/model.dart';
import 'package:posq/newchart.dart';
import 'package:posq/summarytab.dart';
import 'package:posq/userinfo.dart';

class AppsMobile extends StatefulWidget {
  final Outlet? profileusaha;
  final List todaysale;
  final List monthlysales;
  final List chartdata;
  const AppsMobile(
      {Key? key,
      this.profileusaha,
      required this.todaysale,
      required this.monthlysales,
      required this.chartdata})
      : super(key: key);

  @override
  State<AppsMobile> createState() => _AppsMobileState();

  static _AppsMobileState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppsMobileState>();
}

class _AppsMobileState extends State<AppsMobile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DatabaseHandler handler;
  bool? _loading;
  double? _progressValue;
  Outlet? outlet;
  String? outletdesc = '';
  String? pscd = '';

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    outlet = Outlet(
      outletcd: widget.profileusaha!.outletcd,
      outletname: widget.profileusaha!.outletname,
      telp: widget.profileusaha!.telp,
      alamat: widget.profileusaha!.alamat,
      kodepos: widget.profileusaha!.kodepos,
      trnonext: widget.profileusaha!.trnonext,
      trnopynext: widget.profileusaha!.trnopynext,
    );
    print(widget.profileusaha!.outletname);
    _loading = true;
    _progressValue = 0.0;
    _progressValue = 0.1;
    pscd = widget.profileusaha!.outletcd;
  }

  set string(Outlet? value) => setState(() => outlet = Outlet(
      outletcd: value!.outletcd.isEmpty
          ? widget.profileusaha!.outletcd
          : value.outletcd,
      outletname: value.outletname!.isEmpty
          ? widget.profileusaha!.outletname
          : value.outletname,
      telp: value.telp,
      alamat: value.alamat,
      kodepos: value.kodepos,
      trnonext: value.trnonext,
      trnopynext: value.trnopynext));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: constraints.maxWidth <= 480
              ? DrawerWidgetMain()
              : DrawerWidgetMainTab(),
          body: LayoutBuilder(builder: (
            context,
            BoxConstraints constraints,
          ) {
            if (constraints.maxWidth <= 480) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      // borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.circular(20),
                      //     bottomRight: Radius.circular(20)),
                    ),
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.013,
                          width: MediaQuery.of(context).size.width * 1,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              imageurl == ''
                                  ? CircleAvatar(
                                      radius: 30,
                                      // backgroundImage: AssetImage(
                                      //   'assets/sheryl.png',
                                      // ),
                                      child: Text(
                                        usercd.substring(0, 1),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(imageurl),
                                    ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        child: Text(
                                            outlet!.outletname.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        child: Text(usercd,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                ),
                                iconSize: 30,
                                color: Colors.white,
                                splashColor: Colors.purple,
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.width * 1,
                      child: MenuMain(
                          pscd: pscd.toString(),
                          callback: (val) => setState(() {
                                pscd = val.outletcd;
                              }),
                          outletinfo: widget.profileusaha)),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  //   width: MediaQuery.of(context).size.width * 0.02,
                  // ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Summarytoday(
                        monthlysales: widget.monthlysales,
                        todaysale: widget.todaysale,
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text('Ringkasan Chart',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.45,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          widget.todaysale.isNotEmpty
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Text(
                                    '${CurrencyFormat.convertToIdr(widget.todaysale.first['totalaftdisc'], 0)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                )
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Text('0')),
                          ButtonNoIcon(
                            height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.width*0.2,
                            color: Colors.transparent,
                            textcolor: Colors.orange,
                            name: '1 Minggu',
                            onpressed: () async {
                              // await showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return DialogClass1(
                              //         fromreopen: false,
                              //       );
                              //     });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 1,
                    child: LineChartSample1(widget.chartdata),
                  )
                ],
              );
            } else if (constraints.maxWidth >= 480) {
              return Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          // borderRadius: BorderRadius.only(
                          //     bottomLeft: Radius.circular(20),
                          //     bottomRight: Radius.circular(20)),
                        ),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.040,
                              width: MediaQuery.of(context).size.width * 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: const Text('?'),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Text(
                                              outlet!.outletname.toString(),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Text(usercd,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                  ),
                                  iconSize: 30,
                                  color: Colors.white,
                                  splashColor: Colors.purple,
                                  onPressed: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 1,
                          child: MenuMain(
                              pscd: pscd.toString(),
                              callback: (val) => setState(() {
                                    pscd = val.outletcd;
                                  }),
                              outletinfo: widget.profileusaha)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: SummaryTodayTabs(
                              monthlysales: widget.monthlysales,
                              todaysale: widget.todaysale,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Ringkasan Chart',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                      ),
                                      ButtonNoIcon(
                                        color: Colors.transparent,
                                        textcolor: Colors.blue,
                                        name: 'Choose Category',
                                        onpressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogClass1(
                                                  fromreopen: false,
                                                );
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.42,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: LineChartSample1(widget.chartdata)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ));
            }
            return Container();
          }),
        );
      }),
    );
  }
}
