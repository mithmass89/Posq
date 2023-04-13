import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartSample1 extends StatefulWidget {
  LineChartSample1(this.chartdata);
  final List chartdata;

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  int lastindex = 0;
  List<SalesData> chartData = [
    // SalesData(DateTime.parse('2023-04-01'), 35),
    // SalesData(DateTime.parse('2023-04-02'), 28),
    // SalesData(DateTime.parse('2023-04-03'), 34),
    // SalesData(DateTime.parse('2023-04-04'), 32),
    // SalesData(DateTime.parse('2023-04-05'), 40)
  ];

  @override
  void initState() {
    super.initState();
    isShowingMainData = false;
    
  }

  @override
  Widget build(BuildContext context) {
    List.generate(
        widget.chartdata.length,
        (index) => chartData.add(SalesData(
            DateTime.parse(widget.chartdata[index]['trdt']),
            widget.chartdata[index]['totalaftdisc'])));
    return Center(
        child: AspectRatio(
      aspectRatio: 1.5,
      child:
          SfCartesianChart(primaryXAxis: DateTimeAxis(), series: <ChartSeries>[
        // Renders line chart
        LineSeries<SalesData, DateTime>(
            width: 3,
            dataSource: chartData,
            xValueMapper: (SalesData sales, _) => sales.date,
            yValueMapper: (SalesData sales, _) => sales.sales)
      ]),
    ));
  }
}

class SalesData {
  SalesData(this.date, this.sales);
  final DateTime date;
  final num sales;
}
