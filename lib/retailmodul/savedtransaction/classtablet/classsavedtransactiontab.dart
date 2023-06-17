import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/savedtransaction/classlisttrnosavedmob.dart';
import 'package:posq/retailmodul/savedtransaction/classtablet/classtrnosavedtab.dart';
import 'package:posq/userinfo.dart';

class ClassSavedTransactionTab extends StatefulWidget {
  final String? pscd;
  final Outlet outletinfo;

  const ClassSavedTransactionTab({
    Key? key,
    this.pscd,
    required this.outletinfo,
  }) : super(key: key);

  @override
  State<ClassSavedTransactionTab> createState() =>
      _ClassSavedTransactionTabState();
}

class _ClassSavedTransactionTabState extends State<ClassSavedTransactionTab> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  int? pending;
  TextEditingController search = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
        title: Text('Order Management'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.1,
              child: TextFieldMobile2(
                  label: 'Search',
                  suffixIcon: search.text.length != 0
                      ? IconButton(
                          icon: Icon(
                            Icons.close_outlined,
                          ),
                          iconSize: 20,
                          color: Colors.blue,
                          splashColor: Colors.purple,
                          onPressed: () {
                            setState(() {
                              search.clear();
                            });
                          },
                        )
                      : Icon(
                          Icons.search_outlined,
                          color: Colors.blue,
                          size: 20.0,
                        ),
                  controller: search,
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  typekeyboard: TextInputType.text),
            ),
            FutureBuilder(
                future: ClassApi.getOutstandingBill(query, dbname, ''),
                builder: (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                  var x = snapshot.data ?? [];
                  if (x.isNotEmpty) {
                    print(x);
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 1,
                          child: ListView.builder(
                              itemCount: x.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      ClassListSavedTab(
                                        datatransaksi: snapshot.data![index],
                                        trno: x[index].transno,
                                        outletinfo: widget.outletinfo,
                                        pscd: widget.pscd.toString(),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                );
                              }),
                        )
                      ],
                    );
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 1,
                      child:
                          Center(child: Text('Tidak ada transaksi tersimpan')));
                }),
          ],
        ),
      ),
    );
  }
}
