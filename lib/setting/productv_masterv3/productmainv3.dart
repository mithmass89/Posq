// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:posq/setting/productv_masterv3/classproductmobilev3.dart';

class Productmainv3 extends StatefulWidget {
  const Productmainv3({Key? key, required this.pscd}) : super(key: key);
  final String pscd;
  @override
  State<Productmainv3> createState() => _Productmainv3State();
}

class _Productmainv3State extends State<Productmainv3> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 480) {
        return ClassproductmobileV3(
          pscd: widget.pscd,
        );
      }
      return Container();
    });
  }
}
