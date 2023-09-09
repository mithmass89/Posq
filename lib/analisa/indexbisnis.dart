import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/classformat.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class _ChartSampleData {
  _ChartSampleData(this.x, this.y, this.secondSeriesYValue);
  final String x;
  final double? y;
  final double? secondSeriesYValue;
}

class ChartData {
  ChartData({this.x, this.yValue1, this.yValue2});
  final String? x;
  final double? yValue1;
  final double? yValue2;
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
  ScrollController _controller = ScrollController();
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  List<Sales> summary = [
    Sales('Pendapatan Gross', 800000),
    Sales('COGS', 240000),
    Sales('Pengluaran', 100000),
    Sales('Pendapatan Nett', 460000),
    Sales('Target Pendapatan', 750000),
  ];

  List<CustomerHabits> habits = [
    CustomerHabits('Hari Dengan Penjualan Terbanyak', 'Sabtu'),
    CustomerHabits('Hari Dengan Penjualan Paling Sedikit', 'Selasa'),
    CustomerHabits('Waktu Dengan Penjualan Terbanyak', '19:02'),
    CustomerHabits('Rata-Rata pendapatan Setiap Pelanggan', 30000),
  ];
  final List<ChartData> chartData = <ChartData>[
    ChartData(x: 'Jan', yValue1: 1.5, yValue2: 0.6),
    ChartData(x: 'Feb', yValue1: 2, yValue2: 0.6),
    ChartData(x: 'March', yValue1: 2.5, yValue2: 0.75),
    ChartData(x: 'April', yValue1: 2, yValue2: 0.6),
    ChartData(x: 'May', yValue1: 3, yValue2: 0.9),
    ChartData(x: 'June', yValue1: 3.5, yValue2: 1.05)
  ];

  @override
  void initState() {
    data = [
      _ChartData('Es Degan Muda', 80),
      _ChartData('Es Teh', 38),
      _ChartData('Cappucino', 34),
      _ChartData('Latte', 52)
    ];
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
      body: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Hari ini',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                ElevatedButton(onPressed: () {}, child: Text('Bulan ini')),
                ElevatedButton(onPressed: () {}, child: Text('Tahun ini'))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SfRadialGauge(
                    enableLoadingAnimation: true,
                    axes: <RadialAxis>[
                      RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0, endValue: 50, color: Colors.red),
                        GaugeRange(
                            startValue: 50,
                            endValue: 100,
                            color: Colors.orange),
                        GaugeRange(
                            startValue: 100, endValue: 150, color: Colors.green)
                      ], pointers: <GaugePointer>[
                        NeedlePointer(value: 100)
                      ], annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Text('100 Transaksi',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))),
                            angle: 90,
                            positionFactor: 0.5)
                      ])
                    ])),
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
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Hari ini',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                ElevatedButton(onPressed: () {}, child: Text('Bulan ini')),
                ElevatedButton(onPressed: () {}, child: Text('Tahun ini'))
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
                        title: Text(summary[index].x),
                        trailing: Text(
                            CurrencyFormat.convertToIdr(summary[index].y, 0)),
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
            SfCircularChart(
                legend: Legend(
                    isVisible: true, borderColor: Colors.black, borderWidth: 2),
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
                ]),
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
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SfCartesianChart(
                legend: Legend(
                    position: LegendPosition.bottom,
                    isVisible: true,
                    borderColor: Colors.black,
                    borderWidth: 2),
                // axes: <ChartAxis>[
                //   NumericAxis(
                //       numberFormat: NumberFormat.compact(),
                //       majorGridLines: const MajorGridLines(width: 0),
                //       opposedPosition: true,
                //       name: 'yAxis1',
                //       interval: 0.1,
                //       minimum: 0,
                //       maximum: 1000)
                // ],
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                      animationDuration: 1000,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.yValue1,
                      name: ':Pendapatan'),
                  LineSeries<ChartData, String>(
                      animationDuration: 2000,
                      animationDelay: 1000,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.yValue2,
                      yAxisName: 'yAxis1',
                      markerSettings: MarkerSettings(isVisible: true),
                      name: 'Cogs')
                ])
          ])),
    );
  }
}
