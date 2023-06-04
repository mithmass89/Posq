import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:posq/model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClassPaymentQrisTab extends StatefulWidget {
  final String trno;
  final String pscd;
  final String trdt;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final List<IafjrndtClass> datatrans;
  final bool fromsaved;
  late TextEditingController debitcontroller;
  late TextEditingController cardno;
  late TextEditingController cardexp;
  final List<IafjrndtClass> listdata = [];
  final Function? insertIafjrnhdRefund;
  final Function? insertIafjrnhd;
  late String pymtmthd;
  final List<String> paymentlist;
  late num? result;
  late String selectedpay;
  final Function? selectedpayment;
  ClassPaymentQrisTab(
      {Key? key,
      required this.trno,
      required this.pscd,
      required this.trdt,
      required this.balance,
      required this.debitcontroller,
      required this.cardno,
      required this.cardexp,
      this.outletname,
      this.outletinfo,
      required this.datatrans,
      required this.fromsaved,
      this.insertIafjrnhdRefund,
      this.insertIafjrnhd,
      required this.pymtmthd,
      required this.selectedpay,
      required this.result,
      required this.paymentlist,
      required this.selectedpayment})
      : super(key: key);

  @override
  State<ClassPaymentQrisTab> createState() => _ClassPaymentQrisTabState();
}

class _ClassPaymentQrisTabState extends State<ClassPaymentQrisTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QrImage(
            data: "Harusnya isinya deeplink",
            version: QrVersions.auto,
            size: MediaQuery.of(context).size.height * 0.55,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                  onPressed: () {}, child: Text('Check payment'))),
        )
      ],
    );
  }
}
