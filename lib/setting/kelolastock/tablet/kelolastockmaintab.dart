import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class KelolaProductMainTablet extends StatefulWidget {
  const KelolaProductMainTablet({Key? key}) : super(key: key);

  @override
  State<KelolaProductMainTablet> createState() =>
      _KelolaProductMainTabletState();
}

class _KelolaProductMainTabletState extends State<KelolaProductMainTablet> {
  String query = '';
  List<TextEditingController> _controller = [];
  TextEditingController search = TextEditingController();
  List<int> qty = [];
  List<TransaksiBO> datatrans = [];
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  String type = '1010';
  String trno = '';
  int currenttrno = 0;

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    getTrnoBo();
  }

  getTrnoBo() async {
    currenttrno = await ClassApi.getTrnoBO(type, dbname);
    trno = '$dbname-$currenttrno';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 173, 150),
        foregroundColor: Colors.white,
        splashColor: Colors.yellow,
        hoverColor: Colors.red,
        onPressed: () async {
            EasyLoading.show(status: 'Proses data...');
          await ClassApi.insertAdujsmentStock(dbname, datatrans);
            EasyLoading.dismiss();
                  Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Kelola Stock'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: TextFieldMobile2(
              label: 'Search',
              controller: search,
              typekeyboard: TextInputType.text,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: FutureBuilder(
                future: ClassApi.getItemList(pscd, dbname, search.text),
                builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                  List<Item>? data = snapshot.data;
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          qty.add(0);
                          _controller.add(TextEditingController(text: '0'));

                          return Container(
                            child: ListTile(
                              dense: true,
                              title: Text(data[index].itemdesc!),
                              subtitle:
                                  Text('Stock Saat Ini : ${data[index].stock}'),
                              trailing: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: IconButton(
                                          iconSize: 20,
                                          onPressed: () {
                                            qty[index]++;
                                            _controller[index].text =
                                                qty[index].toString();
                                            if (qty[index] >= 0) {
                                              if (datatrans.any((element) =>
                                                      element.product ==
                                                      data[index].itemcode) ==
                                                  true) {
                                                datatrans[index].qty =
                                                    qty[index];
                                                datatrans[index].famount =
                                                    data[index].costamt! *
                                                        qty[index];
                                                datatrans[index].lamount =
                                                    data[index].costamt! *
                                                        qty[index];
                                              } else {
                                                datatrans.add(TransaksiBO(
                                                    trdt: formattedDate,
                                                    transno: trno,
                                                    documentno: '',
                                                    description:
                                                        'adjusment stock $formattedDate',
                                                    type_tr: type,
                                                    product:
                                                        data[index].itemcode,
                                                    proddesc:
                                                        data[index].itemdesc,
                                                    qty: qty[index],
                                                    unit: 'Unit',
                                                    ctr: 'Inventory',
                                                    subctr: 'Biaya',
                                                    famount:
                                                        data[index].costamt,
                                                    lamount:
                                                        data[index].costamt,
                                                    note:
                                                        'Adjusment Stock PreBo',
                                                    active: 1,
                                                    usercreate: usercd));
                                              }
                                            }
                                            setState(() {});
                                            print(datatrans);
                                          },
                                          icon: Icon(Icons.add)),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      child: TextFieldMobile3(
                                        controller: _controller[index],
                                        typekeyboard: TextInputType.number,
                                        onChanged: (value) {
                                          // datatrans = [];
                                          if (int.parse(value) <= 0) {
                                            _controller[index].text =
                                                0.toString();
                                            setState(() {});
                                          }
                                          qty[index] = int.parse(value);
                                          if (qty[index] >= 0) {
                                            if (datatrans.any((element) =>
                                                    element.product ==
                                                    data[index].itemcode) ==
                                                true) {
                                              datatrans[index].qty = qty[index];
                                              datatrans[index].famount =
                                                  data[index].costamt! *
                                                      qty[index];
                                              datatrans[index].lamount =
                                                  data[index].costamt! *
                                                      qty[index];
                                            } else {
                                              datatrans.add(TransaksiBO(
                                                  trdt: formattedDate,
                                                  transno: trno,
                                                  documentno: '',
                                                  description:
                                                      'adjusment stock $formattedDate',
                                                  type_tr: type,
                                                  product: data[index].itemcode,
                                                  proddesc:
                                                      data[index].itemdesc,
                                                  qty: qty[index],
                                                  unit: 'Unit',
                                                  ctr: 'Inventory',
                                                  subctr: 'Biaya',
                                                  famount: data[index].costamt,
                                                  lamount: data[index].costamt,
                                                  note: 'Adjusment Stock PreBo',
                                                  active: 1,
                                                  usercreate: usercd));
                                            }
                                          } 
                                          if (qty[index] <= 0) {
                                            datatrans.removeWhere((element) =>
                                                element.product ==
                                                data[index].itemcode);
                                          }
                                          print(datatrans);
                                          setState(() {});
                                    
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: IconButton(
                                          iconSize: 20,
                                          onPressed: () {
                                            qty[index] <= 0
                                                ? qty[index]
                                                : qty[index]--;
                                            _controller[index].text =
                                                qty[index].toString();
                                            if (datatrans.any((element) =>
                                                    element.product ==
                                                    data[index].itemcode) ==
                                                true) {
                                              datatrans[index].qty = qty[index];
                                              datatrans[index].famount =
                                                  data[index].costamt! *
                                                      qty[index];
                                              datatrans[index].lamount =
                                                  data[index].costamt! *
                                                      qty[index];
                                            }
                                            if (qty[index] <= 0) {
                                              datatrans.removeWhere((element) =>
                                                  element.product ==
                                                  data[index].itemcode);
                                            }
                                            print(datatrans);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.remove)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}
