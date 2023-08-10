import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
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
  List total = [];
  num? totals = 0;
  num? endings = 0;
  late ScrollController _scrollController;

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
    checkAmount();
    getDataDetail();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  checkAmount() async {
    await ClassApi.checkOpen_cashier(formatdate!, usercd, dbname).then((value) {
      data = value;
      if (value.isNotEmpty) {
        total.add(data.first!.amount);
      }
    });

    setState(() {});
  }

  getDataDetail() async {
    total =
        await ClassApi.getDetail_transaksiCashier(formatdate!, usercd, dbname);
    if (total.isNotEmpty) {
      totals =
          total.fold(0.0, (sum, transaction) => sum! + transaction['lamount']);
    }

    if (data.isNotEmpty) {
      endings = data[0]!.amount! + totals!;
    }

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
                        dbname);
                    print('Entered Amount: $enteredAmount');
                    Navigator.pop(context);
                  }
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
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
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
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.lock_clock),
            label: 'Close kasir',
            onTap: () async {
              _showModalAmountDialog(context);
              await getDataDetail();
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
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
        title: Text('Pengeluaran'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: TextFieldMobileButton(
                suffixicone: Icon(Icons.date_range),
                controller: _controllerdate,
                onChanged: (value) {},
                ontap: () async {
                  await _selectDate(context);
                },
                typekeyboard: TextInputType.text,
              ),
            ),
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
              height: MediaQuery.of(context).size.height * 0.65,
              child: FutureBuilder(
                  future: ClassApi.getDetail_transaksiCashier(
                      formatdate!, usercd, dbname),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var datax = snapshot.data;
                      return ListView.builder(
                          controller: _scrollController,
                          itemCount: datax.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                datax[index]['description'] != ''
                                    ? ListTile(
                                        dense: true,
                                        title:
                                            Text(datax[index]['description']),
                                        trailing: Text(
                                          CurrencyFormat.convertToIdr(
                                              datax[index]!['lamount'], 0),
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
            Expanded(
                child: ListTile(
              title: Text(
                'Saldo Akhir : ${CurrencyFormat.convertToIdr(endings, 0)}',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
