import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/classdetailsavedmobile.dart';
import 'package:posq/retailmodul/classdetailtransactionmobile.dart';

class ClassDetailSavedMobile extends StatefulWidget {
  final Outlet outletinfo;
  final String pscd;
  final String? trno;
  final IafjrndtClass? datatransaksi;

  const ClassDetailSavedMobile(
      {Key? key,
      required this.outletinfo,
      required this.pscd,
      this.trno,
      this.datatransaksi,
     })
      : super(key: key);

  @override
  State<ClassDetailSavedMobile> createState() => _ClassDetailSavedMobileState();
}

class _ClassDetailSavedMobileState extends State<ClassDetailSavedMobile> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailSavedTransaction(
          
                    outletinfo: widget.outletinfo,
                    pscd: widget.outletinfo.outletcd,
                    status: 'Pending',
                    trno: widget.trno!,
                  )),
        );
      },
      leading: CircleAvatar(
        child: Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
      ),
      title: Text(widget.datatransaksi!.trno.toString()),
      trailing: Text(
          '${CurrencyFormat.convertToIdr(widget.datatransaksi!.nettamt, 0)}'),
    );
  }
}
