import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/productclass/subcondimentv2.dart';
import 'package:posq/retailmodul/productclass/subcondimentv2tab.dart';
import 'package:posq/userinfo.dart';
import 'package:collection/collection.dart';

class ClassInputCondimentTab extends StatefulWidget {
  final Item data;
  final String transno;
  final String outletcd;
  final int itemseq;
  final List<IafjrndtClass>? dataedit;
  final IafjrndtClass? datatransaksi;
  final bool? fromedit;
  final int? iditem;
  final String guestname;
  const ClassInputCondimentTab({
    Key? key,
    required this.data,
    required this.transno,
    this.dataedit,
    required this.outletcd,
    required this.itemseq,
    required this.fromedit,
    this.iditem,
    this.datatransaksi,
    required this.guestname,
  }) : super(key: key);

  @override
  State<ClassInputCondimentTab> createState() => _ClassInputCondimentTabState();
}

class _ClassInputCondimentTabState extends State<ClassInputCondimentTab> {
  ScrollController _controllerscroll = ScrollController(); // scroll controller
  String query = '';
  List<Condiment> condiment = [];
  TextEditingController _controlllermainitem = TextEditingController(text: '0');
  TextEditingController note = TextEditingController();
  Map<String, List<Condiment>> groupedCondiments = {};
  List<String> keys = [];
  List<TextEditingCondiment> controller = [];

  List<SelectedItems> listchoice = [];
  List<int> qtylist = [];
  String isSelected = '';
  List<PosCondiment> summarycondiment = [];
  List<PosCondiment> poscondimentchoice = [];
  List<PosCondiment> poscondimenttopping = [];

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  Future? getdetailcondiment;
  Future? checkfromedit;
  List<String> controllerindexing = [];
  bool _isloading = false;
  int qtyitemmaster = 1;
  bool hasupdate = false;

//mengammbil data condiment dari item yg tersetup//
  Future<void> getDetailCondiment() async {
    condiment =
        await ClassApi.getItemCondiment(widget.data.itemcode!, dbname, query);
    // print(condiment);
    groupedData();
    if (widget.fromedit == true) {
      await checkFromEdit();
    }
    setState(() {});
  }

//function grouping data//

  groupedData() {
    groupedCondiments = groupBy(condiment, (Condiment c) => c.condimentdesc!);
    for (var x in groupedCondiments.keys) {
      keys.add(x);
    }
  }

//proses milih condiment //
  posCodimentChoice() {
    poscondimentchoice = [];
    for (var x in condiment.where((element) => element.isSelected == true)) {
      poscondimentchoice.add(PosCondiment(
          transno: widget.transno,
          itemseq: widget.itemseq,
          trdt: formattedDate,
          outletcode: widget.outletcd,
          itemcode: widget.data.itemcode,
          condimentcode: x.itemcode,
          condimentdesc: x.condimentdesc,
          condimenttype: x.condimenttype,
          qty: 1,
          rateamt: x.amount,
          rateamtservice: x.serviceamount,
          rateamttax: x.taxamount,
          totalamt: 1 * x.amount!,
          totalserviceamt: 1 * x.serviceamount!,
          totaltaxamt: 1 * x.taxamount!,
          totalnett: 1 * x.amount!,
          optioncode: x.optioncode,
          optiondesc: x.optiondesc,
          qtystarted: 1));
    }
    setState(() {});

    // print(poscondimentchoice);
  }

  posCodimentTopping() {
    setState(() {});
    // print(poscondimenttopping);
  }

  ///check dari edit or not //
  checkFromEdit() async {
    var data = await ClassApi.getDetailCondimentTrno(widget.transno,
        widget.data.itemcode!, widget.itemseq.toString(), dbname, pscd);
    // print("ini data for edit $data");
    for (var x in data) {
      if (x.condimenttype == 'menuchoice') {
        poscondimentchoice.add(x);
      } else {
        poscondimenttopping.add(x);
      }
    }
    for (var x in poscondimenttopping) {
      x.qty = x.qty! / widget.datatransaksi!.qty!;
      x.qty = x.qty!.toInt();
      x.qtystarted = widget.datatransaksi!.qty!;
      print('ini qtystarted ${x.qtystarted}');
    }

    qtyitemmaster = widget.datatransaksi!.qty!;
    _controlllermainitem.text = widget.datatransaksi!.qty.toString();

    setState(() {});
  }

  functionBool(hasil) {
    hasupdate = hasil;
    // apakah ada perubahan data atau tidak ;
  }

  @override
  void initState() {
    super.initState();
    getDetailCondiment();
    _controlllermainitem.text = qtyitemmaster.toString();
    // checkfromedit = checkItemExistFromEdit();
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu Modifier'),
        ),
        body: Center(
          child: Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                        controller: _controllerscroll,
                        itemCount: keys.length,
                        itemBuilder: (context, i) {
                          var x = groupedCondiments[keys[i]];
                          return ListTile(
                            title: Text(
                              '* ${keys[i]} *',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Container(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: ListView.builder(
                                  controller: _controllerscroll,
                                  itemCount: x!.length,
                                  itemBuilder: (context, index) {
                                    return SubCondimentV2Tab(
                                      hasUpdate: functionBool,
                                      hasupdate: hasupdate,
                                      fromedit: widget.fromedit!,
                                      master: widget.data,
                                      qtymaster: qtyitemmaster,
                                      posCodimentTopping: posCodimentTopping,
                                      poscondimenttopping: poscondimenttopping,
                                      transno: widget.transno,
                                      outletcd: widget.outletcd,
                                      formattedDate: formattedDate,
                                      itemseq: widget.itemseq,
                                      poscondimentchoice: poscondimentchoice,
                                      mainindex: i,
                                      subindex: index,
                                      selectedChoice: listchoice,
                                      posCodimentChoice: posCodimentChoice,
                                      condimentlist: condiment,
                                      condiment: x[index],
                                    );
                                    // return SubCondiment(
                                    //   index: index,
                                    //   poscondimentchoice: poscondimentchoice[index],
                                    //   poscondimenttopping:
                                    //       poscondimenttopping[index],
                                    //   controller: controller[index],
                                    //   qtylist: qtylist[index],
                                    //   condiment: x[index],
                                    //   listchoice: listchoice[index],
                                    // );
                                  }),
                            ),
                          );
                        })),
            
                 Row(
                   children: [
                    SizedBox(

                           width: MediaQuery.of(context).size.width * 0.02,
                    ),
                     Text('Catatan'),
                   ],
                 ),
                 
             
                TextFieldTab2(
                    height: MediaQuery.of(context).size.height * 0.05,
                    hint: 'Contoh : gak pake sayur',
                    controller: note,
                    onChanged: (value) {},
                    typekeyboard: null),
                ListTile(
                    trailing: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Row(
                          children: [
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                if (qtyitemmaster > 1) {
                                  hasupdate = true;
                                  qtyitemmaster--;
                                  _controlllermainitem.text =
                                      qtyitemmaster.toString();
                                  poscondimentchoice.forEach((element) {
                                    element.qty =
                                        element.qtystarted! * qtyitemmaster;
                                    element.totalamt =
                                        qtyitemmaster * element.rateamt!;
                                    element.totaltaxamt =
                                        element.rateamttax! * element.qty!;
                                    element.totalserviceamt =
                                        element.rateamtservice! * element.qty!;
                                    element.totalnett =
                                        element.qty! * element.rateamt! +
                                            element.totalserviceamt! +
                                            element.totaltaxamt!;
                                  });
                                  poscondimenttopping.forEach((element) {
                                    element.qty =
                                        element.qtystarted! * qtyitemmaster;
                                    element.totalamt =
                                        element.qty! * element.rateamt!;
                                    element.totaltaxamt =
                                        element.rateamttax! * element.qty!;
                                    element.totalserviceamt =
                                        element.rateamtservice! * element.qty!;
                                    element.totalnett =
                                        element.qty! * element.rateamt! +
                                            element.totalserviceamt! +
                                            element.totaltaxamt!;
                                  });
                                  // print(poscondimenttopping);
                                  // print(hasupdate);
                                  setState(() {});
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                              ),
                              iconSize: 20,
                            ),
                            SizedBox(
                              width: 65,
                              height: 60,
                              child: TextFieldMobile2(
                                  readonly: true,
                                  enable: false,
                                  controller: _controlllermainitem,
                                  onChanged: (value) {},
                                  typekeyboard: TextInputType.number),
                            ),
                            IconButton(
                              onPressed: () {
                                if (qtyitemmaster >= 1) {
                                  hasupdate = true;
                                  qtyitemmaster++;
                                  _controlllermainitem.text =
                                      qtyitemmaster.toString();
                                  poscondimentchoice.forEach((element) {
                                    element.qty =
                                        element.qtystarted! * qtyitemmaster;
                                    element.totalamt =
                                        qtyitemmaster * element.rateamt!;
                                    element.totaltaxamt =
                                        element.rateamttax! * element.qty!;
                                    element.totalserviceamt =
                                        element.rateamtservice! * element.qty!;
                                    element.totalnett =
                                        element.qty! * element.rateamt! +
                                            element.totalserviceamt! +
                                            element.totaltaxamt!;
                                  });
                                  poscondimenttopping.forEach((element) {
                                    element.qty =
                                        element.qtystarted! * qtyitemmaster;
                                    element.totalamt =
                                        element.qty! * element.rateamt!;

                                    element.totaltaxamt =
                                        element.rateamttax! * element.qty!;
                                    element.totalserviceamt =
                                        element.rateamtservice! * element.qty!;
                                    element.totalnett =
                                        element.qty! * element.rateamt! +
                                            element.totalserviceamt! +
                                            element.totaltaxamt!;
                                  });
                                  setState(() {});
                                  // print(poscondimenttopping);
                                  // print(hasupdate);
                                }
                              },
                              icon: Icon(Icons.add),
                              iconSize: 20,
                            )
                          ],
                        )),
                    title: Container(
                      child: Text(
                        widget.data.itemdesc!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                widget.fromedit == false || widget.fromedit == null
                    ? LoadingButton(
                        isLoading: _isloading,
                        color: Colors.orange,
                        textcolor: Colors.white,
                        name: 'Simpan',
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
                        onpressed: _isloading == false
                            ? () async {
                                setState(() {
                                  _isloading = true;
                                });
                                //jadi satu list //
                                for (var x in poscondimentchoice) {
                                  summarycondiment.add(x);
                                }
                                for (var x in poscondimenttopping) {
                                  summarycondiment.add(x);
                                }
                                await ClassApi.insert_Poscondiment(
                                    dbname, summarycondiment);
                                await ClassApi.insertPosDetail(
                                    IafjrndtClass(
                                      trdt: formattedDate,
                                      pscd: widget.data.outletcode,
                                      transno: widget.transno,
                                      transno1: widget.transno,
                                      split: 1,
                                      itemcode: widget.data.itemcode,
                                      itemdesc: widget.data.itemdesc,
                                      description: widget.data.description,
                                      itemseq: widget.itemseq,
                                      qty: qtyitemmaster,
                                      discpct: 0,
                                      discamt: 0,
                                      ratecurcd: 'Rupiah',
                                      ratebs1: 1,
                                      ratebs2: 1,
                                      rateamtitem: widget.data.slsamt,
                                      rateamtcost: widget.data.costamt,
                                      rateamtservice: widget.data.slsamt! *
                                          widget.data.svchgpct! /
                                          100,
                                      rateamttax: widget.data.slsamt! *
                                          widget.data.taxpct! /
                                          100,
                                      rateamttotal: widget.data.slsamt! +
                                          (widget.data.slsamt! *
                                              widget.data.svchgpct! /
                                              100) +
                                          (widget.data.slsamt! *
                                              widget.data.taxpct! /
                                              100),
                                      revenueamt:
                                          qtyitemmaster * widget.data.slsamt!,
                                      taxamt: (widget.data.slsamt! *
                                              widget.data.taxpct! /
                                              100) *
                                          qtyitemmaster,
                                      serviceamt: (widget.data.slsamt! *
                                              widget.data.svchgpct! /
                                              100) *
                                          qtyitemmaster,
                                      totalaftdisc:
                                          qtyitemmaster * widget.data.slsamt! +
                                              ((widget.data.slsamt! *
                                                      widget.data.svchgpct! /
                                                      100) *
                                                  qtyitemmaster) +
                                              ((widget.data.slsamt! *
                                                      widget.data.taxpct! /
                                                      100) *
                                                  qtyitemmaster),
                                      rebateamt: 0,
                                      rvncoa: 'REVENUE',
                                      taxcoa: 'TAX',
                                      servicecoa: 'SERVICE',
                                      costcoa: 'COST',
                                      active: 1,
                                      usercrt: usercd,
                                      userupd: '',
                                      userdel: '',
                                      prnkitchen: 0,
                                      prnkitchentm: now.hour.toString() +
                                          ":" +
                                          now.minute.toString() +
                                          ":" +
                                          now.second.toString(),
                                      confirmed: '1',
                                      taxpct: widget.data.taxpct,
                                      svchgpct: widget.data.svchgpct,
                                      createdt: now.toString(),
                                      guestname: widget.guestname,
                                    ),
                                    pscd);
                                var result = IafjrndtClass(
                                    trdt: formattedDate,
                                    pscd: widget.data.outletcode,
                                    transno: widget.transno,
                                    transno1: widget.transno,
                                    split: 1,
                                    itemcode: widget.data.itemcode,
                                    itemdesc: widget.data.itemdesc,
                                    description: widget.data.description,
                                    qty: 1,
                                    discpct: 0,
                                    discamt: 0,
                                    ratecurcd: 'Rupiah',
                                    ratebs1: 1,
                                    ratebs2: 1,
                                    rateamtcost: widget.data.costamt,
                                    rateamtservice: 0,
                                    rateamttax: 0,
                                    rateamttotal: widget.data.slsamt!,
                                    revenueamt: 1 * widget.data.slsamt!,
                                    taxamt: 0,
                                    serviceamt: 0,
                                    totalaftdisc: 1 * widget.data.slsamt!,
                                    rebateamt: 0,
                                    rvncoa: 'REVENUE',
                                    taxcoa: 'TAX',
                                    servicecoa: 'SERVICE',
                                    costcoa: 'COST',
                                    active: 1,
                                    usercrt: usercd,
                                    userupd: '',
                                    userdel: '',
                                    prnkitchen: 0,
                                    prnkitchentm: now.hour.toString() +
                                        ":" +
                                        now.minute.toString() +
                                        ":" +
                                        now.second.toString(),
                                    confirmed: '1',
                                    taxpct: widget.data.taxpct,
                                    svchgpct: widget.data.svchgpct,
                                    createdt: now.toString(),
                                    guestname: widget.guestname);
                                // ClassRetailMainMobile.of(context)!.string = result;
                                setState(() {
                                  _isloading = false;
                                });
                                Navigator.of(context).pop(result);
                              }
                            : null,
                      )
                    : LoadingButton(
                        isLoading: _isloading,
                        color: Colors.orange,
                        textcolor: Colors.white,
                        name: 'Update',
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
                        onpressed: _isloading == false
                            ? () async {
                                setState(() {
                                  _isloading = true;
                                });
                                // print('ini hasupdate : $hasupdate');
                                //jadi satu list //
                                await ClassApi.updateCondimentTrno(
                                    widget.transno,
                                    widget.itemseq.toString(),
                                    dbname);
                                for (var x in poscondimentchoice) {
                                  summarycondiment.add(x);
                                }
                                if (hasupdate == false) {
                                  for (var x in poscondimenttopping) {
                                    x.qty = x.qty! * widget.datatransaksi!.qty!;
                                    print(x.qty);
                                  }
                                } else {
                                  for (var x in poscondimenttopping) {
                                    x.qty = x.qtystarted! * qtyitemmaster;
                                    print(x.qty);
                                  }
                                }

                                for (var x in poscondimenttopping) {
                                  summarycondiment.add(x);
                                }
                                await ClassApi.insert_Poscondiment(
                                    dbname, summarycondiment);
                                var result = IafjrndtClass(
                                    id: widget.iditem,
                                    trdt: formattedDate,
                                    pscd: widget.outletcd,
                                    transno: widget.transno,
                                    transno1: widget.transno,
                                    split: 1,
                                    itemcode: widget.data.itemcode,
                                    itemdesc: widget.data.itemdesc,
                                    description: widget.data.description,
                                    qty: qtyitemmaster,
                                    discpct: 0,
                                    discamt: 0,
                                    ratecurcd: 'Rupiah',
                                    ratebs1: 1,
                                    ratebs2: 1,
                                    rateamtcost: widget.data.costamt,
                                    rateamtitem: widget.data.slsamt!,
                                    rateamtservice:
                                        (widget.data.slsamt! / qtyitemmaster) *
                                            widget.data.svchgpct! /
                                            100,
                                    rateamttax:
                                        (widget.data.slsamt! / qtyitemmaster) *
                                            widget.data.taxpct! /
                                            100,
                                    rateamttotal:
                                        widget.data.slsamt! / qtyitemmaster,
                                    revenueamt:
                                        qtyitemmaster * widget.data.slsamt!,
                                    taxamt:
                                        (qtyitemmaster * widget.data.slsamt!) *
                                            widget.data.taxpct! *
                                            100,
                                    serviceamt:
                                        (qtyitemmaster * widget.data.slsamt!) *
                                            widget.data.svchgpct! *
                                            100,
                                    totalaftdisc:
                                        qtyitemmaster * widget.data.slsamt!,
                                    rebateamt: 0,
                                    rvncoa: 'REVENUE',
                                    taxcoa: 'TAX',
                                    servicecoa: 'SERVICE',
                                    costcoa: 'COST',
                                    active: 1,
                                    usercrt: usercd,
                                    userupd: '',
                                    userdel: '',
                                    prnkitchen: 0,
                                    prnkitchentm: now.hour.toString() +
                                        ":" +
                                        now.minute.toString() +
                                        ":" +
                                        now.second.toString(),
                                    confirmed: '1',
                                    taxpct: widget.data.taxpct,
                                    svchgpct: widget.data.svchgpct,
                                    createdt: now.toString(),
                                    guestname: widget.guestname);
                                await ClassApi.updatePosDetail(result, dbname);
                                setState(() {
                                  _isloading = false;
                                });
                                // ClassRetailMainMobile.of(context)!.string = result;
                                Navigator.of(context).pop(result);
                              }
                            : null,
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
        ));
  }
}
