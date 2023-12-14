import 'dart:developer';
import 'dart:typed_data';

import 'package:epson_epos/epson_epos.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:posq/userinfo.dart';

class ClassPrinterNetwork {
  // Properti atau variabel dalam class
  // konsep on print ini disesuaikan lagi // di pisah masing masing printer //
  // Konstruktor
  ClassPrinterNetwork();

  // Metode atau fungsi dalam class
  List<EpsonPrinterModel> printers = [];

  Future<dynamic> onDiscoveryTCP() async {
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.TCP);
      if (data != null && data.isNotEmpty) {
        for (var element in data) {
          print(element.toJson());
        }
        printers = data;
      }
    } catch (e) {
      log("Error: $e");
    }
    return printers;
  }

  Future<List<int>> profileProperty(List gnprofile) async {
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];
      print(gnprofile[0]['prfnm']);
      bytes += generator.text(gnprofile[0]['prfnm'],
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      bytes +=
          generator.text(gnprofile[0]['prfadd'].toString().substring(0, 25),
              maxCharsPerLine: 10,
              styles: const PosStyles(
                bold: true,
                align: PosAlign.center,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              ));
      bytes += generator.text(gnprofile[0]['prfct'],
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      bytes +=
          generator.text('------------------------------------------------',
              styles: const PosStyles(
                align: PosAlign.center,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              ));
      //  print('ini list : $list');
      // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');

      // bytes += generator.reset();
      // bytes += generator.cut();
      return bytes;
    } catch (e) {
      List<int> errors = [1];
      return errors;
    }
  }

  Future<List<int>> resetPrinter() async {
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];
      bytes += generator.reset();
      return bytes;
    } catch (e) {
      List<int> errors = [1];
      return errors;
    }
  }

  Future<List<int>> headerDataBill(String trno, String table, String waiter,
      String guestname, String time, String date) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    //  print('ini list : $list');
    // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
    bytes += generator.row([
      PosColumn(
        text: "Transno : $trno",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Table : $table",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Waiter : $waiter",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "guest : $guestname  ",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Kasir : $usercd",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Time : $time",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Date : $date",
        width: 12,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.text('------------------------------------------------',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    // bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> headerData(String trno, String table, String waiter,
      String guestname, String time, String date) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    //  print('ini list : $list');
    // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
    bytes += generator.row([
      PosColumn(
        text: "Transno : $trno",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Table : $table",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Waiter : $waiter",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "guest : $guestname  ",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Kasir : $usercd",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Time : $time",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Date : $date",
        width: 12,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);

    // bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> headerDataCO(String trno, String table, String waiter,
      String guestname, String time, String date) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes += generator.text('CAPTAIN ORDER\n',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    //  print('ini list : $list');
    // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
    bytes += generator.row([
      PosColumn(
        text: "Transno : $trno",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Table : $table",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Waiter : $waiter",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "guest : $guestname",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Kasir : $usercd",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Time : $time",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Date : $date",
        width: 12,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);

    // bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> headerDataVoidItem(String trno, String table, String waiter,
      String guestname, String time, String date) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes += generator.text('VOID ITEM\n',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    //  print('ini list : $list');
    // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
    bytes += generator.row([
      PosColumn(
        text: "Transno : $trno",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Table : $table",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Waiter : $waiter",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "guest : $guestname",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Kasir : $usercd",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Time : $time",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Date : $date",
        width: 12,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);

    // bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> headerDataVoidBill(String trno, String table, String waiter,
      String guestname, String time, String date) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes += generator.text('VOID BILL\n',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    //  print('ini list : $list');
    // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
    bytes += generator.row([
      PosColumn(
        text: "Transno : $trno",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Table : $table",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Waiter : $waiter",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "guest : $guestname",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Kasir : $usercd",
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "Time : $time",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Date : $date",
        width: 12,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);

    // bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> preparedataKitchen(List datatransaksi) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    for (var list in datatransaksi) {
      print('ini list : $list');
      // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
      bytes += generator.row([
        PosColumn(
          text: list[0].itemdesc,
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.left),
        ),
        PosColumn(
          text: "X ${list[1].toString()}",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left,
          ),
        ),
      ]);

      bytes += generator.text(list[4],
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
    }

    bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> preparedataVoidBillKitchen(List datatransaksi) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    for (var list in datatransaksi) {
      print('ini list : $list');
      // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
      bytes += generator.row([
        PosColumn(
          text: list.trdesc,
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.left),
        ),
        PosColumn(
          text: "X ${list.qty.toString()}",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left,
          ),
        ),
      ]);

      bytes += generator.text(list.notes,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
    }

    // bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> prepareDataBill(List datatransaksi) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    for (var list in datatransaksi) {
      print('ini list : $list');
      // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
      bytes += generator.row([
        PosColumn(
          text: "${list.qty.toString()}",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: list.trdesc,
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.left),
        ),
        PosColumn(
          text: NumberFormat.decimalPattern().format(list.rvnamt.toInt()),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.text('------------------------------------------------',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> prepareDataSummary(List datatransaksi) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    for (var list in datatransaksi) {
      print('ini list : $list');
      // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');

      bytes += generator.row([
        PosColumn(
          text: "Total",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: NumberFormat.decimalPattern().format(list.amountplus),
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: "Service",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: NumberFormat.decimalPattern().format(list.service),
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          text: "Tax",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: NumberFormat.decimalPattern().format(list.tax),
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right),
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          text: "Total Tagihan",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: NumberFormat.decimalPattern().format(list.total),
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.text('------------------------------------------------',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> prepareDataPayment(List datatransaksi) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    for (var list in datatransaksi) {
      print('ini list : $list');
      bytes += generator.row([
        PosColumn(
          text: "${list.trdesc2}-${list.compdesc}",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: NumberFormat.decimalPattern().format(list.totamt.toInt()),
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.reset();
    return bytes;
  }

  Future<List<int>> preparedataCO(List datatransaksi) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    for (var list in datatransaksi) {
      print('ini list CO : $list');
      // print('ini list print ke ${list[0].printerpath} : ${list[0].itemdesc}');
      bytes += generator.row([
        PosColumn(
          text: list[0].itemdesc,
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.left),
        ),
        PosColumn(
          text: "X ${list[1].toString()}",
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left,
          ),
        ),
      ]);

      bytes += generator.text(list[4],
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
    }

    bytes += generator.reset();
    // bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> prepareDataVoidItem(datatransaksi) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    print('ini list : $datatransaksi');
    bytes += generator.row([
      PosColumn(
        text: datatransaksi.trdesc,
        width: 6,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.left),
      ),
      PosColumn(
        text: "X ${datatransaksi.qty.toString()}",
        width: 6,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
          align: PosAlign.left,
        ),
      ),
    ]);

    bytes += generator.text(datatransaksi.notes,
        styles: const PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    return bytes;
  }

  Future<dynamic> onPrintKitchen(
      EpsonPrinterModel printer,
      List<int> bytes,
      String trno,
      String table,
      String waiter,
      String guestname,
      String time,
      String date) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(2));
      commands.add(command.rawData(Uint8List.fromList(
          await headerData(trno, table, waiter, guestname, time, date))));
      commands.add(command.addFeedLine(3));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(4));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      commands.add(command.rawData(Uint8List.fromList(await resetPrinter())));
      // await EpsonEPOS.isPrinterConnected(printer).then((value) => print("is printer connected ? $value"));
      await EpsonEPOS.onPrint(printer, commands)
          .then((value) => print("printer error :$value"));
    } catch (e) {
      print("printer error : $e");
      throw e;
    }
  }


  
  Future<dynamic> onPrintBar(
      EpsonPrinterModel printer,
      List<int> bytes,
      String trno,
      String table,
      String waiter,
      String guestname,
      String time,
      String date) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(2));
      commands.add(command.rawData(Uint8List.fromList(
          await headerData(trno, table, waiter, guestname, time, date))));
      commands.add(command.addFeedLine(3));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(4));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      commands.add(command.rawData(Uint8List.fromList(await resetPrinter())));
      // await EpsonEPOS.isPrinterConnected(printer).then((value) => print("is printer connected ? $value"));
      await EpsonEPOS.onPrint1(printer, commands)
          .then((value) => print("printer error :$value"));
    } catch (e) {
      print("printer error : $e");
      throw e;
    }
  }

  Future<dynamic> onPrintVoidItemKitchen(
      EpsonPrinterModel printer,
      List<int> bytes,
      String trno,
      String table,
      String waiter,
      String guestname,
      String time,
      String date) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(2));
      commands.add(command.rawData(Uint8List.fromList(await headerDataVoidItem(
          trno, table, waiter, guestname, time, date))));
      commands.add(command.addFeedLine(3));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(4));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      commands.add(command.rawData(Uint8List.fromList(await resetPrinter())));
      await EpsonEPOS.onPrint(printer, commands)
          .then((value) => print("printer error :$value"));
    } catch (e) {
      throw e;
    }
  }

    Future<dynamic> onPrintVoidItemBar(
      EpsonPrinterModel printer,
      List<int> bytes,
      String trno,
      String table,
      String waiter,
      String guestname,
      String time,
      String date) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(2));
      commands.add(command.rawData(Uint8List.fromList(await headerDataVoidItem(
          trno, table, waiter, guestname, time, date))));
      commands.add(command.addFeedLine(3));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(4));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      commands.add(command.rawData(Uint8List.fromList(await resetPrinter())));
      await EpsonEPOS.onPrint1(printer, commands)
          .then((value) => print("printer error :$value"));
    } catch (e) {
      throw e;
    }
  }


  Future<dynamic> onPrintVoidBill(
      EpsonPrinterModel printer,
      List<int> bytes,
      String trno,
      String table,
      String waiter,
      String guestname,
      String time,
      String date) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(2));
      commands.add(command.rawData(Uint8List.fromList(await headerDataVoidBill(
          trno, table, waiter, guestname, time, date))));
      commands.add(command.addFeedLine(3));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(4));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      commands.add(command.rawData(Uint8List.fromList(await resetPrinter())));
      await EpsonEPOS.onPrint2(printer, commands)
          .then((value) => print("printer error :$value"));
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> onPrintCO(
      EpsonPrinterModel printer,
      List<int> bytes,
      String trno,
      String table,
      String waiter,
      String guestname,
      String time,
      String date) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(2));
      commands.add(command.rawData(Uint8List.fromList(
          await headerDataCO(trno, table, waiter, guestname, time, date))));
      commands.add(command.addFeedLine(3));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(2));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      commands.add(command.rawData(Uint8List.fromList(await resetPrinter())));
      await EpsonEPOS.onPrint2(printer, commands)
          .then((value) => print("printer error :$value"));
    } catch (e) {
      print('ini error : $e');
      throw e;
    }
  }

  Future<dynamic> onPrintBill(
    EpsonPrinterModel printer,
    List<int> bytes,
    String trno,
    String table,
    String waiter,
    String guestname,
    String time,
    String date,
    List gnprofile,
    List datasummary,
    List payment,
  ) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.CENTER));
      commands.add(command.addFeedLine(2));
      commands.add(command
          .rawData(Uint8List.fromList(await profileProperty(gnprofile))));
      commands.add(command.addFeedLine(2));
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.rawData(Uint8List.fromList(
          await headerDataBill(trno, table, waiter, guestname, time, date))));
      commands.add(command.addFeedLine(1));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(1));
      commands.add(command
          .rawData(Uint8List.fromList(await prepareDataSummary(datasummary))));
      commands.add(command.addFeedLine(2));
      payment.isNotEmpty
          ? commands.add(command
              .rawData(Uint8List.fromList(await prepareDataPayment(payment))))
          : commands.add(command.addFeedLine(1));
      commands.add(command.addFeedLine(1));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      commands.add(command.rawData(Uint8List.fromList(await resetPrinter())));
      await EpsonEPOS.onPrint2(printer, commands)
          .onError((error, stackTrace) => print('error printer : $error'));
    } catch (e) {
      print('error printer : $e');
      throw e;
    }
  }
}
