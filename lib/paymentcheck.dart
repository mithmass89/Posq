import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/mainapps.dart';
import 'package:posq/subscriptionpage.dart';

class PaymentChecks extends StatefulWidget {
  final String trno;
  final String email;
  final String fullname;
  const PaymentChecks(
      {Key? key,
      required this.trno,
      required this.fullname,
      required this.email})
      : super(key: key);

  @override
  State<PaymentChecks> createState() => _PaymentChecksState();
}

class _PaymentChecksState extends State<PaymentChecks> {
  String trno = '';
  bool sukses = false;
  String confirmasi = 'Akun anda dalam verifikasi';
  String belumbayar = 'Anda Akan di alihkan';

  @override
  void initState() {
    super.initState();
    paymentCheckS();
  }

  paymentCheckS() async {
    await ClassApi.getStatusTransactionSubscribe(widget.trno)
        .then((value) async {
      print(value);
      if (value == 'settlement') {
        await ClassApi.updatePaymentVerification('confirm', widget.fullname);
        setState(() {
          sukses = true;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Mainapps(
                   fromretailmain: false,
            )),
            (Route<dynamic> route) => false);
      } else if (value != 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubScribetionPage(
                    email: widget.email,
                    fullname: widget.fullname,
                  )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: trno == '' ? Text(belumbayar) : Text(confirmasi)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(onPressed: () {}, child: Text('Subscribe layanan'))
          ],
        ),
      ),
    );
  }
}
