// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, prefer_generic_function_type_aliases, avoid_print, must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classpaymentsuccessmobile.dart';
import 'package:posq/classui/searchwidget.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/classcategorylist.dart';
import 'package:posq/setting/classcreatecategorymobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogClass1 extends StatefulWidget {
  const DialogClass1({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogClass1> createState() => _DialogClass1State();
}

class _DialogClass1State extends State<DialogClass1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ButtonNoIcon(
                      name: 'Revenue',
                      onpressed: () async {},
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  children: [
                    ButtonNoIcon(
                      name: 'Cover',
                      onpressed: () async {},
                    ),
                  ],
                )
              ],
            )),
        title: Text('Choose Catagory'),
        actions: <Widget>[
          // InkWell(
          //   child: Text('OK   '),
          //   onTap: () {
          //     if (_formKey.currentState!.validate()) {
          //       // Do something like updating SharedPreferences or User Settings etc.
          //       Navigator.of(context).pop();
          //     }
          //   },
          // ),
        ],
      );
    });
  }
}

class DialogCustomerManual extends StatefulWidget {
  const DialogCustomerManual({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogCustomerManual> createState() => _DialogCustomerManualState();
}

class _DialogCustomerManualState extends State<DialogCustomerManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllername = TextEditingController();
  final TextEditingController controlleremail = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkSF();
  }

  checkSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String guestPref = prefs.getString('savecostmrs') ?? "";

    Map<String, dynamic> userMap =
        jsonDecode(guestPref) as Map<String, dynamic>;
    setState(() {
      controllername.text = userMap['guestname'];
      controlleremail.text = userMap['email'];
    });
  }

  getSf() async {
    Map<String, dynamic> user = {
      'guestname': controllername.text,
      'email': controlleremail.text
    };
    final savecostmrs = await SharedPreferences.getInstance();
    await savecostmrs.setString('savecostmrs', jsonEncode(user));
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Form(
              key: _formKey,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldMobile2(
                      label: 'Guest Name',
                      controller: controllername,
                      onChanged: (String value) {},
                      typekeyboard: TextInputType.text,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    TextFieldMobile2(
                      label: 'Email',
                      controller: controlleremail,
                      onChanged: (String value) {},
                      typekeyboard: TextInputType.text,
                    ),
                  ])),
          title: Text('Guest info'),
          actions: [
            ButtonNoIcon(
              textcolor: Colors.white,
              name: "Save",
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.2,
              onpressed: () async {
                await getSf();
                Navigator.of(context).pop();
              },
            )
          ]);
    });
  }
}

class DialogCustomerList extends StatefulWidget {
  const DialogCustomerList({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogCustomerList> createState() => _DialogCustomerListState();
}

class _DialogCustomerListState extends State<DialogCustomerList> {
  late DatabaseHandler handler;
  String query = '';
  String name = '';
  String email = '';
  final search = TextEditingController();
  int? selected;
  var x;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  getSf(String user, String email) async {
    Map<String, dynamic> user = {'guestname': name, 'email': email};
    final savecostmrs = await SharedPreferences.getInstance();
    await savecostmrs.setString('savecostmrs', jsonEncode(user));
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: FutureBuilder(
              future: handler.retrieveListCustomers(query),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Costumers>> snapshot) {
                x = snapshot.data ?? [];
                if (x.isNotEmpty) {
                  print(snapshot.data);
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SearchWidgetSmall(
                                label: 'Search',
                                controller: search,
                                onChanged: (value) {
                                  setState(() {
                                    query = value;
                                  });
                                }),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          selected = index;
                                          name = snapshot.data![index].compdesc
                                              .toString();
                                          email = snapshot.data![index].email
                                              .toString();
                                        });
                                        print(index);
                                      },
                                      dense: true,
                                      visualDensity: VisualDensity(
                                          vertical: -1), // to compact
                                      title: Text(
                                        snapshot.data![index].compdesc
                                            .toString(),
                                        style: TextStyle(
                                            color: index == selected
                                                ? Colors.blue
                                                : Colors.black),
                                      ),
                                      subtitle: Text(
                                        snapshot.data![index].email.toString(),
                                        style: TextStyle(
                                            color: index == selected
                                                ? Colors.blue
                                                : Colors.black),
                                      ),
                                    ),
                                    Divider()
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                      child: Text('Tidak ada data pelanggan'),
                    ),
                  );
                }
              },
            ),
          ),
          title: Text('Pilih Pelanggan'),
          actions: [
            x != null
                ? ButtonNoIcon(
                    textcolor: Colors.white,
                    name: "Save",
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.2,
                    onpressed: () async {
                      await getSf(name, email);
                      Navigator.of(context).pop();
                    },
                  )
                : ButtonNoIcon(
                    textcolor: Colors.white,
                    name: "Keluar",
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.2,
                    onpressed: () async {
                      Navigator.of(context).pop();
                    },
                  )
          ]);
    });
  }
}

class DialogTabClass extends StatefulWidget {
  const DialogTabClass({Key? key}) : super(key: key);

  @override
  State<DialogTabClass> createState() => _DialogTabClassState();
}

class _DialogTabClassState extends State<DialogTabClass>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TabController? controller;
  int? index = 0;

  @override
  void initState() {
    controller =
        TabController(vsync: this, length: 2, initialIndex: index!.toInt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Creates border
                      color: Colors.blue), //Change background color from here
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blue,
                  controller: controller,
                  tabs: <Widget>[
                    Tab(
                      text: 'Kategori',
                    ),
                    Tab(
                      text: 'Buat Kategori',
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: TabBarView(
                    controller: controller,
                    children: [
                      CategoryList(
                        controller: controller,
                        index: index,
                      ),
                      Createctg()
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      );
    });
  }
}

class DialogTabArscompClass extends StatefulWidget {
  const DialogTabArscompClass({Key? key}) : super(key: key);

  @override
  State<DialogTabArscompClass> createState() => _DialogTabArscompClassState();
}

class _DialogTabArscompClassState extends State<DialogTabArscompClass>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TabController? controller;
  int? index = 0;

  @override
  void initState() {
    controller =
        TabController(vsync: this, length: 2, initialIndex: index!.toInt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Creates border
                      color: Colors.blue), //Change background color from here
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blue,
                  controller: controller,
                  tabs: <Widget>[
                    Tab(
                      text: 'Kategori',
                    ),
                    Tab(
                      text: 'Buat Kategori',
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: TabBarView(
                    controller: controller,
                    children: [
                      CategoryListArscomp(
                        controller: controller,
                        index: index,
                      ),
                      CreatectgArscomp()
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      );
    });
  }
}

class Telepon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}

class Telepon2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Icon(
              Icons.phone_android,
              size: 90.0,
              color: Colors.lightBlueAccent,
            ),
            Text(
              "PHONE2",
              style: TextStyle(fontSize: 30.0, color: Colors.lightGreen),
            )
          ],
        ),
      ),
    );
  }
}

typedef void StringCallback(IafjrndtClass val);

class DialogClassRetailDesc extends StatefulWidget {
  final TextEditingController controller;
  final typekeyboard;
  final num? result;
  final Outlet outletinfo;
  final StringCallback callback;
  final VoidCallback cleartext;
  final int? itemlenght;
  final String? trno;
  const DialogClassRetailDesc(
      {Key? key,
      required this.controller,
      this.typekeyboard,
      this.result,
      required this.outletinfo,
      required this.callback,
      required this.cleartext,
      this.itemlenght,
      this.trno})
      : super(key: key);

  @override
  State<DialogClassRetailDesc> createState() => _DialogClassRetailDescState();
}

class _DialogClassRetailDescState extends State<DialogClassRetailDesc> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  var formattedDate;
  late IafjrndtClass hasil;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  int? nexttrno;
  int counter = 1;
  int? totalbarang = 0;
  num? amounttotal = 0;
  bool isSwitched = false;
  TextEditingController pcttax = TextEditingController();
  TextEditingController pctservice = TextEditingController();
  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    handler = DatabaseHandler();
    handler.initializeDB();
    handler.getTrno(widget.outletinfo.outletcd).then((value) {
      setState(() {
        nexttrno = value.first.trnonext;
      });
    });
  }

  getDataSlide() async {
    await handler.retrieveDetailIafjrndt(widget.trno.toString()).then((isi) {
      if (isi.isNotEmpty) {
        setState(() {
          totalbarang = isi.length;
          print('total barang collpse $totalbarang');
        });
      } else {
        setState(() {
          totalbarang = 0;
        });
      }

      print('terpanggil');
    });

    await handler.checktotalAmountNett(widget.trno.toString()).then((value) {
      setState(() {
        amounttotal = value.first.nettamt;
      });
    });
  }

  Future<int> insertIafjrndt(day) async {
    IafjrndtClass iafjrndt = IafjrndtClass(
      trdt: formattedDate,
      pscd: widget.outletinfo.outletcd,
      trno: widget.trno,
      split: 'A',
      trnobill: 'trnobill',
      itemcd: widget.controller.text,
      trno1: widget.trno,
      itemseq: widget.itemlenght,
      cono: 'cono',
      waitercd: 'waitercd',
      discpct: 0,
      discamt: 0,
      qty: 1,
      ratecurcd: 'Rupiah',
      ratebs1: 1,
      ratebs2: 1,
      rateamtcost: widget.result!.toDouble(),
      rateamt: widget.result!.toDouble(),
      rateamtservice: pctservice.text != ''
          ? widget.result!.toDouble() * num.parse(pctservice.text) / 100
          : num.parse('0'),
      rateamttax: pcttax.text != ''
          ? widget.result!.toDouble() * num.parse(pcttax.text) / 100
          : num.parse('0'),
      rateamttotal: widget.result!.toDouble(),
      rvnamt: 1 * widget.result!.toDouble(),
      taxamt: pcttax.text != ''
          ? 1 * widget.result!.toDouble() * num.parse(pcttax.text) / 100
          : num.parse('0'),
      serviceamt: pctservice.text != ''
          ? widget.result!.toDouble() * num.parse(pctservice.text) / 100
          : num.parse('0'),
      nettamt: widget.result!.toDouble(),
      rebateamt: 0,
      rvncoa: 'REVENUE',
      taxcoa: 'TAX',
      servicecoa: 'SERVICE',
      costcoa: 'COST',
      active: '1',
      usercrt: 'Admin',
      userupd: 'Admin',
      userdel: 'Admin',
      prnkitchen: '1',
      prnkitchentm: '10:10',
      confirmed: '1',
      trdesc: widget.controller.text,
      taxpct: 0,
      servicepct: 0,
    );
    List<IafjrndtClass> listiafjrndt = [iafjrndt];
    return await handler.insertIafjrndt(listiafjrndt);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: AnimatedContainer(
          height: isSwitched == false
              ? MediaQuery.of(context).size.height * 0.15
              : MediaQuery.of(context).size.height * 0.3,
          duration: Duration(milliseconds: 600),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldMobile2(
                          label: 'Produk',
                          controller: widget.controller,
                          onChanged: (String value) {},
                          typekeyboard: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        title: Text('Deskripsi Produk'),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {
                handler.initializeDB().whenComplete(() async {
                  await insertIafjrndt(formattedDate);
                }).then((_) {
                  handler.retrievetotaltransaksi(widget.trno!).then((value) {
                    setState(() {
                      hasil = IafjrndtClass(
                        trdt: '2022-05-16',
                        pscd: widget.outletinfo.outletcd,
                        trno: widget.trno,
                        split: 'A',
                        trnobill: 'trnobill',
                        itemcd: widget.controller.text,
                        trno1: widget.trno,
                        itemseq: widget.itemlenght,
                        cono: 'cono',
                        waitercd: 'waitercd',
                        discpct: 0,
                        discamt: 0,
                        qty: 1,
                        ratecurcd: 'Rupiah',
                        ratebs1: 1,
                        ratebs2: 1,
                        rateamtcost: widget.result!.toDouble(),
                        rateamt: widget.result!.toDouble(),
                        rateamtservice: 0,
                        rateamttax: 0,
                        rateamttotal: widget.result!.toDouble(),
                        rvnamt: widget.result!.toDouble(),
                        taxamt: 0,
                        serviceamt: 0,
                        nettamt: widget.result!.toDouble(),
                        rebateamt: 0,
                        rvncoa: 'REVENUE',
                        taxcoa: 'TAX',
                        servicecoa: 'SERVICE',
                        costcoa: 'COST',
                        active: '1',
                        usercrt: 'Admin',
                        userupd: 'Admin',
                        userdel: 'Admin',
                        prnkitchen: '1',
                        prnkitchentm: '10:10',
                        confirmed: '1',
                        trdesc: widget.controller.text,
                        taxpct: 0,
                        servicepct: 0,
                      );
                      // ClassRetailMainMobile.of(context)!.string = hasil;
                    });
                  }).then((_) async {
                    await getDataSlide();
                    setState(() {
                      counter++;
                    });
                    Navigator.of(context).pop(IafjrndtClass(
                      trdt: hasil.trdt,
                      pscd: hasil.pscd,
                      trno: hasil.trno,
                      split: hasil.split,
                      trnobill: hasil.trnobill,
                      itemcd: hasil.itemcd,
                      trno1: hasil.trno1,
                      itemseq: hasil.itemseq,
                      cono: hasil.cono,
                      waitercd: hasil.waitercd,
                      discpct: hasil.discpct,
                      discamt: hasil.discamt,
                      qty: hasil.qty,
                      ratecurcd: hasil.ratecurcd,
                      ratebs1: hasil.ratebs1,
                      ratebs2: hasil.ratebs2,
                      rateamtcost: hasil.rateamtcost,
                      rateamt: hasil.rateamt,
                      rateamtservice: hasil.rateamtservice,
                      rateamttax: hasil.rateamttax,
                      rateamttotal: hasil.rateamttotal,
                      rvnamt: hasil.rvnamt,
                      taxamt: hasil.taxamt,
                      serviceamt: hasil.serviceamt,
                      nettamt: hasil.nettamt,
                      rebateamt: hasil.rebateamt,
                      rvncoa: hasil.rvncoa,
                      taxcoa: hasil.taxcoa,
                      servicecoa: hasil.servicecoa,
                      costcoa: hasil.costcoa,
                      active: hasil.active,
                      usercrt: hasil.usercrt,
                      userupd: hasil.userupd,
                      userdel: hasil.userdel,
                      prnkitchen: hasil.prnkitchen,
                      prnkitchentm: hasil.prnkitchentm,
                      confirmed: hasil.confirmed,
                      trdesc: hasil.trdesc,
                    ));
                  });
                  widget.cleartext();
                });
              },
              child: Text(
                'Ok!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      );
    });
  }
}

class DialogClassWillPop extends StatefulWidget {
  final String trno;
  const DialogClassWillPop({
    Key? key,
    required this.trno,
  }) : super(key: key);

  @override
  State<DialogClassWillPop> createState() => _DialogClassWillPopState();
}

class _DialogClassWillPopState extends State<DialogClassWillPop> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  children: [],
                )
              ],
            )),
        title: Text('Anda akan kembali ke modul utama?'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await handler.activeZeroiafjrndttrno(
                    IafjrndtClass(active: '1', trno: widget.trno));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogClassReopen extends StatefulWidget {
  final String trno;
  final Outlet outletinfo;
  final String pscd;

  const DialogClassReopen({
    Key? key,
    required this.trno,
    required this.outletinfo,
    required this.pscd,
  }) : super(key: key);

  @override
  State<DialogClassReopen> createState() => _DialogClassReopenState();
}

class _DialogClassReopenState extends State<DialogClassReopen> {
  late DatabaseHandler handler;
  List<IafjrnhdClass> data = [];
  bool haspayment = false;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
    checkTransaction();
  }

  checkTransaction() {
    handler.retriveListDetailPayment(widget.trno).then((value) {
      if (value.first.pymtmthd != null) {
        setState(() {
          haspayment = true;
        });
      } else {
        setState(() {
          haspayment = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.7,
          child: FutureBuilder(
              future: handler.retrieveDetailIafjrndt(widget.trno),
              builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                var x = snapshot.data ?? [];
                if (x.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                        height: x.length <= 4
                            ? MediaQuery.of(context).size.height *
                                0.06 *
                                double.parse(x.length.toString())
                            : MediaQuery.of(context).size.height * 0.06 * 4,
                        child: ListView.builder(
                            itemCount: x.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    dense: true,
                                    visualDensity:
                                        VisualDensity(vertical: -2), // t
                                    leading:
                                        Text('${x[index].qty.toString()} X'),
                                    title: Text(x[index].trdesc.toString(),
                                        style: TextStyle(fontSize: 14)),
                                    trailing:
                                        Text(x[index].rateamttotal.toString()),
                                  ),
                                  Divider(
                                    height: 2,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                ],
                              );
                            }),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.18,
                          child: FutureBuilder(
                              future: handler.summarybill(widget.trno),
                              builder: (context,
                                  AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                                var x = snapshot.data ?? [];

                                if (x.isNotEmpty) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          visualDensity: VisualDensity(
                                              vertical: -4), // to compact
                                          dense: true,
                                          title: Text('Total'),
                                          trailing:
                                              Text(x.first.rvnamt.toString()),
                                        ),
                                        ListTile(
                                          visualDensity: VisualDensity(
                                              vertical: -4), // to compact
                                          dense: true,
                                          title: Text('Pajak'),
                                          trailing:
                                              Text(x.first.taxamt.toString()),
                                        ),
                                        ListTile(
                                          visualDensity: VisualDensity(
                                              vertical: -4), // to compact
                                          dense: true,
                                          title: Text('Service'),
                                          trailing:
                                              Text(x.first.taxamt.toString()),
                                        ),
                                        ListTile(
                                          visualDensity: VisualDensity(
                                              vertical: -4), // to compact
                                          dense: true,
                                          title: Text('Grand total'),
                                          trailing:
                                              Text(x.first.nettamt.toString()),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          height: 2,
                                          // indent: 20,
                                          // endIndent: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              })),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(' Payment')),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FutureBuilder(
                            future: this
                                .handler
                                .retriveListDetailPayment(widget.trno),
                            builder: (context,
                                AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
                              data = snapshot.data ?? [];
                              if (data != []) {
                                return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        visualDensity: VisualDensity(
                                            vertical: -4), // to compact
                                        dense: true,
                                        title: Text(
                                            data[index].pymtmthd.toString()),
                                        trailing: Text(
                                            data[index].ftotamt.toString()),
                                      );
                                    });
                              } else {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                    ),
                                    Text('Belum Ada Pembayaran'),
                                  ],
                                );
                              }
                            }),
                      ),
                    ],
                  );
                }
                return Container();
              }),
        ),
        title: Text('Informasi transaksi'),
        actions: <Widget>[
          ButtonNoIcon(
            onpressed: () async {
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassRetailMainMobile(
                            outletinfo: widget.outletinfo,
                            pscd: widget.pscd,
                            qty: 0,
                            trno: widget.trno,
                          )));
            },
            textcolor: Colors.white,
            color: Colors.blue,
            name: haspayment == true ? 'Reopen' : 'Selesaikan',
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.2,
          ),
          ButtonNoIcon(
            onpressed: () {},
            textcolor: Colors.white,
            color: Colors.blue,
            name: 'Reprint',
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.2,
          ),
        ],
      );
    });
  }
}

class DialogClassEwallet extends StatefulWidget {
  final String trno;
  final String pscd;
  late num? result;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? discbyamount;
  final String compcd;
  final String? compdesc;
  final String? url;
  final bool? fromtrfbank;
  DialogClassEwallet({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.balance,
    this.outletname,
    this.outletinfo,
    this.discbyamount,
    this.result,
    required this.compcd,
    required this.compdesc,
    this.url,
    this.fromtrfbank,
  }) : super(key: key);

  @override
  State<DialogClassEwallet> createState() => _DialogClassEwalletState();
}

class _DialogClassEwalletState extends State<DialogClassEwallet> {
  TextEditingController docno = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        trno: widget.trno,
        split: 'A',
        pscd: widget.pscd,
        trtm: '00:00',
        disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
        pax: '1',
        pymtmthd: 'EWALLET',
        ftotamt: double.parse(widget.result.toString()),
        totalamt: double.parse(widget.result.toString()),
        framtrmn: double.parse(widget.result.toString()),
        amtrmn: double.parse(widget.result.toString()),
        compcd: widget.compcd.toString(),
        compdesc: widget.compdesc.toString(),
        active: '1',
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    List<IafjrnhdClass> listiafjrnhd = [iafjrnhd];
    return await handler.insertIafjrnhd(listiafjrnhd);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: QrImage(
                        size: MediaQuery.of(context).size.height * 0.4,
                        version: QrVersions.auto,
                        data: widget.url.toString(),
                      ),
                    ),
                    ButtonClassPayment(
                      styleasset: BoxFit.fitWidth,
                      iconasset: 'qris.png',
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('copy data'),
                    IconButton(
                      icon: Icon(Icons.copy),
                      iconSize: 20,
                      color: Colors.green,
                      splashColor: Colors.purple,
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.url.toString()));
                      },
                    ),
                  ],
                ),
              ],
            )),
        title: Text('Pembayaran Via ${widget.compdesc}?'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await insertIafjrnhd().whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassPaymetSucsessMobile(
                              frombanktransfer: false,
                              cash: false,
                              outletinfo: widget.outletinfo,
                              outletname: widget.outletname,
                              outletcd: widget.pscd,
                              amount: double.parse(widget.result.toString()),
                              paymenttype: widget.compdesc.toString(),
                              trno: widget.trno.toString(),
                              trdt: formattedDate,
                            )),
                  );
                });
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogClassBankTransfer extends StatefulWidget {
  final String trno;
  final String pscd;
  late num? result;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? discbyamount;
  final String compcd;
  final String? compdesc;
  final String? virtualaccount;
  final String? bank;
  final String? transactionstatus;
  final num? grossmaount;
  final String? paymenttype;
  DialogClassBankTransfer({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.balance,
    this.outletname,
    this.outletinfo,
    this.discbyamount,
    this.result,
    required this.compcd,
    required this.compdesc,
    this.virtualaccount,
    this.bank,
    this.transactionstatus,
    this.grossmaount,
    required this.paymenttype,
  }) : super(key: key);

  @override
  State<DialogClassBankTransfer> createState() =>
      _DialogClassBankTransferState();
}

class _DialogClassBankTransferState extends State<DialogClassBankTransfer> {
  TextEditingController docno = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
      trdt: formattedDate,
      trno: widget.trno,
      split: 'A',
      pscd: widget.pscd,
      trtm: '00:00',
      disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
      pax: '1',
      pymtmthd: 'Account',
      ftotamt: double.parse(widget.result.toString()),
      totalamt: double.parse(widget.result.toString()),
      framtrmn: double.parse(widget.result.toString()),
      amtrmn: double.parse(widget.result.toString()),
      compcd: widget.compcd.toString(),
      compdesc: widget.compdesc.toString(),
      active: '1',
      usercrt: 'Admin',
      slstp: '1',
      currcd: 'IDR',
      virtualaccount: widget.virtualaccount,
    );
    List<IafjrnhdClass> listiafjrnhd = [iafjrnhd];
    return await handler.insertIafjrnhd(listiafjrnhd);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Please transfer to virtual account',
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  children: [
                    Text(
                      widget.virtualaccount.toString(),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      iconSize: 20,
                      color: Colors.green,
                      splashColor: Colors.purple,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: widget.virtualaccount.toString()));
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Total charge : ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(widget.result.toString(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )
              ],
            )),
        title: Text('Pembayaran Via Virtual Account  ${widget.bank}?'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await insertIafjrnhd().whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassPaymetSucsessMobile(
                              frombanktransfer: true,
                              virtualaccount: widget.virtualaccount,
                              cash: false,
                              outletinfo: widget.outletinfo,
                              outletname: widget.outletname,
                              outletcd: widget.pscd,
                              amount: double.parse(widget.result.toString()),
                              paymenttype: 'Bank Transfer',
                              trno: widget.trno.toString(),
                              trdt: formattedDate,
                            )),
                  );
                });
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogClassMandiribiller extends StatefulWidget {
  final String trno;
  final String pscd;
  late num? result;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final bool? discbyamount;
  final String compcd;
  final String? compdesc;
  final String? bill_key;
  final String? biller_code;
  final String? transactionstatus;
  final num? grossmaount;
  final String? paymenttype;
  DialogClassMandiribiller({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.balance,
    this.outletname,
    this.outletinfo,
    this.discbyamount,
    this.result,
    required this.compcd,
    required this.compdesc,
    this.bill_key,
    this.biller_code,
    this.transactionstatus,
    this.grossmaount,
    required this.paymenttype,
  }) : super(key: key);

  @override
  State<DialogClassMandiribiller> createState() =>
      _DialogClassMandiribillerState();
}

class _DialogClassMandiribillerState extends State<DialogClassMandiribiller> {
  TextEditingController docno = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        trno: widget.trno,
        split: 'A',
        pscd: widget.pscd,
        trtm: '00:00',
        disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
        pax: '1',
        pymtmthd: 'Account',
        ftotamt: double.parse(widget.result.toString()),
        totalamt: double.parse(widget.result.toString()),
        framtrmn: double.parse(widget.result.toString()),
        amtrmn: double.parse(widget.result.toString()),
        compcd: widget.compcd.toString(),
        compdesc: widget.compdesc.toString(),
        active: '1',
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    List<IafjrnhdClass> listiafjrnhd = [iafjrnhd];
    return await handler.insertIafjrnhd(listiafjrnhd);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  children: [
                    Text(
                      'Biller kode :',
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Text(
                      widget.biller_code.toString(),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      iconSize: 20,
                      color: Colors.green,
                      splashColor: Colors.purple,
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.bill_key.toString()));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Row(
                  children: [
                    Text(
                      'Bill Key : ',
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Text(
                      widget.bill_key.toString(),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      iconSize: 20,
                      color: Colors.green,
                      splashColor: Colors.purple,
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.bill_key.toString()));
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Total charge : ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(widget.result.toString(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )
              ],
            )),
        title: Text('Pembayaran Mandiri biller'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await insertIafjrnhd().whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassPaymetSucsessMobile(
                              frombanktransfer: true,
                              cash: false,
                              outletinfo: widget.outletinfo,
                              outletname: widget.outletname,
                              outletcd: widget.pscd,
                              amount: double.parse(widget.result.toString()),
                              paymenttype: widget.compdesc.toString(),
                              trno: widget.trno.toString(),
                              trdt: formattedDate,
                            )),
                  );
                });
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}
