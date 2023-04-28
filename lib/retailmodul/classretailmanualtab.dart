// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, prefer_generic_function_type_aliases, avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';

typedef void StringCallback(IafjrndtClass val);

class ClassRetailManualTabs extends StatefulWidget {
  final Outlet outletinfo;
  final int? itemlenght;
  final String? trno;
  final Function? refreshdata;
  final String? guestname;

  const ClassRetailManualTabs({
    Key? key,
    required this.outletinfo,
    this.itemlenght,
    this.trno,
    this.refreshdata,
    required this.guestname,
  }) : super(key: key);

  @override
  State<ClassRetailManualTabs> createState() => _ClassRetailManualTabsState();
  static _ClassRetailManualTabsState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ClassRetailManualTabsState>();
}

class _ClassRetailManualTabsState extends State<ClassRetailManualTabs> {
  var userInput = '0';
  var answer = '';
  final TextEditingController _myController = TextEditingController();

  final TextEditingController dialog = TextEditingController();
  final TextEditingController dialogguest = TextEditingController();

  resetTextEditing() {
    setState(() {
      _myController.clear();
      dialog.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    print('ini outletinfo${widget.outletinfo.outletcd}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 1,
            // decoration: BoxDecoration(color: Colors.grey[200]),
            child: Center(
                child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: _myController,
              textAlign: TextAlign.center,
              showCursor: false,
              style: const TextStyle(fontSize: 40),
              // Disable the default soft keybaord
              keyboardType: TextInputType.none,
            )),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * 0.5,
            // decoration: BoxDecoration(color: Colors.grey[200]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.4,
                  alignment: Alignment.topCenter,
                  child: NumPadTabs(
                    controller: _myController,
                    delete: () {
                      _myController.text = _myController.text
                          .substring(0, _myController.text.length - 1);
                    },
                    onSubmit: () {
                      debugPrint('Your code: ${_myController.text}');

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: Text(
                                  "You code is ${_myController.text}",
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ));
                    },
                    clear: () {
                      _myController.text = '';
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.10,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.shopping_bag_outlined,
                                ),
                                iconSize: 30,
                                color: Colors.black,
                                splashColor: Colors.purple,
                                onPressed: () async {
                                  if (_myController.text != '' ||
                                      _myController.text == '0') {
                                    final IafjrndtClass results =
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DialogClassRetailDesc(
                                                itemlenght: widget.itemlenght,
                                                trno: widget.trno,
                                                cleartext: () {
                                                  resetTextEditing();
                                                },
                                                outletinfo: widget.outletinfo,
                                                result: double.parse(
                                                    _myController.text == ''
                                                        ? '0'
                                                        : _myController.text),
                                                controller: dialog,
                                                callback:
                                                    (IafjrndtClass val) {},
                                              );
                                            });
                                    ClassRetailMainMobile.of(context)!.string =
                                        results;
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Isi Amount Dulu",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Color.fromARGB(255, 11, 12, 14),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }

                                  setState(() {});
                                },
                              ),
                              Text('Deskripsi')
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.10,
                          height: MediaQuery.of(context).size.height * 0.2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.contact_page_outlined,
                                ),
                                iconSize: 30,
                                color: Colors.black,
                                splashColor: Colors.purple,
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogCustomerManual(
                                          pscd: widget.outletinfo.outletcd,
                                          trno: widget.trno!,
                                        );
                                      });
                                },
                              ),
                              Text('pelanggan')
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
