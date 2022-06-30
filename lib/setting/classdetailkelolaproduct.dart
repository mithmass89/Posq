// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';

class ClassDetailKelolaProduct extends StatefulWidget {
  final TextEditingController adjusmentstock;
  final TextEditingController minproduct;
  final TextEditingController catatan;
  late Gntrantp? gntrantp;
   late TextEditingController? stocknow;
    late int trackstock;
  ClassDetailKelolaProduct(
      {Key? key,
      required this.adjusmentstock,
      this.gntrantp,
      required this.minproduct,
      required this.trackstock,
      required this.catatan,
      this.stocknow,
      })
      : super(key: key);

  @override
  State<ClassDetailKelolaProduct> createState() =>
      _ClassDetailKelolaProductState();
}

class _ClassDetailKelolaProductState extends State<ClassDetailKelolaProduct> {
  final penyesuaian = TextEditingController(text: 'Pilih Tipe Penyesuaian');

  String typeadjusment = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   children: [
        //     SizedBox(
        //       width: MediaQuery.of(context).size.width * 0.05,
        //     ),
        //     Text('Penyesuaian Stok'),
        //   ],
        // ),
        // Container(
        //   height: MediaQuery.of(context).size.height * 0.09,
        //   child: TextFieldMobileButton(
        //     ontap: () async {
        //       Gntrantp transaksitype = await Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => ClassAdjusmentType()),
        //       );
        //       setState(() {
        //         penyesuaian.text = transaksitype.ProgNm!;
        //         widget.gntrantp = transaksitype;
        //       });
        //       print(transaksitype.trnonext);
        //     },
        //     hint: 'Pilih tipe penyesuaian',
        //     controller: penyesuaian,
        //     typekeyboard: TextInputType.text,
        //     onChanged: (value) {},
        //   ),
        // ),
       widget.stocknow!.text=='0' ||widget.stocknow!.text=='0.0'   ||widget.stocknow!.text==''? Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text('Jumlah Stok awal'),
          ],
        ):Container(),
         widget.stocknow!.text=='0'  ||widget.stocknow!.text=='0.0' ||widget.stocknow!.text==''? Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFieldMobile2(
                focus: null,
                readonly:false ,
                hint: '',
                controller: widget.adjusmentstock,
                typekeyboard: TextInputType.number,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ):Container(),
        // Row(
        //   children: [
        //     SizedBox(
        //       width: MediaQuery.of(context).size.width * 0.05,
        //     ),
        //     Text('Minimum Stok'),
        //   ],
        // ),
        // Container(
        //   height: MediaQuery.of(context).size.height * 0.09,
        //   child: TextFieldMobile2(
        //     hint: '',
        //     controller: widget.minproduct,
        //     typekeyboard: TextInputType.text,
        //     onChanged: (value) {
        //       setState(() {});
        //     },
        //   ),
        // ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text('Catatan (Optional)'),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          child: TextFieldMobile2(
            hint: '',
            controller: widget.catatan,
            typekeyboard: TextInputType.text,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
