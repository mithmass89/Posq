import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/setting/classdetailkelolaproduct.dart';

class ClassKelolaStockMobile extends StatefulWidget {
  final TextEditingController stock;
  final TextEditingController adjusmentplus;
  final TextEditingController adjusmentmin;
  final TextEditingController minproduct;
  final num qty;
  final TextEditingController catatan;

  ClassKelolaStockMobile(
      {Key? key,
      required this.stock,
      required this.qty,
      required this.adjusmentplus,
      required this.adjusmentmin,
      required this.minproduct,required this.catatan})
      : super(key: key);

  @override
  State<ClassKelolaStockMobile> createState() => _ClassKelolaStockMobileState();
}

class _ClassKelolaStockMobileState extends State<ClassKelolaStockMobile> {
  bool seedetail = false;
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
                  print(seedetail);
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
            suffixIcon: TextButton(onPressed: (){}, child: Text('Riwayat')),
            readonly: true,
            label: 'Stok Barang Saat ini',
            controller: widget.stock,
            typekeyboard: TextInputType.text,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
      seedetail==true?  ClassDetailKelolaProduct(
          catatan: widget.catatan,
          adjusmentmin: widget.adjusmentmin,
          adjusmentplus: widget.adjusmentplus,
          minproduct: widget.minproduct,
        ):Container()
      ],
    );
  }
}
