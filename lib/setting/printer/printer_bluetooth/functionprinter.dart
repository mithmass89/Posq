import 'dart:async';
import 'package:flutter/services.dart';

class BluetoothScanner {
  static const MethodChannel _methodChannel =
      MethodChannel('bluetooth_scanner');

  static Future<List<dynamic>> scan() async {
    try {
      List<dynamic> devices = await _methodChannel.invokeMethod('scan');
      return devices;
    } on PlatformException catch (e) {
      throw e;
    }
  }

  
}


