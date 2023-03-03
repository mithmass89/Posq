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

class PrintSmall {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  prints(List<IafjrndtClass> detail, String outletname) async {
    print(detail);
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

    // ///image from Network
    // var response = await http.get(Uri.parse(
    //     "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
    // Uint8List bytesNetwork = response.bodyBytes;
    // Uint8List imageBytesFromNetwork = bytesNetwork.buffer
    //     .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom(
            outletname, Size.boldMedium.val, Align.center.val);
        bluetooth.printNewLine();
        List.generate(
            detail.length,
            (index) => bluetooth.printCustom(
                '${detail[index].description!.padRight(15)}\n' +
                    '${detail[index].qty.toString().padLeft(3)} X ' +
                    '${CurrencyFormat.convertToIdr(detail[index].rateamtitem, 0).toString().padLeft(10)}',
                Size.bold.val,
                Align.left.val));
        bluetooth
            .paperCut(); //some printer not supported (sometime making image not centered)
        //bluetooth.drawerPin2(); // or you can use bluetooth.drawerPin5();
      }
    });
  }
}
