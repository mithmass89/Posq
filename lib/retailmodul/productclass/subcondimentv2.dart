// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';

class SubCondimentV2 extends StatefulWidget {
  final Item master;
  late Condiment condiment;
  final String transno;
  late List<Condiment> condimentlist;
  late int qtymaster;
  late List<SelectedItems> selectedChoice;
  final Function? posCodimentChoice;
  final Function? posCodimentTopping;
  final Function? hasUpdate;
  final int subindex;
  final int mainindex;
  late List<PosCondiment> poscondimentchoice;
  late List<PosCondiment> poscondimenttopping;
  final int itemseq;
  final formattedDate;
  final String outletcd;
  final bool fromedit;
  late bool hasupdate;
  SubCondimentV2({
    Key? key,
    required this.condiment,
    required this.qtymaster,
    required this.poscondimentchoice,
    required this.poscondimenttopping,
    required this.condimentlist,
    required this.selectedChoice,
    required this.posCodimentChoice,
    required this.subindex,
    required this.mainindex,
    required this.itemseq,
    this.formattedDate,
    required this.outletcd,
    required this.transno,
    required this.posCodimentTopping,
    required this.master,
    required this.fromedit,
    required this.hasupdate,
    required this.hasUpdate,
  }) : super(key: key);

  @override
  State<SubCondimentV2> createState() => _SubCondimentV2State();
}

class _SubCondimentV2State extends State<SubCondimentV2> {
  bool selected = false;
  String itemselected = '';
  TextEditingController _controller = TextEditingController(text: '0');
  int qty = 0;
  List<Condiment> classchoice = [];

  @override
  void initState() {
    super.initState();
    //check apakah dari edit //
    print(widget.condiment.qty);
    if (widget.fromedit == true) {
      if (widget.poscondimentchoice.any(
              (element) => element.optioncode == widget.condiment.optioncode) ==
          true) {
        widget.condiment.isSelected = true;
        for (var x in widget.poscondimentchoice) {
          qty = x.qty!.toInt();
          x.qtystarted = 1;
        }
      } else if (widget.poscondimenttopping.any(
              (element) => element.optioncode == widget.condiment.optioncode) ==
          true) {
        for (var x in widget.poscondimenttopping.where(
            (element) => element.optioncode == widget.condiment.optioncode)) {
          _controller.text = x.qty.toString();
          qty = x.qty!.toInt();
          x.qtystarted = qty;
          print(x.qty);
        }
      }
      setState(() {});
    } else {
      // widget.condimentlist.first.isSelected = true;
      // widget.posCodimentChoice!();
      // classchoice.add(widget.condimentlist.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.condiment.condimenttype == 'topping'
            ? ListTile(
                dense: true,
                title: Text(widget.condiment.optiondesc!),
                trailing: Container(
                    width: qty != 0
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.23,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        qty != 0
                            ? IconButton(
                                onPressed: () {
                                  if (qty != 0) {
                                    widget.hasUpdate!(true);
                                    qty--;
                                    _controller.text = qty.toString();
                                    bool exist = widget.poscondimenttopping.any(
                                        (element) =>
                                            element.optioncode ==
                                            widget.condiment.optioncode);

                                    if (exist == true) {
                                      for (var x in widget.poscondimenttopping
                                          .where((element) =>
                                              element.optioncode ==
                                              widget.condiment.optioncode)) {
                                        x.qty = widget.qtymaster * qty;

                                        x.qtystarted = qty;
                                        x.totalamt = widget.qtymaster *
                                            qty *
                                            widget.condiment.amount!;
                                        x.totaltaxamt = x.totalamt! *
                                            widget.condiment.taxpct! /
                                            100;
                                        x.totalserviceamt = x.totalamt! *
                                            widget.condiment.taxpct! /
                                            100;
                                        x.totalnett =
                                            (qty * widget.condiment.amount!) +
                                                x.totalserviceamt! +
                                                x.totaltaxamt!;
                                      }
                                    }
                                  }
                                  for (var x in widget.poscondimenttopping
                                      .where((element) => element.qty == 0)) {
                                    widget.poscondimenttopping.remove(x);
                                    widget.posCodimentTopping!();
                                  }
                                  setState(() {});
                                  widget.posCodimentTopping!();
                                  print(widget.poscondimenttopping);
                                },
                                icon: Icon(Icons.remove),
                                iconSize: 20,
                              )
                            : Container(),
                        qty != 0
                            ? SizedBox(
                                width: 65,
                                height: 60,
                                child: TextFieldMobile2(
                                    readonly: true,
                                    enable: false,
                                    controller: _controller,
                                    onChanged: (value) {},
                                    typekeyboard: TextInputType.number),
                              )
                            : Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.21,
                                child: ElevatedButton(
                                    onPressed: () {
                                      qty++;
                                      widget.hasUpdate!(true);
                                      _controller.text = qty.toString();
                                      widget.poscondimenttopping.add(PosCondiment(
                                          transno: widget.transno,
                                          itemseq: widget.itemseq,
                                          trdt: widget.formattedDate,
                                          outletcode: widget.outletcd,
                                          itemcode: widget.master.itemcode,
                                          condimentcode:
                                              widget.condiment.itemcode,
                                          condimentdesc:
                                              widget.condiment.condimentdesc,
                                          condimenttype:
                                              widget.condiment.condimenttype,
                                          qty: widget.qtymaster * 1,
                                          rateamt: widget.condiment.amount,
                                          rateamtservice:
                                              widget.condiment.serviceamount,
                                          rateamttax:
                                              widget.condiment.taxamount,
                                          totalamt: widget.qtymaster *
                                              1 *
                                              widget.condiment.amount!,
                                          totalserviceamt: 1 *
                                              widget.condiment.serviceamount!,
                                          totaltaxamt:
                                              1 * widget.condiment.taxamount!,
                                          totalnett: 1 *
                                                  widget.condiment.amount! +
                                              (1 *
                                                  widget.condiment
                                                      .serviceamount!) +
                                              (1 * widget.condiment.taxamount!),
                                          optioncode:
                                              widget.condiment.optioncode,
                                          optiondesc:
                                              widget.condiment.optiondesc,
                                          qtystarted: 1));

                                      setState(() {});
                                      widget.posCodimentTopping!();
                                    },
                                    child: Text('Add')),
                              ),
                        qty != 0
                            ? IconButton(
                                onPressed: () {
                                  if (qty >= 0) {
                                    qty++;
                                    widget.hasUpdate!(true);
                                    _controller.text = qty.toString();
                                    bool exist = widget.poscondimenttopping.any(
                                        (element) =>
                                            element.optioncode ==
                                            widget.condiment.optioncode);

                                    if (exist == true) {
                                      for (var x in widget.poscondimenttopping
                                          .where((element) =>
                                              element.optioncode ==
                                              widget.condiment.optioncode)) {
                                        x.qty = widget.qtymaster * qty;
                                        x.qtystarted = qty;
                                        x.totalamt = widget.qtymaster *
                                            qty *
                                            widget.condiment.amount!;
                                        x.totaltaxamt = x.totalamt! *
                                            widget.condiment.taxpct! /
                                            100;
                                        x.totalserviceamt = x.totalamt! *
                                            widget.condiment.taxpct! /
                                            100;
                                        x.totalnett = widget.qtymaster *
                                                (qty *
                                                    widget.condiment.amount!) +
                                            x.totalserviceamt! +
                                            x.totaltaxamt!;
                                      }
                                    }
                                  }
                                  setState(() {});
                                  widget.posCodimentTopping!();
                                  print(widget.poscondimenttopping);
                                },
                                icon: Icon(Icons.add),
                                iconSize: 20,
                              )
                            : Container()
                      ],
                    )),
              )
            : ListTile(
                dense: true,
                title: Text(widget.condiment.optiondesc!),
                trailing: Checkbox(
                    value: widget.condiment.isSelected,
                    onChanged: (bool? value) {
                      for (var x in widget.condimentlist.where((element) =>
                          element.itemcode == widget.condiment.itemcode)) {
                        x.isSelected = false;
                        classchoice.add(x);
                      }
                      print(classchoice);
                      for (var x in widget.condimentlist.where((element) =>
                          element.optioncode == widget.condiment.optioncode)) {
                        x.isSelected = true;
                      }

                      print(widget.condimentlist
                          .where((element) => element.isSelected == true));
                      widget.posCodimentChoice!();
                      setState(() {});
                    }),
              ));
  }
}
