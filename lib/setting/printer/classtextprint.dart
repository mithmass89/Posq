// ignore_for_file: unused_import

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:http/http.dart' as http;
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/printer/printerenum.dart';
import 'package:intl/intl.dart';

class PrintSmall {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  prints(List<IafjrndtClass> detail, List<IafjrndtClass> summary,
      String outletname, Outlet outletinfo, TemplatePrinter template) async {
    print('detail from printer : $detail');
    // ignore: unused_local_variable
    var formatter = NumberFormat('#,##,000');
    //image max 300px X 300px

    ///image from File path
    // String filename = 'cutlery.png';
    // ByteData bytesData = await rootBundle.load("assets/cutlery.png");
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
    //     .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

    ///image from Asset
    // ByteData bytesAsset = await rootBundle.load("assets/cutlery.png");
    // Uint8List imageBytesFromAsset = bytesAsset.buffer
    //     .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    ///image from Network
    var logo = template.logourl;
    var response = await http.get(Uri.parse(logo!));
    Uint8List bytesNetwork = response.bodyBytes;
    Uint8List imageBytesFromNetwork = bytesNetwork.buffer
        .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        logo.isNotEmpty
            ? bluetooth.printImageBytes(imageBytesFromNetwork)
            : null;
        bluetooth.printNewLine();
        bluetooth.printCustom(
            outletname, Size.boldMedium.val, Align.center.val);
        bluetooth.printCustom(
            outletinfo.alamat!, Size.medium.val, Align.center.val);

        bluetooth.printCustom(
            '-------------------------------', Size.bold.val, Align.left.val);
        bluetooth.printNewLine();
        List.generate(
            detail.length,
            (index) => bluetooth.printCustom(
                detail[index].typ != 'condiment'
                    ? '${detail[index].condimenttype == 'menuchoice' ? detail[index].itemdesc!.padRight(15) : detail[index].itemdesc!.padRight(15)}\n' +
                        '${detail[index].qty.toString().padLeft(3)} X ' +
                        '${CurrencyFormatNo.convertToIdr(detail[index].rateamtitem, 0).toString().padRight(9)}'
                            '${CurrencyFormat.convertToIdr(detail[index].totalaftdisc, 0).toString().padLeft(15)}'
                    : '*** ${detail[index].itemdesc!.padRight(15)} \n' +
                        '${detail[index].qty.toString().padLeft(3)} X ' +
                        '${CurrencyFormatNo.convertToIdr(detail[index].rateamtitem, 0).toString().padRight(9)}'
                            '${CurrencyFormat.convertToIdr(detail[index].totalaftdisc, 0).toString().padLeft(15)}',
                Size.bold.val,
                Align.left.val));
        bluetooth.printNewLine();
        bluetooth.printCustom(
            '-------------------------------', Size.bold.val, Align.left.val);
        bluetooth.printCustom(
            'Subtotal'.padRight(20) +
                CurrencyFormat.convertToIdr(summary[0].revenueamt, 0)
                    .toString(),
            Size.bold.val,
            Align.left.val);
        bluetooth.printCustom(
            'Discount'.padRight(20) +
                CurrencyFormat.convertToIdr(summary[0].discamt, 0).toString(),
            Size.bold.val,
            Align.left.val);
        bluetooth.printCustom(
            'Tax'.padRight(20) +
                CurrencyFormat.convertToIdr(summary[0].taxamt, 0).toString(),
            Size.bold.val,
            Align.left.val);
        bluetooth.printCustom(
            'Service'.padRight(20) +
                CurrencyFormat.convertToIdr(summary[0].serviceamt, 0)
                    .toString(),
            Size.bold.val,
            Align.left.val);
        bluetooth.printCustom(
            'Total'.padRight(20) +
                CurrencyFormat.convertToIdr(summary[0].totalaftdisc, 0)
                    .toString(),
            Size.bold.val,
            Align.left.val);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            '-------------------------------', Size.bold.val, Align.left.val);
        bluetooth.printNewLine();
        bluetooth.printCustom('AOVIPOS', Size.medium.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth
            .paperCut(); //some printer not supported (sometime making image not centered)
        //bluetooth.drawerPin2(); // or you can use bluetooth.drawerPin5();
      }
    });
  }
}
