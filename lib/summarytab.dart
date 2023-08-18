import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';

class SummaryTodayTabs extends StatefulWidget {
  final List todaysale;
  final List monthlysales;
  final List penjualanratarata;
  const SummaryTodayTabs(
      {Key? key,
      required this.todaysale,
      required this.monthlysales,
      required this.penjualanratarata})
      : super(key: key);

  @override
  State<SummaryTodayTabs> createState() => _SummaryTodayTabsState();
}

class _SummaryTodayTabsState extends State<SummaryTodayTabs> {
  @override
  void initState() {
    print(widget.todaysale);
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
 
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
                              : Text('Rp 0'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),

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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          dense: true,
                          title: Text('Penjualan Rata-rata / 30 hari / bill'),
                          trailing: Text(
                            widget.penjualanratarata.isNotEmpty? '${CurrencyFormat.convertToIdr(widget.penjualanratarata[0]['totalaftdisc'], 0)}':'Rp 0',
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
}
