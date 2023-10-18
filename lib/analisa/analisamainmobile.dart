import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/analisa/indexbisnis.dart';

class AnalisaMainMobile extends StatefulWidget {
  const AnalisaMainMobile({super.key});

  @override
  State<AnalisaMainMobile> createState() => _AnalisaMainMobileState();
}

class _AnalisaMainMobileState extends State<AnalisaMainMobile> {
  List<String> itemmenu = [
    "Analisa cepat",
    "Inventory / Stock",
    "Tren Item",
    "Favorit Item",
    "Guest Review",
    "Analisa bisnis",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analisa bisnis',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: itemmenu.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(itemmenu[index]),
                onTap: () {
                  print(itemmenu[index]);
                  if (itemmenu[index] == "Tren Item") {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => CompareItemMobile()),
                    // );
                    Fluttertoast.showToast(
                        msg: "Segera hadir",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (itemmenu[index] == "Analisa bisnis") {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => AdvanceAnalisaTab()),
                    // );
                    Fluttertoast.showToast(
                        msg: "Segera hadir",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (itemmenu[index] == "Inventory / Stock") {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => AdvanceAnalisaTab()),
                    // );
                    Fluttertoast.showToast(
                        msg: "Segera hadir",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (itemmenu[index] == "Analisa cepat") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndexBisnisMobile()),
                    );
                  } else if (itemmenu[index] == "Favorit Item") {
                    Fluttertoast.showToast(
                        msg: "Segera hadir",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (itemmenu[index] == "Guest Comment") {
                    Fluttertoast.showToast(
                        msg: "Segera hadir",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 11, 12, 14),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
            );
          }),
    );
  }
}
