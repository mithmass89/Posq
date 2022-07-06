import 'package:flutter/material.dart';
import 'package:posq/integrasipayment/classpaymentmidtrans.dart';
import 'package:toast/toast.dart';

class ClassListIntegrasi extends StatefulWidget {
  const ClassListIntegrasi({Key? key}) : super(key: key);

  @override
  State<ClassListIntegrasi> createState() => _ClassListIntegrasiState();
}

class _ClassListIntegrasiState extends State<ClassListIntegrasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Integrasi List'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              ListTile(
                title: Text('Midtrans Payment Online'),
                subtitle:
                    Text('Midtrans adalah penyedia layanan Payment Gateaway'),
                  onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ClassPaymentMidtrans();
                          }));
                  },
              ),
              Divider()
            ],
          ),
          Column(
            children: [
              ListTile(
                title: Text('Xendit Payment Online'),
                subtitle:
                    Text('Xendit adalah penyedia layanan Payment Gateaway'),
                    onTap: (){
                         Toast.show(
                          "Saat ini belum tersedia",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
                    },
              ),
              Divider()
            ],
          ),
          Column(
            children: [
              ListTile(
                title: Text('Raja Ongkir'),
                onTap: (){
                     Toast.show(
                          "Saat ini belum tersedia",
                          duration: Toast.lengthLong,
                          gravity: Toast.center);
                },
                subtitle: Text(
                    'Raja Ongkir adalah penyedia layanan pihak ketiga untuk Terhubung langsung dengan perusahaan expedisi semisal JNE,Si Cepat'),
              ),
              Divider()
            ],
          )
        ],
      ),
    );
  }
}
