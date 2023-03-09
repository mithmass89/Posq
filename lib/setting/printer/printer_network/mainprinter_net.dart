import 'package:flutter/material.dart';
import 'dart:io';
import 'package:posq/setting/printer/printer_network/scanning.dart';

ClassPrinterNet? classprinter;

class PrinterMain extends StatefulWidget {
  const PrinterMain({Key? key}) : super(key: key);

  @override
  State<PrinterMain> createState() => _PrinterMainState();
}

class _PrinterMainState extends State<PrinterMain> {

  
  void connectToWifi(String ssid, String password) async {
    if (Platform.isAndroid) {
      // On Android, use the 'wifi_configuration' method to connect to a Wi-Fi network.
      await Process.run('su', [
        '-c',
        'am startservice -n com.wifi.configuration/.WiFiConfigureService -a WifiConfiguration --es ssid $ssid --es password $password'
      ]);
    } else if (Platform.isIOS) {
      // On iOS, use the 'networksetup' command-line tool to connect to a Wi-Fi network.
      await Process.run(
          'networksetup', ['-setairportnetwork', 'en0', ssid, password]);
    } else {
      throw UnsupportedError(
          'This platform does not support Wi-Fi configuration.');
    }
  }

  @override
  void initState() {
    super.initState();
    // connectToWifi();
    classprinter = ClassPrinterNet();
    classprinter!.scanWifi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Scanner'),
      ),
    );
  }
}
