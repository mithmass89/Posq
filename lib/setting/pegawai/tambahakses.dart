import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';

class TambahAksesStaff extends StatefulWidget {
  final String user;
  final String outletcd;
  final String email;
  const TambahAksesStaff(
      {Key? key,
      required this.user,
      required this.outletcd,
      required this.email})
      : super(key: key);

  @override
  State<TambahAksesStaff> createState() => _TambahAksesStaffState();
}

class _TambahAksesStaffState extends State<TambahAksesStaff> {
  String query = '';
  final TextEditingController search = TextEditingController();




  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Tambah akses ${widget.user}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFieldMobile(
              suffixicon: search.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        search.clear();
                        query = '';
                        setState(() {});
                      },
                      icon: Icon(Icons.close))
                  : null,
              hint: 'Cari Akses',
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
          Container(
                height: MediaQuery.of(context).size.height * 0.7,
            child: FutureBuilder(
                future: ClassApi.getMainAccess(search.text),
                builder: (context, AsyncSnapshot<List<AksesMain>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    print(snapshot.data);
                    var data = snapshot.data;
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                onTap: () async {
                                  EasyLoading.show(status: 'loading...');
                                  await ClassApi.insertAccessToUser(
                                      widget.email,
                                      '',
                                      '',
                                      data[index].accessname,
                                      data[index].note,
                                      widget.outletcd,
                                      'Pro');
                                  EasyLoading.dismiss();
                                },
                                title: Text(data[index].accessname!),
                                subtitle: Text(data[index].note));
                          });
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Text('OoopS contact administrator'),
                        ),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
