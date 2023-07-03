import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';

class RewardMobile extends StatefulWidget {
  final String fromdate;
  final String todate;
  final String point;
  final num amount;
  final num initialamount;
  final String type;
  const RewardMobile(
      {Key? key,
      required this.fromdate,
      required this.todate,
      required this.point,
      required this.amount,
      required this.initialamount,
      required this.type})
      : super(key: key);

  @override
  State<RewardMobile> createState() => _RewardMobileState();
}

class _RewardMobileState extends State<RewardMobile> {
  List<RewardCLass> datareward = [];
  String query = '';

  @override
  void initState() {
    super.initState();
     getDataReward();
  }

  getDataReward() async {
    datareward = await ClassApi.getRewardData(query);
    setState(() {});
    print(datareward);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Reward Setting'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
                itemCount: datareward.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(datareward[index].redempoint!.toString()),
                        Text(datareward[index].reward!.toString()),
                      ],
                    ),
                  );
                }),
          ),
          Container(
            child: ElevatedButton(
                onPressed: () async {
                  final String titles = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogReward(
                          type: widget.type,
                          amount: widget.amount,
                          fromdate: widget.fromdate,
                          initialamount: widget.initialamount,
                          point: widget.point,
                          todate: widget.todate,
                        );
                      });
                  await getDataReward();
                },
                child: Text('Tambah Reward')),
          )
        ],
      ),
    );
  }
}
