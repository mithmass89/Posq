import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/classdetailsavedmobile.dart';

class ClassListSavedMobile extends StatefulWidget {
  final Outlet outletinfo;
  final String pscd;
  final String? trno;
  final IafjrndtClass? datatransaksi;

  const ClassListSavedMobile({
    Key? key,
    required this.outletinfo,
    required this.pscd,
    this.trno,
    this.datatransaksi,
  }) : super(key: key);

  @override
  State<ClassListSavedMobile> createState() => _ClassListSavedMobileState();
}

class _ClassListSavedMobileState extends State<ClassListSavedMobile> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    print(widget.datatransaksi!.statustrans!);
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
          size: 26.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
      ),
      title: Text(widget.datatransaksi!.transno.toString()),
      subtitle: Text(widget.datatransaksi!.time!),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${CurrencyFormat.convertToIdr(widget.datatransaksi!.totalaftdisc, 0)}'),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.03,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.datatransaksi!.statustrans!,
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
