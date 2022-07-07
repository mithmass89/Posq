// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:toast/toast.dart';

class ClassitemRetailMobile extends StatefulWidget {
  final image;
  final Item item;
  final String trdt;
  final String? pscd;
  final String trno;
  const ClassitemRetailMobile(
      {Key? key,
      this.image,
      required this.item,
      required this.trdt,
      this.pscd,
      required this.trno})
      : super(key: key);

  @override
  State<ClassitemRetailMobile> createState() => _ClassitemRetailMobileState();
}

class _ClassitemRetailMobileState extends State<ClassitemRetailMobile> {
  late DatabaseHandler handler;
  int counter = 0;
  IafjrndtClass? result;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB(databasename);
    ToastContext().init(context);
  }

  Future<int> insertIafjrndt() async {
    IafjrndtClass iafjrndt = IafjrndtClass(
      trdt: widget.trdt,
      pscd: widget.item.outletcd,
      trno: widget.trno,
      split: 'A',
      trnobill: 'trnobill',
      itemcd: widget.item.itemcd,
      trno1: widget.trno,
      itemseq: counter,
      cono: 'cono',
      waitercd: 'waitercd',
      discpct: 0,
      discamt: 0,
      qty: 1,
      ratecurcd: 'Rupiah',
      ratebs1: 1,
      ratebs2: 1,
      rateamtcost: widget.item.costamt,
      rateamt: widget.item.slsamt,
      rateamtservice: widget.item.slsamt! * widget.item.svchgpct! / 100,
      rateamttax: widget.item.slsamt! * widget.item.taxpct! / 100,
      rateamttotal: widget.item.slsnett,
      rvnamt: 1 * widget.item.slsamt!.toDouble(),
      taxamt: widget.item.slsamt! * widget.item.taxpct! / 100,
      serviceamt: widget.item.slsamt! * widget.item.svchgpct! / 100,
      nettamt: 1 * widget.item.slsamt! +
          widget.item.slsamt! * widget.item.taxpct! / 100 +
          widget.item.slsamt! * widget.item.svchgpct! / 100,
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
      prnkitchentm: now.hour.toString() +
          ":" +
          now.minute.toString() +
          ":" +
          now.second.toString(),
      confirmed: '1',
      trdesc: widget.item.itemdesc,
      taxpct: widget.item.taxpct,
      servicepct: widget.item.svchgpct,
      statustrans: 'prosess',
      time: now.hour.toString() +
          ":" +
          now.minute.toString() +
          ":" +
          now.second.toString(),
    );
    List<IafjrndtClass> listiafjrndt = [iafjrndt];
    setState(() {
      result = iafjrndt;
    });
    return await handler.insertIafjrndt(listiafjrndt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          dense: true,
          onTap: () async {
            if (widget.item.stock != 0 && widget.item.trackstock == 1) {
              await insertIafjrndt();
              //update to main // callback
              ClassRetailMainMobile.of(context)!.string = result!;
            } else if (widget.item.trackstock == 0) {
              await insertIafjrndt();
              ClassRetailMainMobile.of(context)!.string = result!;
            } else {
              Toast.show("Kamu Kehabisan Stock",
                  duration: Toast.lengthLong, gravity: Toast.center);
            }
          },
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            // color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.13,
            width: MediaQuery.of(context).size.width * 0.19,
            child: Image.file(
              widget.image,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Center(child: const Text('No Image'));
              },
            ),
          ),
          // contentPadding: EdgeInsets.all(8.0),
          title: Text(widget.item.itemdesc!),
          subtitle: Text(widget.item.description == 'Empty'
              ? ''
              : widget.item.description.toString()),
          trailing: widget.item.trackstock == 1
              ? Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        '${CurrencyFormat.convertToIdr(widget.item.slsnett, 0)}',
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.036,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Row(
                        children: [
                          Text(
                            'Stock',
                          ),
                          Text(
                            widget.item.stock.toString(),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Text(
                    '${CurrencyFormat.convertToIdr(widget.item.slsnett, 0)}',
                  ),
                ),
        ),
        Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        )
      ],
    );
  }
}
