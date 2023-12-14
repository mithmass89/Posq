import 'package:flutter/material.dart';
import 'package:posq/setting/printer/classprinterBluetooth.dart';
import 'package:posq/setting/printer/printer_wifi/printernetwork.dart';
import 'package:posq/setting/printer/templateprinter.dart';

class ClassMainPrinter extends StatefulWidget {
  const ClassMainPrinter({Key? key}) : super(key: key);

  @override
  State<ClassMainPrinter> createState() => _ClassMainPrinterState();
}

class _ClassMainPrinterState extends State<ClassMainPrinter> {
  List<String> printer = ['Bluetooth', 'Network Printer', 'Setelan'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Setting',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: printer.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    if (printer[index] == 'Bluetooth') {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ClassBluetoothPrinter();
                      }));
                    } else if (printer[index] == 'Setelan') {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return TemplatePrinter();
                      }));
                    } else if (printer[index] == 'Network Printer') {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PrinterNetwork();
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
