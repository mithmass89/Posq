// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, prefer_generic_function_type_aliases, avoid_print

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:toast/toast.dart';

typedef void StringCallback(IafjrndtClass val);

class ClassRetailManualMobile extends StatefulWidget {
  final Outlet outletinfo;
  final int? itemlenght;
  final String? trno;
  final Function? refreshdata;

  const ClassRetailManualMobile({
    Key? key,
    required this.outletinfo,
    this.itemlenght,
    this.trno,
    this.refreshdata,
  }) : super(key: key);

  @override
  State<ClassRetailManualMobile> createState() =>
      _ClassRetailManualMobileState();
  static _ClassRetailManualMobileState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ClassRetailManualMobileState>();
}

class _ClassRetailManualMobileState extends State<ClassRetailManualMobile> {
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
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: SizedBox(
              height: 70,
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
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
            width: MediaQuery.of(context).size.width * 1,
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: NumPad(
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
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          alignment: Alignment.topCenter,
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              child: IconButton(
                                icon: Icon(
                                  Icons.shopping_bag_outlined,
                                ),
                                iconSize: 30,
                                color: Colors.black,
                                splashColor: Colors.purple,
                                onPressed: () async {
                                  if (_myController.text != '' ||_myController.text =='0' ) {
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
                                    Toast.show("Masukan Harga dulu",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.center);
                                  }

                                  setState(() {});
                                },
                              )),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          alignment: Alignment.topCenter,
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              child: IconButton(
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
                              )),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
