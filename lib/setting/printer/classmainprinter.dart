import 'package:flutter/material.dart';
import 'package:posq/setting/printer/classprinterBluetooth.dart';
import 'package:posq/setting/printer/printer_network/mainprinter_net.dart';
import 'package:posq/setting/printer/templateprinter.dart';

class ClassMainPrinter extends StatefulWidget {
  const ClassMainPrinter({Key? key}) : super(key: key);

  @override
  State<ClassMainPrinter> createState() => _ClassMainPrinterState();
}

class _ClassMainPrinterState extends State<ClassMainPrinter> {
  List<String> printer = ['Bluetooth', 'Wi-fi', 'Setelan'];
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
                    } else if (printer[index] == 'Setelan') {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return TemplatePrinter();
                      }));
                    } else if (printer[index] == 'Wi-fi') {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PrinterMain();
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
