import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

class ChartDoughnut extends StatefulWidget {
  final List<_ChartData> data;
  const ChartDoughnut({super.key, required this.data});

  @override
  State<ChartDoughnut> createState() => _ChartDoughnutState();
}

class _ChartDoughnutState extends State<ChartDoughnut> {
  TooltipBehavior _tooltip = TooltipBehavior(enable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCircularChart(
          legend: Legend(
              isVisible: true, borderColor: Colors.black, borderWidth: 2),
          tooltipBehavior: _tooltip,
          series: [
            DoughnutSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                    // Renders the data label
                    isVisible: true),
                dataSource: widget.data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'Produk')
          ]),
    );
  }
}
