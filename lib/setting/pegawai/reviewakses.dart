import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/pegawai/reviewaksesdetail.dart';
import 'package:posq/userinfo.dart';

class ReviewAksesStaf extends StatefulWidget {
  const ReviewAksesStaf({Key? key}) : super(key: key);

  @override
  State<ReviewAksesStaf> createState() => _ReviewAksesStafState();
}

class _ReviewAksesStafState extends State<ReviewAksesStaf> {
  final TextEditingController outlet =
      TextEditingController(text: 'Pilih Outlet');
  final TextEditingController staff =
      TextEditingController(text: 'Pilih Staff');
  List<dynamic>? selectedOutlet = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    selectedOutlet!.add(pscd);
    outlet.text = pscd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Akses staff'),
      ),
      body: Container(
        child: Column(children: [
          ListTile(
            title: Text(
              'Pilih outlet',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          TextFieldMobileButton(
              hint: 'Outlet',
              controller: outlet,
              typekeyboard: TextInputType.none,
              onChanged: (value) {},
              ontap: () async {
                selectedOutlet = [];
                selectedOutlet = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogOutletStaff();
                    });
                if (selectedOutlet!.isEmpty) {
                  selectedOutlet!.add(pscd);
                }
                outlet.text = selectedOutlet!.first;
                setState(() {});
              }),
          ListTile(
            title: Text(
              'List User',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: FutureBuilder(
                future: ClassApi.getStaff(selectedOutlet!.first, query),
                builder: (context, AsyncSnapshot<List<StaffAccess>> snapshot) {
                  var data = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Card(
                              child: ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewAksesDetail(
                                                    email: data[index].email,
                                                    outletcd:
                                                        selectedOutlet!.first,
                                                    user: data[index].usercd!,
                                                  )));
                                    },
                                    icon: Icon(Icons.arrow_forward_ios)),
                                title: Text(data[index].usercd!),
                                subtitle: Text(data[index].roledesc),
                              ),
                            ),
                          );
                        });
                  }
                }),
          )
        ]),
      ),
    );
  }
}
