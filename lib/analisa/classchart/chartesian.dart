import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

class ChartesianSeries extends StatefulWidget {
  final List<ChartData> chartData;
  const ChartesianSeries({super.key, required this.chartData});

  @override
  State<ChartesianSeries> createState() => _ChartesianSeriesState();
}

class _ChartesianSeriesState extends State<ChartesianSeries> {
  //sample data //
  // final List<ChartData> chartData = <ChartData>[
  //   ChartData(x: 'Jan', yValue1: 45, yValue2: 1000),
  //   ChartData(x: 'Feb', yValue1: 100, yValue2: 3000),
  //   ChartData(x: 'March', yValue1: 25, yValue2: 1000),
  //   ChartData(x: 'April', yValue1: 100, yValue2: 7000),
  //   ChartData(x: 'May', yValue1: 85, yValue2: 5000),
  //   ChartData(x: 'June', yValue1: 140, yValue2: 7000)
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
          axes: <ChartAxis>[
            NumericAxis(
                numberFormat: NumberFormat.compact(),
                majorGridLines: const MajorGridLines(width: 0),
                opposedPosition: true,
                name: 'yAxis1',
                interval: 1000,
                minimum: 0,
                maximum: 10000)
          ],
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
                animationDuration: 2000,
                dataSource: widget.chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.yValue1,
                name: 'Unit Sold'),
            LineSeries<ChartData, String>(
                animationDuration: 4500,
                animationDelay: 2000,
                dataSource: widget.chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.yValue2,
                yAxisName: 'yAxis1',
                markerSettings: MarkerSettings(isVisible: true),
                name: 'Total Transaction')
          ]),
    );
  }
}
