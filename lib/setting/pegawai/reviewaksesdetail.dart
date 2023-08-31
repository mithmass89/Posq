import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/pegawai/tambahakses.dart';

class ReviewAksesDetail extends StatefulWidget {
  final String user;
  final String outletcd;
  final String email;
  const ReviewAksesDetail(
      {Key? key,
      required this.user,
      required this.outletcd,
      required this.email})
      : super(key: key);

  @override
  State<ReviewAksesDetail> createState() => _ReviewAksesDetailState();
}

class _ReviewAksesDetailState extends State<ReviewAksesDetail> {
  String query = '';
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Detail Akses ${widget.user} ${widget.outletcd}'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
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
              height: MediaQuery.of(context).size.height * 0.68,
              child: FutureBuilder(
                  future: ClassApi.getAccessStaffOutlet(
                      widget.user, widget.outletcd, widget.outletcd, query),
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
                                      onPressed: () async {
                                        await ClassApi.deleteAksesStaff(
                                            data[index].email,
                                            data[index].id,
                                            widget.outletcd);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.close)),
                                  title: Text(data[index].accessdesc),
                                  subtitle: Text(data[index].usercd!),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // Background color
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TambahAksesStaff(
                                  email: widget.email,
                                  outletcd: widget.outletcd,
                                  user: widget.user,
                                )));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.height * 0.3,
                    child: Text(
                      'Tambah Akses',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
