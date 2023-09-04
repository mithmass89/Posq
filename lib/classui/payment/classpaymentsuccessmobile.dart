// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_import, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classfungsi/classhitungreward.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/fungsipdf/billpdf.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/printer/classmainprinter.dart';
import 'package:posq/setting/printer/classprinterbillpayment.dart';
import 'package:posq/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

PaymentGate? paymentapi;
ClassApi? api;
PrintSmallPayment? printing;

class ClassPaymetSucsessMobile extends StatefulWidget {
  final bool frombanktransfer;
  final String? virtualaccount;
  final String trno;
  final num amount;
  final String paymenttype;
  final String? guestname;
  final String? trdt;
  final String? outletcd;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? cash;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final bool fromsplit;

  const ClassPaymetSucsessMobile({
    Key? key,
    required this.trno,
    required this.amount,
    required this.paymenttype,
    required this.guestname,
    this.trdt,
    this.outletcd,
    this.outletname,
    required this.outletinfo,
    required this.cash,
    this.virtualaccount,
    required this.frombanktransfer,
    required this.datatrans,
    required this.fromsaved,
    required this.fromsplit,
  }) : super(key: key);

  @override
  State<ClassPaymetSucsessMobile> createState() =>
      _ClassPaymetSucsessMobileState();
}

class _ClassPaymetSucsessMobileState extends State<ClassPaymetSucsessMobile> {
  late DatabaseHandler handler;
  int? trno;
  String? nexttrno;
  String? statustransaction = '';
  final bool pending = true;
  final TextEditingController _telp = TextEditingController();
  final TextEditingController _email = TextEditingController();
  List<String> string = [];
  List<ItemMail> itememail = [];
  List<String> summary = [];
  List<String> payment = [];
  List<PaymentEmail> paymentemail = [];
  num subtotal = 0;
  num discounts = 0;
  num total = 0;
  num tax = 0;
  num service = 0;
  num grantotal = 0;
  num totalcharge = 0;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  bool loading = false;
  bool emailValid = false;
  List<IafjrndtClass> datacheck = [];
  int? pendings;
  PrintSmallPayment printing = PrintSmallPayment();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool connected = false;
  List<IafjrndtClass>? summarybill;
  List<IafjrnhdClass> data = [];
  String logourl = '';
  String header = '';
  String footer = '';
  var wsUrl;
  var wsUrlWa;
  WebSocketChannel? channel;
  WebSocketChannel? channelwa;

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    print(isConnected);
    try {} on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      print(state);
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            connected = true;
            print("bluetooth device state: connected");
            Fluttertoast.showToast(
                msg: "bluetooth device state: connected",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            connected = false;
            print("bluetooth device state: disconnected");
            Fluttertoast.showToast(
                msg: "bluetooth device state: disconnected",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            connected = false;
            print("bluetooth device state: disconnect requested");
            Fluttertoast.showToast(
                msg: "bluetooth device state: disconnect requested",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            connected = false;
            print("bluetooth device state: bluetooth turning off");
            Fluttertoast.showToast(
                msg: "bluetooth device state: bluetooth turning off",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            connected = false;
            print("bluetooth device state: bluetooth off");
            Fluttertoast.showToast(
                msg: "bluetooth device state: bluetooth off",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            connected = false;
            print("bluetooth device state: bluetooth on");
            Fluttertoast.showToast(
                msg: "bluetooth device state: bluetooth on",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            connected = false;
            print("bluetooth device state: bluetooth turning on");
            Fluttertoast.showToast(
                msg: "bluetooth device state: bluetooth turning on",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            connected = false;
            print("bluetooth device state: error");
            Fluttertoast.showToast(
                msg: "bluetooth device state: error : restart printer",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {});

    if (isConnected == true) {
      setState(() {
        connected = true;
      });
    }
  }

  checkPrinter() async {
    connected = await bluetooth.isConnected.then((value) => value!);
    setState(() {});
    print(connected);
    if (connected == false) {
      final prefs = await SharedPreferences.getInstance();
      Map<dynamic, dynamic> printer = json
          .decode(prefs.getString('bluetoothdevice')!) as Map<String, dynamic>;
      if (printer.isNotEmpty) {
        Fluttertoast.showToast(
            msg: "try to connect printer",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 11, 12, 14),
            textColor: Colors.white,
            fontSize: 16.0);
        await bluetooth
            .connect(BluetoothDevice(
                printer.values.elementAt(0), printer.values.elementAt(1)))
            .catchError((error) {
          print('ini error : $error');
        });
      } else {
        Fluttertoast.showToast(
            msg: "printer belum di setting",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 11, 12, 14),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    checkPrinter();
    wsUrl = Uri.parse('ws://digims.online:8080?property=$dbname');
    channel = WebSocketChannel.connect(wsUrl);
    channel!.stream.listen((message) {
      print(message[0]['status pesan']);
      var x = json.decode(message);
      print('ini : X $x');

      // channel.sink.close(status.goingAway);
    });
    wsUrlWa = Uri.parse('ws://digims.online:8085?id=${widget.trno}');
    channelwa = WebSocketChannel.connect(wsUrlWa);
    channelwa!.stream.listen((message) {
      print(message);

      // channel.sink.close(status.goingAway);
    });
    getSumm();
    formattedDate = formatter.format(now);
    generateDataWA();
    removeDiscount();
    api = ClassApi();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    // getSummary();

    getPaymentList();
    getTemplatePrinter();
    if (widget.cash == false) {
      PaymentGate.getStatusTransaction(widget.trno).then((value) {
        setState(() {
          statustransaction = value;
        });
      });
    } else {
      setState(() {
        statustransaction = 'Settlement';
      });
    }
  }

  getTemplatePrinter() {
    ClassApi.getTemplatePrinter().then((value) {
      if (value.isNotEmpty) {
        logourl = value[0]['logourl'];
        header = value[0]['header'];
        footer = value[0]['footer'];
      }
      ;
    });
    setState(() {});
  }

  Future<List<IafjrndtClass>> getDetailTrnos() async {
    datacheck = await ClassApi.getTrnoDetail(widget.trno, dbname, '');

    setState(() {});
    return datacheck;
  }

  Stream<String> _getstatus() async* {
    if (widget.cash == false) {
      await PaymentGate.getStatusTransaction(widget.trno).then((value) {
        setState(() {
          statustransaction = value;
        });
      });
    }

    // This loop will run forever because _running is always true
  }

  checkPending() {
    ClassApi.getOutstandingBillTransno(widget.trno, dbname, '').then((value) {
      setState(() {
        pendings = value.length;
      });
    });
  }

  checkTrno() async {
    var transno = await ClassApi.checkTrno();
    nexttrno = widget.outletcd! + '-' + transno[0]['transnonext'].toString();
    print(trno);
  }

  updateTrno() async {
    await ClassApi.updateTrno(dbname);
    await checkTrno();
  }

  generateDataWA() {
    List.generate(widget.datatrans.length, (index) {
      string.add(
          '${widget.datatrans[index].description.toString().padRight(23)}\n   ${widget.datatrans[index].qty.toString().padLeft(40)}X\t   ${widget.datatrans[index].totalaftdisc.toString().padRight(10)}\n');
    });
    List.generate(widget.datatrans.length, (index) {
      itememail.add(ItemMail(
          item: widget.datatrans[index].itemdesc!,
          harga: widget.datatrans[index].totalaftdisc!));
    });
  }

  removeDiscount() {
    string.removeWhere((element) => element.contains('Discount'));
  }

  // getSummary() async {
  //   await handler.summarybill(widget.datatrans.first.transno!).then((value) {
  //     List.generate(value.length, (index) {
  //       summary.add('total'.padRight(16, '  ') +
  //           ':'.padRight(2) +
  //           '${value[index].revenueamt.toString().padLeft(20)}\n' +
  //           'discount'.padRight(14, '  ') +
  //           ':'.padRight(2) +
  //           '${value[index].discamt.toString().padLeft(20)}\n' +
  //           'pajak'.padRight(15, '  ') +
  //           ':'.padRight(2) +
  //           '${value[index].taxamt.toString().padLeft(20)}\n' +
  //           'service'.padRight(15, '  ') +
  //           ':'.padRight(2) +
  //           '${value[index].serviceamt.toString().padLeft(20)}\n' +
  //           'grand total'.padRight(15, '  ') +
  //           ':'.padRight(2) +
  //           '${value[index].totalaftdisc.toString().padLeft(20)}\n');
  //     });
  //   });
  // }

  getSumm() async {
    await ClassApi.getSumTrans(widget.trno, dbname, '').then((value) {
      print('ini summary : $value');
      if (value.isNotEmpty) {
        setState(() {
          summarybill = value;
        });
      } else {}
    });
  }

  getPaymentList() async {
    data = await ClassApi.getDetailPayment(widget.trno, dbname, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          StreamBuilder(
              stream: _getstatus(),
              builder: (context, AsyncSnapshot<String> snapshot) {
                return Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 95,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          'Transaksi Berhasil',
                          style: TextStyle(fontSize: 25, color: Colors.green),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.height * 0.14,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/check.png'),
                            fit: BoxFit.fill,
                          )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        TextFieldMobile2(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send,
                            ),
                            iconSize: 20,
                            color: Colors.blue,
                            splashColor: Colors.purple,
                            onPressed: () async {
                              final pdfGenerator = BillPdfGenerator();
                              final pdfFile = await pdfGenerator.generatePDF(
                                  widget.outletname!,
                                  widget.outletinfo!.alamat!,
                                  widget.datatrans,
                                  summarybill!,
                                  data);
                              final output = await getTemporaryDirectory();
                              final file = File('${output.path}/example.pdf');
                              final Uint8List uint8List =
                                  await File(file.path).readAsBytes();
                              print(uint8List);
                              await ClassApi.uploadFilesLogoPDF(
                                  uint8List, '${widget.trno}.pdf');
                              channelwa!.sink.add(json.encode({
                                "function": "sendfile",
                                "number": _telp.text,
                                "chat": "E-bill",
                                "index": "6282221769478",
                                "attachment": '${widget.trno}.pdf'
                              }));
                              Fluttertoast.showToast(
                                  msg: "Upload bill",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Color.fromARGB(255, 11, 12, 14),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              // channelwa!.sink.close();
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => PdfViewer(pdfFile.path),
                              //   ),
                              // );
                              // Lakukan sesuatu dengan file PDF, seperti menampilkan atau membagikannya.
                            },
                          ),
                          label: 'Whatsapp',
                          hint: '+621231231231',
                          controller: _telp,
                          onChanged: (String value) {},
                          typekeyboard: TextInputType.phone,
                        ),
                        TextFieldMobile2(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send,
                            ),
                            iconSize: 20,
                            color: Colors.blue,
                            splashColor: Colors.purple,
                            onPressed: emailValid == true
                                ? () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await ClassApi.sendMail(
                                            paymentemail,
                                            itememail,
                                            formattedDate,
                                            widget.outletname!,
                                            widget.trno,
                                            totalcharge,
                                            _email.text)
                                        .then((value) {
                                      if (value['hasil'] == 'success') {
                                        setState(() {
                                          loading = false;
                                        });
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "Failed send email",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromARGB(255, 11, 12, 14),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                      print(value['hasil']);
                                      Fluttertoast.showToast(
                                          msg: "Send email",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Color.fromARGB(255, 11, 12, 14),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    });
                                  }
                                : null,
                          ),
                          label: 'E-mail',
                          controller: _email,
                          onChanged: (String value) {
                            emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_email.text);
                            print(emailValid);
                          },
                          validator: (value) {
                            emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_email.text);
                            print(emailValid);
                            if (emailValid) {
                              return 'valid';
                            } else {
                              return 'not valid email';
                            }
                          },
                          typekeyboard: TextInputType.text,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.27,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonNoIcon(
                              textcolor: connected == true
                                  ? AppColors.primaryColor
                                  : Colors.red,
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.18,
                              onpressed:
                                  accesslist.contains('settingprinter') == true
                                      ? () async {
                                          await checkPrinter();
                                          await getSumm();
                                          if (connected == true) {
                                            await printing.prints(
                                                widget.datatrans,
                                                summarybill!,
                                                data,
                                                widget.outletinfo!.outletname!,
                                                widget.guestname!,
                                                header,
                                                footer,
                                                logourl,
                                                widget.outletinfo!);
                                          } else {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClassMainPrinter()));
                                          }
                                        }
                                      : () {
                                          Fluttertoast.showToast(
                                              msg: "Tidak punya akses printer",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Color.fromARGB(
                                                  255, 11, 12, 14),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        },
                              name: connected == true ? 'Print' : 'Offline',
                            ),
                            ButtonNoIcon(
                              textcolor: Colors.white,
                              color: AppColors.primaryColor,
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.18,
                              onpressed: () async {
                                var minconv = 0;
                                var point = 0;
                                await ClassApi.getLoyalityProgramActive()
                                    .then((rules) async {
                                  if (rules.isNotEmpty) {
                                    minconv = rules.first['convamount'];
                                    point = rules.first['point'];
                                           if (Pembelian(
                                              summarybill!.first.totalaftdisc!,
                                              minconv,
                                              point)
                                          .hitungPoin()
                                          .toInt() !=
                                      0) {
                                    final savecostmrs =
                                        await SharedPreferences.getInstance();
                                    if (savecostmrs.getString('savecostmrs') !=
                                        null) {
                                      Map<String, dynamic> guest = json.decode(
                                          savecostmrs
                                              .getString('savecostmrs')!);
                                      await ClassApi.insertPointguest(
                                          Pembelian(
                                                  summarybill!
                                                      .first.totalaftdisc!,
                                                  minconv,
                                                  point)
                                              .hitungPoin()
                                              .toInt(),
                                          guest['guestname'],
                                          widget.trdt!,
                                          widget.trno,
                                          summarybill!.first.totalaftdisc!);

                                      await savecostmrs.remove("savecostmrs");
                                      var x = await savecostmrs
                                          .getString('savecostmrs');
                                    }
                                  }
                                  }
                           
                                });

                                channel!.sink
                                    .add(json.encode({"property": dbname}));
                                await getDetailTrnos().then((value) async {
                                  print('ini value : $value');
                                  if (value.isEmpty) {
                                    await updateTrno();
                                    await ClassApi.cleartable(
                                        dbname, widget.trno);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove("savecostmrs");
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClassRetailMainMobile(
                                                  fromsaved: widget.fromsaved,
                                                  pscd: widget.outletcd!,
                                                  trno: nexttrno,
                                                  outletinfo:
                                                      widget.outletinfo!,
                                                  qty: 0,
                                                )),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    if (widget.fromsaved == true) {
                                      await checkTrno();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.remove("savecostmrs");
                                      await ClassApi.cleartable(
                                          dbname, widget.trno);
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClassRetailMainMobile(
                                                    fromsaved: false,
                                                    pscd: widget.outletcd!,
                                                    trno: nexttrno,
                                                    outletinfo:
                                                        widget.outletinfo!,
                                                    qty: 0,
                                                  )),
                                          (Route<dynamic> route) => false);
                                    } else if (widget.fromsplit == true) {
                                      for (var x in widget.datatrans) {
                                        if (x.condimenttype == '') {
                                          await ClassApi.updateSplit(
                                              dbname, widget.trno, x.itemseq!);
                                        }
                                      }

                                      await ClassApi.getOutstandingBillTransno(
                                              widget.trno, dbname, '')
                                          .then((valued) async {
                                        print('ini value success:  $valued');
                                        if (valued.isEmpty) {
                                          await updateTrno();
                                          await ClassApi.cleartable(
                                              dbname, widget.trno);
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ClassRetailMainMobile(
                                                            fromsaved: widget
                                                                .fromsaved,
                                                            pscd: widget
                                                                .outletcd!,
                                                            trno: nexttrno,
                                                            outletinfo: widget
                                                                .outletinfo!,
                                                            qty: 0,
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        } else {
                                          print('masih ada OT');

                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ClassRetailMainMobile(
                                                            fromsaved: false,
                                                            pscd: widget
                                                                .outletcd!,
                                                            trno: widget.trno,
                                                            outletinfo: widget
                                                                .outletinfo!,
                                                            qty: 0,
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        }
                                      });
                                    } else {
                                      await updateTrno();
                                      await ClassApi.cleartable(
                                          dbname, widget.trno);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.remove("savecostmrs");

                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClassRetailMainMobile(
                                                    fromsaved: false,
                                                    pscd: widget.outletcd!,
                                                    trno: nexttrno,
                                                    outletinfo:
                                                        widget.outletinfo!,
                                                    qty: 0,
                                                  )),
                                          (Route<dynamic> route) => false);
                                    }
                                  }
                                });
                              },
                              name: 'Transaksi baru',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          Center(
            child: Opacity(
              opacity: loading ? 1.0 : 0,
              child: Container(
                color: Colors.grey,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      'Sending email',
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
