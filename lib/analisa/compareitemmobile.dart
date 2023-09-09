// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:posq/analisa/dropdownclass.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}

class CompareItemMobile extends StatefulWidget {
  const CompareItemMobile({super.key});

  @override
  State<CompareItemMobile> createState() => _CompareItemMobileState();
}

class _CompareItemMobileState extends State<CompareItemMobile> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  List<num> datax = [1, 2, 3, 4, 5, 6];
  List<num> datay = [3, 4, 3, 5, 6, 9];
  final List<SalesData> chartData = [
    SalesData(DateTime(2019), 35),
    SalesData(DateTime(2020), 28),
    SalesData(DateTime(2021), 34),
    SalesData(DateTime(2022), 32),
    SalesData(DateTime(2023), 40)
  ];

  final List<SalesData> chartData1 = [
    SalesData(DateTime(2019), 40),
    SalesData(DateTime(2020), 43),
    SalesData(DateTime(2021), 50),
    SalesData(DateTime(2022), 100),
    SalesData(DateTime(2023), 80)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trend item',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
               height: MediaQuery.of(context).size.height * 0.3,
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3))),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 1,
              child: Text(
                'Analisa Trend Produk',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: DropDownItem(
                      data: [
                        'Pilih Item',
                        'Es Teh',
                        'Es Kelapa Muda',
                        'Cappucino',
                        'Latte'
                      ],
                      defaultvalue: 'Pilih Item',
                      selectedvalue: 'Pilih Item',
                    )),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: DropDownItem(
                      data: [
                        'Pilih Item',
                        'Es Teh',
                        'Es Kelapa Muda',
                        'Cappucino',
                        'Latte'
                      ],
                      defaultvalue: 'Pilih Item',
                      selectedvalue: 'Pilih Item',
                    )),
              ],
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 1,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    //Initialize the spark charts widget
                    child: SfCartesianChart(
                        legend: Legend(
                            overflowMode: LegendItemOverflowMode.wrap,
                            toggleSeriesVisibility: true,
                            legendItemBuilder: (String name, dynamic series,
                                dynamic point, int index) {
                              List<String> items = ['Es Teh', 'Es Kelapa muda'];
                              return Container(
                                  // height: MediaQuery.of(context).size.height*0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: ListTile(title: Text(items[index])));
                            },
                            title: LegendTitle(text: 'Produk'),
                            position: LegendPosition.bottom,
                            isVisible: true),
                        primaryXAxis: DateTimeAxis(),
                        series: <ChartSeries>[
                          // Renders line chart
                          LineSeries<SalesData, DateTime>(
                              isVisibleInLegend: true,
                              dataSource: chartData,
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) =>
                                  sales.sales),
                          LineSeries<SalesData, DateTime>(
                              isVisibleInLegend: true,
                              dataSource: chartData1,
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) => sales.sales)
                        ])))
          ],
        ),
      ),
    );
  }
}
