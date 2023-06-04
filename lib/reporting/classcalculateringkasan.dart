import 'package:intl/intl.dart';
import 'package:posq/model.dart';
import 'package:intl/date_symbol_data_local.dart';

class SalesData {
  final DateTime date;
  final int sales;

  SalesData({required this.date, required this.sales});
}

class BusinessAnalysis {
  List<IafjrndtClass> salesDataList;

  BusinessAnalysis({required this.salesDataList});

  double calculateAverageSales() {
    int totalSales = 0;
    for (var data in salesDataList) {
      totalSales += data.revenueamt!.toInt();
    }
    return totalSales / salesDataList.length;
  }

  int calculateTotalSales() {
    int totalSales = 0;
    for (var data in salesDataList) {
      totalSales += data.revenueamt!.toInt();
    }
    return totalSales;
  }

  String findHighestSalesDate() {
    initializeDateFormatting();
    int highestSales = 0;
    String highestSalesDate = '';
    for (var data in salesDataList) {
      if (data.revenueamt! > highestSales) {
        highestSales = data.revenueamt!.toInt();
        highestSalesDate = data.trdt.toString();
      }
    }
    DateTime dateTime = DateTime.parse(highestSalesDate);
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }

  String? findLowestSalesDate() {
    initializeDateFormatting();
    int lowestSales =
        salesDataList.isNotEmpty ? salesDataList[0].revenueamt!.toInt() : 0;
    String? lowestSalesDate = '';
    for (var data in salesDataList) {
      if (data.revenueamt! <= lowestSales) {
        lowestSales = data.revenueamt!.toInt();
        lowestSalesDate = data.trdt.toString();
      }
    }
    DateTime dateTime = DateTime.parse(lowestSalesDate!);
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }
}
