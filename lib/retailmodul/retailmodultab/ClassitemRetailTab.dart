// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/retailmodul/productclass/classretailcondimenttab.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassitemRetailTabs extends StatefulWidget {
  final image;
  final Item item;
  final String trdt;
  final String? pscd;
  final String trno;
  final int itemseq;
  final String? guestname;
  final VoidCallback refreshdata;
  final VoidCallback? updatedata;

  const ClassitemRetailTabs({
    Key? key,
    this.image,
    required this.item,
    required this.trdt,
    this.pscd,
    required this.trno,
    required this.itemseq,
    this.guestname,
    required this.refreshdata,
    required this.updatedata,
  }) : super(key: key);

  @override
  State<ClassitemRetailTabs> createState() => _ClassitemRetailTabsState();
}

class _ClassitemRetailTabsState extends State<ClassitemRetailTabs> {
  int counter = 0;
  IafjrndtClass? result;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    print('ini dari product ${widget.trno}');
  }

  Future<List<Item>> getitemOutlet(query) async {
    List<Item> data = await ClassApi.getItemList(pscd, dbname, query);
    return data;
  }

  Future<IafjrndtClass?> insertIafjrndt() async {
    now = DateTime.now();

    await ClassApi.insertPosDetail(
        IafjrndtClass(
          totalcost: widget.item.costamt!*1,
          trdt: widget.trdt,
          pscd: pscd,
          transno: widget.trno,
          split: 1,
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
          ratecostamt: widget.item.costamt!,
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
          svchgpct: widget.item.svchgpct,
          statustrans: 'prosess',
          createdt: now.toString(),
          guestname: widget.guestname,
        ),
        pscd);
    result = IafjrndtClass(
      totalcost: widget.item.costamt!*1,
      trdt: widget.trdt,
      pscd: pscd,
      transno: widget.trno,
      split: 1,
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
      ratecostamt: widget.item.costamt!,
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
      svchgpct: widget.item.svchgpct,
      statustrans: 'prosess',
      createdt: now.toString(),
      guestname: widget.guestname,
    );
    return result;
  }

  Future<IafjrndtClass?> insertIafjrndtRefundMod() async {
    now = DateTime.now();

    await ClassApi.insertPosDetail(
        IafjrndtClass(
          totalcost:widget.item.costamt!*1,
          trdt: widget.trdt,
          pscd: pscd,
          transno: widget.trno,
          split: 1,
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
          ratecostamt: -widget.item.costamt!,
          rateamtitem: -widget.item.slsamt!,
          rateamtservice: -(widget.item.slsamt! * widget.item.svchgpct! / 100),
          rateamttax: -(widget.item.slsamt! * widget.item.taxpct! / 100),
          rateamttotal: -widget.item.slsnett!,
          revenueamt: -(1 * widget.item.slsamt!.toDouble()),
          taxamt: -(widget.item.slsamt! * widget.item.taxpct! / 100),
          serviceamt: -(widget.item.slsamt! * widget.item.svchgpct! / 100),
          totalaftdisc: -(1 * widget.item.slsamt! +
              widget.item.slsamt! * widget.item.taxpct! / 100 +
              widget.item.slsamt! * widget.item.svchgpct! / 100),
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
          description: 'refund mode',
          taxpct: widget.item.taxpct,
          svchgpct: widget.item.svchgpct,
          statustrans: 'prosess',
          createdt: now.toString(),
          guestname: widget.guestname,
        ),
        pscd);
    result = IafjrndtClass(
      totalcost:widget.item.costamt!*(-1),
      trdt: widget.trdt,
      pscd: pscd,
      transno: widget.trno,
      split: 1,
      transno1: 'trnobill',
      itemcode: widget.item.itemcode,
      itemdesc: widget.item.itemdesc,
      trno1: widget.trno,
      itemseq: widget.itemseq,
      cono: 'cono',
      waitercd: 'waitercd',
      discpct: 0,
      discamt: 0,
      qty: -1,
      ratecurcd: 'Rupiah',
      ratebs1: 1,
      ratebs2: 1,
      ratecostamt: -widget.item.costamt!,
      rateamtitem: -widget.item.slsamt!,
      rateamtservice: -(widget.item.slsamt! * widget.item.svchgpct! / 100),
      rateamttax: -(widget.item.slsamt! * widget.item.taxpct! / 100),
      rateamttotal: -widget.item.slsnett!,
      revenueamt: -(1 * widget.item.slsamt!.toDouble()),
      taxamt: -(widget.item.slsamt! * widget.item.taxpct! / 100),
      serviceamt: -(widget.item.slsamt! * widget.item.svchgpct! / 100),
      totalaftdisc: -(1 * widget.item.slsamt! +
          widget.item.slsamt! * widget.item.taxpct! / 100 +
          widget.item.slsamt! * widget.item.svchgpct! / 100),
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
      svchgpct: widget.item.svchgpct,
      statustrans: 'prosess',
      createdt: now.toString(),
      guestname: widget.guestname,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // dense: true,
      onTap: () async {
        if (widget.item.modifiers == 0) {
          if (widget.item.stock != 0 && widget.item.trackstock == 1) {
            await getitemOutlet(widget.item.itemcode).then((value) async {
              print('ini checking data $value');
              if (value.first.stock! > 0) {
                if (refundmode == true) {
                  insertIafjrndtRefundMod();
                } else {
                  await insertIafjrndt();
                }

                ClassRetailMainMobile.of(context)!.string = result!;
              } else {
                Toast.show("Kamu Kehabisan Stock",
                    duration: Toast.lengthLong, gravity: Toast.center);
              }
            });
            // DetailTransTabs.of(context)!.refreshtrans = result!;
          } else if (widget.item.trackstock == 0) {
            if (refundmode == true) {
              await insertIafjrndtRefundMod();
              ClassRetailMainMobile.of(context)!.string = result!;
            } else {
              await insertIafjrndt();
              ClassRetailMainMobile.of(context)!.string = result!;
            }

            // DetailTransTabs.of(context)!.refreshtrans = result!;
          } else {
            Toast.show("Kamu Kehabisan Stock",
                duration: Toast.lengthLong, gravity: Toast.center);
          }
        } else {
          if (refundmode == false) {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClassInputCondimentTab(
                        guestname: widget.guestname!,
                        fromedit: false,
                        itemseq: widget.itemseq,
                        outletcd: pscd,
                        transno: widget.trno,
                        data: widget.item,
                      )),
            );
            print("ini result $result");
            ClassRetailMainMobile.of(context)!.string = result!;
          } else {
            Toast.show("Mode ini belum aktif",
                duration: Toast.lengthLong, gravity: Toast.center);
          }
        }
        widget.refreshdata();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                // color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.19,
                width: MediaQuery.of(context).size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image.network(
                    widget.item.pathimage!,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930',
                        fit: BoxFit.fill,
                      );
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 160, 147),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              height: MediaQuery.of(context).size.height * 0.09,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.22,
                      child: Text(
                        widget.item.itemdesc!,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    widget.item.modifiers != 0
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              'Bisa Custome : ${widget.item.modifiers.toString()}',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          )
                        : Container(),
                    widget.item.trackstock == 1
                        ? Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  '${CurrencyFormat.convertToIdr(widget.item.slsnett, 0)}',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ),
                               widget.item.trackstock=='1'?    Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: Row(
                                  children: [
                               Text('Stk : ',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white)),
                                    Text(
                                      widget.item.stock.toString(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            :Container()],
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              '${CurrencyFormat.convertToIdr(widget.item.slsnett, 0)}',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // contentPadding: EdgeInsets.all(8.0),
    );
  }
}
