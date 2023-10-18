// ignore_for_file: unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/analisa/classchart/chartguage.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/userinfo.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartSampleData {
  _ChartSampleData(this.x, this.y, this.secondSeriesYValue);
  final String x;
  final double? y;
  final double? secondSeriesYValue;
}

class ChartData {
  ChartData({this.x, this.yValue1, this.yValue2});
  final String? x;
  final num? yValue1;
  final num? yValue2;
  @override
  String toString() {
    return '{"x": $x,"yValue1":$yValue1,"yValue2": $yValue2}';
  }
}

class ChartData1 {
  ChartData1(this.y);
  final double y;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class Sales {
  Sales(this.x, this.y);
  final String x;
  final double y;
}

class CustomerHabits {
  CustomerHabits(this.x, this.y);
  final String x;
  final dynamic y;
}

class IndexBisnisMobile extends StatefulWidget {
  const IndexBisnisMobile({super.key});

  @override
  State<IndexBisnisMobile> createState() => _IndexBisnisMobileState();
}

class _IndexBisnisMobileState extends State<IndexBisnisMobile> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formatter2 = DateFormat('dd-MMM-yyyy');
  var formaterprd = DateFormat('yyyyMM');
  String? formattedDate;
  String? formatdate;
  String? formatdatebar;
  String? periode;
  String? fromdate;
  String? todate;
  String? fromdatebar;
  String? todatebar;
  String? today;
  String selectedgauge = '';
  String selectedsummary = '';
  String selecteditem = '';
  String barchart = '';
  ScrollController _controller = ScrollController();
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  double pointer = 0;
  double cogspercent = 0;
  List<ChartData> chartdata = [];
  int totaldateonmonth = 0;

  List<Sales> summary = [];

  List<CustomerHabits> habits = [
    CustomerHabits('Hari Dengan Penjualan Terbanyak', 'Sabtu'),
    CustomerHabits('Hari Dengan Penjualan Paling Sedikit', 'Selasa'),
    CustomerHabits('Waktu Dengan Penjualan Terbanyak', '19:02'),
    CustomerHabits('Rata-Rata pendapatan Setiap Pelanggan', 30000),
  ];
  final List<ChartData> chartData = <ChartData>[
    // ChartData(x: 'Jan', yValue1: 1.5, yValue2: 0.6),
    // ChartData(x: 'Feb', yValue1: 2, yValue2: 0.6),
    // ChartData(x: 'March', yValue1: 2.5, yValue2: 0.75),
    // ChartData(x: 'April', yValue1: 2, yValue2: 0.6),
  ];

  int getDaysInMonth(int year, int month) {
    final date = DateTime(year, month + 1, 0);
    totaldateonmonth = date.day;
    return date.day;
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

  getChartPenjualan() async {
    chartdata = [];
    await ClassApi.listdataFromtoChart(fromdatebar!, todate!, dbname)
        .then((value) {
      for (var x in value) {
        chartdata.add(
          ChartData(x: x['trdt'], yValue1: x['amount'], yValue2: x['costamt']),
        );
      }
      print(chartdata);
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

  getDataDoughnuts() async {
    data = [];
    await ClassApi.getDataChartDoughnut(fromdate!, todate!, dbname)
        .then((value) {
      for (var x in value) {
        data.add(
            _ChartData(x['itemdesc'], double.parse(x['percent'].toString())));
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    selectedgauge = 'Hari ini';
    selectedsummary = 'Hari ini';
    selecteditem = 'Hari ini';
    barchart = 'Minggu ini';
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    periode = formaterprd.format(now);
    formatdate = formatter.format(now);
    formatdatebar = formatter.format(now.add((Duration(days: -7))));
    fromdate = formatdate;
    todate = formatdate;
    fromdatebar = formatdatebar;
    todatebar = formatdate;
    today = formatdate;
    getDataGuage();
    getSummaryPenjualan();
    getDataDoughnuts();
    getChartPenjualan();
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final daysInMonth = getDaysInMonth(year, month);
    print('Jumlah hari dalam bulan ini adalah $daysInMonth');
    data = [];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Performa bisnis',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 800) {
          return Container(
              padding: EdgeInsets.all(10),
              child: ListView(controller: _controller, children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Performa bisnis anda hari ini',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Total transaksi bisnis anda',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedgauge == 'Hari ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          selectedgauge = 'Hari ini';
                          formatdate = formatter.format(now);
                          fromdate = formatdate;
                          todate = formatdate;
                          await getDataGuage();
                        },
                        child: Text(
                          'Hari ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedgauge == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          selectedgauge = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month =
                              formatter.format(now.add((Duration(days: -30))));
                          fromdate = month;
                          todate = formatdate;

                          await getDataGuage();
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedgauge == '1 Tahun'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          selectedgauge = '1 Tahun';
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;

                          await getDataGuage();
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Guage(
                    height: MediaQuery.of(context).size.height * 0.3,
                    valuemax: 200,
                    pointer: pointer,
                    startpoint: 0,
                    notgood: 60,
                    comfort: 60,
                    goodbisnis: 150,
                    starpointnotgood: 0,
                    starpointnotcomfort: 150,
                    starpointgoodbisnis: 200,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Summary Penjualan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedsummary == 'Hari ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          selectedsummary = 'Hari ini';

                          formatdate = formatter.format(now);
                          fromdate = formatdate;
                          todate = formatdate;
                          await getSummaryPenjualan();
                          setState(() {});
                        },
                        child: Text(
                          'Hari ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedsummary == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          selectedsummary = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month =
                              formatter.format(now.add((Duration(days: -30))));
                          fromdate = month;
                          todate = formatdate;
                          await getSummaryPenjualan();
                          setState(() {});
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedsummary == 'Tahun ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;
                          selectedsummary = 'Tahun ini';
                          await getSummaryPenjualan();
                          setState(() {});
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: summary.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            title: summary[index].x != 'Bahan Baku'
                                ? Text(summary[index].x)
                                : Text("${summary[index].x} ($cogspercent %) "),
                            trailing: Text(CurrencyFormat.convertToIdr(
                                summary[index].y, 0)),
                          );
                        })),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Penjualan item terbanyak',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Index item dengan persentasi',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selecteditem == 'Hari ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          selecteditem = 'Hari ini';
                          formatdate = formatter.format(now);
                          fromdate = formatdate;
                          todate = formatdate;
                          await getDataDoughnuts();
                        },
                        child: Text(
                          'Hari ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selecteditem == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          selecteditem = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month =
                              formatter.format(now.add((Duration(days: -30))));
                          fromdate = month;
                          todate = formatdate;

                          await getDataDoughnuts();
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selecteditem == '1 Tahun'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          selecteditem = '1 Tahun';
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;

                          await getDataDoughnuts();
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                data.isNotEmpty
                    ? SfCircularChart(
                        legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 2),
                        tooltipBehavior: _tooltip,
                        series: [
                            DoughnutSeries<_ChartData, String>(
                                explodeAll: true,
                                dataLabelSettings: DataLabelSettings(
                                    // Renders the data label

                                    isVisible: true),
                                dataSource: data,
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y,
                                name: 'Produk')
                          ])
                    : Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Center(child: Text('No data Available'))),
                      ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Penjualan dengan Harga dasar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Angka di hitung dengan skala jutaan',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: barchart == 'Minggu ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var minggu;
                          barchart = 'Minggu ini';
                          formatdate = formatter.format(now);
                          minggu =
                              formatter.format(now.add((Duration(days: -7))));
                          fromdate = formatdate;
                          todate = formatdate;
                          await getChartPenjualan();
                        },
                        child: Text(
                          'Minggu ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: barchart == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          barchart = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month = formatter.format(
                              now.add((Duration(days: -totaldateonmonth))));
                          fromdate = month;
                          todate = formatdate;

                          await getChartPenjualan();
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: barchart == '1 Tahun'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          barchart = '1 Tahun';
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;

                          await getChartPenjualan();
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                SfCartesianChart(
                    legend: Legend(
                        position: LegendPosition.bottom,
                        isVisible: true,
                        borderColor: Colors.black,
                        borderWidth: 2),
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries<ChartData, String>>[
                      ColumnSeries<ChartData, String>(
                          animationDuration: 1000,
                          dataSource: chartdata,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.yValue1,
                          name: 'Penjualan'),
                      LineSeries<ChartData, String>(
                          animationDuration: 2000,
                          animationDelay: 1000,
                          dataSource: chartdata,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.yValue2,
                          yAxisName: 'yAxis1',
                          markerSettings: MarkerSettings(isVisible: true),
                          name: 'Bahan baku')
                    ])
              ]));
        } else if (constraints.maxWidth >= 800) {
          return Container(
              padding: EdgeInsets.all(10),
              child: ListView(controller: _controller, children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Performa bisnis anda hari ini',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedgauge == 'Hari ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          selectedgauge = 'Hari ini';
                          formatdate = formatter.format(now);
                          fromdate = formatdate;
                          todate = formatdate;
                          await getDataGuage();
                        },
                        child: Text(
                          'Hari ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedgauge == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          selectedgauge = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month =
                              formatter.format(now.add((Duration(days: -30))));
                          fromdate = month;
                          todate = formatdate;

                          await getDataGuage();
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedgauge == '1 Tahun'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          selectedgauge = '1 Tahun';
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;

                          await getDataGuage();
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Guage(
                    height: MediaQuery.of(context).size.height * 0.3,
                    valuemax: 200,
                    pointer: pointer,
                    startpoint: 0,
                    notgood: 60,
                    comfort: 60,
                    goodbisnis: 150,
                    starpointnotgood: 0,
                    starpointnotcomfort: 150,
                    starpointgoodbisnis: 200,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Summary Penjualan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedsummary == 'Hari ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          selectedsummary = 'Hari ini';

                          formatdate = formatter.format(now);
                          fromdate = formatdate;
                          todate = formatdate;
                          await getSummaryPenjualan();
                          setState(() {});
                        },
                        child: Text(
                          'Hari ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedsummary == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          selectedsummary = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month =
                              formatter.format(now.add((Duration(days: -30))));
                          fromdate = month;
                          todate = formatdate;
                          await getSummaryPenjualan();
                          setState(() {});
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedsummary == 'Tahun ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;
                          selectedsummary = 'Tahun ini';
                          await getSummaryPenjualan();
                          setState(() {});
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: summary.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            title: summary[index].x != 'Bahan Baku'
                                ? Text(summary[index].x)
                                : Text("${summary[index].x} ($cogspercent %) "),
                            trailing: Text(CurrencyFormat.convertToIdr(
                                summary[index].y, 0)),
                          );
                        })),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Penjualan item terbanyak',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Index item dengan persentasi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selecteditem == 'Hari ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          selecteditem = 'Hari ini';
                          formatdate = formatter.format(now);
                          fromdate = formatdate;
                          todate = formatdate;
                          await getDataDoughnuts();
                        },
                        child: Text(
                          'Hari ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selecteditem == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          selecteditem = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month =
                              formatter.format(now.add((Duration(days: -30))));
                          fromdate = month;
                          todate = formatdate;

                          await getDataDoughnuts();
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selecteditem == '1 Tahun'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          selecteditem = '1 Tahun';
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;

                          await getDataDoughnuts();
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                data.isNotEmpty
                    ? SfCircularChart(
                        legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 2),
                        tooltipBehavior: _tooltip,
                        series: [
                            DoughnutSeries<_ChartData, String>(
                                explodeAll: true,
                                dataLabelSettings: DataLabelSettings(
                                    // Renders the data label

                                    isVisible: true),
                                dataSource: data,
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y,
                                name: 'Produk')
                          ])
                    : Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Center(child: Text('No data Available'))),
                      ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Penjualan dengan Harga dasar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Text(
                    'Angka di hitung dengan skala jutaan',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: barchart == 'Minggu ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var minggu;
                          barchart = 'Minggu ini';
                          formatdate = formatter.format(now);
                          minggu =
                              formatter.format(now.add((Duration(days: -7))));
                          fromdate = formatdate;
                          todate = formatdate;
                          await getChartPenjualan();
                        },
                        child: Text(
                          'Minggu ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: barchart == 'Bulan ini'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var month;
                          barchart = 'Bulan ini';
                          formatdate = formatter.format(now);
                          month = formatter.format(
                              now.add((Duration(days: -totaldateonmonth))));
                          fromdate = month;
                          todate = formatdate;

                          await getChartPenjualan();
                        },
                        child: Text(
                          'Bulan ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: barchart == '1 Tahun'
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          var year;
                          barchart = '1 Tahun';
                          formatdate = formatter.format(now);
                          year =
                              formatter.format(now.add((Duration(days: -360))));
                          fromdate = year;
                          todate = formatdate;

                          await getChartPenjualan();
                        },
                        child: Text(
                          'Tahun ini',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                SfCartesianChart(
                    legend: Legend(
                        position: LegendPosition.bottom,
                        isVisible: true,
                        borderColor: Colors.black,
                        borderWidth: 2),
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries<ChartData, String>>[
                      ColumnSeries<ChartData, String>(
                          animationDuration: 1000,
                          dataSource: chartdata,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.yValue1,
                          name: 'Penjualan'),
                      LineSeries<ChartData, String>(
                          animationDuration: 2000,
                          animationDelay: 1000,
                          dataSource: chartdata,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.yValue2,
                          yAxisName: 'yAxis1',
                          markerSettings: MarkerSettings(isVisible: true),
                          name: 'Bahan baku')
                    ])
              ]));
        }
        return Container();
      }),
    );
  }
}
