import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassPilihOutletMobile extends StatefulWidget {
  const ClassPilihOutletMobile({Key? key}) : super(key: key);

  @override
  State<ClassPilihOutletMobile> createState() => _ClassPilihOutletMobileState();
}

class _ClassPilihOutletMobileState extends State<ClassPilihOutletMobile> {
  List<dynamic> listoutlet = [];
  List<dynamic> selectedoutlet = [];

  @override
  void initState() {
    ToastContext().init(context);
    super.initState();
  }

  pesanBelumReady() {
    Toast.show("Module Belum Tersedia",
        duration: Toast.lengthLong, gravity: Toast.center);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Outlet'),
      ),
      body: FutureBuilder(
          future: ClassApi.getOutlets(emaillogin),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.isNotEmpty) {
                listoutlet.add(
                    {"outletcd": 'All Outlet', "outletdesc": 'All Outlet', "alamat": ''});
                for (var x in snapshot.data) {
                  listoutlet.add(x);
                }

                print(listoutlet);
                return ListView.builder(
                  itemCount: listoutlet.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(listoutlet[index]['outletdesc']),
                      subtitle: Text(listoutlet[index]['alamat']),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                      ),
                      onTap: () {
                        if (listoutlet[index]['outletdesc'] == 'ALL') {
                          selectedoutlet.add(listoutlet[0]);
                          Navigator.of(context).pop(listoutlet);
                        } else {
                          selectedoutlet.add(listoutlet[index]);
                          Navigator.of(context).pop(selectedoutlet);
                        }
                      },
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('Empty Outlet'),
                );
              }
            } else {
              return Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.06,
                      child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
