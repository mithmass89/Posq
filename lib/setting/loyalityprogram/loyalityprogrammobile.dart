import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';

class LoyalityMainMobile extends StatefulWidget {
  final List<RewardCLass> datareward;
  
  const LoyalityMainMobile({
    
    Key? key, required this.datareward,
  }) : super(key: key);

  @override
  State<LoyalityMainMobile> createState() => _LoyalityMainMobileState();
}

class _LoyalityMainMobileState extends State<LoyalityMainMobile> {
  List program = [];
  List<RewardCLass> datareward = [];
  String query = '';
  @override
  void initState() {
    super.initState();
    getProgram();
    getDataReward();
    print('data widget oke : ${widget.datareward}');
  }

  getProgram() async {
    program = await ClassApi.getLoyalityProgramActive();
    setState(() {});
  }

  getDataReward() async {
    datareward = await ClassApi.getRewardData(query);
    setState(() {});
    print(datareward);
  }

  @override
  Widget build(BuildContext context) {
    return program.isNotEmpty? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          title: Text(
            program[0]['loyaltiydesc'],
            style: TextStyle(fontSize: 18),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                dense: true,
                title: Text('Aktif'),
                subtitle: Text(program[0]['fromdate'].toString()),
              ),
            ),
            Expanded(
              child: ListTile(
                dense: true,
                title: Text('Berakhir'),
                subtitle: Text(program[0]['todate'].toString()),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                dense: true,
                title: Text('Kelipatan Point'),
                subtitle: Text(
                    CurrencyFormat.convertToIdr(program[0]['convamount'], 0)
                        .toString()),
              ),
            ),
            Expanded(
              child: ListTile(
                dense: true,
                title: Text('Point'),
                subtitle: Text(program[0]['point'].toString()),
              ),
            ),
          ],
        ),
        ListTile(
          dense: true,
          title: Text('Joint Point'),
          subtitle: Text(program[0]['joinreward'].toString()),
        ),
        ListTile(
          dense: true,
          title: Text(
            'Reward aktif',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          child: ListView.builder(
              itemCount: datareward.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: Text('${
                         datareward[index].note}'),
                  title: Row(
                    children: [
                      Text('Point : '),
                      Text(datareward[index].redempoint.toString()),
                    ],
                  ),
                  subtitle: datareward[index].rewaradtype == '0'
                      ? Text(CurrencyFormat.convertToIdr(
                         datareward[index].reward, 0))
                      : Text('${datareward[index].reward} %'),
                  // trailing: Text(datareward[index].rewaradtype.toString()),
                );
              }),
        )
      ],
    ): Container();
  }
}
