import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/setting/loyalityprogram/loyalitydetailmobile.dart';

class StepperLoyalityProgramMobile extends StatefulWidget {
  const StepperLoyalityProgramMobile({Key? key}) : super(key: key);

  @override
  State<StepperLoyalityProgramMobile> createState() =>
      _StepperLoyalityProgramMobileState();
}

class _StepperLoyalityProgramMobileState
    extends State<StepperLoyalityProgramMobile> {
  List datatype = [];

  @override
  void initState() {
    super.initState();
    getType();
  }

  getType() async {
    datatype = await ClassApi.checkTypeLoyality();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pilih tipe loyality program',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
                itemCount: datatype.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          print(datatype[index]['typedesc']);
                          index == 0
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Loyalityprogramdetail(
                                            type: datatype[index]['typecd'],
                                          )),
                                ).then((_) async {
                                  setState(() {});
                                })
                              : null;
                        },
                        title: Text(datatype[index]['typedesc']),
                        subtitle: Text(datatype[index]['note']),
                      ),
                      Divider()
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
