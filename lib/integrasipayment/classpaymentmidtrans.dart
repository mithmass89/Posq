import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

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
    loadKey();
    ToastContext().init(context);
  }

  simpanKeyMidtrans() async {
    final midtranskey = await SharedPreferences.getInstance();
    await midtranskey.setString('serverkey', serverkey.text);
  }

  loadKey() async {
    final midtranskey = await SharedPreferences.getInstance();
    serverkey.text = midtranskey.getString('serverkey')!;
    setState(() {
      serverkeymidtrans = serverkey.text;
      midkey=serverkeymidtrans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Midtrans',style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        clipBehavior: Clip.none, children: [
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
                  // Text('Demo Key : SB-Mid-server-J4XJjwc-pTBQYsY4hUFztCP- '),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Coba dummy key'),
                  IconButton(
                    icon: Icon(Icons.copy),
                    iconSize: 20,
                    color: Colors.green,
                    splashColor: Colors.purple,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: 'Mid-server-qmj2d89j1ghmOZWkj1dYrJtg'));
                      Toast.show("Clipboard Copy",
                          duration: Toast.lengthLong, gravity: Toast.center);
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
                await simpanKeyMidtrans();
                setState(() {
                  serverkeymidtrans = serverkey.text;
                });
                Toast.show("Server Key tersimpan",
                    duration: Toast.lengthLong, gravity: Toast.center);
                Navigator.of(context).pop();
              },
              name: 'Simpan',
            ),
          )
        ],
      ),
    );
  }
}
