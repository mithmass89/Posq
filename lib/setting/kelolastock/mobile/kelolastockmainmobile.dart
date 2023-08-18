import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class KelolaProductMainMobile extends StatefulWidget {
  const KelolaProductMainMobile({Key? key}) : super(key: key);

  @override
  State<KelolaProductMainMobile> createState() =>
      _KelolaProductMainMobileState();
}

class _KelolaProductMainMobileState extends State<KelolaProductMainMobile> {
  String query = '';
  List<TextEditingController> _controller = [];
  TextEditingController search = TextEditingController();
  List<int> qty = [];
  List<TransaksiBO> datatrans = [];
  List<TransaksiBOTemp> datatemp = [];
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  String type = '1010';
  String trno = '';
  int currenttrno = 0;
  List<Item>? datax = [];
  getTrnoBo() async {
    currenttrno = await ClassApi.getTrnoBO(type, dbname);
    trno = '$dbname-$currenttrno';
  }

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    formattedDate = formatter.format(now);
    getTrnoBo();
    data();
    // search.addListener(() {
    //   print('oke');
    // });
  }

  data() async {
    await ClassApi.getItemList(pscd, dbname, search.text).then((value) {
      for (var x in value) {
        datatrans.add(TransaksiBO(
            trdt: formattedDate,
            transno: trno,
            documentno: '',
            description: 'adjusment stock $formattedDate',
            type_tr: type,
            product: x.itemcode,
            proddesc: x.itemdesc,
            qty: 0,
            unit: 'Unit',
            ctr: 'Inventory',
            subctr: 'Biaya',
            famount: x.costamt,
            lamount: x.costamt,
            note: 'Adjusment Stock PreBo',
            active: 1,
            usercreate: usercd));

        _controller.add(TextEditingController(text: '0'));
      }
    });
    print(datatrans);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Kelola Stock'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: TextFieldMobile2(
              focus: _focusNode,
              label: 'Search',
              controller: search,
              typekeyboard: TextInputType.text,
              onChanged: (value) {
                print(search.hasListeners);

                setState(() {});
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: FutureBuilder(
                future: ClassApi.getItemList(pscd, dbname, search.text),
                builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                  datax = snapshot.data;
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: datax!.length,
                        itemBuilder: (context, index) {
                          if (search.hasListeners == true) {
                            for (var x in datax!) {
                              _controller[datax!.indexWhere((element) =>
                                      element.itemcode == x.itemcode)]
                                  .text = datatrans[datatrans.indexWhere(
                                      (element) =>
                                          element.product == x.itemcode)]
                                  .qty
                                  .toString();
                            }
                          }

                          return Container(
                            child: ListTile(
                              dense: true,
                              title: Text(datax![index].itemdesc!),
                              subtitle: Text(
                                  'Stock Saat Ini : ${datax![index].stock}'),
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
                                        

                                            datatrans[datatrans.indexWhere(
                                                    (element) =>
                                                        element.product ==
                                                        datax![index].itemcode)]
                                                .qty++;

                                            print(datatrans.where((element) =>
                                                element.product ==
                                                datax![index].itemcode));
                                            // print(datax!.length);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.add)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.21,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: TextFieldMobile3(
                                        controller: _controller[index],
                                        typekeyboard: TextInputType.number,
                                        onChanged: (value) {
                                          // datatrans = [];

                                          datatrans[datatrans.indexWhere(
                                                  (element) =>
                                                      element.product ==
                                                      datax![index].itemcode)]
                                              .qty = num.parse(value);

                                          print(datatrans);
                                          // setState(() {});
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
                                            if( datatrans[datatrans.indexWhere(
                                                    (element) =>
                                                        element.product ==
                                                        datax![index].itemcode)]
                                                .qty>0)
                                                      datatrans[datatrans.indexWhere(
                                                    (element) =>
                                                        element.product ==
                                                        datax![index].itemcode)]
                                                .qty--;

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
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
          ButtonNoIcon(
              name: 'Simpan',
              color: Colors.orange,
              textcolor: Colors.white,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.94,
              onpressed: () async {
                EasyLoading.show(status: 'Proses data...');
                datatrans.removeWhere((item) => item.qty == 0);
                await ClassApi.insertAdujsmentStock(dbname, datatrans);
                EasyLoading.dismiss();
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
