import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:collection/collection.dart';

class ClassInputCondiment extends StatefulWidget {
  final Item data;
  final String transno;
  final String outletcd;
  final int itemseq;
  final List<IafjrndtClass>? dataedit;
  final bool? fromedit;
  const ClassInputCondiment({
    Key? key,
    required this.data,
    required this.transno,
    this.dataedit,
    required this.outletcd,
    required this.itemseq,
    this.fromedit,
  }) : super(key: key);

  @override
  State<ClassInputCondiment> createState() => _ClassInputCondimentState();
}

class _ClassInputCondimentState extends State<ClassInputCondiment> {
  String query = '';
  List<Condiment> condiment = [];
  TextEditingController _controlllermainitem = TextEditingController(text: '0');
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
  Future<void> getDetailCondiment() async {
    condiment =
        await ClassApi.getItemCondiment(widget.data.itemcode!, dbname, query);
    // print(condiment);

    for (var x in condiment) {
      if (x.condimenttype == 'menuchoice') {
        listchoice.add(SelectedItems(isSelected: false, name: x.optiondesc!));
      } else if (x.condimenttype == 'topping') {
        qtylist.add(0);
        controllerindexing.add(x.optiondesc!);
        controller.add(TextEditingCondiment(
            opsidesc: x.optiondesc!,
            opsicode: x.optioncode!,
            controller: TextEditingController(text: '0')));
        poscondimenttopping.add(PosCondiment(
            trdt: formattedDate,
            itemcode: widget.data.itemcode,
            transno: widget.transno,
            outletcode: widget.outletcd,
            itemseq: widget.itemseq,
            condimentcode: '',
            condimentdesc: x.condimentdesc,
            condimenttype: x.condimenttype,
            qty: 0,
            rateamt: x.amount,
            rateamttax: 0,
            rateamtservice: 0,
            totalamt: 0 * x.amount!,
            totaltaxamt: 0,
            totalserviceamt: 0,
            totalnett: 0 * x.amount!,
            createdt: now.toString(),
            optioncode: x.optioncode,
            optiondesc: x.optiondesc));
      }
      // print(poscondimenttopping);
    }

    groupedData();
    if (widget.fromedit == true || widget.fromedit != null) {
      await checkItemExistFromEdit();
    }

    setState(() {});
  }

  groupedData() {
    groupedCondiments = groupBy(condiment, (Condiment c) => c.condimentdesc!);
    for (var x in groupedCondiments.keys) {
      keys.add(x);
    }
  }

  //proses from edit ///
  Future<void> checkItemExistFromEdit() async {
    String selectedchoice = '';
    List<PosCondiment> datax = await ClassApi.getDetailCondimentTrno(
        widget.dataedit!.first.transno!,
        widget.data.itemcode!,
        widget.itemseq.toString(),
        dbname,
        query);

    for (var x in datax) {
      if (x.condimenttype == 'menuchoice') {
        selectedchoice = x.optiondesc!;
        setState(() {});

        poscondimentchoice.add(x);
        // print(poscondimentchoice);
      }
    }
    for (var x in listchoice) {
      // print(listchoice.indexOf(x));
      if (x.name == selectedchoice) {
        x.isSelected = true;
        setState(() {});
      }
    }

    for (var x in datax) {
      if (x.condimenttype == 'topping') {
        int indexs = controller
            .indexWhere((element) => element.opsidesc == x.optiondesc);
        // print(condiment.where((element) => element.optioncode == x.optioncode));
        num totalqty = datax
            .where((element) => element.condimenttype == 'topping')
            .fold(0, (previousValue, datax) => previousValue + datax.qty!);
        print(totalqty);
        controller[indexs].controller.text = x.qty.toString();
        qtylist[indexs] = x.qty!.toInt();
        poscondimenttopping[indexs].qty = qtylist[indexs];
        poscondimenttopping[indexs].totalamt = qtylist[indexs] * x.totalamt!;
        poscondimenttopping[indexs].totalnett = qtylist[indexs] * x.totalnett!;
        print(poscondimenttopping);
      } else {}
    }

    setState(() {});
    print(poscondimentchoice);
    print(poscondimenttopping);
  }

  @override
  void initState() {
    super.initState();
    getdetailcondiment = getDetailCondiment();
    // checkfromedit = checkItemExistFromEdit();
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu Modifier'),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, i) {
                      var x = groupedCondiments[keys[i]];
                      return ListTile(
                        title: Text(
                          '* ${keys[i]} *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Container(
                          height: MediaQuery.of(context).size.height *
                              x!.length /
                              10,
                          child: ListView.builder(
                              itemCount: x.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('${x[index].optiondesc}'),
                                  subtitle: Text(x[index].amount.toString()),
                                  trailing: Container(
                                      width: qtylist[index] != 0
                                          ? MediaQuery.of(context).size.width *
                                              0.42
                                          : MediaQuery.of(context).size.width *
                                              0.20,
                                      child: x[index].condimenttype == 'topping'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                qtylist[index] != 0
                                                    ? IconButton(
                                                        onPressed: () {
                                                          if (qtylist[index] !=
                                                              0) {
                                                            qtylist[index]--;
                                                            controller[index]
                                                                    .controller
                                                                    .text =
                                                                qtylist[index]
                                                                    .toString();
                                                            poscondimenttopping[
                                                                        index]
                                                                    .qty =
                                                                qtylist[index];
                                                            poscondimenttopping[
                                                                        index]
                                                                    .totalamt =
                                                                qtylist[index] *
                                                                    x[index]
                                                                        .amount!;
                                                            poscondimenttopping[
                                                                        index]
                                                                    .totalnett =
                                                                qtylist[index] *
                                                                    x[index]
                                                                        .amount!;
                                                            print(
                                                                poscondimenttopping);
                                                            if (qtylist[
                                                                    index] ==
                                                                0) {
                                                              poscondimenttopping
                                                                  .removeAt(
                                                                      index);
                                                            }
                                                            setState(() {});
                                                          }
                                                        },
                                                        icon:
                                                            Icon(Icons.remove),
                                                        iconSize: 20,
                                                      )
                                                    : Container(),
                                                qtylist[index] != 0
                                                    ? SizedBox(
                                                        width: 65,
                                                        height: 60,
                                                        child: TextFieldMobile2(
                                                            readonly: true,
                                                            enable: false,
                                                            controller:
                                                                controller[
                                                                        index]
                                                                    .controller,
                                                            onChanged:
                                                                (value) {},
                                                            typekeyboard:
                                                                TextInputType
                                                                    .number),
                                                      )
                                                    : Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              qtylist[index] =
                                                                  1;
                                                              poscondimenttopping[
                                                                          index]
                                                                      .qty =
                                                                  qtylist[
                                                                      index];
                                                              controller[index]
                                                                  .controller
                                                                  .text = qtylist[
                                                                      index]
                                                                  .toString();
                                                              poscondimenttopping[
                                                                          index]
                                                                      .totalamt =
                                                                  qtylist[index] *
                                                                      x[index]
                                                                          .amount!;
                                                              poscondimenttopping[
                                                                          index]
                                                                      .totalnett =
                                                                  qtylist[index] *
                                                                      x[index]
                                                                          .amount!;
                                                              print(
                                                                  poscondimenttopping);
                                                              setState(() {});
                                                            },
                                                            child: Text('Add')),
                                                      ),
                                                qtylist[index] != 0
                                                    ? IconButton(
                                                        onPressed: () {
                                                          print(index);
                                                          if (qtylist[index] >=
                                                              0) {
                                                            qtylist[index]++;
                                                            controller[index]
                                                                    .controller
                                                                    .text =
                                                                qtylist[index]
                                                                    .toString();
                                                            poscondimenttopping[
                                                                        index]
                                                                    .qty =
                                                                qtylist[index];
                                                            poscondimenttopping[
                                                                        index]
                                                                    .totalamt =
                                                                qtylist[index] *
                                                                    x[index]
                                                                        .amount!;
                                                            poscondimenttopping[
                                                                        index]
                                                                    .totalnett =
                                                                qtylist[index] *
                                                                    x[index]
                                                                        .amount!;
                                                            print(
                                                                poscondimenttopping[
                                                                    index]);
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
                                              value:
                                                  listchoice[index].isSelected,
                                              onChanged: (value) {
                                                for (var x in listchoice) {
                                                  poscondimentchoice = [];
                                                  x.isSelected = false;
                                                  setState(() {});
                                                }
                                                listchoice[index].isSelected =
                                                    value!;

                                                setState(() {});
                                                isSelected =
                                                    x[index].optiondesc!;
                                                poscondimentchoice.add(
                                                    PosCondiment(
                                                        trdt: formattedDate,
                                                        itemcode: widget
                                                            .data.itemcode,
                                                        transno: widget.transno,
                                                        outletcode: widget
                                                            .outletcd,
                                                        itemseq: widget.itemseq,
                                                        condimentcode:
                                                            x[index].itemcode,
                                                        condimentdesc: x[index]
                                                            .condimentdesc,
                                                        condimenttype: x[index]
                                                            .condimenttype,
                                                        qty: 1,
                                                        rateamt:
                                                            x[index].amount,
                                                        rateamttax: 0,
                                                        rateamtservice: 0,
                                                        totalamt:
                                                            x[index].amount,
                                                        totaltaxamt: 0,
                                                        totalserviceamt: 0,
                                                        totalnett:
                                                            x[index].amount,
                                                        createdt:
                                                            now.toString(),
                                                        optioncode:
                                                            x[index].optioncode,
                                                        optiondesc: x[index]
                                                            .optiondesc));
                                                print(poscondimentchoice);
                                              })),
                                );
                              }),
                        ),
                      );
                    })),
            ListTile(
                trailing: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
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
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          iconSize: 20,
                        )
                      ],
                    )),
                title: Text(
                  widget.data.itemdesc!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            widget.fromedit == false || widget.fromedit == null
                ? ButtonNoIcon2(
                    color: Colors.blue,
                    textcolor: Colors.white,
                    name: 'Simpan',
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onpressed: () async {
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
                              split: 'A',
                              itemcode: widget.data.itemcode,
                              itemdesc: widget.data.itemdesc,
                              description: widget.data.description,
                              itemseq: widget.itemseq,
                              qty: 1,
                              discpct: 0,
                              discamt: 0,
                              ratecurcd: 'Rupiah',
                              ratebs1: 1,
                              ratebs2: 1,
                              rateamtitem: widget.data.slsamt,
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
                              servicepct: widget.data.svchgpct,
                              createdt: now.toString()),
                          pscd);
                      var result = IafjrndtClass(
                          trdt: formattedDate,
                          pscd: widget.data.outletcode,
                          transno: widget.transno,
                          transno1: widget.transno,
                          split: 'A',
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
                          servicepct: widget.data.svchgpct,
                          createdt: now.toString());
                      // ClassRetailMainMobile.of(context)!.string = result;
                      Navigator.of(context).pop(result);
                    },
                  )
                : LoadingButton(
                    isLoading: _isloading,
                    color: Colors.blue,
                    textcolor: Colors.white,
                    name: 'Update',
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.9,
                    onpressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      //jadi satu list //
                      await ClassApi.updateCondimentTrno(
                          widget.transno, widget.itemseq.toString(), dbname);
                      for (var x in poscondimentchoice) {
                        summarycondiment.add(x);
                      }
                      for (var x in poscondimenttopping) {
                        summarycondiment.add(x);
                      }
                      await ClassApi.insert_Poscondiment(
                          dbname, summarycondiment);

                      var result = IafjrndtClass(
                          trdt: formattedDate,
                          pscd: widget.outletcd,
                          transno: widget.transno,
                          transno1: widget.transno,
                          split: 'A',
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
                          servicepct: widget.data.svchgpct,
                          createdt: now.toString());
                      setState(() {
                        _isloading = false;
                      });
                      // ClassRetailMainMobile.of(context)!.string = result;
                      Navigator.of(context).pop(result);
                    },
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
          ],
        ));
  }
}
