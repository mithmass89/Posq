import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

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
  List<IafjrnhdClass> data = [];

  @override
  void initState() {
    super.initState();
    getPaymentList();
  }

  getPaymentList() async {
    data = await ClassApi.getDetailPayment(widget.trno, dbname, '');
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
              future: ClassApi.getDetailPayment(widget.trno, dbname, ''),
              builder: (context, AsyncSnapshot<List<IafjrnhdClass>> snapshot) {
                var x = snapshot.data ?? [];
                print('ini x: $data');
                if (data.isNotEmpty) {
                  return ListView.builder(
                      controller: widget.controllers,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              visualDensity: VisualDensity(vertical: -2), // t
                              dense: true,
                              title: Text(data[index].transno.toString()),
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
                                        child: Text(data[index].totalamt.toString())),
                                    IconButton(
                                        icon: Icon(
                                          Icons.close,
                                        ),
                                        iconSize: 30,
                                        color: Colors.blue,
                                        splashColor: Colors.transparent,
                                        onPressed: () async {
                                          await ClassApi.deletePayment(
                                                  dbname, x[index].id!)
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
