import 'package:flutter/material.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class ClassAdjusmentType extends StatefulWidget {
  const ClassAdjusmentType({Key? key}) : super(key: key);

  @override
  State<ClassAdjusmentType> createState() => _ClassAdjusmentTypeState();
}

class _ClassAdjusmentTypeState extends State<ClassAdjusmentType> {
  late DatabaseHandler handler;
  String query = '';

  @override
  void initState() {
    super.initState();

    this.handler = DatabaseHandler();
    handler.initializeDB(databasename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Adjusment'),
      ),
      body: FutureBuilder(
          future: handler.retrivegntranstp(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Gntrantp>> snapshot) {
            var x = snapshot.data ?? [];
            if (x.isNotEmpty) {
              return ListView.builder(
                  itemCount: x.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(x[index].ProgNm!),
                          onTap: () {
                            Navigator.of(context).pop(x[index]);
                          },
                        ),
                        Divider()
                      ],
                    );
                  });
            }
            return Container(
              child: Center(
                child: Text('Tidak ada data!!'),
              ),
            );
          }),
    );
  }
}
