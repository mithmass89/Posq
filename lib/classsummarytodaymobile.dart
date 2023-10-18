// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';

class Summarytoday extends StatefulWidget {
  final List todaysale;
  final List monthlysales;
  final List rataratapenjualan;
  const Summarytoday(
      {Key? key,
      required this.todaysale,
      required this.monthlysales,
      required this.rataratapenjualan})
      : super(key: key);

  @override
  State<Summarytoday> createState() => _SummarytodayState();
}

class _SummarytodayState extends State<Summarytoday> {
  @override
  void initState() {
    print(widget.todaysale);
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      context,
      BoxConstraints constraints,
    ) {
      if (constraints.maxWidth <= 800) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.01,
              //   width: MediaQuery.of(context).size.width * 1,
              // ),
              ListTile(
                title: Container(
                  height: MediaQuery.of(context).size.height * 0.025,
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Text('Ringkasan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 19)),
                ),
                trailing: GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Text(
                      'Lihat Selebihnya >>',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.01,
              //   width: MediaQuery.of(context).size.width * 1,
              // ),
              Column(
                mainAxisSize: MainAxisSize.min,
                // scrollDirection: Axis.horizontal,
                children: [
                  Card(
                    elevation: 5,
                    child: ListTile(
                      dense: true,
                      title: Text('Penjualan Hari ini'),
                      trailing: widget.todaysale.isNotEmpty
                          ? Text(
                              '${CurrencyFormat.convertToIdr(widget.todaysale.first['totalaftdisc'], 0)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text('0'),
                    ),
                  ),

                  Card(
                    elevation: 5,
                    child: ListTile(
                      dense: true,
                      title: Text('Penjualan Bulan ini'),
                      trailing: Text(
                        '${CurrencyFormat.convertToIdr(widget.monthlysales.isNotEmpty ? widget.monthlysales.first['totalaftdisc'] : 0, 0)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  //   width: MediaQuery.of(context).size.width * 0.03,
                  // ),
                  Card(
                    elevation: 5,
                    child: ListTile(
                      dense: true,
                      title: Text('Penjualan Rata-rata / 30 hari / bill'),
                      trailing: Text(
                     '${CurrencyFormat.convertToIdr(widget.rataratapenjualan.isNotEmpty? widget.rataratapenjualan[0]['totalaftdisc']:0,0)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}
