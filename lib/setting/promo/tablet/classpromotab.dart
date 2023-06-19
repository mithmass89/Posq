import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/setting/promo/classcreatepromomobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/promo/classeditpromomobile.dart';
import 'package:posq/userinfo.dart';

class ClassPromoTab extends StatefulWidget {
  const ClassPromoTab({Key? key}) : super(key: key);

  @override
  State<ClassPromoTab> createState() => _ClassPromoTabState();
}

class _ClassPromoTabState extends State<ClassPromoTab> {
  final search = TextEditingController();
  late DatabaseHandler handler;
  String query = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 173, 150),
        foregroundColor: Colors.white,
        splashColor: Colors.yellow,
        hoverColor: Colors.red,
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassCreatePromoMobile()))
              .then((_) async {
            await handler.retrievePromo(query);

            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Setting promo')),
      body: Column(
        children: [
          TextFieldMobile2(
              label: 'Search',
              controller: search,
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              typekeyboard: TextInputType.text),
          FutureBuilder(
              future: ClassApi.getPromoList(dbname, query),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Promo>> snapshot) {
                var x = snapshot.data ?? [];
                if (x.isNotEmpty) {
                  return Container(
                    // color: Colors.grey[200],
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 1,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: x.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.grey[100],
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.close),
                          ),
                          key: ValueKey<int>(snapshot.data![index].id!),
                          onDismissed: (DismissDirection direction) async {
                            await ClassApi.deletePromo(
                                pscd, snapshot.data![index].id!);
                            setState(() {
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          child: Card(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ClassEditPromoMobile(
                                            data: snapshot.data![index],
                                          ))).then((_) {
                                setState(() {});
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Text(snapshot.data![index].promodesc!)),
                          )),
                        );
                      },
                    ),
                  );
                }
                return Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: MediaQuery.of(context).size.width * 1,
                );
              }),
    
        ],
      ),
    );
  }
}
