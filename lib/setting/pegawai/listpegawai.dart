import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/pegawai/pegawaimaintab.dart';

class ListPegawaiClass extends StatefulWidget {
  const ListPegawaiClass({Key? key}) : super(key: key);

  @override
  State<ListPegawaiClass> createState() => _ListPegawaiClassState();
}

class _ListPegawaiClassState extends State<ListPegawaiClass> {
  List<ListUser>? pegawai = [];

  getListPegawai() async {
    pegawai = await ClassApi.getListUser('');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getListPegawai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 173, 150),
        foregroundColor: Colors.white,
        splashColor: Colors.yellow,
        hoverColor: Colors.red,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PegawaiMainTab()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('List User')),
      body: Container(
        child: ListView.builder(
            itemCount: pegawai!.length,
            itemBuilder: (context, index) {
              if (pegawai!.isNotEmpty) {
                return Card(
                  child: ListTile(
                    title: Text(pegawai![index].usercd!),
                    subtitle: Text(pegawai![index].level!),
                    onTap: () {},
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
