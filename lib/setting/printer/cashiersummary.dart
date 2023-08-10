import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/printer/printerenum.dart';
import 'package:intl/intl.dart';

class PrintSmallCashierSummary {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  prints(
    List<dynamic> cashflow,
    List<dynamic> otherpayment,
    List<dynamic> condiments,
    String outletname,
    String header,
  ) async {
    var formatter = NumberFormat('#,##,000');
    //image max 300px X 300px

    ///image from File path
    // String filename = 'cutlery.png';
    // ByteData bytesData = await rootBundle.load("assets/cutlery.png");
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
    //     .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

    // //image from Asset
    // ByteData bytesAsset = await rootBundle.load("assets/cutlery.png");
    // Uint8List imageBytesFromAsset = bytesAsset.buffer
    //     .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);
    //yg dipakai network//
    ///image from Network
    // print("urllogo: $urllogo");
    var logo = 'http://digims.online:3000/Logo%20Rev%201-01.png';
    var response = await http.get(Uri.parse(
        logo /*"https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"*/));
    print(response.bodyBytes);
    Uint8List bytesNetwork = response.bodyBytes;
    Uint8List imageBytesFromNetwork = bytesNetwork.buffer
        .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        // bluetooth.printImageBytes(imageBytesFromNetwork);
        bluetooth.printNewLine();
        bluetooth.printCustom(outletname, Size.bold.val, Align.center.val);
        bluetooth.printCustom(header, Size.medium.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printCustom('Cashier summary', Size.bold.val, Align.left.val);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            '-------------------------------', Size.bold.val, Align.left.val);
        bluetooth.printNewLine();
        bluetooth.printCustom('Cash flow', Size.bold.val, Align.left.val);

        cashflow.isNotEmpty
            ? List.generate(
                cashflow.length,
                (index) => bluetooth.printCustom(
                    '${cashflow[index]['Pendapatan oprational'].toString().padLeft(3)} : ' +
                        '${CurrencyFormatNo.convertToIdr(cashflow[index]['total'], 0).toString().padLeft(9,' ')}',
                    Size.bold.val,
                    Align.left.val))
            : null;
        bluetooth.printNewLine();
        bluetooth.printCustom(
            '-------------------------------', Size.bold.val, Align.left.val);
        otherpayment.isNotEmpty
            ? bluetooth.printCustom(
                'Other payment', Size.bold.val, Align.left.val)
            : null;
        bluetooth.printNewLine();
        otherpayment.isNotEmpty
            ? List.generate(
                otherpayment.length,
                (index) => bluetooth.printCustom(
                    '${otherpayment[index]['pymtmthd'].toString().padLeft(3)} : ' +
                        '${CurrencyFormatNo.convertToIdr(otherpayment[index]['total'], 0).toString().padLeft(9,' ')}',
                    Size.bold.val,
                    Align.left.val))
            : null;
        bluetooth.printNewLine();
        otherpayment.isNotEmpty
            ? bluetooth.printCustom(
                'Condiment terjual', Size.bold.val, Align.left.val)
            : null;
        bluetooth.printCustom(
            '-------------------------------', Size.bold.val, Align.left.val);
        bluetooth.printNewLine();
        condiments.isNotEmpty
            ? List.generate(
                condiments.length,
                (index) => bluetooth.printCustom(
                    '${condiments[index]['optiondesc'].toString().padLeft(3)} : ' +
                        ' Terjual x ${condiments[index]['qty'].toString().padLeft(9,' ')}',
                    Size.bold.val,
                    Align.left.val))
            : null;

        bluetooth
            .paperCut(); //some printer not supported (sometime making image not centered)
        //bluetooth.drawerPin2(); // or you can use bluetooth.drawerPin5();
      }
    });
  }
}
