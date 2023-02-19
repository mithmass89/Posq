// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:posq/setting/classproductmobile.dart' ; 

class Productmain extends StatefulWidget {
  const Productmain({Key? key, required this.pscd}) : super(key: key);
final String pscd;
  @override
  State<Productmain> createState() => _ProductmainState();
}

class _ProductmainState extends State<Productmain> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 480) {
        return Classproductmobile(
          pscd: widget.pscd,
        );
      }
      return Container();
    });
  }
}
