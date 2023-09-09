import 'package:flutter/material.dart';
import 'package:posq/analisa/compareitemmobile.dart';
import 'package:posq/analisa/indexbisnis.dart';

class AnalisaMainMobile extends StatefulWidget {
  const AnalisaMainMobile({super.key});

  @override
  State<AnalisaMainMobile> createState() => _AnalisaMainMobileState();
}

class _AnalisaMainMobileState extends State<AnalisaMainMobile> {
  List<String> itemmenu = [
    "Performa bisnis",
    "Compare Item",
    "Favorit Item",
    "Guest Comment"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analisa chart',style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
          itemCount: itemmenu.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(itemmenu[index]),
                onTap: () {
                  print(itemmenu[index]);
                  if (itemmenu[index] == "Compare Item") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompareItemMobile()),
                    );
                  } else if (itemmenu[index] == "Performa bisnis") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndexBisnisMobile()),
                    );
                  }
                },
              ),
            );
          }),
    );
  }
}
