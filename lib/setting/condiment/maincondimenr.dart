import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class MainCondiment extends StatefulWidget {
  final String pscd;
  const MainCondiment({Key? key, required this.pscd}) : super(key: key);

  @override
  State<MainCondiment> createState() => _MainCondimentState();
}

class _MainCondimentState extends State<MainCondiment> {
  String query = '';
  List<Condiment> condiment = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Condiment List'),
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
                future: ClassApi.getCondimentList(dbname, query),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: condiment.length,
                        itemBuilder: (context, index) {
                          return ListTile();
                        }),
                  );
                }),
            ElevatedButton(onPressed: () {}, child: Text('Create Condiment'))
          ],
        ),
      ),
    );
  }
}
