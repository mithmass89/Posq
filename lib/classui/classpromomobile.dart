import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classcreatepromomobile.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class ClassPromoMobile extends StatefulWidget {
  const ClassPromoMobile({Key? key}) : super(key: key);

  @override
  State<ClassPromoMobile> createState() => _ClassPromoMobileState();
}

class _ClassPromoMobileState extends State<ClassPromoMobile> {
  final search = TextEditingController();
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Diskon')),
      body: Column(
        children: [
          TextFieldMobile2(
              label: 'Search',
              controller: search,
              onChanged: (value) {},
              typekeyboard: TextInputType.text),
          FutureBuilder(
              future: handler.retrievePromo(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Promo>> snapshot) {
                var x = snapshot.data ?? [];
                if (x.isNotEmpty) {
                  return Container(
                    // color: Colors.grey[200],
                    height: MediaQuery.of(context).size.height * 0.70,
                    width: MediaQuery.of(context).size.width * 1,
                    child: ListView.builder(
                      itemCount: x.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.delete_forever),
                          ),
                          key: ValueKey<int>(snapshot.data![index].id!),
                          onDismissed: (DismissDirection direction) async {
                            await this
                                .handler
                                .deletePromo(snapshot.data![index].id!);
                            setState(() {
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Card(
                                child: ListTile(
                              contentPadding: EdgeInsets.all(8.0),
                              title: Text(snapshot.data![index].promodesc!),
                              subtitle:
                                  Text(snapshot.data![index].amount.toString()),
                            )),
                          ),
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
          ButtonNoIcon(
            textcolor: Colors.white,
            color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.90,
            name: 'Tambah Diskon',
            onpressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassCreatePromoMobile()))
                  .then((_) async {
                await handler.retrievePromo();

                setState(() {});
              });
            },
          )
        ],
      ),
    );
  }
}
