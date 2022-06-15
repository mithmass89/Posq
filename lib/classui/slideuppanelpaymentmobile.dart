import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlideupPayment extends StatefulWidget {
  final String trno;
  final Function callback;

  final ScrollController controllers;
  SlideupPayment({
    Key? key,
    required this.trno,
    required this.controllers,
    required this.callback,
  }) : super(key: key);

  @override
  State<SlideupPayment> createState() => _SlideupPaymentState();
}

class _SlideupPaymentState extends State<SlideupPayment> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.menu,
          ),
          iconSize: 25,
          color: Colors.blue,
          splashColor: Colors.transparent,
          onPressed: () {},
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.2,
          child: FutureBuilder(
              future: handler.retriveListDetailPayment(widget.trno),
              builder: (context, AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
                var x = snapshot.data ?? [];
                // print(x.first.trno);
                if (x.isNotEmpty) {
                  return ListView.builder(
                      controller: widget.controllers,
                      itemCount: x.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                                 visualDensity: VisualDensity(
                                            vertical: -2), // t
                              dense: true,
                              title: Text(x[index].trno.toString()),
                              trailing: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child:
                                            Text(x[index].amtrmn.toString())),
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                        ),
                                        iconSize: 30,
                                        color: Colors.blue,
                                        splashColor: Colors.transparent,
                                        onPressed: () async {
                                          await handler
                                              .deletepayment(x[index].id!)
                                              .whenComplete(() async {
                                            await widget.callback();
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      });
                }
                return Container();
              }),
        )
      ],
    );
  }
}
