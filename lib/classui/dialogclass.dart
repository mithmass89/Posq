// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, prefer_generic_function_type_aliases, avoid_print, must_be_immutable, non_constant_identifier_names, unused_import, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/payment/classpaymentsuccessmobile.dart';
import 'package:posq/classui/payment/paymentsugestionclass.dart';
import 'package:posq/classui/payment/paymenttablet/paymentsuccesstab.dart';
import 'package:posq/classui/searchwidget.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/category/classcategorylist.dart';
import 'package:posq/setting/category/classcreatecategorymobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:flutter/services.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';
import 'package:posq/userinfo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DialogClass1 extends StatefulWidget {
  final bool fromreopen;
  const DialogClass1({
    Key? key,
    required this.fromreopen,
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
  final String trno;
  final String pscd;
  DialogCustomerManual({
    Key? key,
    required this.trno,
    required this.pscd,
  }) : super(key: key);

  @override
  State<DialogCustomerManual> createState() => _DialogCustomerManualState();
}

class _DialogCustomerManualState extends State<DialogCustomerManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllername = TextEditingController();
  final TextEditingController controlleremail = TextEditingController();
  final TextEditingController controllerphone = TextEditingController();
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    checkSF();
  }

  checkSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String guestPref = prefs.getString('savecostmrs') ?? "";
    if (guestPref.isNotEmpty) {
      Map<String, dynamic> userMap =
          jsonDecode(guestPref) as Map<String, dynamic>;
      setState(() {
        controllername.text = userMap['guestname'];
        controlleremail.text = userMap['email'];
      });
    }
  }

  getSf() async {
    Map<String, dynamic> user = {
      'guestname': controllername.text,
      'email': controlleremail.text,
      'telp': controllerphone.text,
    };
    final savecostmrs = await SharedPreferences.getInstance();
    await addCustomersTemp();
    await savecostmrs.setString('savecostmrs', jsonEncode(user));
  }

  Future<int> addCustomersTemp() async {
    CostumersSavedManual costumes = CostumersSavedManual(
        trno: widget.trno,
        outletcd: widget.pscd,
        alamat: '',
        nama: controllername.text,
        email: controlleremail.text,
        telp: controllerphone.text);
    List<CostumersSavedManual> listcustomers = [costumes];
    return await handler.insertCustomersTrno(listcustomers);
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
                    TextFieldMobile2(
                      label: 'Telp',
                      controller: controllerphone,
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
    handler.initializeDB(databasename);
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
              future: ClassApi.getCustomers(query),
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
                                          name = snapshot.data![index].fullname
                                              .toString();
                                          email = snapshot.data![index].phone
                                              .toString();
                                        });
                                        print(index);
                                      },
                                      dense: true,
                                      visualDensity: VisualDensity(
                                          vertical: -1), // to compact
                                      title: Text(
                                        snapshot.data![index].fullname
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
  const DialogTabClass({
    Key? key,
  }) : super(key: key);

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
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: TabBar(
                    // indicator: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20), // Creates border
                    //     color: Colors.orange), //Change background color from here
                    labelColor: Colors.orange,
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
                    width: MediaQuery.of(context).size.width * 0.5,
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
      );
    });
  }
}

class DialogSetMenu extends StatefulWidget {
  const DialogSetMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogSetMenu> createState() => _DialogSetMenuState();
}

class _DialogSetMenuState extends State<DialogSetMenu>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController search = TextEditingController();
  TabController? controller;
  int? index = 0;
  String query = '';
  List<String> selecteditem = [];
  var selectedindex;
  List<bool> _value = [];
  bool selected = false;
  List<Item> data = [];
  Future<List<Item>> getitemOutlet(query) async {
    data = await ClassApi.getItemList(pscd, dbname, search.text);
    setState(() {});
    return data;
  }

  searching() {
    data = data
        .where(
            (element) => element.itemdesc!.toLowerCase().contains(search.text))
        .toList();
    setState(() {});
    print(data.length);
  }

  bool isloading = true;

  @override
  void initState() {
    controller =
        TabController(vsync: this, length: 2, initialIndex: index!.toInt());
    super.initState();
    getitemOutlet(query);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: Text('Pilih Set Menu'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selecteditem);
                },
                child: Text('Oke'))
          ],
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldMobile2(
                    controller: search,
                    onChanged: (value) {
                      searching();
                      setState(() {});
                      if (value == '' || value.isEmpty) {
                        getitemOutlet(value);
                        setState(() {});
                      }
                    },
                    typekeyboard: TextInputType.text),
                Container(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                if (selecteditem
                                        .contains(data[index].itemcode) ==
                                    true) {
                                  selecteditem.remove(data[index].itemcode);
                                  setState(() {});
                                } else {
                                  selecteditem.add(data[index].itemcode!);
                                  setState(() {});
                                }

                                print(selecteditem);
                              },
                              dense: true,
                              title: Text(
                                data[index].itemdesc!,
                                style: TextStyle(
                                  color: selecteditem
                                          .contains(data[index].itemcode)
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          ));
    });
  }
}

class DialogSetPackage extends StatefulWidget {
  final TextEditingController controllerpackage;
  final String packagecode;
  final String note;
  // final String imagepath;
  DialogSetPackage({
    Key? key,
    required this.controllerpackage,
    required this.packagecode,
    required this.note,
    // required this.imagepath,
  }) : super(key: key);

  @override
  State<DialogSetPackage> createState() => _DialogSetPackageState();
}

class _DialogSetPackageState extends State<DialogSetPackage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController search = TextEditingController();
  TabController? controller;
  int? index = 0;
  String query = '';
  List<Package> selecteditem = [];
  var selectedindex;
  List<bool> _value = [];
  bool selected = false;
  List<Item> data = [];
  Future<List<Item>> getitemOutlet(query) async {
    data = await ClassApi.getItemList(pscd, dbname, search.text);
    setState(() {});
    return data;
  }

  searching() {
    data = data
        .where(
            (element) => element.itemdesc!.toLowerCase().contains(search.text))
        .toList();
    setState(() {});
    print(data.length);
  }

  bool isloading = true;

  @override
  void initState() {
    controller =
        TabController(vsync: this, length: 2, initialIndex: index!.toInt());
    super.initState();
    getitemOutlet(query);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: Text('Pilih Set Menu'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selecteditem);
                },
                child: Text('Oke'))
          ],
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldMobile2(
                    suffixIcon: search.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              search.clear();
                              setState(() {});
                            },
                            icon: Icon(Icons.close),
                          )
                        : null,
                    controller: search,
                    onChanged: (value) {
                      searching();
                      setState(() {});
                      if (value == '' || value.isEmpty) {
                        getitemOutlet(value);
                        setState(() {});
                      }
                    },
                    typekeyboard: TextInputType.text),
                Container(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                print(selecteditem.where((element) =>
                                    element.itemcode == data[index].itemcode));
                                if (selecteditem.any((item) =>
                                        item.itemcode ==
                                        data[index].itemcode) ==
                                    true) {
                                  selecteditem.removeWhere((element) =>
                                      element.itemcode == data[index].itemcode);
                                  setState(() {});
                                } else {
                                  selecteditem.add(Package(
                                      packagecd: widget.packagecode,
                                      packagedesc:
                                          widget.controllerpackage.text,
                                      packagenote: widget.note,
                                      itemcode: data[index].itemcode!,
                                      itemdesc: data[index].itemdesc!,
                                      qty: 1));
                                  setState(() {});
                                }

                                print(selecteditem);
                              },
                              dense: true,
                              title: Text(
                                data[index].itemdesc!,
                                style: TextStyle(
                                  color: selecteditem.any((item) =>
                                          item.itemcode == data[index].itemcode)
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          ));
    });
  }
}

class DialogRoleStaff extends StatefulWidget {
  DialogRoleStaff({
    Key? key,

    // required this.imagepath,
  }) : super(key: key);

  @override
  State<DialogRoleStaff> createState() => _DialogRoleStaffState();
}

class _DialogRoleStaffState extends State<DialogRoleStaff>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int? index = 0;
  String query = '';
  List<Pegawai> selectedRole = [];
  var selectedindex;
  List<bool> _value = [];
  bool selected = false;
  List<Pegawai> data = [];
  Future<List<Pegawai>> getRoleStaff(query) async {
    data = await ClassApi.getRoleStaff('');
    setState(() {});
    return data;
  }

  bool isloading = true;

  @override
  void initState() {
    controller =
        TabController(vsync: this, length: 2, initialIndex: index!.toInt());
    super.initState();
    getRoleStaff(query);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: Text('Pilih staff role'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
          ],
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(data[index].joblevel),
                    onTap: () {
                      selectedRole.add(data[index]);
                      Navigator.of(context).pop(selectedRole);
                    },
                  ),
                );
              },
            ),
          ));
    });
  }
}

class DialogOutletStaff extends StatefulWidget {
  DialogOutletStaff({
    Key? key,

    // required this.imagepath,
  }) : super(key: key);

  @override
  State<DialogOutletStaff> createState() => _DialogOutletStaffState();
}

class _DialogOutletStaffState extends State<DialogOutletStaff>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int? index = 0;
  String query = '';
  List<dynamic> selectedRole = [];
  var selectedindex;
  List<bool> _value = [];
  List<String> selectedoutlet = [];
  bool selected = false;
  List<dynamic> data = [
    {
      "outletcode": "All",
      "usercode": usercd,
      "id": "",
      "outletcd": "All",
      "outletdesc": "All outlet",
      "telp": "",
      "alamat": "",
      "kodepos": "",
      "slstp": "",
      "dbname": ""
    }
  ];
  Future<List<dynamic>> getOutlets(query) async {
    await ClassApi.getOutlets(emaillogin).then((value) {
      for (var x in value) {
        data.add(x);
      }
    });
    setState(() {});

    print(data);
    return data;
  }

  bool isloading = true;

  @override
  void initState() {
    controller =
        TabController(vsync: this, length: 2, initialIndex: index!.toInt());
    super.initState();
    getOutlets(query);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: Text('Pilih Outlet'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
          ],
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    dense: true,
                    title: Text(data[index]['outletdesc']),
                    onTap: () {
                      if (data[index]['outletcd'] == 'All') {
                        // selectedRole.add(data);
                        for (var x in data) {
                          selectedoutlet.add(x['outletcode']);
                        }
                        Navigator.of(context).pop(selectedoutlet);
                      } else {
                        selectedoutlet.add(data[index]['outletcode']);
                        Navigator.of(context).pop(selectedoutlet);
                      }
                    },
                  ),
                );
              },
            ),
          ));
    });
  }
}

class DialogListStaff extends StatefulWidget {
  DialogListStaff({
    Key? key,

    // required this.imagepath,
  }) : super(key: key);

  @override
  State<DialogListStaff> createState() => _DialogListStaffState();
}

class _DialogListStaffState extends State<DialogListStaff>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int? index = 0;
  String query = '';
  List<dynamic> selectedRole = [];
  var selectedindex;
  List<bool> _value = [];
  bool selected = false;
  List<dynamic> data = [];
  Future<List<dynamic>> getListStaffOutlet(query) async {
    await ClassApi.getListStaffOutlet(pscd).then((value) {
      for (var x in value) {
        data.add(x);
      }
    });
    setState(() {});
    print(data);
    return data;
  }

  bool isloading = true;

  @override
  void initState() {
    controller =
        TabController(vsync: this, length: 2, initialIndex: index!.toInt());
    super.initState();
    getListStaffOutlet(query);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: Text('Pilih Staff'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
          ],
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    dense: true,
                    title: Text(data[index]['usercd']),
                    onTap: () {
                      Navigator.of(context).pop(SelectedPegawai(
                          usercode: data[index]['usercd'],
                          email: data[index]['email']));
                    },
                  ),
                );
              },
            ),
          ));
    });
  }
}

class DialogTipeCondiment extends StatefulWidget {
  const DialogTipeCondiment({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogTipeCondiment> createState() => _DialogTipeCondimentState();
}

class _DialogTipeCondimentState extends State<DialogTipeCondiment>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController search = TextEditingController();
  TabController? controller;
  int? index = 0;
  String query = '';
  bool selectedtype = false;
  String choice = '';
  String choicedesc = '';

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
          title: Text('Pilih Tipe Modifier'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
          ],
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        choice = 'menuchoice';
                        choicedesc = 'Pilihan Menu';
                      });
                      Navigator.of(context).pop(TypeCondiment(
                          opsidesc: choicedesc, opsitype: choice));
                    },
                    title: Text('Pilihan Menu'),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        choice = 'topping';
                        choicedesc = 'Additional/Topping';
                      });
                      Navigator.of(context).pop(TypeCondiment(
                          opsidesc: choicedesc, opsitype: choice));
                    },
                    title: Text('Additional/Topping'),
                  ),
                ),
              ],
            ),
          ));
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'))
        ],
        title: Text('Gender'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pop('Laki Laki');
                },
                title: Text('Laki Laki'),
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pop('Perempuan');
                },
                title: Text('Perempuan'),
              )),
        ]),
      );
    });
  }
}

class DialogReward extends StatefulWidget {
  final String fromdate;
  final String todate;
  final String point;
  final num amount;
  final num initialamount;
  final String type;
  const DialogReward(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.point,
      required this.amount,
      required this.initialamount,
      required this.type})
      : super(key: key);

  @override
  State<DialogReward> createState() => _DialogRewardState();
}

class _DialogRewardState extends State<DialogReward>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController minimum = TextEditingController(text: '0');
  TextEditingController persen = TextEditingController();
  TextEditingController point = TextEditingController();
  TabController? controller;
  int? index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        child: AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal')),
            TextButton(
                onPressed: () async {
                  await ClassApi.insertRewardSetting(
                      '01-01',
                      index.toString(),
                      num.parse(point.text),
                      index == 0
                          ? num.parse(amount.text.replaceAll(',', ''))
                          : num.parse(persen.text),
                      index == 0
                          ? 'Discount By amount'
                          : 'Discount by percentage',
                      minimum.text == '0' ? 0 : 1,
                      num.parse(minimum.text.replaceAll(',', '')));
                  Navigator.of(context).pop();
                },
                child: Text('Simpan'))
          ],
          title: Text('Setting reward'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(mainAxisSize: MainAxisSize.max, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              // alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Pilih Reward',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              color: index == 0 ? Colors.orange : Colors.transparent,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListTile(
                    leading: Icon(Icons.numbers, size: 20),
                    onTap: () {
                      index = 0;
                      persen.clear();
                      setState(() {});
                    },
                    title: Text('Dari Nominal'),
                    subtitle: Text(
                        'Pelanggan akan mendapat reward nominal dari total belanja'),
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Card(
              color: index == 1 ? Colors.orange : Colors.transparent,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListTile(
                    leading: Icon(Icons.percent, size: 20),
                    onTap: () {
                      index = 1;
                      amount.clear();
                      setState(() {});
                    },
                    title: Text('Dari persentasi'),
                    subtitle: Text(
                        'Pelanggan akan mendapat reward persentasi dari total belanja'),
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              // alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Reward Convert',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: point,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Point yg di tukar',
                  prefixText: 'pts ',
                ),
              ),
            ),
            index == 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: amount,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _NumberFormatter(),
                      ],
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jumlah Nominal Reward',
                        prefixText: 'Rp ',
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: persen,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jumlah persentasi reward',
                        prefixText: '% ',
                      ),
                    ),
                  ),
            Container(
              // alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Belanja Minimum',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: minimum,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _NumberFormatter(),
                ],
                onChanged: (value) {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Minimum',
                  prefixText: 'Rp ',
                ),
              ),
            )
          ]),
        ),
      );
    });
  }
}

class _NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int selectionIndex = newValue.selection.end;
    String formattedValue = newValue.text;

    if (formattedValue.isNotEmpty) {
      final numberValue = int.tryParse(formattedValue.replaceAll(',', ''));
      if (numberValue != null) {
        final NumberFormat numberFormat = NumberFormat('#,###');
        formattedValue = numberFormat.format(numberValue);
      }
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
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
    print('outlet ${widget.outletinfo.outletcd}');
    formattedDate = formatter.format(now);
  }

  getDataSlide() async {
    await ClassApi.getTrnoDetail(widget.trno!, dbname, '').then((isi) {
      if (isi.isNotEmpty) {
        num totalSlsNett = isi.fold(
            0, (previousValue, isi) => previousValue + isi.totalaftdisc!);
        setState(() {
          totalbarang = isi.length;
          print('total barang collpse $totalbarang');
          amounttotal = totalSlsNett;
        });
      } else {
        setState(() {
          totalbarang = 0;
        });
      }
    });
  }

  insertIafjrndt(day) async {
    await ClassApi.insertPosDetail(
        IafjrndtClass(
            trdt: formattedDate,
            pscd: widget.outletinfo.outletcd,
            transno: widget.trno,
            split: 1,
            transno1: 'trnobill',
            itemcode: widget.controller.text,
            itemdesc: widget.controller.text,
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
            ratecostamt: widget.result!.toDouble(),
            rateamtitem: widget.result!.toDouble(),
            rateamtservice: pctservice.text != ''
                ? widget.result!.toDouble() * num.parse(pctservice.text) / 100
                : num.parse('0'),
            rateamttax: pcttax.text != ''
                ? widget.result!.toDouble() * num.parse(pcttax.text) / 100
                : num.parse('0'),
            rateamttotal: widget.result!.toDouble(),
            revenueamt: 1 * widget.result!.toDouble(),
            taxamt: pcttax.text != ''
                ? 1 * widget.result!.toDouble() * num.parse(pcttax.text) / 100
                : num.parse('0'),
            serviceamt: pctservice.text != ''
                ? widget.result!.toDouble() * num.parse(pctservice.text) / 100
                : num.parse('0'),
            totalaftdisc: widget.result!.toDouble(),
            rebateamt: 0,
            rvncoa: 'REVENUE',
            taxcoa: 'TAX',
            servicecoa: 'SERVICE',
            costcoa: 'COST',
            active: 1,
            usercrt: usercd,
            userupd: usercd,
            userdel: usercd,
            prnkitchen: 0,
            prnkitchentm: '10:10',
            confirmed: '1',
            description: widget.controller.text,
            taxpct: 0,
            svchgpct: 0,
            statustrans: 'prosess',
            createdt: now.toString(),
            guestname: 'No Guest Name',
            totalcost: widget.result!.toDouble() * 1),
        pscd);
  }

  insertIafjrndtRefundMod(day) async {
    await ClassApi.insertPosDetail(
        IafjrndtClass(
            trdt: formattedDate,
            pscd: widget.outletinfo.outletcd,
            transno: widget.trno,
            split: 1,
            transno1: 'trnobill',
            itemcode: widget.controller.text,
            itemdesc: widget.controller.text,
            trno1: widget.trno,
            itemseq: widget.itemlenght,
            cono: 'cono',
            waitercd: 'waitercd',
            discpct: 0,
            discamt: 0,
            qty: -1,
            ratecurcd: 'Rupiah',
            ratebs1: 1,
            ratebs2: 1,
            ratecostamt: -(widget.result!.toDouble()),
            rateamtitem: -(widget.result!.toDouble()),
            rateamtservice: -(pctservice.text != ''
                ? widget.result!.toDouble() * num.parse(pctservice.text) / 100
                : num.parse('0')),
            rateamttax: -(pcttax.text != ''
                ? widget.result!.toDouble() * num.parse(pcttax.text) / 100
                : num.parse('0')),
            rateamttotal: -(widget.result!.toDouble()),
            revenueamt: -(1 * widget.result!.toDouble()),
            taxamt: -(pcttax.text != ''
                ? 1 * widget.result!.toDouble() * num.parse(pcttax.text) / 100
                : num.parse('0')),
            serviceamt: -(pctservice.text != ''
                ? widget.result!.toDouble() * num.parse(pctservice.text) / 100
                : num.parse('0')),
            totalaftdisc: -(widget.result!.toDouble()),
            rebateamt: 0,
            rvncoa: 'REVENUE',
            taxcoa: 'TAX',
            servicecoa: 'SERVICE',
            costcoa: 'COST',
            active: 1,
            usercrt: usercd,
            userupd: usercd,
            userdel: usercd,
            prnkitchen: 0,
            prnkitchentm: '10:10',
            confirmed: '1',
            description: 'refund mode',
            taxpct: 0,
            svchgpct: 0,
            statustrans: 'prosess',
            createdt: now.toString(),
            guestname: 'No Guest Name',
            totalcost: -(widget.result!.toDouble()) * (-1)),
        pscd);
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
              onPressed: () async {
                if (refundmode == false) {
                  await insertIafjrndt(formattedDate);
                  setState(() {
                    hasil = IafjrndtClass(
                      trdt: formattedDate,
                      pscd: widget.outletinfo.outletcd,
                      transno: widget.trno,
                      split: 1,
                      transno1: 'trnobill',
                      itemcode: widget.controller.text,
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
                      ratecostamt: widget.result!.toDouble(),
                      rateamtitem: widget.result!.toDouble(),
                      rateamtservice: 0,
                      rateamttax: 0,
                      rateamttotal: widget.result!.toDouble(),
                      revenueamt: widget.result!.toDouble(),
                      taxamt: 0,
                      serviceamt: 0,
                      totalaftdisc: widget.result!.toDouble(),
                      rebateamt: 0,
                      rvncoa: 'REVENUE',
                      taxcoa: 'TAX',
                      servicecoa: 'SERVICE',
                      costcoa: 'COST',
                      active: 1,
                      usercrt: usercd,
                      userupd: usercd,
                      userdel: usercd,
                      prnkitchen: 0,
                      prnkitchentm: now.hour.toString() +
                          ":" +
                          now.minute.toString() +
                          ":" +
                          now.second.toString(),
                      confirmed: '1',
                      description: widget.controller.text,
                      taxpct: 0,
                      svchgpct: 0,
                      totalcost: widget.result!.toDouble() * 1,
                    );
                    // ClassRetailMainMobile.of(context)!.string = hasil;
                  });

                  await getDataSlide();
                  setState(() {
                    counter++;
                  });
                  Navigator.of(context).pop(IafjrndtClass(
                    trdt: hasil.trdt,
                    pscd: hasil.pscd,
                    transno: hasil.transno,
                    split: hasil.split,
                    transno1: hasil.transno,
                    itemcode: hasil.itemcode,
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
                    ratecostamt: hasil.ratecostamt,
                    rateamtitem: hasil.rateamtitem,
                    rateamtservice: hasil.rateamtservice,
                    rateamttax: hasil.rateamttax,
                    rateamttotal: hasil.rateamttotal,
                    revenueamt: hasil.revenueamt,
                    taxamt: hasil.taxamt,
                    serviceamt: hasil.serviceamt,
                    totalaftdisc: hasil.totalaftdisc,
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
                    description: hasil.description,
                    totalcost: hasil.totalcost,
                  ));

                  widget.cleartext();
                } else {
                  await insertIafjrndtRefundMod(formattedDate);
                  setState(() {
                    hasil = IafjrndtClass(
                      trdt: formattedDate,
                      pscd: widget.outletinfo.outletcd,
                      transno: widget.trno,
                      split: 1,
                      transno1: 'trnobill',
                      itemcode: widget.controller.text,
                      trno1: widget.trno,
                      itemseq: widget.itemlenght,
                      cono: 'cono',
                      waitercd: 'waitercd',
                      discpct: 0,
                      discamt: 0,
                      qty: -1,
                      ratecurcd: 'Rupiah',
                      ratebs1: 1,
                      ratebs2: 1,
                      ratecostamt: -(widget.result!.toDouble()),
                      rateamtitem: -(widget.result!.toDouble()),
                      rateamtservice: 0,
                      rateamttax: 0,
                      rateamttotal: -(widget.result!.toDouble()),
                      revenueamt: -(widget.result!.toDouble()),
                      taxamt: 0,
                      serviceamt: 0,
                      totalaftdisc: -(widget.result!.toDouble()),
                      rebateamt: 0,
                      rvncoa: 'REVENUE',
                      taxcoa: 'TAX',
                      servicecoa: 'SERVICE',
                      costcoa: 'COST',
                      active: 1,
                      usercrt: usercd,
                      userupd: usercd,
                      userdel: usercd,
                      prnkitchen: 0,
                      prnkitchentm: now.hour.toString() +
                          ":" +
                          now.minute.toString() +
                          ":" +
                          now.second.toString(),
                      confirmed: '1',
                      description: widget.controller.text,
                      taxpct: 0,
                      svchgpct: 0,
                      totalcost: -(widget.result!.toDouble()) * 1,
                    );
                    // ClassRetailMainMobile.of(context)!.string = hasil;
                  });

                  await getDataSlide();
                  setState(() {
                    counter++;
                  });
                  Navigator.of(context).pop(IafjrndtClass(
                    trdt: hasil.trdt,
                    pscd: hasil.pscd,
                    transno: hasil.transno,
                    split: hasil.split,
                    transno1: hasil.transno,
                    itemcode: hasil.itemcode,
                    trno1: hasil.trno1,
                    itemseq: hasil.itemseq,
                    cono: hasil.cono,
                    waitercd: hasil.waitercd,
                    discpct: -hasil.discpct!,
                    discamt: -hasil.discamt!,
                    qty: -(hasil.qty)!,
                    ratecurcd: hasil.ratecurcd,
                    ratebs1: hasil.ratebs1,
                    ratebs2: hasil.ratebs2,
                    ratecostamt: -hasil.ratecostamt,
                    rateamtitem: -hasil.rateamtitem!,
                    rateamtservice: -hasil.rateamtservice!,
                    rateamttax: -hasil.rateamttax!,
                    rateamttotal: -hasil.rateamttotal!,
                    revenueamt: -hasil.revenueamt!,
                    taxamt: -hasil.taxamt!,
                    serviceamt: -hasil.serviceamt!,
                    totalaftdisc: -hasil.totalaftdisc!,
                    rebateamt: -hasil.rebateamt!,
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
                    description: hasil.description,
                    totalcost: hasil.totalcost,
                  ));

                  widget.cleartext();
                }
              },
              child: Text(
                'Ok!',
                style: TextStyle(
                  color: Colors.black,
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
  final Outlet outletinfo;
  const DialogClassWillPop({
    Key? key,
    required this.trno,
    required this.outletinfo,
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
    handler.initializeDB(databasename);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        title: Text('kembali ke modul utama?'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                // await handler.activeZeroiafjrndttrno(
                //     IafjrndtClass(active: 1, transno: widget.trno));
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/', (Route<dynamic> route) => false);
                Navigator.of(context).pop();
              },
              child: Text('Batal')),
          TextButton(
              onPressed: () async {
                Random random = new Random();
                int randomNumber =
                    random.nextInt(100); // from 0 upto 99 included
                await ClassApi.updateTrnoGuest(
                    pscd, widget.trno, 'no guest $randomNumber');
                await handler.activeZeroiafjrndttrno(IafjrndtClass(
                    active: 1,
                    transno: widget.trno,
                    totalcost: 0,
                    ratecostamt: 0));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Dashboard', (Route<dynamic> route) => false);
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogCopyItem extends StatefulWidget {
  const DialogCopyItem({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogCopyItem> createState() => DialogCopyItemState();
}

class DialogCopyItemState extends State<DialogCopyItem> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                ListTile(
                  title: Text('Anda akan menyinkronkan item dengan pusat ? '),
                ),
              ],
            )),
        title: Text('Sync Item'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
              },
              child: Text('Batal')),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogClassWillPopExit extends StatefulWidget {
  const DialogClassWillPopExit({
    Key? key,
  }) : super(key: key);

  @override
  State<DialogClassWillPopExit> createState() => _DialogClassWillPopExitState();
}

class _DialogClassWillPopExitState extends State<DialogClassWillPopExit> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        title: Text('Anda ingin Keluar aplikasi'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                // await handler.activeZeroiafjrndttrno(
                //     IafjrndtClass(active: 1, transno: widget.trno));
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/', (Route<dynamic> route) => false);
                Navigator.of(context).pop();
              },
              child: Text('Batal')),
          TextButton(
              onPressed: () async {
                // Navigator.of(context).pop();
                exit(0);
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogClassCancelorder extends StatefulWidget {
  final String trno;
  final String outletcd;
  final Outlet outletinfo;
  final bool? fromsaved;

  const DialogClassCancelorder({
    Key? key,
    required this.trno,
    required this.outletcd,
    required this.outletinfo,
    this.fromsaved,
  }) : super(key: key);

  @override
  State<DialogClassCancelorder> createState() => _DialogClassCancelorderState();
}

class _DialogClassCancelorderState extends State<DialogClassCancelorder> {
  int? trno;
  String? trnolanjut;

  @override
  void initState() {
    super.initState();
  }

  checkTrno() async {
    var transno = await ClassApi.checkTrno();
    trnolanjut = widget.outletcd + '-' + transno[0]['transnonext'].toString();
    print(trno);
  }

  updateTrno() async {
    if (widget.fromsaved == true) {
      print('trno not update');
      await checkTrno();
    } else {
      await ClassApi.updateTrno(dbname);
      await checkTrno();
    }
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
                  children: [Text('Batalkan transaksi?')],
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
        title: Text('Cancel Transaksi'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal')),
          TextButton(
              onPressed: () async {
                await ClassApi.deactivePosdetailtrans(widget.trno, dbname);
                await ClassApi.deactivePosPaymenttrans(widget.trno, dbname);
                await ClassApi.deactivePromoTrno(widget.trno, dbname);
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('savecostmrs');
                await updateTrno();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => ClassRetailMainMobile(
                              pscd: widget.outletcd,
                              fromsaved: widget.fromsaved,
                              trno: trnolanjut,
                              outletinfo: widget.outletinfo,
                              qty: 0,
                            )),
                    (Route<dynamic> route) => false);
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogClassRefundorder extends StatefulWidget {
  final String trno;
  final String outletcd;
  final Outlet outletinfo;
  final bool? fromsaved;

  const DialogClassRefundorder({
    Key? key,
    required this.trno,
    required this.outletcd,
    required this.outletinfo,
    this.fromsaved,
  }) : super(key: key);

  @override
  State<DialogClassRefundorder> createState() => _DialogClassRefundorderState();
}

class _DialogClassRefundorderState extends State<DialogClassRefundorder> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  TextEditingController _controller = TextEditingController();
  String trno = '';
  int? selected;

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
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
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: FutureBuilder(
                      future: ClassApi.getSummaryCashierDetail(formattedDate,
                          formattedDate, dbname, _controller.text),
                      builder: (context,
                          AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
                        if (snapshot.hasData) {
                          var x = snapshot.data ?? [];
                          return ListView.builder(
                              itemCount: x.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  selectedColor: Colors.orange,
                                  onTap: () {
                                    trno = x[index].transno!;
                                    selected = index;

                                    setState(() {});
                                  },
                                  dense: true,
                                  title: Text(x[index].transno!,
                                      style: TextStyle(
                                          color: selected == index
                                              ? Colors.orange
                                              : Colors.black)),
                                  subtitle: Text(x[index].pymtmthd!,
                                      style: TextStyle(
                                          color: selected == index
                                              ? Colors.orange
                                              : Colors.black)),
                                  trailing: Text(
                                      CurrencyFormat.convertToIdr(
                                          x[index].totalamt, 0),
                                      style: TextStyle(
                                          color: selected == index
                                              ? Colors.orange
                                              : Colors.black)),
                                );
                              });
                        }
                        return Container();
                      },
                    )),
              ],
            )),
        title: Text('Cancel Transaksi'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal')),
          TextButton(
              onPressed: () async {
                EasyLoading.show(status: 'loading...');
                await ClassApi.deactivePosdetailtrans(trno, dbname);
                await ClassApi.deactivePosPaymenttrans(trno, dbname);
                await ClassApi.deactivePromoTrno(trno, dbname);
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('savecostmrs');
                EasyLoading.dismiss();
                Navigator.of(context).pop();
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogRefund extends StatefulWidget {
  final String trno;
  final String outletcd;
  final Outlet outletinfo;
  final bool? fromsaved;

  const DialogRefund({
    Key? key,
    required this.trno,
    required this.outletcd,
    required this.outletinfo,
    this.fromsaved,
  }) : super(key: key);

  @override
  State<DialogRefund> createState() => _DialogRefundState();
}

class _DialogRefundState extends State<DialogRefund> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  TextEditingController _controller = TextEditingController();
  String trno = '';
  int? selected;
  final TextEditingController reason = TextEditingController();

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
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
                TextFieldMobileLogin(
                  showpassword: true,
                  hint: 'Alasan?',
                  controller: reason,
                  onChanged: (String value) {},
                  typekeyboard: null,
                ),
              ],
            )),
        title: Text('Refund Transaksi'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal')),
          TextButton(
              onPressed: () async {
                EasyLoading.show(status: 'loading...');
                await ClassApi.refundTrans(widget.trno, reason.text, dbname);
                setState(() {});
                EasyLoading.dismiss();
                Navigator.of(context).pop();
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogDeactivePackage extends StatefulWidget {
  final String itemcode;

  const DialogDeactivePackage({
    Key? key,
    required this.itemcode,
  }) : super(key: key);

  @override
  State<DialogDeactivePackage> createState() => _DialogDeactivePackageState();
}

class _DialogDeactivePackageState extends State<DialogDeactivePackage> {
  @override
  void initState() {
    super.initState();
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
                  children: [Text('Batalkan transaksi?')],
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
        title: Text('Deactive Paket'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal')),
          TextButton(
              onPressed: () async {
                ClassApi.deActivePackageMenu(widget.itemcode, dbname);
                Navigator.of(context).pop();
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

////payment class  ////

/// end dialogpayment ///

class DialogClassReopen extends StatefulWidget {
  final String trno;
  final Outlet outletinfo;
  final String pscd;
  final bool fromreopen;
  final bool fromsaved;

  const DialogClassReopen({
    Key? key,
    required this.trno,
    required this.outletinfo,
    required this.pscd,
    required this.fromreopen,
    required this.fromsaved,
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
    handler.initializeDB(databasename);
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
          height: MediaQuery.of(context).size.height * 0.65,
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
                                    title: Text(x[index].description.toString(),
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
                          height: MediaQuery.of(context).size.height * 0.25,
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
                                          trailing: Text(
                                              x.first.revenueamt.toString()),
                                        ),
                                        ListTile(
                                          visualDensity: VisualDensity(
                                              vertical: -4), // to compact
                                          dense: true,
                                          title: Text('Discount'),
                                          trailing:
                                              Text(x.first.discamt.toString()),
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
                                          trailing: Text(
                                              x.first.totalaftdisc.toString()),
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
                            fromsaved: widget.fromsaved,
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
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final bool fromsplit;
  final String guestname;
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
    required this.datatrans,
    required this.fromsaved,
    required this.fromsplit,
    required this.guestname,
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

  String initialUrl = 'https://google.com'; // Replace with your desired URL
  bool isLoading = true;
  String trnotemp = '';
  bool complatepay = false;

  @override
  void initState() {
    super.initState();

    trnotemp = '${widget.trno}-$now';
    formattedDate = formatter.format(now);
    PaymentGate.snapWeb(widget.trno, widget.result.toString()).then((value) {
      print('test $value');
    });
    getStatusTransaction();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getStatusTransaction() {
    Timer periodicTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // This function will be called every 1 second (adjust the duration as needed).
      // Put your code here to perform the periodic tasks.
      PaymentGate.getStatusTransaction(trnotemp).then((value) {
        print(value);
        if (value == 'settlement') {
          print(value);
          complatepay = true;
        } else {
          complatepay = false;
        }
      });
      setState(() {});
      print('Periodic task executed at ${complatepay}');
    });
  }

  Future<dynamic> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: widget.trno,
        transno1: widget.trno,
        split: 1,
        pscd: widget.pscd,
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
        pax: '1',
        pymtmthd: 'QRIS',
        trdesc2: 'QRIS',
        trdesc: 'QRIS',
        ftotamt: double.parse(widget.result.toString()),
        totalamt: double.parse(widget.result.toString()),
        framtrmn: double.parse(widget.result.toString()),
        amtrmn: double.parse(widget.result.toString()),
        compcd: widget.compcd.toString(),
        compdesc: widget.compdesc.toString(),
        active: 1,
        usercrt: usercd,
        docno: trnotemp,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd);
  }

  String qr =
      'https://api.midtrans.com/v2/qris/270c2c13-a548-417b-9a30-06abe9901bfd/qr-code';

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1.1,
              child: FutureBuilder(
                  future:
                      PaymentGate.snapWeb(trnotemp, widget.result.toString()),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.hasData);
                      // String url ='https://api.midtrans.com/v2/qris/${snapshot.data['token']}/qr-code';
                      // print(url);
                      String url = snapshot.data['redirect_url'];
                      // String url ='https://app.midtrans.com/snap/v3/redirection/7539cd1c-4326-4ff8-9dc7-6a490c7db922#/gopay-qris';

                      return complatepay == false
                          ? WebView(
                              initialUrl: '$url#/gopay-qris',
                              // initialUrl: 'https://www.google.com',
                              // initialUrl: '$url',
                              javascriptMode: JavascriptMode.unrestricted,
                              onPageFinished: (String url) {
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            )
                          : Container(
                              child: Center(child: Text('Payment Success')));
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await insertIafjrnhd().whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassPaymetSucsessMobile(
                              guestname: widget.guestname,
                              fromsplit: widget.fromsplit,
                              fromsaved: widget.fromsaved,
                              datatrans: widget.datatrans,
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
              child: Text('Lanjutkan!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
        ],
      );
    });
  }
}

class DialogClassEwalletTab extends StatefulWidget {
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
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final bool fromsplit;
  final String guestname;
  DialogClassEwalletTab({
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
    required this.datatrans,
    required this.fromsaved,
    required this.fromsplit,
    required this.guestname,
  }) : super(key: key);

  @override
  State<DialogClassEwalletTab> createState() => _DialogClassEwalletTabState();
}

class _DialogClassEwalletTabState extends State<DialogClassEwalletTab> {
  TextEditingController docno = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DatabaseHandler handler;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  bool complatepay = false;

  String initialUrl = 'https://google.com'; // Replace with your desired URL
  bool isLoading = true;
  String trnotemp = '';

  @override
  void initState() {
    super.initState();
    trnotemp = '${widget.trno}-$now';
    formattedDate = formatter.format(now);
    PaymentGate.snapWeb(widget.trno, widget.result.toString()).then((value) {
      print('test $value');
    });
    getStatusTransaction();
  }

  getStatusTransaction() {
    Timer periodicTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // This function will be called every 1 second (adjust the duration as needed).
      // Put your code here to perform the periodic tasks.
      PaymentGate.getStatusTransaction(trnotemp).then((value) {
        print(value);
        if (value == 'settlement') {
          print(value);
          complatepay = true;
        } else {
          complatepay = false;
        }
      });
      setState(() {});
      print('Periodic task executed at ${complatepay}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: widget.trno,
        transno1: widget.trno,
        split: 1,
        pscd: widget.pscd,
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
        pax: '1',
        pymtmthd: 'QRIS',
        trdesc2: 'QRIS',
        trdesc: 'QRIS',
        ftotamt: double.parse(widget.result.toString()),
        totalamt: double.parse(widget.result.toString()),
        framtrmn: double.parse(widget.result.toString()),
        amtrmn: double.parse(widget.result.toString()),
        compcd: widget.compcd.toString(),
        compdesc: widget.compdesc.toString(),
        active: 1,
        usercrt: usercd,
        docno: trnotemp,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd);
  }

  String qr =
      'https://api.midtrans.com/v2/qris/270c2c13-a548-417b-9a30-06abe9901bfd/qr-code';

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1.1,
              child: FutureBuilder(
                  future:
                      PaymentGate.snapWeb(trnotemp, widget.result.toString()),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.hasData);
                      // String url ='https://api.midtrans.com/v2/qris/${snapshot.data['token']}/qr-code';
                      // print(url);
                      String url = snapshot.data['redirect_url'];
                      // String url ='https://app.midtrans.com/snap/v3/redirection/7539cd1c-4326-4ff8-9dc7-6a490c7db922#/gopay-qris';

                      return complatepay == false
                          ? WebView(
                              initialUrl: '$url#/gopay-qris',
                              // initialUrl: 'https://www.google.com',
                              // initialUrl: '$url',
                              javascriptMode: JavascriptMode.unrestricted,
                              onPageFinished: (String url) {
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            )
                          : Container(
                              child: Center(child: Text('Payment Success')));
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await insertIafjrnhd().whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassPaymetSucsessTabs(
                              guestname: widget.guestname,
                              fromsplit: widget.fromsplit,
                              fromsaved: widget.fromsaved,
                              datatrans: widget.datatrans,
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
              child: Text('Lanjutkan!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
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
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final bool fromsplit;
  final String guestname;

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
    required this.datatrans,
    required this.fromsaved,
    required this.fromsplit,
    required this.guestname,
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
    handler.initializeDB(databasename);
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
      trdt: formattedDate,
      transno: widget.trno,
      transno1: widget.trno,
      split: 1,
      pscd: widget.pscd,
      trtm: now.hour.toString() +
          ":" +
          now.minute.toString() +
          ":" +
          now.second.toString(),
      disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
      pax: '1',
      pymtmthd: 'Account',
      ftotamt: double.parse(widget.result.toString()),
      totalamt: double.parse(widget.result.toString()),
      framtrmn: double.parse(widget.result.toString()),
      amtrmn: double.parse(widget.result.toString()),
      compcd: widget.compcd.toString(),
      compdesc: widget.compdesc.toString(),
      active: 1,
      usercrt: 'Admin',
      slstp: '1',
      currcd: 'IDR',
      virtualaccount: widget.virtualaccount,
    );
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd);
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
                              guestname: widget.guestname,
                              fromsplit: widget.fromsplit,
                              fromsaved: widget.fromsaved,
                              datatrans: widget.datatrans,
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
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  final bool fromsplit;
  final String guestname;

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
    required this.datatrans,
    required this.fromsaved,
    required this.fromsplit,
    required this.guestname,
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
    handler.initializeDB(databasename);
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: widget.trno,
        transno1: widget.trno,
        split: 1,
        pscd: widget.pscd,
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: widget.discbyamount == true ? 'By Amount' : 'By Percent',
        pax: '1',
        pymtmthd: 'Account',
        ftotamt: double.parse(widget.result.toString()),
        totalamt: double.parse(widget.result.toString()),
        framtrmn: double.parse(widget.result.toString()),
        amtrmn: double.parse(widget.result.toString()),
        compcd: widget.compcd.toString(),
        compdesc: widget.compdesc.toString(),
        active: 1,
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd);
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
                              guestname: widget.guestname,
                              fromsplit: widget.fromsplit,
                              fromsaved: widget.fromsaved,
                              datatrans: widget.datatrans,
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

class DialogClassSimpan extends StatefulWidget {
  final String trno;
  final String pscd;
  final Outlet outletinfo;
  final bool? fromsaved;
  final IafjrndtClass datatrans;

  DialogClassSimpan({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.outletinfo,
    this.fromsaved,
    required this.datatrans,
  }) : super(key: key);

  @override
  State<DialogClassSimpan> createState() => _DialogClassSimpanState();
}

class _DialogClassSimpanState extends State<DialogClassSimpan> {
  TextEditingController guestname = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String trno = '';
  List<String> table = [];
  List<String> items = [];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    getTables();
    print('ini data ${widget.datatrans.tablesid}');
    formattedDate = formatter.format(now);
    if (widget.datatrans.guestname != '' &&
        widget.datatrans.guestname != null) {
      guestname.text = widget.datatrans.guestname!;
      setState(() {});
    }
    if (widget.datatrans.tablesid != '' && widget.datatrans.tablesid != null) {
      selectedValue = widget.datatrans.tablesid;
      print('update tables');
      setState(() {});
    }
  }

  updateGuest(String guestname) async {
    await ClassApi.updateTrnoGuest(dbname, widget.trno, guestname);
  }

  updateTablestrno(String table) async {
    await ClassApi.updateTablestrno(dbname, widget.trno, selectedValue!);
  }

  checkTrno() async {
    var transno = await ClassApi.checkTrno();
    trno = widget.pscd + '-' + transno[0]['transnonext'].toString();
    print(trno);
  }

  updateTrno() async {
    await ClassApi.updateTrno(dbname);
    await checkTrno();
  }

  getTables() async {
    await ClassApi.getTablesNotUse('').then((value) {
      if (value.isNotEmpty) {
        for (var x in value) {
          items.add(x.tablecd!);
        }
      }
      setState(() {});
    });
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFieldMobile2(
                    label: 'Guest Name',
                    controller: guestname,
                    onChanged: (String value) {},
                    typekeyboard: TextInputType.text,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            selectedValue == null
                                ? 'Table No.'
                                : selectedValue!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.orange,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      padding: null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.redAccent,
                      ),
                      elevation: 8,
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              ],
            )),
        title: Text('Simpan Sebagai '),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                print(selectedValue);
                if (selectedValue != null) {
                  await updateTablestrno(selectedValue!);
                  await ClassApi.updateTables_use(
                      dbname, widget.trno, selectedValue!);
                }
                await updateGuest(
                    guestname.text.isEmpty ? 'No Guest' : guestname.text);
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('savecostmrs');
                if (widget.fromsaved == false) {
                  await updateTrno();
                } else {
                  await checkTrno();
                }

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => ClassRetailMainMobile(
                              fromsaved: widget.fromsaved,
                              pscd: widget.pscd,
                              trno: trno,
                              outletinfo: widget.outletinfo,
                              qty: 0,
                            )),
                    (Route<dynamic> route) => false);
              },
              child: Text('OK!'))
        ],
      );
    });
  }
}

class DialogClassSimpanTab extends StatefulWidget {
  final String trno;
  final String pscd;
  final Outlet outletinfo;
  final bool? fromsaved;
  final IafjrndtClass datatrans;

  DialogClassSimpanTab({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.outletinfo,
    this.fromsaved,
    required this.datatrans,
  }) : super(key: key);

  @override
  State<DialogClassSimpanTab> createState() => _DialogClassSimpanTabState();
}

class _DialogClassSimpanTabState extends State<DialogClassSimpanTab> {
  TextEditingController guestname = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String trno = '';
  List<String> table = [];
  List<String> items = [];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    getTables();
    print('ini data ${widget.datatrans.tablesid}');
    formattedDate = formatter.format(now);
    if (widget.datatrans.guestname != '' &&
        widget.datatrans.guestname != null) {
      guestname.text = widget.datatrans.guestname!;
      setState(() {});
    }
    if (widget.datatrans.tablesid != '' && widget.datatrans.tablesid != null) {
      selectedValue = widget.datatrans.tablesid;
      print('update tables');
      setState(() {});
    }
  }

  updateGuest(String guestname) async {
    await ClassApi.updateTrnoGuest(dbname, widget.trno, guestname);
  }

  updateTablestrno(String table) async {
    await ClassApi.updateTablestrno(dbname, widget.trno, selectedValue!);
  }

  checkTrno() async {
    var transno = await ClassApi.checkTrno();
    trno = widget.pscd + '-' + transno[0]['transnonext'].toString();
    print(trno);
  }

  updateTrno() async {
    await ClassApi.updateTrno(dbname);
    await checkTrno();
  }

  getTables() async {
    await ClassApi.getTablesNotUse('').then((value) {
      if (value.isNotEmpty) {
        for (var x in value) {
          items.add(x.tablecd!);
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        child: AlertDialog(
          content: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFieldTab1(
                      label: 'Guest Name',
                      controller: guestname,
                      onChanged: (String value) {},
                      typekeyboard: TextInputType.text,
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Icon(
                            Icons.list,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              selectedValue == null
                                  ? 'Table No.'
                                  : selectedValue!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.orange,
                        ),
                        elevation: 2,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Colors.yellow,
                        iconDisabledColor: Colors.white,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.redAccent,
                        ),
                        elevation: 8,
                        offset: const Offset(-20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ],
              )),
          title: Text('Simpan Sebagai '),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  print(selectedValue);
                  if (selectedValue != null) {
                    await updateTablestrno(selectedValue!);
                    await ClassApi.updateTables_use(
                        dbname, widget.trno, selectedValue!);
                  }
                  await updateGuest(
                      guestname.text.isEmpty ? 'No Guest' : guestname.text);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('savecostmrs');
                  if (widget.fromsaved == false) {
                    await updateTrno();
                  } else {
                    await checkTrno();
                  }

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ClassRetailMainMobile(
                                fromsaved: widget.fromsaved,
                                pscd: widget.pscd,
                                trno: trno,
                                outletinfo: widget.outletinfo,
                                qty: 0,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: Text('OK!'))
          ],
        ),
      );
    });
  }
}

class DialogClassGuest extends StatefulWidget {
  final String trno;
  final String pscd;
  final Outlet outletinfo;
  final bool? fromsaved;

  DialogClassGuest({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.outletinfo,
    this.fromsaved,
  }) : super(key: key);

  @override
  State<DialogClassGuest> createState() => _DialogClassGuestTabState();
}

class _DialogClassGuestTabState extends State<DialogClassGuest> {
  TextEditingController guestname = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String trno = '';
  List<String> table = [];
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        child: AlertDialog(
          content: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFieldTab1(
                  label: 'Guest Name',
                  controller: guestname,
                  onChanged: (String value) {},
                  typekeyboard: TextInputType.text,
                ),
              )),
          title: Text('Isi nama tamu '),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('savecostmrs');
                  Navigator.of(context).pop(guestname.text);
                },
                child: Text('OK!'))
          ],
        ),
      );
    });
  }
}

class DialogForm extends StatefulWidget {
  final String trdt;

  const DialogForm({Key? key, required this.trdt}) : super(key: key);
  @override
  _DialogFormState createState() => _DialogFormState();
}

class _DialogFormState extends State<DialogForm> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  String _amount = "";
  List<TransaksiBO> databo = [];
  int _randomNumber = 0;

  void _generateRandomNumber() {
    setState(() {
      _randomNumber =
          Random().nextInt(10000); // Menghasilkan angka acak dari 0 hingga 99
    });
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Lakukan tindakan setelah validasi
      print("Deskripsi: $_description");
      print("Jumlah: $_amount");
      databo.add(TransaksiBO(
          ctr: '',
          subctr: '',
          transno: _randomNumber.toString(),
          product: '',
          proddesc: '',
          trdt: widget.trdt,
          documentno: _description,
          description: _description,
          type_tr: '1030',
          famount: num.parse(_amount),
          lamount: num.parse(_amount),
          note: '',
          usercreate: usercd,
          active: 1));
      await ClassApi.insertAdujsmentStock(dbname, databo);

      Navigator.pop(context); // Tutup dialog setelah selesai
    }
  }

  @override
  void initState() {
    super.initState();
    _generateRandomNumber();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Input Data Pengeluaran"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _amount = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Jumlah tidak boleh kosong';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Simpan'),
        ),
      ],
    );
  }
}

class DialogFormTambahModal extends StatefulWidget {
  final String trdt;

  const DialogFormTambahModal({Key? key, required this.trdt}) : super(key: key);
  @override
  _DialogFormTambahModalState createState() => _DialogFormTambahModalState();
}

class _DialogFormTambahModalState extends State<DialogFormTambahModal> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  String _amount = "";
  List<TransaksiBO> databo = [];
  int _randomNumber = 0;

  void _generateRandomNumber() {
    setState(() {
      _randomNumber =
          Random().nextInt(10000); // Menghasilkan angka acak dari 0 hingga 99
    });
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Lakukan tindakan setelah validasi
      print("Deskripsi: $_description");
      print("Jumlah: $_amount");
      databo.add(TransaksiBO(
          ctr: '',
          subctr: '',
          transno: _randomNumber.toString(),
          product: '',
          proddesc: '',
          trdt: widget.trdt,
          documentno: _description,
          description: _description,
          type_tr: '1040',
          famount: num.parse(_amount),
          lamount: num.parse(_amount),
          note: '',
          usercreate: usercd,
          active: 1));
      await ClassApi.insertAdujsmentStock(dbname, databo);

      Navigator.pop(context); // Tutup dialog setelah selesai
    }
  }

  @override
  void initState() {
    super.initState();
    _generateRandomNumber();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Input Data Pengeluaran"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _amount = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Jumlah tidak boleh kosong';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Simpan'),
        ),
      ],
    );
  }
}

class DialogCancelClosing extends StatefulWidget {
  final String trdt;

  const DialogCancelClosing({Key? key, required this.trdt}) : super(key: key);
  @override
  _DialogCancelClosingState createState() => _DialogCancelClosingState();
}

class _DialogCancelClosingState extends State<DialogCancelClosing> {
  final _formKey = GlobalKey<FormState>();

  _submitForm() async {
    await ClassApi.cancelClosing(widget.trdt,usercd,dbname);
    Navigator.of(context).pop(true); // Tutup dialog setelah selesai
    
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Batalkan closing"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Oke'),
        ),
      ],
    );
  }
}
