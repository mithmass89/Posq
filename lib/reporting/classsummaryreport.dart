import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/cashiersummary.dart';
import 'package:posq/reporting/classdetailpenjualan2mobile.dart';
import 'package:posq/reporting/classlaporanmobile.dart';
import 'package:posq/reporting/classlistoutlet.dart';
import 'package:posq/reporting/classringkasancombine.dart';
import 'package:posq/reporting/detailcondimentmobile.dart';
import 'package:posq/reporting/detailitemterjaulmobile.dart';
import 'package:posq/reporting/marginitemcost.dart';
import 'package:posq/reporting/refundtransaksi.dart';
import 'package:posq/setting/printer/cashiersummary.dart';
import 'package:posq/setting/printer/classprinterBluetooth.dart';
import 'package:posq/setting/printer/classprinterbillpayment.dart';
import 'package:posq/setting/printer/classprintpengeluarang.dart';
import 'package:posq/userinfo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodA);
PrintSmallCashierSummary? cashiersummary;

class ClassSummaryReport extends StatefulWidget {
  final String user;
  const ClassSummaryReport({Key? key, required this.user}) : super(key: key);

  @override
  State<ClassSummaryReport> createState() => _ClassSummaryReportMobState();
}

class _ClassSummaryReportMobState extends State<ClassSummaryReport> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formatter2 = DateFormat('dd-MMM-yyyy');
  var formaterprd = DateFormat('yyyyMM');
  String? formattedDate;
  String? formatdate;
  String? periode;
  late DatabaseHandler handler;
  String? fromdate;
  String? todate;
  String? fromdatenamed;
  String? todatenamed;
  String? today;
  final TextEditingController _controllerdate = TextEditingController();
  final TextEditingController _controllerpilihan =
      TextEditingController(text: "Pilih tipe report");
  final TextEditingController outlet =
      TextEditingController(text: "All Outlet");
  String query = '';
  String type = '';
  List<dynamic>? outletdata = [];
  int myIndex = 0;
  String selected = '';
  late void Function() myMethod;
  late void Function() ringkasan;
  late void Function() ringkasancombine;
  late void Function() detailmenu;
  late void Function() detailmenu2;
  late void Function() refund;
  late void Function() marginitem;
  late void Function() condiment;
  List<IafjrnhdClass> listdatapayment = [];
  List<dynamic> cashflow = [];
  List<dynamic> otherpayment = [];
  List<dynamic> condiments = [];
  List<dynamic> itemsold = [];
  List<dynamic> ringkasanpenjualan = [];
  List<dynamic> detailpengeluaran = [];
  List<CombineDataRingkasan> data = [];
  var wsUrl;
  WebSocketChannel? channel;
  bool buttonprint = false;
  PrintSmallCashierSummary cashiersummary = PrintSmallCashierSummary();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool connected = false;
  String logourl = '';
  String header = '';
  String footer = '';

  checkPrinter() async {
    connected = await bluetooth.isConnected.then((value) => value!);
    setState(() {});
    print(connected);
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

  CLosingCashier() async {
    cashflow = await ClassApi.ClosingCashFlow(fromdate!, todate!, dbname, '');
    otherpayment =
        await ClassApi.ClosingOtherPayment(fromdate!, todate!, dbname, '');
    condiments =
        await ClassApi.CLosingCondiment(fromdate!, todate!, dbname, '');
    itemsold = await ClassApi.DetailMenuWithSize(
      fromdate!,
      todate!,
      dbname,
    );
    ringkasanpenjualan =
        await ClassApi.getReportRingkasan(fromdate!, todate!, dbname, '');
    detailpengeluaran = await ClassApi.getDetail_transaksiCashierSummary(
        fromdate!, usercd, dbname);
    print('ini detail pengeluaran $detailpengeluaran');
  }

  void initState() {
    super.initState();
    checkPrinter();
    wsUrl = Uri.parse('ws://$ip:8080?property=$dbname');
    channel = WebSocketChannel.connect(wsUrl);
    channel!.stream.listen((message) {
      if (type == 'Summary Cashier') {
        myMethod.call();
      } else if (type == 'Ringkasan') {
        ringkasan.call();
      } else if (type == 'Ringkasan Combine') {
        ringkasancombine.call();
      } else if (type == 'Detail Item Terjual') {
        detailmenu.call();
      } else if (type == 'Refund transaksi') {
        refund.call();
      } else if (type == 'Margin Item') {
        marginitem.call();
      }
      if (outletdata![0]['outletdesc'] == 'All Outlet') {
        // outletdata = [];
      }
    });
    type = 'Summary Cashier';
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    periode = formaterprd.format(now);
    startDate();
    _controllerpilihan.text = 'Summary Cashier';
    fromdatenamed = formattedDate;
    todatenamed = formattedDate;
    today = formatdate;
    _controllerdate.text = '$fromdatenamed - $todatenamed';

    selected = 'Hari ini';
    checkButton();
  }

  startDate() async {
    setState(() {
      fromdate = formatdate;
      todate = formatdate;
    });
    await CLosingCashier();
    // print("ini formatdate sql $formatdate");
    // print("ini from date$fromdate");
    // print("ini todate $todate");
  }

  @override
  void dispose() {
    super.dispose();
    channel!.sink.close();
  }

  checkButton() {
    if (type == 'Summary Cashier') {
      buttonprint = true;
    } else if (type == 'Detail Item Terjual') {
      buttonprint = true;
    } else {
      buttonprint = false;
    }
    setState(() {});
  }

/////fungsi pengambilan tanggal////
  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
        saveText: 'Done',
        context: context,
        // initialDate: now,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2201));
    if (result != null) {
      // Rebuild the UI
      // print(result.start.toString());

      setState(() {
        ///tanggal dan nama
        fromdatenamed = formatter2.format(result.start);
        todatenamed = formatter2.format(result.end);

        ///tanggal format database///
        fromdate = formatter.format(result.start);
        todate = formatter.format(result.end);
        _controllerdate.text = '$fromdatenamed - $todatenamed';
      });
    }
    // getDataReport();
  }

  getDataReport() async {
    //mengambil data list payment cashier summary//
    await ClassApi.getCashierSummary(fromdate!, todate!, dbname).then((value) {
      setState(() {
        listdatapayment = value;
      });
      // print('Data harusnya terisi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Laporan'),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFieldMobileButton(
                      suffixicone: Icon(Icons.date_range),
                      controller: _controllerdate,
                      onChanged: (value) {},
                      ontap: () async {
                        await _selectDate(context);
                        if (type == 'Summary Cashier') {
                          myMethod.call();
                        } else if (type == 'Ringkasan') {
                          ringkasan.call();
                        } else if (type == 'Ringkasan Combine') {
                          ringkasancombine.call();
                        } else if (type == 'Refund transaksi') {
                          refund.call();
                        } else if (type == 'Detail Item Terjual') {
                          detailmenu.call();
                        } else if (type == 'Detail Item Terjual2') {
                          detailmenu2.call();
                        } else if (type == 'Margin Item') {
                          marginitem.call();
                        } else if (type == 'Detail condiment') {
                          condiment.call();
                        }

                        if (outletdata![0]['outletdesc'] == 'All Outlet') {
                          outletdata = [];
                        }
                        checkButton();
                        setState(() {});
                      },
                      typekeyboard: TextInputType.text,
                    ),
                  ),
                  Expanded(
                    child: TextFieldMobileButton(
                      suffixicone: Icon(Icons.arrow_circle_right),
                      controller: outlet,
                      onChanged: (value) {},
                      ontap: () async {
                        outletdata = [];
                        outletdata = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ClassPilihOutletMobile();
                        }));
                        outlet.text = outletdata![0]['outletdesc'];
                        if (type == 'Summary Cashier') {
                          myMethod.call();
                        } else if (type == 'Ringkasan') {
                          ringkasan.call();
                        } else if (type == 'Ringkasan Combine') {
                          ringkasancombine.call();
                        } else if (type == 'Refund transaksi') {
                          refund.call();
                        } else if (type == 'Detail Item Terjual') {
                          detailmenu.call();
                        } else if (type == 'Detail Item Terjual2') {
                          detailmenu2.call();
                        } else if (type == 'Margin Item') {
                          marginitem.call();
                        } else if (type == 'Detail condiment') {
                          condiment.call();
                        }
                        if (outletdata![0]['outletdesc'] == 'All Outlet') {
                          outletdata = [];
                        }
                        getDataReport();
                        checkButton();
                        // print('ini selcted outlet $outletdata');
                        setState(() {});
                      },
                      typekeyboard: TextInputType.text,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFieldMobileButton(
                suffixicone: Icon(Icons.arrow_drop_down_outlined),
                controller: _controllerpilihan,
                onChanged: (value) {},
                ontap: () async {
                  type = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return ClassLaporanMobile();
                  }));
                  _controllerpilihan.text = type;
                  getDataReport();
                  // print(type);
                  if (type == 'Summary Cashier') {
                    myMethod.call();
                  } else if (type == 'Ringkasan') {
                    ringkasan.call();
                  } else if (type == 'Ringkasan Combine') {
                    ringkasancombine.call();
                  } else if (type == 'Refund transaksi') {
                    refund.call();
                  } else if (type == 'Detail Item Terjual2') {
                    detailmenu2.call();
                  } else if (type == 'Detail Item Terjual') {
                    detailmenu.call();
                  } else if (type == 'Margin Item') {
                    marginitem.call();
                  } else if (type == 'Detail condiment') {
                    condiment.call();
                  }
                  if (outletdata![0]['outletdesc'] == 'All Outlet') {
                    outletdata = [];
                  }
                  checkButton();
                  setState(() {});
                },
                typekeyboard: TextInputType.text,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonNoIcon2(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: selected == 'Hari ini'
                        ? Colors.white
                        : Color.fromARGB(255, 0, 116, 131),
                    textcolor: selected == 'Hari ini'
                        ? Color.fromARGB(255, 0, 116, 131)
                        : Colors.white,
                    name: 'Hari ini',
                    onpressed: () {
                      selected = 'Hari ini';
                      fromdatenamed = formatter2.format(now);
                      todatenamed = formatter2.format(now);
                      formatdate = formatter.format(now);
                      fromdate = formatdate;
                      todate = formatdate;
                      _controllerdate.text = '$fromdatenamed - $todatenamed';
                      setState(() {});
                      if (type == 'Summary Cashier') {
                        myMethod.call();
                      } else if (type == 'Ringkasan') {
                        ringkasan.call();
                      } else if (type == 'Ringkasan Combine') {
                        ringkasancombine.call();
                      } else if (type == 'Refund transaksi') {
                        refund.call();
                      } else if (type == 'Detail Item Terjual2') {
                        detailmenu2.call();
                      } else if (type == 'Detail Item Terjual') {
                        detailmenu.call();
                      } else if (type == 'Margin Item') {
                        marginitem.call();
                      } else if (type == 'Detail condiment') {
                        condiment.call();
                      }
                      if (outletdata![0]['outletdesc'] == 'All Outlet') {
                        outletdata = [];
                      }
                      checkButton();
                      setState(() {});
                    },
                  ),
                  ButtonNoIcon2(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: selected == '7 Hari'
                        ? Colors.white
                        : Color.fromARGB(255, 0, 116, 131),
                    textcolor: selected == '7 Hari'
                        ? Color.fromARGB(255, 0, 116, 131)
                        : Colors.white,
                    name: '7 Hari',
                    onpressed: () {
                      var weeks;
                      selected = '7 Hari';
                      formatdate = formatter.format(now);
                      weeks = formatter.format(now.add((Duration(days: -6))));
                      fromdate = weeks;
                      todate = formatdate;
                      fromdatenamed =
                          formatter2.format(now.add((Duration(days: -6))));
                      todatenamed = formatter2.format(now);
                      formatdate =
                          formatter.format(now.add((Duration(days: -6))));

                      _controllerdate.text = '$fromdatenamed - $todatenamed';
                      setState(() {});
                      if (type == 'Summary Cashier') {
                        myMethod.call();
                      } else if (type == 'Ringkasan') {
                        ringkasan.call();
                      } else if (type == 'Ringkasan Combine') {
                        ringkasancombine.call();
                      } else if (type == 'Refund transaksi') {
                        refund.call();
                      } else if (type == 'Detail Item Terjual2') {
                        detailmenu2.call();
                      } else if (type == 'Detail Item Terjual') {
                        detailmenu.call();
                      } else if (type == 'Margin Item') {
                        marginitem.call();
                      } else if (type == 'Detail condiment') {
                        condiment.call();
                      }
                      if (outletdata![0]['outletdesc'] == 'All Outlet') {
                        outletdata = [];
                      }
                      checkButton();
                      setState(() {});
                    },
                  ),
                  ButtonNoIcon2(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: selected == '30 Hari'
                        ? Colors.white
                        : Color.fromARGB(255, 0, 116, 131),
                    textcolor: selected == '30 Hari'
                        ? Color.fromARGB(255, 0, 116, 131)
                        : Colors.white,
                    name: '30 Hari',
                    onpressed: () {
                      var month;
                      selected = '30 Hari';
                      formatdate = formatter.format(now);
                      month = formatter.format(now.add((Duration(days: -30))));
                      fromdate = month;
                      todate = formatdate;
                      fromdatenamed =
                          formatter2.format(now.add((Duration(days: -30))));
                      todatenamed = formatter2.format(now);
                      _controllerdate.text = '$fromdatenamed - $todatenamed';
                      setState(() {});
                      if (type == 'Summary Cashier') {
                        myMethod.call();
                      } else if (type == 'Ringkasan') {
                        ringkasan.call();
                      } else if (type == 'Ringkasan Combine') {
                        ringkasancombine.call();
                      } else if (type == 'Refund transaksi') {
                        refund.call();
                      } else if (type == 'Detail Item Terjual2') {
                        detailmenu2.call();
                      } else if (type == 'Detail Item Terjual') {
                        detailmenu.call();
                      } else if (type == 'Margin Item') {
                        marginitem.call();
                      } else if (type == 'Detail condiment') {
                        condiment.call();
                      }
                      if (outletdata![0]['outletdesc'] == 'All Outlet') {
                        outletdata = [];
                      }
                      checkButton();
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              type == 'Summary Cashier'
                  ? CashierSummary(
                      builder: (BuildContext context, void Function() methodA) {
                        myMethod = methodA;
                      },
                      listoutlets: outletdata!.isEmpty
                          ? listoutlets
                          : List.generate(outletdata!.length,
                              (index) => outletdata![index]['outletcode']),
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container(),
              type == 'Ringkasan'
                  ? ClassRingkasanAll(
                      listoutlets: outletdata!.isEmpty
                          ? listoutlets
                          : List.generate(outletdata!.length,
                              (index) => outletdata![index]['outletcode']),
                      data: data,
                      builder: (BuildContext context, void Function() methodA) {
                        ringkasan = methodA;
                      },
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container(),
              type == 'Detail Item Terjual'
                  ? DetailMenuTerjualMobile(
                      listoutlets: outletdata!.isEmpty
                          ? listoutlets
                          : List.generate(outletdata!.length,
                              (index) => outletdata![index]['outletcode']),
                      builder: (BuildContext context, void Function() methodA) {
                        detailmenu = methodA;
                      },
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container(),
              type == 'Detail Item Terjual2'
                  ? DetailMenuTerjual2Mobile(
                      listoutlets: outletdata!.isEmpty
                          ? listoutlets
                          : List.generate(outletdata!.length,
                              (index) => outletdata![index]['outletcode']),
                      builder: (BuildContext context, void Function() methodA) {
                        detailmenu2 = methodA;
                      },
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container(),
              type == 'Detail condiment'
                  ? DetailCondimentTerjualMobile(
                      listoutlets: outletdata!.isEmpty
                          ? listoutlets
                          : List.generate(outletdata!.length,
                              (index) => outletdata![index]['outletcode']),
                      builder: (BuildContext context, void Function() methodA) {
                        condiment = methodA;
                      },
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container(),
              type == 'Refund transaksi'
                  ? RefundTransaksi(
                      listoutlets: outletdata!.isEmpty
                          ? listoutlets
                          : List.generate(outletdata!.length,
                              (index) => outletdata![index]['outletcode']),
                      builder: (BuildContext context, void Function() methodA) {
                        refund = methodA;
                      },
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container(),
              type == 'Margin Item'
                  ? GrossMarginItem(
                      listoutlets: outletdata!.isEmpty
                          ? listoutlets
                          : List.generate(outletdata!.length,
                              (index) => outletdata![index]['outletcode']),
                      builder: (BuildContext context, void Function() methodA) {
                        marginitem = methodA;
                      },
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container()
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.0,
            bottom: MediaQuery.of(context).size.height * 0.01,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 0.2,
              child: buttonprint == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonNoIcon2(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: Colors.white,
                            textcolor: Colors.orange,
                            name: 'Print',
                            onpressed: () async {
                              if (connected == true) {
                                await cashiersummary.prints(
                                    cashflow,
                                    otherpayment,
                                    condiments,
                                    itemsold,
                                    ringkasanpenjualan,
                                    detailpengeluaran,
                                    outlet.text,
                                    '',
                                    today!);
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ClassBluetoothPrinter();
                                }));
                                checkPrinter();
                              }
                            }),
                        ButtonNoIcon2(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.05,
                          color: Colors.orange,
                          textcolor: Colors.white,
                          name: 'Kirim Laporan',
                          onpressed: () {
                            Fluttertoast.showToast(
                                msg: "Segera hadir",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(255, 11, 12, 14),
                                textColor: Colors.white,
                                fontSize: 16.0);
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(builder: (BuildContext context) {
                            //   return ClassKirimLaporan(
                            //     datapayment: listdatapayment,
                            //   );
                            // }));
                          },
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
