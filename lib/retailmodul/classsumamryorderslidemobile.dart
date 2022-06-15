// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:posq/classui/classcreatepromomobile.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/selectdiscountmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class SummaryOrderSlidemobile extends StatefulWidget {
  final String trno;
  const SummaryOrderSlidemobile({Key? key, required this.trno})
      : super(key: key);

  @override
  State<SummaryOrderSlidemobile> createState() =>
      _SummaryOrderSlidemobileState();
}

class _SummaryOrderSlidemobileState extends State<SummaryOrderSlidemobile> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: handler.summarybill(widget.trno),
        builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
          var x = snapshot.data ?? [];

          if (x.isNotEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Total'),
                    trailing:
                        Text(CurrencyFormat.convertToIdr(x.first.rvnamt, 0)),
                  ),
                  ListTile(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectPromoMobile()));
                    },
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Discount'),
                    trailing: Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: TextButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectPromoMobile()));
                          },
                          child: Text('>')),
                    ),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Pajak'),
                    trailing:
                        Text(CurrencyFormat.convertToIdr(x.first.taxamt, 0)),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Service'),
                    trailing: Text(
                        CurrencyFormat.convertToIdr(x.first.serviceamt, 0)),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4), // to compact
                    dense: true,
                    title: Text('Grand total'),
                    trailing:
                        Text(CurrencyFormat.convertToIdr(x.first.nettamt, 0)),
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }
}
