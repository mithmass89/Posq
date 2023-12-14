// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';

class CreateProductMaster extends StatefulWidget {
  const CreateProductMaster({super.key});

  @override
  State<CreateProductMaster> createState() => _CreateProductMasterState();
}

class _CreateProductMasterState extends State<CreateProductMaster> {
  TextEditingController _itemdesc = TextEditingController();
  TextEditingController _variant = TextEditingController();
  TextEditingController _category =
      TextEditingController(text: 'Pilih Category');
  TextEditingController _merk = TextEditingController(text: 'Pilih Merek');
  TextEditingController _hargadasar = TextEditingController();
  TextEditingController _hargajual = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Produk',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Informasi dasar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextFieldMobile2(
                  hint: 'Nama Produk',
                  controller: _itemdesc,
                  onChanged: (v) {},
                  typekeyboard: TextInputType.text,
                )),
            Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextFieldMobileButton(
                  ontap: () {},
                  hint: 'Category Produk',
                  controller: _category,
                  onChanged: (v) {},
                  typekeyboard: TextInputType.text,
                )),
                       Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextFieldMobileButton(
                  ontap: () {},
                  hint: 'Produk Merek ',
                  controller: _merk,
                  onChanged: (v) {},
                  typekeyboard: TextInputType.text,
                )),
          ],
        ),
      ),
    );
  }
}
