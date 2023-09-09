// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DropDownItem extends StatefulWidget {
  final List<String> data;
  late String selectedvalue;
  final String defaultvalue;

  DropDownItem(
      {super.key,
      required this.data,
      required this.defaultvalue,
      required this.selectedvalue});
  @override
  _DropDownItemState createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {
  // String selectedValue = 'Pilih Salah Satu'; // Nilai default dropdown

  // // Daftar pilihan dropdown
  // List<String> dropdownItems = [
  //   'Pilihan 1',
  //   'Pilihan 2',
  //   'Pilihan 3',
  //   'Pilihan 4'
  // ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButton<String>(
            value: widget.selectedvalue,
            onChanged: (String? newValue) {
              widget.selectedvalue = newValue!;
              setState(() {});
            },
            items: widget.data.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
   
        ],
      ),
    );
  }
}
