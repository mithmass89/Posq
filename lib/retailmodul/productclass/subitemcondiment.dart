// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';

class SubCondiment extends StatefulWidget {
  final int index;
  final Condiment condiment;
  late int qtylist;
  late TextEditingCondiment controller;
  late PosCondiment poscondimentchoice;
  late PosCondiment poscondimenttopping;
  late SelectedItems listchoice;
  SubCondiment({
    Key? key,
    required this.condiment,
    required this.qtylist,
    required this.controller,
    required this.poscondimentchoice,
    required this.poscondimenttopping,
    required this.index,
    required this.listchoice,
  }) : super(key: key);

  @override
  State<SubCondiment> createState() => _SubCondimentState();
}

class _SubCondimentState extends State<SubCondiment> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${widget.condiment.optiondesc}'),
      subtitle: Text(widget.condiment.amount.toString()),
      trailing: Container(
          width: widget.qtylist != 0
              ? MediaQuery.of(context).size.width * 0.42
              : MediaQuery.of(context).size.width * 0.20,
          child: widget.condiment.condimenttype == 'topping'
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.qtylist != 0
                        ? IconButton(
                            onPressed: () {
                              if (widget.qtylist != 0) {
                                widget.qtylist--;
                                widget.controller.controller.text =
                                    widget.qtylist.toString();
                                widget.poscondimenttopping.qty = widget.qtylist;
                                widget.poscondimenttopping.totalamt =
                                    widget.qtylist * widget.condiment.amount!;
                                widget.poscondimenttopping.totalnett =
                                    widget.qtylist * widget.condiment.amount!;
                                print(widget.poscondimenttopping);
                                if (widget.qtylist == 0) {
                                  // widget.poscondimenttopping.removeAt(widget.index);
                                }
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.remove),
                            iconSize: 20,
                          )
                        : Container(),
                    widget.qtylist != 0
                        ? SizedBox(
                            width: 65,
                            height: 60,
                            child: TextFieldMobile2(
                                readonly: true,
                                enable: false,
                                controller: widget.controller.controller,
                                onChanged: (value) {},
                                typekeyboard: TextInputType.number),
                          )
                        : Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ElevatedButton(
                                onPressed: () {
                                  widget.qtylist = 1;
                                  widget.poscondimenttopping.qty =
                                      widget.qtylist;
                                  widget.controller.controller.text =
                                      widget.qtylist.toString();
                                  widget.poscondimenttopping.totalamt =
                                      widget.qtylist * widget.condiment.amount!;
                                  widget.poscondimenttopping.totalnett =
                                      widget.qtylist * widget.condiment.amount!;
                                  // print(poscondimenttopping);
                                  setState(() {});
                                },
                                child: Text('Add')),
                          ),
                    widget.qtylist != 0
                        ? IconButton(
                            onPressed: () {
                              print(widget.index);
                              if (widget.qtylist >= 0) {
                                widget.qtylist++;
                                widget.controller.controller.text =
                                    widget.qtylist.toString();
                                widget.poscondimenttopping.qty = widget.qtylist;
                                widget.poscondimenttopping.totalamt =
                                    widget.qtylist * widget.condiment.amount!;
                                widget.poscondimenttopping.totalnett =
                                    widget.qtylist * widget.condiment.amount!;
                                widget.poscondimenttopping.totalserviceamt =
                                    widget.condiment.qty! *
                                        widget.condiment.serviceamount!;

                                widget.poscondimenttopping.totaltaxamt =
                                    widget.condiment.qty! *
                                        widget.condiment.serviceamount!;
                                print(widget.condiment.serviceamount!);
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.add),
                            iconSize: 20,
                          )
                        : Container(),
                  ],
                )
              : CheckboxListTile(
                  value:  widget.listchoice.isSelected,
                  onChanged: (value) {
                    print(widget.listchoice.name);
                    if (widget.condiment.optiondesc == widget.listchoice.name) {
                      setState(() {
                        widget.listchoice.isSelected = true;
                      });
                    } else {
                      setState(() {
                        widget.listchoice.isSelected = false;
                      });
                    }
                    // widget.poscondimentchoice.add(PosCondiment(
                    //     trdt: formattedDate,
                    //     itemcode: widget.data.itemcode,
                    //     transno: widget.transno,
                    //     outletcode: widget.outletcd,
                    //     itemseq: widget.itemseq,
                    //     condimentcode: widget.condiment.itemcode,
                    //     condimentdesc: widget.condiment.condimentdesc,
                    //     condimenttype: widget.condiment.condimenttype,
                    //     qty: 1,
                    //     rateamt: widget.condiment.amount,
                    //     rateamttax: 0,
                    //     rateamtservice: 0,
                    //     totalamt: widget.condiment.amount,
                    //     totaltaxamt: 0,
                    //     totalserviceamt: 0,
                    //     totalnett: widget.condiment.amount,
                    //     createdt: now.toString(),
                    //     optioncode: widget.condiment.optioncode,
                    //     optiondesc: widget.condiment.optiondesc));
                  })),
    );
  }
}
