// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/classdetailkelolaproduct.dart';

class ClassKelolaStockMobile extends StatefulWidget {
  late TextEditingController stocknow;
  final TextEditingController adjusmentstock;
  final TextEditingController minproduct;
  final num qty;
  final TextEditingController catatan;
  late Gntrantp? gntrantp;
  late int trackstock;
  final Item? data;
  final Function? trackstockcallback;

  ClassKelolaStockMobile(
      {Key? key,
      required this.stocknow,
      required this.qty,
      required this.minproduct,
      required this.catatan,
      required this.adjusmentstock,
      required this.trackstock,
      this.gntrantp,
      required this.data,required this.trackstockcallback})
      : super(key: key);

  @override
  State<ClassKelolaStockMobile> createState() => _ClassKelolaStockMobileState();
}

class _ClassKelolaStockMobileState extends State<ClassKelolaStockMobile> {
  bool seedetail = false;

  @override
  void initState() {
    super.initState();
    checkproductDetail();
  }

  checkproductDetail() {
    if (widget.data != null) {
      setState(() {
        seedetail = true;
      });
    }
    if (widget.trackstock == 1) {
      setState(() {
        seedetail = true;
      });
    }else{
     setState(() {
        seedetail = false;
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Text('Stok Barang',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
            ),
            Switch(
              value: seedetail,
              onChanged: (value) {
                setState(() {
                  seedetail = value;
                  if (seedetail == true) {
                  widget.trackstockcallback!(1);
                  } else {
                      widget.trackstockcallback!(0);
                  }
                  print(widget.trackstock);
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
              child: Text('Lacak Penambahan dan pengurangan barang ini '),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          child: TextFieldMobile2(
            suffixIcon: TextButton(onPressed: () {}, child: Text('Riwayat')),
            readonly: true,
            label: 'Stok Barang Saat ini',
            controller: widget.stocknow,
            typekeyboard: TextInputType.text,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        seedetail == true
            ? ClassDetailKelolaProduct(
              stocknow: widget.stocknow,
                trackstock: widget.trackstock,
                gntrantp: widget.gntrantp,
                catatan: widget.catatan,
                adjusmentstock: widget.adjusmentstock,
                minproduct: widget.minproduct,
              )
            : Container()
      ],
    );
  }
}
