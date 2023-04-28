import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';

class SummaryTodayTabs extends StatefulWidget {
  final List todaysale;
  final List monthlysales;
  const SummaryTodayTabs(
      {Key? key, required this.todaysale, required this.monthlysales})
      : super(key: key);

  @override
  State<SummaryTodayTabs> createState() => _SummaryTodayTabsState();
}

class _SummaryTodayTabsState extends State<SummaryTodayTabs> {
  @override
  void initState() {
    print(widget.todaysale);
    super.initState();
    print(widget.todaysale == null);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Container(
          child: Column(
            children: [
              // ),
              ListTile(
                title: Text('Ringkasan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16)),
                trailing: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Lihat Selebihnya >>',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.01,
              //   width: MediaQuery.of(context).size.width * 1,
              // ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Card(
                      color: Colors.white,
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
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
    
                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Card(
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
                  ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  //   width: MediaQuery.of(context).size.width * 0.03,
                  // ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        dense: true,
                        title: Text('Penjualan Rata Rata'),
                        trailing: Text(
                          '10',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
