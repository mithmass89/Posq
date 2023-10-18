import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/kitchen/kitchencard.dart';
import 'package:posq/kitchen/kitchencardtabs.dart';
import 'package:posq/userinfo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KitchenDisplayMain extends StatefulWidget {
  const KitchenDisplayMain({super.key});

  @override
  State<KitchenDisplayMain> createState() => _KitchenDisplayMainState();
}

class _KitchenDisplayMainState extends State<KitchenDisplayMain>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  final currentDate = DateTime.now();
  var formattedDate;
  List dataorder = [];
  Map<String, List<Map<String, dynamic>>> groupedData = {};
  Color _randomColor = Colors.blue; // Warna default
  int? indexstrike;
  late AnimationController _controllers;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    listen_Ordr();
    orderAwal();
    _controllers = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _controllers.forward();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Color _changeColor() {
    // Generate warna acak dengan nilai RGB acak
    _randomColor = Color.fromARGB(
      255,
      Random().nextInt(128), // Batasi komponen merah ke angka kecil
      Random().nextInt(128), // Batasi komponen hijau ke angka kecil
      Random().nextInt(128), // Batasi komponen biru ke angka kecil
    );
    return _randomColor;
  }

  listen_Ordr() async {
    await supabase
        .from('new_orders')
        .stream(primaryKey: ['id'])
        .eq('prfcd', dbname)
        .order('transno')
        .limit(10)
        .listen((List<Map<String, dynamic>> data) async {
          await ClassApi.kitchenData(formattedDate, dbname).then((value) {});
        });
  }

  notifyDone(String key) async {
    if (groupedData.containsKey(key)) {
      groupedData.remove(key);
      await ClassApi.updateKitchenOrder(2, key, dbname);
    }
    setState(() {});
  }

  orderAwal() async {
    await ClassApi.kitchenData(formattedDate, dbname).then((value) {
     
      for (var item in value) {
        String transno = item['transno'];
        if (groupedData.containsKey(transno)) {
          groupedData[transno]!.add(item);
        } else {
          groupedData[transno] = [item];
        }
      }
      groupedData.forEach((key, value) {
        print('Transaction $key:');
        value.forEach((item) {
          print(
              '- ${item['itemdesc']} (Qty: ${item['qty']}, Condiments: ${item['condiment']})');
        });
      });
      print(groupedData);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.history))],
        title: Text(
          'Kitchen Display',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 800) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: groupedData.length,
                itemBuilder: (context, index) {
                  String key = groupedData.keys.elementAt(index);
                  var datax = groupedData.values.elementAt(index);
              
                  return KitchenCard(
                    notif: notifyDone,
                    keys: key,
                    datax: datax,
                    color: _changeColor(),
                  );
                }),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        MediaQuery.of(context).size.width * 0.4,
                    childAspectRatio: 3 / 5,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemCount: groupedData.length,
                itemBuilder: (context, index) {
                  String key = groupedData.keys.elementAt(index);
                  var datax = groupedData.values.elementAt(index);
                  print('ini datax : $datax');
                  return KitchenCardTabs(
                    notif: notifyDone,
                    keys: key,
                    datax: datax,
                    color: _changeColor(),
                  );
                }),
          );
        }
      }),
    );
  }
}
