import 'package:flutter/material.dart';

class GeneralSettingMobile extends StatefulWidget {
  final String pscd;
  const GeneralSettingMobile({Key? key, required this.pscd}) : super(key: key);

  @override
  State<GeneralSettingMobile> createState() => _GeneralSettingMobileState();
}

class _GeneralSettingMobileState extends State<GeneralSettingMobile> {
  bool usestrict = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Setting'),
      ),
      body: Container(
          child: ListView(
        children: [
          ListTile(
            title: Text('Mode Strict'),
            subtitle: Text(
                'Mode yg di gunakan untuk membatasi akses cancel order dan delete untuk staff '),
            trailing: Switch(
              value: usestrict,
              onChanged: (val) {
                usestrict = val;
                setState(() {});
              },
            ),
          ),
        ],
      )),
    );
  }
}
