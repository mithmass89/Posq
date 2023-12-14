// ignore_for_file: library_private_types_in_public_api, avoid_print, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:epson_epos/epson_epos.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterNetwork extends StatefulWidget {
  @override
  _PrinterNetworkState createState() => _PrinterNetworkState();
}

class _PrinterNetworkState extends State<PrinterNetwork> {
  List<EpsonPrinterModel> printers = [];
  List<String> dummy = ['TM-T88', 'TM-T99', 'TM-U220'];
  TextEditingController _kitchen = TextEditingController();
  TextEditingController _bar = TextEditingController();
  TextEditingController _co = TextEditingController();
  TextEditingController _cashier = TextEditingController();
  @override
  void initState() {
    super.initState();
    print(dummy);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    setState(() {});
  }

  _saveString() async {
    SharedPreferences kitchen = await SharedPreferences.getInstance();
    SharedPreferences bar = await SharedPreferences.getInstance();
    SharedPreferences co = await SharedPreferences.getInstance();
    SharedPreferences cashier = await SharedPreferences.getInstance();
    kitchen.setString('kitchen', _kitchen.text);
    bar.setString('bar', _bar.text);
    co.setString('co', _bar.text);
    cashier.setString('cashier', _bar.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Net printer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GoogleTextFormField(
              controller: _kitchen,
              label: 'Printer Kitchen',
            ),
            GoogleTextFormField(
              controller: _bar,
              label: 'Printer Bar',
            ),
            GoogleTextFormField(
              controller: _co,
              label: 'Printer Captain Order',
            ),
            GoogleTextFormField(
              controller: _cashier,
              label: 'Printer Cashier',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color
                    ),
                    onPressed: () {
                       _saveString();
                    },
                    child: Text('Save')),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Text color
                    ),
                    onPressed: () {},
                    child: Text('Check'))
              ],
            )
          ],
        ),
      )),
    );
  }

  buildPrinter() {}

  onDiscoveryTCP() async {
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.TCP);
      if (data != null && data.isNotEmpty) {
        for (var element in data) {
          print(element.toJson());
        }
        setState(() {
          printers = data;
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  onDiscoveryUSB() async {
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.USB);
      if (data != null && data.isNotEmpty) {
        for (var element in data) {
          print(element.toJson());
        }
        setState(() {
          printers = data;
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  void onSetPrinterSetting(EpsonPrinterModel printer) async {
    try {
      await EpsonEPOS.setPrinterSetting(printer, paperWidth: 80);
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<List<int>> _customEscPos() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);
    bytes += generator.qrcode('Barcode by escpos',
        size: QRSize.Size4, cor: QRCorrection.H);
    bytes += generator.feed(2);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.reset();
    bytes += generator.cut();

    return bytes;
  }

  void onPrintTest(EpsonPrinterModel printer) async {
    EpsonEPOSCommand command = EpsonEPOSCommand();
    List<Map<String, dynamic>> commands = [];
    commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
    commands.add(command.addFeedLine(4));
    commands.add(command.append('PRINT TESTE OK!\n'));
    commands.add(command.rawData(Uint8List.fromList(await _customEscPos())));
    commands.add(command.addFeedLine(4));
    commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
    await EpsonEPOS.onPrint(printer, commands);
  }
}

class GoogleTextFormField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  GoogleTextFormField(
      {required this.label, this.isPassword = false, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 5),
          TextField(
            keyboardType: TextInputType.number,
            obscureText: isPassword,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
