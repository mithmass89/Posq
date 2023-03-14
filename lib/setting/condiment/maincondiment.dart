import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/loading/shimmer.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/condiment/createcondiment.dart';
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
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier List'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldMobile(
                hint: 'Example Menu Description',
                label: 'Search',
                controller: search,
                onChanged: (value) async {
                  setState(() {
                    query = value;
                    print(value);
                  });
                },
                typekeyboard: TextInputType.text,
              ),
            ),
            FutureBuilder<List<Condiment>?>(
                future: ClassApi.getCondimentList(dbname, query),
                builder: (context, snapshot) {
                  condiment = snapshot.data ?? [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print(snapshot);
                    return Expanded(
                      child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ShimmerLoading(
                              isLoading: true,
                              child: Card(
                                child: ListTile(
                                  title: Text(''),
                                  onTap: () {},
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: condiment.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(condiment[index].condimentdesc!),
                                trailing: Text('total opsi : ${condiment[index].totalcond!.toString()}'),
                                onTap: () {},
                              ),
                            );
                          }),
                    );
                  }
                }),
            ButtonNoIcon2(
              color: Colors.blue,
              textcolor: Colors.white,
              name: 'Add Modifier',
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CondimentCreate(
                            pscd: widget.pscd,
                          )),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.02,),
          ],
        ),
      ),
    );
  }
}