import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/reporting/cashiersummary.dart';
import 'package:posq/reporting/classkirimlaporan.dart';
import 'package:posq/reporting/classlaporanmobile.dart';
import 'package:posq/reporting/classringkasan.dart';
import 'package:toast/toast.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodA);

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
  final TextEditingController _controllerdate = TextEditingController();
  final TextEditingController _controllerpilihan =
      TextEditingController(text: "Pilih tipe report");
  DateTimeRange? _selectedDateRange;
  String query = '';
  String type = '';
  int myIndex = 0;
  String selected = '';
  late void Function() myMethod;
  late void Function() ringkasan;
  List<IafjrnhdClass> listdatapayment = [];

  void initState() {
    super.initState();
    type = 'Summary Cashier';
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    periode = formaterprd.format(now);
    startDate();
    handler = DatabaseHandler();
    _controllerpilihan.text = 'Summary Cashier';
    fromdatenamed = formattedDate;
    todatenamed = formattedDate;
    _controllerdate.text = '$fromdatenamed - $todatenamed';
    ToastContext().init(context);
    selected = 'Hari ini';
  }

  startDate() {
    setState(() {
      fromdate = formatdate;
      todate = formatdate;
    });
    print("ini formatdate sql $formatdate");
    print("ini from date$fromdate");
    print("ini todate $todate");
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
        _selectedDateRange = result;

        ///tanggal dan nama
        fromdatenamed = formatter2.format(result.start);
        todatenamed = formatter2.format(result.end);

        ///tanggal format database///
        fromdate = formatter.format(result.start);
        todate = formatter.format(result.end);
        _controllerdate.text = '$fromdatenamed - $todatenamed';
      });
    }
    getDataReport();
  }

  getDataReport() {
    //mengambil data list payment cashier summary//
    handler.cashierSummaryDetail(query, fromdate!, todate!).then((value) {
      setState(() {
        listdatapayment = value;
      });
      print('Data harusnya terisi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan'),
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: [
          Column(
            children: [
              TextFieldMobileButton(
                suffixicone: Icon(Icons.date_range),
                controller: _controllerdate,
                onChanged: (value) {},
                ontap: () async {
                  await _selectDate(context);
                },
                typekeyboard: TextInputType.text,
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
                  setState(() {
                    _controllerpilihan.text = type;
                  });
                  getDataReport();
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
                    color: selected == 'Hari ini' ? Colors.white : Colors.blue,
                    textcolor:
                        selected == 'Hari ini' ? Colors.blue : Colors.white,
                    name: 'Hari ini',
                    onpressed: () {
                      setState(() {
                        selected = 'Hari ini';
                        fromdatenamed = formatter2.format(now);
                        todatenamed = formatter2.format(now);
                        formatdate = formatter.format(now);
                        fromdate = formatdate;
                        todate = formatdate;
                        _controllerdate.text = '$fromdatenamed - $todatenamed';
                      });

                      myMethod.call();
                      if (type == 'Ringkasan') {
                        ringkasan.call();
                      }
                    },
                  ),
                  ButtonNoIcon2(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: selected == '7 Hari' ? Colors.white : Colors.blue,
                    textcolor:
                        selected == '7 Hari' ? Colors.blue : Colors.white,
                    name: '7 Hari',
                    onpressed: () {
                      var weeks;
                      setState(() {
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
                      });
                      myMethod.call();
                      if (type == 'Ringkasan') {
                        ringkasan.call();
                      }
                    },
                  ),
                  ButtonNoIcon2(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: selected == '30 Hari' ? Colors.white : Colors.blue,
                    textcolor:
                        selected == '30 Hari' ? Colors.blue : Colors.white,
                    name: '30 Hari',
                    onpressed: () {
                      var month;
                      setState(() {
                        selected = '30 Hari';
                        formatdate = formatter.format(now);
                        month =
                            formatter.format(now.add((Duration(days: -30))));
                        fromdate = month;
                        todate = formatdate;
                        fromdatenamed =
                            formatter2.format(now.add((Duration(days: -30))));
                        todatenamed = formatter2.format(now);

                        _controllerdate.text = '$fromdatenamed - $todatenamed';
                      });

                      myMethod.call();
                      if (type == 'Ringkasan') {
                        ringkasan.call();
                      }
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
                      fromdate: fromdate!,
                      todate: todate!,
                    )
                  : Container(),
              type == 'Ringkasan'
                  ? ClassRingkasan(
                      builder: (BuildContext context, void Function() methodA) {
                        ringkasan = methodA;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonNoIcon2(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: Colors.white,
                    textcolor: Colors.blue,
                    name: 'Print',
                    onpressed: () {},
                  ),
                  ButtonNoIcon2(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: Colors.blue,
                    textcolor: Colors.white,
                    name: 'Kirim Laporan',
                    onpressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ClassKirimLaporan(
                          datapayment: listdatapayment,
                        );
                      }));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
