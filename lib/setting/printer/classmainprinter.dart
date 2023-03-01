import 'package:flutter/material.dart';
import 'package:posq/setting/printer/classprinterBluetooth.dart';

class ClassMainPrinter extends StatefulWidget {
  const ClassMainPrinter({Key? key}) : super(key: key);

  @override
  State<ClassMainPrinter> createState() => _ClassMainPrinterState();
}

class _ClassMainPrinterState extends State<ClassMainPrinter> {
  List<String> printer = ['bluetooth', 'WAN', 'Wifi'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Setting'),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: printer.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    if (printer[index] == 'bluetooth') {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ClassBluetoothPrinter();
                      }));
                    }
                  },
                  title: Text(printer[index]),
                ),
              );
            }),
      ),
    );
  }
}
