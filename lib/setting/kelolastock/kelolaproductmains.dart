import 'package:flutter/material.dart';
import 'package:posq/setting/kelolastock/mobile/kelolastockmainmobile.dart';
import 'package:posq/setting/kelolastock/tablet/kelolastockmaintab.dart';

class KelolaMainsStock extends StatefulWidget {
  const KelolaMainsStock({Key? key}) : super(key: key);

  @override
  State<KelolaMainsStock> createState() => _KelolaMainsStockState();
}

class _KelolaMainsStockState extends State<KelolaMainsStock> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 800) {
        return KelolaProductMainMobile();
      } else if (constraints.maxWidth >= 820) {
        return KelolaProductMainTablet();
      } else {
        return Container();
      }
    });
  }
}
