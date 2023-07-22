import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NonTunaiMobileQRISV2 extends StatefulWidget {
  final TextEditingController amountcash;
  final num balance;
  final String? trno;
  final String? pscd;
  final Outlet outletinfo;
  late num result;
  late bool zerobill;
  final Function callback;
  final List<IafjrndtClass> datatrans;
  final bool midtransonline;
  late String? compcode;
  late String? compdescription;
  late String? pymtmthd;
  final void Function(String compcd, String compdesc, String methode)
      checkselected;
  final bool fromsaved;
  final int lastsplit;
  final bool fromsplit;
  final String guestname;
  final String email;
  final String phone;
  NonTunaiMobileQRISV2({
    Key? key,
    required this.amountcash,
    required this.balance,
    this.trno,
    this.pscd,
    required this.zerobill,
    required this.result,
    required this.outletinfo,
    required this.callback,
    required this.datatrans,
    required this.midtransonline,
    this.compcode,
    this.compdescription,
    required this.checkselected,
    required this.pymtmthd,
    required this.fromsaved,
    required this.lastsplit,
    required this.fromsplit,
    required this.guestname,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  State<NonTunaiMobileQRISV2> createState() => _NonTunaiMobileQRISV2State();
}

class _NonTunaiMobileQRISV2State extends State<NonTunaiMobileQRISV2> {
  late WebViewController _webViewController;
  var formattedDate;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String initialUrl = 'https://google.com'; // Replace with your desired URL
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    PaymentGate.snapWeb(widget.trno!, widget.result.toString()).then((value) {
      print('test $value');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: PaymentGate.snapWeb(widget.trno!, widget.result.toString()),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(snapshot.hasData);
                String url = snapshot.data['redirect_url'];
                // String url ='https://app.midtrans.com/snap/v3/redirection/7539cd1c-4326-4ff8-9dc7-6a490c7db922#/gopay-qris';
           
                return WebView(
                  initialUrl: '$url#/gopay-qris',
                  // initialUrl: 'https://www.google.com',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (String url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
