// // ignore_for_file: prefer_const_constructors

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:posq/title.dart';

// class ChartRevenue extends StatefulWidget {
//   const ChartRevenue({Key? key}) : super(key: key);

//   @override
//   State<ChartRevenue> createState() => _ChartRevenueState();
// }

// class _ChartRevenueState extends State<ChartRevenue> {
//   final List<Color> gradientColors = [
//     Colors.blue,
//     Colors.blue,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         minX: 0,
//         maxX: 11,
//         minY: 0,
//         maxY: 6,
//         titlesData: LineTitles.getTitleData(),
//         gridData: FlGridData(
//           show: true,
//           getDrawingHorizontalLine: (value) {
//             return FlLine(
//               color: Colors.blue,
//               strokeWidth: 0.1,
//             );
//           },
//           drawVerticalLine: true,
//           getDrawingVerticalLine: (value) {
//             return FlLine(
//               color: Colors.blue,
//               strokeWidth: 0.1,
//             );
//           },
//         ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(color: Colors.blue, width: 0.1),
//         ),
//         lineBarsData: [
//           LineChartBarData(
//             spots: [
//               FlSpot(0, 3),
//               FlSpot(2.6, 2),
//               FlSpot(4.9, 5),
//               FlSpot(6.8, 2.5),
//               FlSpot(8, 4),
//               FlSpot(9.5, 3),
//               FlSpot(11, 5.5),
//             ],
//             isCurved: true,
//             colors: gradientColors,
//             barWidth: 1,
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(
//               show: true,
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.1))
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
