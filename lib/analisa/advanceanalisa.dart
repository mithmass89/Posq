import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdvanceAnalisaTab extends StatefulWidget {
  const AdvanceAnalisaTab({super.key});

  @override
  State<AdvanceAnalisaTab> createState() => _AdvanceAnalisaTabState();
}

class _AdvanceAnalisaTabState extends State<AdvanceAnalisaTab> {
  List<String> listanalisa = [
    'Item / Produk terlaris',
    'Guest Review',
    'Category item terlaris',
    'Volume Sales / hari',
    'Volume Sales / Jam',
    'Analisa  Sales / Broker',
    'Analisa Antara Penjualan dan bahan baku',
    'Mutasi Produk',
    'Repeater guest'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
      if (constraints.maxWidth <= 800) {
        return ListView.builder(
            itemCount: listanalisa.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(listanalisa[index]),
              );
            });
      } else if (constraints.maxWidth >= 800) {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.2,
                childAspectRatio: 3 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            itemCount: listanalisa.length,
            itemBuilder: (context, index) {
              return Container(
                child: Card(
                  child: ListTile(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "Segera hadir",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    title: Text(
                      listanalisa[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            });
      }
      return Container();
    }));
  }
}
