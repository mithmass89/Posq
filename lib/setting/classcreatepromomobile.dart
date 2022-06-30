import 'dart:math';

import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class ClassCreatePromoMobile extends StatefulWidget {
  const ClassCreatePromoMobile({Key? key}) : super(key: key);

  @override
  State<ClassCreatePromoMobile> createState() => _ClassCreatePromoMobileState();
}

class _ClassCreatePromoMobileState extends State<ClassCreatePromoMobile> {
  final namadiskon = TextEditingController();
  final nilaidiskonamount = TextEditingController();
  final nilaidiskonpct = TextEditingController();
  final maxdisc = TextEditingController();
  int val = -1;
  bool readOnlypct = true;
  bool readOnlyamount = true;
  FocusNode discpct = FocusNode();
  FocusNode discamount = FocusNode();
  late DatabaseHandler handler;
  String promocd = '';
  num mindisc = 0;
  String disctype = '';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<int> addPromo() async {
    Promo promo = Promo(
      promocd: promocd,
      promodesc: namadiskon.text,
      type: disctype,
      pct: num.parse(nilaidiskonpct.text.isEmpty ? '0' : nilaidiskonpct.text),
      amount: num.parse(
          nilaidiskonamount.text.isEmpty ? '0' : nilaidiskonamount.text),
      mindisc: mindisc,
      maxdisc: num.parse(maxdisc.text.isEmpty ? '0' : maxdisc.text),
    );
    List<Promo> listctg = [promo];
    return await handler.insertPromo(listctg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat diskon baru'),
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  children: [
                    Text(
                      'Detail Diskon',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Text(
                      'Nama diskon',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                TextFieldMobile2(
                    hint: 'Diskon',
                    controller: namadiskon,
                    onChanged: (value) {
                      var rng = Random();
                      setState(() {
                        promocd = '${value.substring(0, 5)}${rng.nextInt(100)}';
                        print(promocd);
                      });
                    },
                    typekeyboard: TextInputType.text),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                    Text(
                      'Nilai Diskon',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                TextFieldMobile2(
                    focus: discamount,
                    readonly: readOnlyamount,
                    suffixIcon: Radio(
                      value: 1,
                      groupValue: val,
                      onChanged: (int? value) {
                        setState(() {
                          print(value);
                          val = value!;
                          readOnlyamount = false;
                          readOnlypct = true;
                          nilaidiskonamount.clear();
                          nilaidiskonpct.clear();
                          discamount.requestFocus();
                          disctype = 'DiscAmount';
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    hint: 'Rp 5000',
                    controller: nilaidiskonamount,
                    onChanged: (value) {},
                    typekeyboard: TextInputType.number),
                TextFieldMobile2(
                    focus: discpct,
                    readonly: readOnlypct,
                    suffixIcon: Radio(
                      value: 2,
                      groupValue: val,
                      onChanged: (int? value) {
                        setState(() {
                          print(value);
                          val = value!;
                          readOnlypct = false;
                          readOnlyamount = true;
                          nilaidiskonpct.clear();
                          nilaidiskonamount.clear();
                          discpct.requestFocus();
                          disctype = 'Pct';
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    hint: '5 %',
                    controller: nilaidiskonpct,
                    onChanged: (value) {},
                    typekeyboard: TextInputType.number),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                val == 2
                    ? Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04),
                          Text(
                            'Jumlah Maksimal Diskon',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      )
                    : Container(),
                val == 2
                    ? TextFieldMobile2(
                        hint: 'Rp 5000',
                        controller: maxdisc,
                        onChanged: (value) {},
                        typekeyboard: TextInputType.number)
                    : Container(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.8,
              left: MediaQuery.of(context).size.width * 0.022,
              child: ButtonNoIcon(
                name: 'Simpan',
                color: nilaidiskonpct.text.isNotEmpty ||
                        nilaidiskonamount.text.isNotEmpty
                    ? Colors.blue
                    : Colors.grey[400],
                textcolor: Colors.white,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.95,
                onpressed: nilaidiskonpct.text.isNotEmpty ||
                        nilaidiskonamount.text.isNotEmpty
                    ? () async {
                        await addPromo().whenComplete(() {
                          Navigator.of(context).pop(context);
                        });
                      }
                    : null,
              ))
        ],
      ),
    );
  }
}
