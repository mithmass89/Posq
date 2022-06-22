import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';

class ClassDetailKelolaProduct extends StatefulWidget {
  final TextEditingController adjusmentplus;
  final TextEditingController adjusmentmin;
  final TextEditingController minproduct;
    final TextEditingController catatan;
  const ClassDetailKelolaProduct(
      {Key? key,
      required this.adjusmentplus,
      required this.adjusmentmin,
      required this.minproduct,required this.catatan})
      : super(key: key);

  @override
  State<ClassDetailKelolaProduct> createState() =>
      _ClassDetailKelolaProductState();
}

class _ClassDetailKelolaProductState extends State<ClassDetailKelolaProduct> {
  final penyesuaian = TextEditingController();
  String typeadjusment = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text('Penyesuaian Stok'),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          child: TextFieldMobile2(
            focus: null,
            suffixIcon: Icon(
              Icons.arrow_right_outlined,
            ),
            readonly: true,
            hint: 'Pilih tipe penyesuaian',
            controller: penyesuaian,
            typekeyboard: TextInputType.text,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text('Jumlah Stok'),
          ],
        ),
        Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFieldMobile2(
                focus: null,
                readonly: true,
                hint: '',
                controller: penyesuaian,
                typekeyboard: TextInputType.text,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text('Minimum Stok'),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          child: TextFieldMobile2(
            hint: '',
            controller: widget.minproduct,
            typekeyboard: TextInputType.text,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
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
