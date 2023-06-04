import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/classcahsiersummarydetail.dart';
import 'package:posq/reporting/classcalculateringkasan.dart';
import 'package:posq/reporting/classsummaryreport.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

enum RevenueTrend { Increase, Decrease, NoChange }

class ClassRingkasantab extends StatefulWidget {
  late String fromdate;
  late String todate;
  final MyBuilder builder;
  final List<IafjrndtClass> topMenu;
  final List<IafjrndtClass> menukuranglaku;

  final List<IafjrndtClass> datasales;

  ClassRingkasantab({
    Key? key,
    required this.fromdate,
    required this.todate,
    required this.builder,
    required this.datasales,
    required this.topMenu,
    required this.menukuranglaku,
  }) : super(key: key);

  @override
  State<ClassRingkasantab> createState() => _ClassRingkasanState();
}

class _ClassRingkasanState extends State<ClassRingkasantab> {
  void initState() {
    super.initState();
    ToastContext().init(context);
  }

  void ringkasan() {
    setState(() {
      print(widget.fromdate);
      print(widget.todate);
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, ringkasan);
    BusinessAnalysis analysis =
        BusinessAnalysis(salesDataList: widget.datasales);
    double averageSales = analysis.calculateAverageSales();
    int totalSales = analysis.calculateTotalSales();
    String? highestSalesDate = analysis.findHighestSalesDate();
    String? lowestSalesDate = analysis.findLowestSalesDate();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Ringkasan Aktifitas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                Text(
                    "Rata Rata Penjualan : ${CurrencyFormat.convertToIdr(averageSales, 0)}",
                    style: TextStyle(
                      fontSize: 14,
                    ))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Text(
                    "Total Penjualan : ${CurrencyFormat.convertToIdr(totalSales, 0)}",
                    style: TextStyle(
                      fontSize: 14,
                    ))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Text("Penjualan Terbanyak di tanggal : ${highestSalesDate}",
                    style: TextStyle(
                      fontSize: 14,
                    ))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Text("Penjualan Terkecil di tanggal : ${lowestSalesDate}",
                    style: TextStyle(
                      fontSize: 14,
                    ))
              ],
            ),
              SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Text("Penjualan Menu tertinggi  : ${widget.topMenu[0].itemdesc}, Qty : ${widget.topMenu[0].qty}",
                    style: TextStyle(
                      fontSize: 14,
                    ))
              ],
            ),
                SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Text("Penjualan Menu Terendah  : ${widget.menukuranglaku[0].itemdesc},  Qty : ${widget.menukuranglaku[0].qty}",
                    style: TextStyle(
                      fontSize: 14,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
