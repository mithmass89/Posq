import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class MembershipsTrans extends StatefulWidget {
  final String membername;
  final String trno;
  final IafjrndtClass? databill;
  final num sum;
  const MembershipsTrans(
      {Key? key,
      required this.membername,
      required this.trno,
      this.databill,
      required this.sum})
      : super(key: key);

  @override
  State<MembershipsTrans> createState() => _MembershipsTransState();
}

class _MembershipsTransState extends State<MembershipsTrans> {
  num points = 0;
  List<RewardCLass> rewardlist = [];
  TextEditingController _controller = TextEditingController();
  // bool selecteds = false;
  List<bool>? selecteds = [];
  List<RewardCLass> selectedreward = [];
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;

  @override
  void initState() {
    super.initState();
    checkPointsCustomer();
    getReward();
    formattedDate = formatter.format(now);
  }

  checkPointsCustomer() async {
    await ClassApi.checkPointCustomer(widget.membername, dbname).then((value) {
      points = value[0]['points'];
    });
    print(points);
    setState(() {});
  }

  getReward() async {
    rewardlist = await ClassApi.getRewardData('');
    setState(() {});
  }

  Future<dynamic> insertIafjrnhdPromo(RewardCLass data) async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: widget.trno,
        split: 1,
        pscd: pscd,
        trtm: now.toString(),
        disccd: data.loyalitycd,
        pax: '1',
        pymtmthd: 'Discount',
        ftotamt: data.rewaradtype == 0
            ? 0 - data.reward!
            : 0 - ((widget.sum * data.reward!) / 100),
        totalamt: data.rewaradtype == 0
            ? data.reward!
            : ((widget.sum * data.reward!) / 100),
        framtrmn: data.rewaradtype == 0
            ? 0 - data.reward!
            : 0 - ((widget.sum * data.reward!) / 100),
        amtrmn: data.rewaradtype == 0
            ? 0 - data.reward!
            : 0 - ((widget.sum * data.reward!) / 100),
        trdesc: 'Redeem point ${widget.trno}',
        trdesc2: 'Redeem Point ${data.rewaradtype}',
        compcd: 'Discount',
        compdesc: 'Redeem Point',
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
          title: Text('Pilih redeem points',style: TextStyle(color: Colors.white),),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("${widget.membername} Points : $points",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextFieldMobileLogin(
                    enable: true,
                    showpassword: true,
                    hint: 'Cari Redeem points',
                    controller: _controller,
                    onChanged: (String value) {
                      setState(() {});
                    },
                    typekeyboard: TextInputType.text,
                  ),
                ),
                FutureBuilder(
                    future: ClassApi.getRewardData(_controller.text),
                    builder: (context, AsyncSnapshot<List<RewardCLass>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        List<RewardCLass> data = snapshot.data!.where((element) => element.redempoint!<=points).toList();
                        return Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    selecteds!.add(false);
                                    return Column(
                                      children: [
                                        ListTile(
                                          trailing: Checkbox(
                                              value: selecteds![index],
                                              onChanged: (value) {
                                                selectedreward = [];

                                                selecteds![index] = value!;
                                                print(
                                                    selecteds![index] == true);
                                                if (selecteds![index] == true) {
                                                  selectedreward
                                                      .add(data[index]);
                                                } else {
                                                  selectedreward = [];
                                                }
                                                print(selectedreward);
                                                setState(() {});
                                              }),
                                          onTap: () {},
                                          subtitle: Text(
                                              "Redem Points : ${data[index].redempoint}"),
                                          title: data[index].rewaradtype != 0
                                              ? Text(
                                                  '${data[index].note!} : ${data[index].reward!} % ')
                                              : Text(
                                                  '${data[index].note!} :Rp ${data[index].reward!} '),
                                        ),
                                        Divider(
                                          indent: 20,
                                          endIndent: 20,
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text('Error Contact Administrator'),
                        );
                      }
                    }),
              ],
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * 0.27,
                top: MediaQuery.of(context).size.height * 0.8,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: () async {
                      await insertIafjrnhdPromo(selectedreward.first);
                      await ClassApi.insertPointguest(
                          -(selectedreward.first.redempoint!),
                          widget.membername,
                          formattedDate,
                          widget.trno,
                          0);
                      await ClassApi.getSumTrans(widget.trno, pscd, '');
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ))))
          ],
        ));
  }
}
