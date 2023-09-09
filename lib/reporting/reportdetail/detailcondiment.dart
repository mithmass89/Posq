import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/userinfo.dart';

class DetailCondimentCheck extends StatefulWidget {
  final String optioncode;
  final String fromdate;
  final String todate;
  const DetailCondimentCheck(
      {Key? key,
      required this.optioncode,
      required this.fromdate,
      required this.todate})
      : super(key: key);

  @override
  State<DetailCondimentCheck> createState() => _DetailCondimentCheckState();
}

class _DetailCondimentCheckState extends State<DetailCondimentCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail transaksi',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: FutureBuilder(
            future: ClassApi.condimentTransDetail(
                widget.fromdate, widget.todate, dbname, widget.optioncode),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                List data = snapshot.data;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index]['itemdesc']),
                    subtitle: Text('Terjual : x${data[index]['qty'].toString()}'),
                    trailing: Text(data[index]['optiondesc']) ,
                  );
                });
              }
            }),
      ),
    );
  }
}
