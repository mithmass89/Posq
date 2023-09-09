// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:toast/toast.dart';

class ClassScanRegisterProdMobile extends StatefulWidget {
  final String produk;
  final String produkname;
  final String? outletcd;
  const ClassScanRegisterProdMobile(
      {Key? key, required this.produk, required this.produkname, this.outletcd})
      : super(key: key);

  @override
  State<ClassScanRegisterProdMobile> createState() =>
      _ClassScanRegisterProdMobileState();
}

class _ClassScanRegisterProdMobileState
    extends State<ClassScanRegisterProdMobile> {
  late DatabaseHandler handler;
  String _scanBarcode = 'Unknown';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) {
      print(barcode);
      // register(barcode);
    });
  }

  Future<dynamic> register(String barcode) async {
    RegisterItem register = RegisterItem(
        barcode: barcode, itemcd: widget.produk, outletcd: 'Belum disetting');
    List<RegisterItem> lisregister = [register];
    print('oke');
    return await handler.registerItem(lisregister);
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      await handler.queryCheckRegister(barcodeScanRes).then((value) async {
        if (value == 'Oke item masih kosong') {
          await register(barcodeScanRes);
        } else {
          await pesanDuplicate();
        }
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  pesanDuplicate() {
    Toast.show("Item Already Exist",
        duration: Toast.lengthShort, gravity: Toast.center);
  }

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    ToastContext().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register ${widget.produkname}',style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder(
        future: handler.retrieveRegisterItem(widget.produk),
        builder:
            (BuildContext context, AsyncSnapshot<List<RegisterItem>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data![index].barcode);
                });
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await scanBarcodeNormal();
          setState(() {});
        },
      ),
    );
  }
}
