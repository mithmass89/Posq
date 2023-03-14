// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/productclass/classretailcondiment.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassitemRetailMobile extends StatefulWidget {
  final image;
  final Item item;
  final String trdt;
  final String? pscd;
  final String trno;
  final int itemseq;
  const ClassitemRetailMobile(
      {Key? key,
      this.image,
      required this.item,
      required this.trdt,
      this.pscd,
      required this.trno,
      required this.itemseq})
      : super(key: key);

  @override
  State<ClassitemRetailMobile> createState() => _ClassitemRetailMobileState();
}

class _ClassitemRetailMobileState extends State<ClassitemRetailMobile> {
  int counter = 0;
  IafjrndtClass? result;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    print(widget.trno);
  }

  Future<IafjrndtClass?> insertIafjrndt() async {
    now = DateTime.now();
    await ClassApi.insertPosDetail(
        IafjrndtClass(
            trdt: widget.trdt,
            pscd: pscd,
            transno: widget.trno,
            split: 'A',
            transno1: 'trnobill',
            itemcode: widget.item.itemcode,
            itemdesc: widget.item.itemdesc,
            trno1: widget.trno,
            itemseq: widget.itemseq,
            cono: 'cono',
            waitercd: 'waitercd',
            discpct: 0,
            discamt: 0,
            qty: 1,
            ratecurcd: 'Rupiah',
            ratebs1: 1,
            ratebs2: 1,
            rateamtcost: widget.item.costamt,
            rateamtitem: widget.item.slsamt,
            rateamtservice: widget.item.slsamt! * widget.item.svchgpct! / 100,
            rateamttax: widget.item.slsamt! * widget.item.taxpct! / 100,
            rateamttotal: widget.item.slsnett,
            revenueamt: 1 * widget.item.slsamt!.toDouble(),
            taxamt: widget.item.slsamt! * widget.item.taxpct! / 100,
            serviceamt: widget.item.slsamt! * widget.item.svchgpct! / 100,
            totalaftdisc: 1 * widget.item.slsamt! +
                widget.item.slsamt! * widget.item.taxpct! / 100 +
                widget.item.slsamt! * widget.item.svchgpct! / 100,
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
            description: widget.item.itemdesc,
            taxpct: widget.item.taxpct,
            servicepct: widget.item.svchgpct,
            statustrans: 'prosess',
            createdt: now.toString()),
        pscd);
    result = IafjrndtClass(
        trdt: widget.trdt,
        pscd: pscd,
        transno: widget.trno,
        split: 'A',
        transno1: 'trnobill',
        itemcode: widget.item.itemcode,
        itemdesc: widget.item.itemdesc,
        trno1: widget.trno,
        itemseq: widget.itemseq,
        cono: 'cono',
        waitercd: 'waitercd',
        discpct: 0,
        discamt: 0,
        qty: 1,
        ratecurcd: 'Rupiah',
        ratebs1: 1,
        ratebs2: 1,
        rateamtcost: widget.item.costamt,
        rateamtitem: widget.item.slsamt,
        rateamtservice: widget.item.slsamt! * widget.item.svchgpct! / 100,
        rateamttax: widget.item.slsamt! * widget.item.taxpct! / 100,
        rateamttotal: widget.item.slsnett,
        revenueamt: 1 * widget.item.slsamt!.toDouble(),
        taxamt: widget.item.slsamt! * widget.item.taxpct! / 100,
        serviceamt: widget.item.slsamt! * widget.item.svchgpct! / 100,
        totalaftdisc: 1 * widget.item.slsamt! +
            widget.item.slsamt! * widget.item.taxpct! / 100 +
            widget.item.slsamt! * widget.item.svchgpct! / 100,
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
        description: widget.item.itemdesc,
        taxpct: widget.item.taxpct,
        servicepct: widget.item.svchgpct,
        statustrans: 'prosess',
        createdt: now.toString());
    return result;
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
            if (widget.item.modifiers == 0) {
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
            } else {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClassInputCondiment(
                          itemseq: widget.itemseq,
                          outletcd: pscd,
                          transno: widget.trno,
                          data: widget.item,
                        )),
              );
              print("ini result $result");
              ClassRetailMainMobile.of(context)!.string = result!;
            }
          },
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            // color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.20,
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
          subtitle: Text(widget.item.modifiers.toString()),
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