import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:posq/setting/printer/testprint.dart';
import 'package:shared_preferences/shared_preferences.dart';

TestPrint? testprint;

class ClassBluetoothPrinter extends StatefulWidget {
  @override
  _ClassBluetoothPrinterState createState() =>
      new _ClassBluetoothPrinterState();
}

class _ClassBluetoothPrinterState extends State<ClassBluetoothPrinter> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  String address = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    testprint = TestPrint();
  }

  getpref() async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    Map<dynamic, dynamic> printer = json
        .decode(prefs.getString('bluetoothdevice')!) as Map<String, dynamic>;
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    print(isConnected);
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      print(state);
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          _connected = true;
          setState(() {});
          break;
        case BlueThermalPrinter.DISCONNECTED:
          _connected = false;
          print("bluetooth device state: disconnected");
          setState(() {});
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          _connected = false;
          print("bluetooth device state: disconnect requested");
          setState(() {});
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          _connected = false;
          print("bluetooth device state: bluetooth turning off");
          setState(() {});
          break;
        case BlueThermalPrinter.STATE_OFF:
          _connected = false;
          print("bluetooth device state: bluetooth off");
          setState(() {});
          break;
        case BlueThermalPrinter.STATE_ON:
          _connected = false;
          print("bluetooth device state: bluetooth on");
          setState(() {});
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          _connected = false;
          print("bluetooth device state: bluetooth turning on");
          setState(() {});
          break;
        case BlueThermalPrinter.ERROR:
          _connected = false;
          print("bluetooth device state: error");
          setState(() {});
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      _connected = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Printer',style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (BluetoothDevice? value) async {
                          setState(() => _device = value);
                          SharedPreferences bluetoothdevice =
                              await SharedPreferences.getInstance();
                          // final removes = await SharedPreferences.getInstance();
                          // removes.remove('bluetoothdevice');
                          bluetoothdevice.setString(
                              'bluetoothdevice', json.encode(_device));
                          print(value!.connected);
                        },
                        value: _device,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _connected == true ? Colors.red : Colors.green),
                      onPressed: _connected == true ? _disconnect : _connect,
                      child: Text(
                        _connected == true ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [Text('Jika Printer tidak terdeteksi')],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('1. anda bisa check koneksi bluetooth anda')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                          '2. pastikan device anda sudah pair dengan device ini')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                          '''3. check kembali printer anda,atau anda bisa coba untuk 
    mencoba di perangkat lain ''')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [Text('''4. Setting printer hanya sekali''')],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    onPressed: () {
                      testprint!.sample();
                    },
                    child: Text('PRINT TEST',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        print(isConnected);
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            print(error);
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    } else {
      show('No device selected.');
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}
