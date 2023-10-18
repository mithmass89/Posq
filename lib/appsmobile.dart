// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_field, unnecessary_null_comparison, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/analisa/classchart/chartesian.dart';
import 'package:posq/analisa/classchart/chartguage.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Sales {
  Sales(this.x, this.y);
  final String x;
  final double y;
}

class ChartCtg {
  ChartCtg(this.x, this.y);
  final String x;
  final num y;
  @override
  String toString() {
    return '{"x": $x,"y":$y}';
  }
}

class ChartSampleData {
  ChartSampleData(this.x, this.y);
  final String x;
  final num y;

  @override
  String toString() {
    return '{"x": $x,"y":$y}';
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

class AppsMobile extends StatefulWidget {
  late Outlet? profileusaha;
  late List todaysale;
  late List monthlysales;
  late List chartdata;
  late List penjualanratarata;
  final Function? chartreload;
  final Function? getSales;
  AppsMobile(
      {Key? key,
      this.profileusaha,
      required this.todaysale,
      required this.monthlysales,
      required this.chartdata,
      required this.penjualanratarata,
      this.chartreload,
      this.getSales})
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
  DateTime currentTime = DateTime.now();
  String? time;
  String? date;
  String? date1;
  var wsUrl;
  List<_ChartData> datadonat = [];
  WebSocketChannel? channel;
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
  String selectedchart = '';
  // final AudioPlayer audioPlayer = AudioPlayer();
  num? totals = 0;
  num? endings = 0;
  List total = [];
  String? formatdate;
  var formatter = DateFormat('yyyy-MM-dd');
  var now = DateTime.now();
  num totalpengeluaran = 0;
  List<OpenCashier?> data = [OpenCashier(amount: 0, type: 'OPEN')];
  List<OpenCashier?> dataclose = [OpenCashier(amount: 0, type: 'CLOSE')];
  double pointer = 0;
  late TooltipBehavior _tooltip;
  var formatter2 = DateFormat('dd-MMM-yyyy');
  var formaterprd = DateFormat('yyyyMM');
  String? formattedDate;
  String? periode;
  String? fromdate;
  String? todate;
  String? today;
  String? fromdatebar;
  String? todatebar;
  String? formatdatebar;
  List<ChartData> chartdatas = [];
  List<ChartBarData> chartctg = [];
  List<Sales> summary = [];
  double cogspercent = 0;
  final supabase = Supabase.instance.client;

  getPreferences() async {
    SharedPreferences chart = await SharedPreferences.getInstance();
    selectedchart = await chart.getString('chart') ?? '';
  }

  setter() {
    setState(() {});
  }

  getDataCategory() async {
    await ClassApi.getDataChartCategory(fromdate!, todate!, dbname)
        .then((value) {
      if (value.isNotEmpty) {
        for (var z in value) {
          chartctg.add(ChartBarData(x: z['ctg'], y: z['totalamt']));
        }
        setState(() {});
        print('ini chartctg : $chartctg');
      }
    });
  }

  getDataGuage() async {
    await ClassApi.getReportRingkasan(fromdate!, todate!, dbname, '')
        .then((value) {
      if (value.isNotEmpty) {
        pointer = value.first.transno!.toDouble();
        setState(() {});
      }
    });
  }

  getDataDoughnuts() async {
    datadonat = [];
    await ClassApi.getDataChartDoughnut(fromdate!, todate!, dbname)
        .then((value) {
      for (var x in value) {
        datadonat.add(
            _ChartData(x['itemdesc'], double.parse(x['percent'].toString())));
      }
    });
    setState(() {});
  }

  getChartPenjualan() async {
    formatdatebar = formatter.format(now.add((Duration(days: -7))));
    fromdatebar = formatdatebar;
    todatebar = formatdate;
    chartdatas = [];
    await ClassApi.listdataFromtoChart(fromdatebar!, todate!, dbname)
        .then((value) {
      for (var x in value) {
        chartdatas.add(
          ChartData(x: x['trdt'], yValue1: x['amount'], yValue2: x['costamt']),
        );
      }
      print(chartdatas);
    });
    setState(() {});
  }

  getSummaryPenjualan() async {
    summary = [];
    await ClassApi.getReportRingkasan(fromdate!, todate!, dbname, '')
        .then((value) {
      if (value.isNotEmpty) {
        summary.add(
            Sales('Pendapatan Nett', value.first.revenuegross!.toDouble()));
        summary.add(Sales('Bahan Baku', value.first.totalcost!.toDouble()));
        summary.add(Sales('Pengluaran', value.first.pengeluaran!.toDouble()));
        summary
            .add(Sales('Pendapatan Gross', value.first.totalnett!.toDouble()));
        summary.add(Sales('Target Pendapatan', 0));
      }
      cogspercent = double.parse((((summary
                      .where((element) => element.x == 'Bahan Baku')
                      .toList()
                      .first
                      .y) /
                  (summary
                      .where((element) => element.x == 'Pendapatan Nett')
                      .toList()
                      .first
                      .y)) *
              100)
          .toStringAsFixed(2));
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    formatdate = formatter.format(now);
    // wsUrl = Uri.parse('wss://digims.online:8080?property=$dbname');
    // channel = WebSocketChannel.connect(wsUrl);
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    periode = formaterprd.format(now);
    formatdate = formatter.format(now);
    fromdate = formatdate;
    todate = formatdate;
    today = formatdate;
    _tooltip = TooltipBehavior(enable: true);
    getPreferences();
    getDataCategory();
    getDataGuage();
    getDataDoughnuts();
    getChartPenjualan();
    getSummaryPenjualan();
    supabase
        .from('finish_order')
        .stream(primaryKey: ['id'])
        .eq('prfcd', dbname)
        .order('transno')
        .limit(10)
        .listen((List<Map<String, dynamic>> data) async {
          if (selectedchart == 'Tren Pendapatan') {
            await getSelesToday();
          } else if (selectedchart == 'Pendapatan Category') {
            await getDataCategory();
          } else if (selectedchart == 'Statistik') {
            await getSummaryPenjualan();
          } else if (selectedchart == 'Guage') {
            await getDataGuage();
          } else if (selectedchart == 'Item terbanyak') {
            await getDataDoughnuts();
          } else if (selectedchart == 'Pendapatan & Bahan baku') {
            await getChartPenjualan();
          }
        });

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
    print(outletdesc);
    _loading = true;
    _progressValue = 0.0;
    _progressValue = 0.1;
    pscd = widget.profileusaha!.outletcd;
    // todayDate();
    // getSelesToday();
  }

  set string(Outlet? value) {
    // widget.getSales!();
    setState(() => outlet = Outlet(
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
    dbname = value!.outletcd;
    pscd = value.outletcd;
    outletdesc = value.outletname;
    widget.chartdata = [];
    widget.chartreload!();
    print(value);
  }

  todayDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    var formatter1 = new DateFormat('yyyy-MM-dd');
    time = DateFormat('kk:mm:a').format(now);
    date = formatter.format(now);
    date1 = formatter1.format(now);
    setState(() {});
  }

  getSelesToday() async {
    widget.chartdata = [];
    todayDate();
    widget.todaysale = await ClassApi.getTodaySales(date1!, dbname);
    widget.monthlysales = await ClassApi.monthlysales(date1!, dbname);
    widget.chartdata = await ClassApi.listdataChart(date1!, dbname);
    widget.penjualanratarata =
        await ClassApi.getPenjualanRataRata(date1!, dbname);
    print('oke refresh');
    setState(() {});
  }

  // void playSoundNotification() async {
  //   String audioasset = 'assets/notification_sound.mp3';
  //   ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
  //   Uint8List soundbytes =
  //       bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  //   int result = await audioPlayer.playBytes(soundbytes);

  //   if (result == 1) {
  //     // Success
  //     print("Sound notification played successfully!");
  //   } else {
  //     // Error
  //     print("Error playing sound notification.");
  //   }
  // }

  getDataDetail() async {
    total =
        await ClassApi.getDetail_transaksiCashier(formatdate!, usercd, dbname);
    if (total.isNotEmpty) {
      totals =
          total.fold(0.0, (sum, transaction) => sum! + transaction['lamount']);
    }
    await totalexpense();

    endings = data.isNotEmpty
        ? data[0]!.amount!
        : 0 + (total.isNotEmpty ? totals! : 0) - dataclose[0]!.amount!;
    closingending = endings!;

    setState(() {});
  }

  totalexpense() async {
    await ClassApi.totalpengeluaranCashier(formatdate!, usercd, dbname)
        .then((value) {
      if (value.isNotEmpty) {
        totalpengeluaran = value[0]['total'];
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    channel!.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return WillPopScope(
          onWillPop: () async {
            return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogClassWillPopExit();
                });
          },
          child: Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ChatScreen()),
            //     );
            //   },
            //   child: Image.asset(
            //     'assets/chat.png', // Replace with your image asset path
            //     width: MediaQuery.of(context).size.width *
            //         0.1, // Adjust the width as needed
            //     height: MediaQuery.of(context).size.height *
            //         0.1, // Adjust the height as needed
            //   ),
            // ),
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            drawer: constraints.maxWidth <= 800
                ? DrawerWidgetMain(
                    endings: endings,
                    today: formatdate,
                  )
                : DrawerWidgetMainTab(),
            body: SingleChildScrollView(
              child: LayoutBuilder(builder: (
                context,
                BoxConstraints constraints,
              ) {
                if (constraints.maxWidth <= 800) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                        ),
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.014,
                              width: MediaQuery.of(context).size.width * 1,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  imageurl == ''
                                      ? CircleAvatar(
                                          radius: 30,
                                          child: Text(
                                            usercd.substring(0, 1),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              NetworkImage(imageurl),
                                        ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
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
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                            child:
                                                Text(usercd + ' ' + statusabsen,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    )),
                                          ),
                                
                                        ],
                                      )),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height *
                                  //       0.05,
                                  //   width: MediaQuery.of(context).size.width *
                                  //       0.05,
                                  // ),
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
                              setter: setter,
                              pscd: pscd.toString(),
                              callback: (val) => setState(() {
                                    pscd = val.outletcd;
                                  }),
                              outletinfo: widget.profileusaha)),
               
                      Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Summarytoday(
                            rataratapenjualan: widget.penjualanratarata,
                            monthlysales: widget.monthlysales,
                            todaysale: widget.todaysale,
                          )),

                      Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              widget.todaysale.isNotEmpty
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Builder(builder: (context) {
                                        switch (selectedchart) {
                                          case 'Pendapatan Category':
                                            return Text(
                                              'Analisa Categori',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            );
                                          case 'Pendapatan':
                                            return SizedBox(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Hari ini  ${CurrencyFormat.convertToIdr(widget.todaysale.first['totalaftdisc'], 0)}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Text('Angka di jutaan')
                                                ],
                                              ),
                                            );
                                          case 'Guage':
                                            return Text(
                                              "Transaksi : $pointer",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            );

                                          case 'Item terbanyak':
                                            return Text(
                                              "Index menggunakan Persentase",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            );
                                          case 'Pendapatan & Bahan baku':
                                            return Text(
                                              "Perbandingan Pendapatan & COGS ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            );
                                          default:
                                            print('It\'s something else.');
                                        }
                                        return Text(
                                          'Hari ini ${CurrencyFormat.convertToIdr(widget.todaysale.first['totalaftdisc'], 0)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        );
                                      }),
                                    )
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.70,
                                      child: Text('0')),
                              ButtonNoIcon(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.23,
                                color: Colors.transparent,
                                textcolor: AppColors.primaryColor,
                                name: 'Ganti Chart',
                                onpressed: () async {
                                  selectedchart = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogClass1();
                                      });
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Builder(builder: (context) {
                          switch (selectedchart) {
                            case 'Tren Pendapatan':
                              return LineChartSample1(widget.chartdata);
                            case 'Pendapatan Category':
                              return SfCartesianChart(
                                  enableAxisAnimation: true,
                                  isTransposed: true,
                                  axes: <ChartAxis>[
                                    NumericAxis(
                                        numberFormat: NumberFormat.compact(),
                                        majorGridLines:
                                            const MajorGridLines(width: 0),
                                        opposedPosition: true,
                                        name: 'yAxis1',
                                        interval: 1000,
                                        minimum: 0,
                                        maximum: 7000)
                                  ],
                                  // legend: Legend(
                                  //     position: LegendPosition.bottom,
                                  //     isVisible: true,
                                  //     borderColor: Colors.black,
                                  //     borderWidth: 2),
                                  primaryXAxis: CategoryAxis(),
                                  series: <ChartSeries<ChartBarData, String>>[
                                    ColumnSeries<ChartBarData, String>(
                                        animationDuration: 1000,
                                        dataSource: chartctg,
                                        xValueMapper: (ChartBarData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartBarData data, _) =>
                                            data.y,
                                        name: 'Penjualan'),
                                  ]);
                            case 'Statistik':
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: ListView.builder(
                                      // controller: _controller,
                                      itemCount: summary.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: summary[index].x !=
                                                  'Bahan Baku'
                                              ? Text(summary[index].x)
                                              : Text(
                                                  "${summary[index].x} ($cogspercent %)  dari nett"),
                                          trailing: Text(
                                              CurrencyFormat.convertToIdr(
                                                  summary[index].y, 0)),
                                        );
                                      }));
                            case 'Guage':
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Guage(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    valuemax: 50,
                                    pointer: pointer,
                                    startpoint: 0,
                                    notgood: 20,
                                    comfort: 35,
                                    goodbisnis: 50,
                                    starpointnotgood: 0,
                                    starpointnotcomfort: 15,
                                    starpointgoodbisnis: 35,
                                  ));

                            case 'Item terbanyak':
                              return SfCircularChart(
                                  legend: Legend(
                                      overflowMode: LegendItemOverflowMode.wrap,
                                      isVisible: true,
                                      borderColor: Colors.black,
                                      borderWidth: 0),
                                  tooltipBehavior: _tooltip,
                                  series: [
                                    DoughnutSeries<_ChartData, String>(
                                        explodeAll: true,
                                        dataLabelSettings: DataLabelSettings(
                                            // Renders the data label
                                            isVisible: true),
                                        dataSource: datadonat,
                                        xValueMapper: (_ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (_ChartData data, _) =>
                                            data.y,
                                        name: 'Produk')
                                  ]);
                            case 'Pendapatan & Bahan baku':
                              return SfCartesianChart(
                                  legend: Legend(
                                      position: LegendPosition.bottom,
                                      isVisible: true,
                                      borderColor: Colors.black,
                                      borderWidth: 2),
                                  primaryXAxis: CategoryAxis(),
                                  series: <ChartSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                        animationDuration: 1000,
                                        dataSource: chartdatas,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.yValue1,
                                        name: 'Penjualan'),
                                    LineSeries<ChartData, String>(
                                        animationDuration: 2000,
                                        animationDelay: 1000,
                                        dataSource: chartdatas,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.yValue2,
                                        yAxisName: 'yAxis1',
                                        markerSettings:
                                            MarkerSettings(isVisible: true),
                                        name: 'Bahan baku')
                                  ]);
                            default:
                              return LineChartSample1(widget.chartdata);
                          }
                        }),
                      )
                    ],
                  );
                } else if (constraints.maxWidth >= 800) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 1,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              // borderRadius: BorderRadius.only(
                              //     bottomLeft: Radius.circular(20),
                              //     bottomRight: Radius.circular(20)),
                            ),
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width * 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.038,
                                  width: MediaQuery.of(context).size.width * 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    imageurl == ''
                                        ? CircleAvatar(
                                            radius: 20,
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
                                            radius: 20,
                                            backgroundImage:
                                                NetworkImage(imageurl),
                                          ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Text(statusabsen,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
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
                                  setter: setter,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: SummaryTodayTabs(
                                  penjualanratarata: widget.penjualanratarata,
                                  monthlysales: widget.monthlysales,
                                  todaysale: widget.todaysale,
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text('Ringkasan Chart',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
                                          ),
                                          ButtonNoIcon(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
                                            color: Colors.transparent,
                                            textcolor: AppColors.primaryColor,
                                            name: 'Pilih Chart',
                                            onpressed: () async {
                                              selectedchart = await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return DialogClass1();
                                                  });
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.42,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Builder(builder: (context) {
                                        switch (selectedchart) {
                                          case 'Tren Pendapatan':
                                            return LineChartSample1(
                                                widget.chartdata);
                                          case 'Pendapatan Category':
                                            return SfCartesianChart(
                                                enableAxisAnimation: true,
                                                isTransposed: true,
                                                axes: <ChartAxis>[
                                                  NumericAxis(
                                                      numberFormat: NumberFormat
                                                          .compact(),
                                                      majorGridLines:
                                                          const MajorGridLines(
                                                              width: 0),
                                                      opposedPosition: true,
                                                      name: 'yAxis1',
                                                      interval: 1000,
                                                      minimum: 0,
                                                      maximum: 7000)
                                                ],
                                                // legend: Legend(
                                                //     position: LegendPosition.bottom,
                                                //     isVisible: true,
                                                //     borderColor: Colors.black,
                                                //     borderWidth: 2),
                                                primaryXAxis: CategoryAxis(),
                                                series: <ChartSeries<
                                                    ChartBarData, String>>[
                                                  ColumnSeries<ChartBarData,
                                                          String>(
                                                      animationDuration: 1000,
                                                      dataSource: chartctg,
                                                      xValueMapper:
                                                          (ChartBarData data,
                                                                  _) =>
                                                              data.x,
                                                      yValueMapper:
                                                          (ChartBarData data,
                                                                  _) =>
                                                              data.y,
                                                      name: 'Penjualan'),
                                                ]);
                                          case 'Statistik':
                                            return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.35,
                                                child: ListView.builder(
                                                    // controller: _controller,
                                                    itemCount: summary.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        dense: true,
                                                        title: summary[index]
                                                                    .x !=
                                                                'Bahan Baku'
                                                            ? Text(
                                                                summary[index]
                                                                    .x)
                                                            : Text(
                                                                "${summary[index].x} ($cogspercent %)  dari nett"),
                                                        trailing: Text(
                                                            CurrencyFormat
                                                                .convertToIdr(
                                                                    summary[index]
                                                                        .y,
                                                                    0)),
                                                      );
                                                    }));
                                          case 'Guage':
                                            return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                child: Guage(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  valuemax: 50,
                                                  pointer: pointer,
                                                  startpoint: 0,
                                                  notgood: 20,
                                                  comfort: 35,
                                                  goodbisnis: 50,
                                                  starpointnotgood: 0,
                                                  starpointnotcomfort: 15,
                                                  starpointgoodbisnis: 35,
                                                ));

                                          case 'Item terbanyak':
                                            return SfCircularChart(
                                                legend: Legend(
                                                    overflowMode:
                                                        LegendItemOverflowMode
                                                            .wrap,
                                                    isVisible: true,
                                                    borderColor: Colors.black,
                                                    borderWidth: 0),
                                                tooltipBehavior: _tooltip,
                                                series: [
                                                  DoughnutSeries<_ChartData,
                                                          String>(
                                                      explodeAll: true,
                                                      dataLabelSettings:
                                                          DataLabelSettings(
                                                              // Renders the data label
                                                              isVisible: true),
                                                      dataSource: datadonat,
                                                      xValueMapper:
                                                          (_ChartData data,
                                                                  _) =>
                                                              data.x,
                                                      yValueMapper:
                                                          (_ChartData data,
                                                                  _) =>
                                                              data.y,
                                                      name: 'Produk')
                                                ]);
                                          case 'Pendapatan & Bahan baku':
                                            return SfCartesianChart(
                                                legend: Legend(
                                                    position:
                                                        LegendPosition.bottom,
                                                    isVisible: true,
                                                    borderColor: Colors.black,
                                                    borderWidth: 2),
                                                primaryXAxis: CategoryAxis(),
                                                series: <ChartSeries<ChartData,
                                                    String>>[
                                                  ColumnSeries<ChartData,
                                                          String>(
                                                      animationDuration: 1000,
                                                      dataSource: chartdatas,
                                                      xValueMapper:
                                                          (ChartData data, _) =>
                                                              data.x,
                                                      yValueMapper:
                                                          (ChartData data, _) =>
                                                              data.yValue1,
                                                      name: 'Penjualan'),
                                                  LineSeries<ChartData, String>(
                                                      animationDuration: 2000,
                                                      animationDelay: 1000,
                                                      dataSource: chartdatas,
                                                      xValueMapper:
                                                          (ChartData data, _) =>
                                                              data.x,
                                                      yValueMapper:
                                                          (ChartData data, _) =>
                                                              data.yValue2,
                                                      yAxisName: 'yAxis1',
                                                      markerSettings:
                                                          MarkerSettings(
                                                              isVisible: true),
                                                      name: 'Bahan baku')
                                                ]);
                                          default:
                                            return LineChartSample1(
                                                widget.chartdata);
                                        }
                                      })),
                                ],
                              )
                            ],
                          ),
                        ],
                      ));
                }
                return Container();
              }),
            ),
          ),
        );
      }),
    );
  }
}
