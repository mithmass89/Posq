// ignore_for_file: unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/printer/cashiersummary.dart';
import 'package:posq/userinfo.dart';

class PengeluaranUang extends StatefulWidget {
  const PengeluaranUang({Key? key}) : super(key: key);

  @override
  State<PengeluaranUang> createState() => _PengeluaranUangState();
}

class _PengeluaranUangState extends State<PengeluaranUang> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formatter2 = DateFormat('dd-MMM-yyyy');
  var formaterprd = DateFormat('yyyyMM');
  String? formattedDate;
  String? formatdate;
  final TextEditingController _controllerdate = TextEditingController();
  String? fromdatenamed;
  String? todatenamed;
  String? fromdate;
  String? todate;
  String? today;
  List<OpenCashier?> data = [OpenCashier(amount: 0, type: 'OPEN')];
  List<OpenCashier?> dataclose = [OpenCashier(amount: 0, type: 'CLOSE')];
  List total = [];
  num? totals = 0;
  num? endings = 0;
  num totalpengeluaran = 0;
  late ScrollController _scrollController;
  PrintSmallCashierSummary cashiersummary = PrintSmallCashierSummary();

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

  @override
  void initState() {
    super.initState();
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    fromdatenamed = formattedDate;
    todatenamed = formattedDate;
    today = formatdate;
    _controllerdate.text = '$fromdatenamed - $todatenamed';
    checkAmountOpening();
    checkAmountCLosing();
    totalexpense();
    getDataDetail();
    _scrollController = ScrollController();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
  }

  checkalldata() async {
    await checkAmountOpening();
    await checkAmountCLosing();
    await totalexpense();
    await getDataDetail();
    await getEnding();
    setState(() {});
  }

  checkAmountOpening() async {
    await ClassApi.checkOpen_cashier(formatdate!, usercd, dbname).then((value) {
      data = value;
      if (value.isNotEmpty) {
        total.add(data.first!.amount);
      }
    });

    setState(() {});
  }

  totalexpense() async {
    await ClassApi.totalpengeluaranCashier(formatdate!, usercd, dbname)
        .then((value) {
      if (value.isNotEmpty) {
        totalpengeluaran = value[0]['total'];
      }
    });
    setState(() {});
  }

  checkAmountCLosing() async {
    await ClassApi.checkCloseCashier(formatdate!, usercd, dbname).then((value) {
      if (value.isNotEmpty) {
        dataclose = value;
      }
    });

    setState(() {});
  }

  getEnding() async {
    await ClassApi.getSummary_transaksiCashierSummary(
            formatdate!, usercd, dbname)
        .then((value) {
      endings = value.first['amount'];
      setState(() {});
    });
  }

  getDataDetail() async {
    total =
        await ClassApi.getDetail_transaksiCashier(formatdate!, usercd, dbname);
    if (total.isNotEmpty) {
      totals =
          total.fold(0.0, (sum, transaction) => sum! + transaction['lamount']);
    }
    await totalexpense();

    endings = data.isNotEmpty
        ? data[0]!.amount!
        : 0 + (total.isNotEmpty ? totals! : 0) - dataclose[0]!.amount!;
    closingending = endings!;
    await getEnding();
    setState(() {});
  }

  checkOpenCashier() async {
    await ClassApi.checkOpen_cashier(formatdate!, usercd, dbname).then((value) {
      print(value);
      if (value.isNotEmpty) {
        if (value.last.type == 'OPEN') {
          opencashier = true;
        } else {
          opencashier = false;
        }
      } else {
        opencashier = false;
      }
    });
    setState(() {});
  }

  void _showModalAmountDialog(BuildContext context) {
    TextEditingController _amountController =
        TextEditingController(text: endings.toString());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Close Kasir'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Setor modal'),
                TextFormField(
                  readOnly: true,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Submit'),
                onPressed: () async {
                  // Process the entered amount here
                  if (_amountController.text.isNotEmpty) {
                    double enteredAmount = endings!.toDouble();
                    await ClassApi.insertOpenCashier(
                            OpenCashier(
                                type: 'CLOSE',
                                trdt: today,
                                amount: endings,
                                usercd: usercd),
                            dbname)
                        .whenComplete(() async {
                      EasyLoading.show(status: 'loading...');
                      await checkOpenCashier();
                      await checkalldata();
                      EasyLoading.dismiss();
                    });
                    print('Entered Amount: $enteredAmount');
                    opencashier = false;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Dashboard', (Route<dynamic> route) => false);
                  }
                },
              ),
            ],
          );
        });
  }

  void _showcancelClose(BuildContext context) {
    _submitForm() async {
      EasyLoading.show(status: 'loading...');
      await ClassApi.cancelClosing(formatdate!, usercd, dbname);
      await getDataDetail();
      EasyLoading.dismiss();
      Navigator.of(context).pop(true); // Tutup dialog setelah selesai
      Navigator.pop(context);
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancel Close'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Submit'),
                onPressed: () async {
                  // Process the entered amount here

                  _submitForm();
                  await getDataDetail();
                  await checkalldata();

                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SpeedDial(
        // Properti untuk konfigurasi SpeedDial
        child: Icon(Icons.menu),
        onPress: () {
          // Aksi ketika tombol utama ditekan
          print('Main FAB Pressed');
        },
        children: [
          SpeedDialChild(
            child: Icon(Icons.remove),
            label: 'Pengeluaran',
            onTap: () async {
              var x = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogForm(
                    trdt: formatdate!,
                  );
                },
              );
              await getDataDetail();
              checkalldata();
              setState(() {});
              // Aksi ketika tombol anak ditekan
              print('Camera FAB Pressed');
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Penambahan',
            onTap: () async {
              var x = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogFormTambahModal(
                    trdt: formatdate!,
                  );
                },
              );
              await getDataDetail();
              await checkalldata();
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.lock_clock),
            label: 'Close kasir',
            onTap: () async {
              _showModalAmountDialog(context);
              await getDataDetail();
              await checkalldata();
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.print_rounded),
            label: 'Print',
            onTap: () async {
              setState(() {});
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Pengeluaran',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Builder(builder: (context) {
            return Column(
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.08,
                //   child: TextFieldMobileButton(
                //     suffixicone: Icon(Icons.date_range),
                //     controller: _controllerdate,
                //     onChanged: (value) {},
                //     ontap: () async {
                //       await _selectDate(context);
                //     },
                //     typekeyboard: TextInputType.text,
                //   ),
                // ),
                ListTile(
                  title: Text(
                    'Modal Awal',
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    CurrencyFormat.convertToIdr(
                        data.isNotEmpty ? data[0]!.amount : 0, 0),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: FutureBuilder(
                      future: ClassApi.getDetail_transaksiCashier(
                          formatdate!, usercd, dbname),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var datax = snapshot.data;
                          print('ini data detail $datax');
                          return ListView.builder(
                              controller: _scrollController,
                              itemCount: datax.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    datax[index]['description'] != ''
                                        ? ListTile(
                                            dense: true,
                                            title: Text(
                                              datax[index]['description'],
                                              style: TextStyle(
                                                  color: datax[index]
                                                              ['type_tr'] ==
                                                          '1040'
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                            trailing: Text(
                                              CurrencyFormat.convertToIdr(
                                                  datax[index]!['lamount'], 0),
                                              style: TextStyle(
                                                  color: datax[index]
                                                              ['type_tr'] ==
                                                          '1040'
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                          )
                                        : Container(),
                                    Divider(
                                      indent: 20,
                                      endIndent: 20,
                                    )
                                  ],
                                );
                              });
                        }
                      }),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'total pengeluaran : ${CurrencyFormat.convertToIdr(totalpengeluaran, 0)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () async {
                      _showcancelClose(context);
                      await getDataDetail();
                      await checkalldata();
                      setState(() {});
                    },
                    title: Text(
                      'Setoran closing : ${CurrencyFormat.convertToIdr(dataclose.isNotEmpty ? dataclose[0]!.amount : 0, 0)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Saldo Akhir : ${CurrencyFormat.convertToIdr(endings, 0)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
