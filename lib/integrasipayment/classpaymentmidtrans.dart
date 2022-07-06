import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

PaymentGate? paymentapi;

class ClassPaymentMidtrans extends StatefulWidget {
  const ClassPaymentMidtrans({Key? key}) : super(key: key);

  @override
  State<ClassPaymentMidtrans> createState() => _ClassPaymentMidtransState();
}

class _ClassPaymentMidtransState extends State<ClassPaymentMidtrans> {
  late DatabaseHandler handler;
  final serverkey = TextEditingController();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    paymentapi = PaymentGate();
    checkIntegrasi();
  }

  Future<dynamic> checkIntegrasi() async {
    String integrasi = '';
    String keyapi = '';
    String use = '';

    await handler.querycheckMidtrans('midtrans').then((value) {
      if (value.isNotEmpty) {
        setState(() {
          serverkey.text = value.first.keyapi;
          integrasi = value.first.integrasi;
          keyapi = value.first.keyapi;
          use = value.first.use;
        });
      }
    });
    return Integrasi(integrasi: integrasi, keyapi: keyapi, use: use);
  }

  Future<int> insertConnection() async {
    Integrasi integrasi = Integrasi(
        integrasi: 'midtrans',
        keyapi: serverkey.text,
        use: serverkey.text == '' ? '0' : '1');
    List<Integrasi> listintegrasi = [integrasi];
    return await handler.insertIntegrasi(listintegrasi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Midtrans'),
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text('Masukan Server Key Midtrans anda'),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFieldMobile2(
                  controller: serverkey,
                  onChanged: (value) {},
                  typekeyboard: TextInputType.text),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text('Demo Key : SB-Mid-server-J4XJjwc-pTBQYsY4hUFztCP- '),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Copy dummy key'),
                  IconButton(
                    icon: Icon(Icons.copy),
                    iconSize: 20,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: 'SB-Mid-server-J4XJjwc-pTBQYsY4hUFztCP-'));
                    },
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.8,
            left: MediaQuery.of(context).size.width * 0.07,
            child: ButtonNoIcon2(
              color: Colors.blue,
              textcolor: Colors.white,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.85,
              onpressed: () async {
                await checkIntegrasi().then((value) async {
                  if (value != null) {
                    await handler.updateServerKeyMidtrans(
                      serverkey.text,
                      'midtrans',
                    );
                     Navigator.of(context).pop();
                  } else {
                    await insertConnection().whenComplete(() {
                      setState(() {
                        serverkeymidtrans = serverkey.text;
                      });
                      Navigator.of(context).pop();
                    });
                  }
                });
              },
              name: 'Simpan',
            ),
          )
        ],
      ),
    );
  }
}
