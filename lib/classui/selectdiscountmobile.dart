// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:posq/setting/promo/classcreatepromomobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
typedef void StringCallback(IafjrndtClass val);
class SelectPromoMobile extends StatefulWidget {
  final String? trno;
  final String? pscd;
  final IafjrndtClass? databill;
  final Function? updatedata;
  final VoidCallback? refreshdata;
  late num sum;

  SelectPromoMobile(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.databill,
      required this.updatedata,
      required this.refreshdata,
      required this.sum})
      : super(key: key);

  @override
  State<SelectPromoMobile> createState() => _SelectPromoMobileState();
}

class _SelectPromoMobileState extends State<SelectPromoMobile> {
  final search = TextEditingController();
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  String query = '';

  @override
  void initState() {
    super.initState();

    formattedDate = formatter.format(now);
  }

  Future<dynamic> insertIafjrnhdPromo(Promo data) async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: widget.trno!,
        split: 1,
        pscd: '${widget.pscd}',
        trtm: now.toString(),
        disccd: data.promocd,
        pax: '1',
        pymtmthd: 'Discount',
        ftotamt: data.amount != 0
            ? 0 - data.amount!
            : 0 - ((widget.databill!.revenueamt! * data.pct!) / 100),
        totalamt: data.amount != 0
            ? data.amount!
            : ((widget.databill!.revenueamt! * data.pct!) / 100),
        framtrmn: data.amount != 0
            ? 0 - data.amount!
            : 0 - ((widget.databill!.revenueamt! * data.pct!) / 100),
        amtrmn: data.amount != 0
            ? 0 - data.amount!
            : 0 - ((widget.databill!.revenueamt! * data.pct!) / 100),
        trdesc: 'Discount ${widget.trno}',
        trdesc2: 'Discount ${data.promodesc}',
        compcd: 'Discount',
        compdesc: 'Discount',
        active: 1,
        usercrt: usercd,
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, dbname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Pilih Promo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 1,
              child: TextFieldMobile2(
                  label: 'Search',
                  controller: search,
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  typekeyboard: TextInputType.text),
            ),
          ),
          FutureBuilder(
              future: ClassApi.getPromoList(dbname, query),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Promo>> snapshot) {
                var x = snapshot.data ?? [];
                if (x.isNotEmpty) {
                  return Container(
                    // color: Colors.grey[200],
                    height: MediaQuery.of(context).size.height * 0.70,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: x.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              dense: true,
                              onTap: () async {
                                await insertIafjrnhdPromo(
                                    snapshot.data![index]);

                                await ClassApi.getSumTrans(
                                        widget.trno!, pscd, '')
                                    .then((value) async {
                                  setState(() {
                                    widget.sum = value.first.totalaftdisc!;
                                  });
                                  print('ini ${value.first}');
                                  await widget.refreshdata;
                                  await widget.updatedata;
                                  // var z = IafjrndtClass(
                                  //     split: 1,
                                  //     tablesid: '',
                                  //     rateamtitem: 0,
                                  //     rateamtservice: 0,
                                  //     rateamttax: 0,
                                  //     rateamttotal: 0,
                                  //     ratebs1: 1,
                                  //     ratebs2: 2,
                                  //     ratecurcd: 'IDR',
                                  //     reason: '',
                                  //     revenueamt: value.first.totalaftdisc,
                                  //     multiprice: 0,
                                  //     salestype: '',
                                  //     guestname: '',
                                  //     note: '',
                                  //     id: 0,
                                  //     itemcode: '',
                                  //     itemdesc: '',
                                  //     itemseq: 0,
                                  //     description: '',
                                  //     pscd: '',
                                  //     svchgpct: 0,
                                  //     taxpct: 0,
                                  //     qty: 0,
                                  //     condimenttype: '',
                                  //     condimentlist: [],
                                  //     pricelist: [],
                                  //     trdt: widget.databill!.trdt,
                                  //     totalaftdisc: value.first.totalaftdisc,
                                  //     transno: value.first.transno,
                                  //     transno1: value.first.transno,
                                  //     trno1: value.first.transno,
                                  //     totalcost: 0,
                                  //     ratecostamt: 0);
                                  // print('value z : $z');
                                  // ClassRetailMainMobile.of(context)!.string = z;
                                  Navigator.of(context).pop(x[index]);
                                });
                              },
                              // contentPadding: EdgeInsets.all(8.0),
                              title: Text(snapshot.data![index].promodesc!),
                              // subtitle:
                              //     Text(snapshot.data![index].amount.toString()),
                            ),
                            Divider()
                          ],
                        );
                      },
                    ),
                  );
                }
                return Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Center(child: Text('Belum Ada Promo')),
                );
              }),
          ButtonNoIcon(
            textcolor: Colors.white,
            color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.90,
            name: 'Tambah Promo',
            onpressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassCreatePromoMobile()))
                  .then((_) async {
                setState(() {});
              });
            },
          )
        ],
      ),
    );
  }
}
