import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/productclass/classretaildetailcondiment.dart';
import 'package:posq/userinfo.dart';
import 'package:collection/collection.dart';

class ClassInputCondiment extends StatefulWidget {
  final Item data;
  final String transno;
  final String outletcd;
  const ClassInputCondiment(
      {Key? key,
      required this.data,
      required this.transno,
      required this.outletcd})
      : super(key: key);

  @override
  State<ClassInputCondiment> createState() => _ClassInputCondimentState();
}

class _ClassInputCondimentState extends State<ClassInputCondiment> {
  String query = '';
  List<Condiment> condiment = [];
  Map<String, List<Condiment>> groupedCondiments = {};
  List<String> keys = [];
  List<TextEditingController> controller = [];
  List<SelectedItems> listchoice = [];
  List<int> qtylist = [];
  int _qty = 0;
  bool _choice = false;
  String isSelected = '';
  List<PosCondiment> summarycondiment = [];
  List<PosCondiment> poscondimentchoice = [];
  List<PosCondiment> poscondimenttopping = [];
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;

  getDetailCondiment() async {
    condiment =
        await ClassApi.getItemCondiment(widget.data.itemcode!, dbname, query);
    // print(condiment);
    groupedData();
    setState(() {});
  }

  groupedData() {
    groupedCondiments = groupBy(condiment, (Condiment c) => c.condimentdesc!);
    for (var x in groupedCondiments.keys) {
      keys.add(x);
    }
    print(groupedCondiments.keys);
  }

  @override
  void initState() {
    super.initState();
    getDetailCondiment();
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
                        height:
                            MediaQuery.of(context).size.height * x!.length / 10,
                        child: ListView(
                          children: List.generate(x.length, (index) {
                            qtylist.add(_qty);
                            controller.add(TextEditingController(text: '0'));
                            if (x[index].condimenttype == 'menuchoice') {
                              listchoice.add(SelectedItems(
                                  isSelected: false,
                                  name: x[index].optiondesc!));
                            }
                            return ListTile(
                              title: Text('${x[index].optiondesc}'),
                              subtitle: Text(x[index].amount.toString()),
                              trailing: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: x[index].condimenttype == 'topping'
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (qtylist[index] != 0) {
                                                  qtylist[index]--;
                                                  controller[index].text =
                                                      qtylist[index].toString();
                                                  setState(() {});
                                                  poscondimentchoice
                                                      .removeLast();
                                                }
                                              },
                                              icon: Icon(Icons.remove),
                                              iconSize: 20,
                                            ),
                                            SizedBox(
                                              width: 65,
                                              height: 60,
                                              child: TextFieldMobile2(
                                                  readonly: true,
                                                  enable: false,
                                                  controller: controller[index],
                                                  onChanged: (value) {},
                                                  typekeyboard:
                                                      TextInputType.number),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (qtylist[index] >= 0) {
                                                  qtylist[index]++;
                                                  controller[index].text =
                                                      qtylist[index].toString();
                                                  poscondimenttopping.add(
                                                      PosCondiment(
                                                          trdt: formattedDate,
                                                          itemcode: widget
                                                              .data.itemcode,
                                                          transno:
                                                              widget.transno,
                                                          outletcode:
                                                              widget.outletcd,
                                                          condimentcode:
                                                              x[index].itemcode,
                                                          condimentdesc: x[index]
                                                              .condimentdesc,
                                                          condimenttype: x[
                                                                  index]
                                                              .condimenttype,
                                                          qty: 1,
                                                          rateamt:
                                                              x[index].amount,
                                                          rateamttax: 0,
                                                          rateamtservice: 0,
                                                          totalamt: 1 *
                                                              x[index].amount!,
                                                          totaltaxamt: 0,
                                                          totalserviceamt: 0,
                                                          totalnett: 1 *
                                                              x[index].amount!,
                                                          createdt:
                                                              now.toString(),
                                                          optioncode: x[index]
                                                              .optioncode,
                                                          optiondesc: x[index]
                                                              .optiondesc));
                                                  setState(() {});
                                                }
                                              },
                                              icon: Icon(Icons.add),
                                              iconSize: 20,
                                            ),
                                          ],
                                        )
                                      : CheckboxListTile(
                                          value: listchoice[index].isSelected,
                                          onChanged: (value) {
                                            for (var x in listchoice) {
                                              poscondimentchoice = [];
                                              x.isSelected = false;
                                              setState(() {});
                                            }
                                            listchoice[index].isSelected =
                                                value!;
                                            setState(() {});
                                            isSelected = x[index].optiondesc!;
                                            poscondimentchoice.add(PosCondiment(
                                                trdt: formattedDate,
                                                itemcode: widget.data.itemcode,
                                                transno: widget.transno,
                                                outletcode: widget.outletcd,
                                                condimentcode:
                                                    x[index].itemcode,
                                                condimentdesc:
                                                    x[index].condimentdesc,
                                                condimenttype:
                                                    x[index].condimenttype,
                                                qty: 0,
                                                rateamt: x[index].amount,
                                                rateamttax: 0,
                                                rateamtservice: 0,
                                                totalamt: x[index].amount,
                                                totaltaxamt: 0,
                                                totalserviceamt: 0,
                                                totalnett: x[index].amount,
                                                createdt: now.toString(),
                                                optioncode: x[index].optioncode,
                                                optiondesc:
                                                    x[index].optiondesc));
                                            print(x[index].optiondesc!);
                                          })),
                            );
                          }),
                        ),
                      ),
                    );
                  })),
          ButtonNoIcon2(
            color: Colors.blue,
            textcolor: Colors.white,
            name: 'Simpan',
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            onpressed: () async {
              for (var x in poscondimentchoice) {
                summarycondiment.add(x);
              }
              for (var x in poscondimenttopping) {
                summarycondiment.add(x);
              }
              await ClassApi.insert_Poscondiment(dbname, summarycondiment);
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
                      createdt: now.toString()),
                  pscd);
            },
          ),
        ],
      ),
    );
  }
}
