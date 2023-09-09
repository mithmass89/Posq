import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/product_master/tabletclass/createpaymenttab.dart';

class PaymentMasterTab extends StatefulWidget {
  final String pscd;
  const PaymentMasterTab({Key? key, required this.pscd}) : super(key: key);

  @override
  State<PaymentMasterTab> createState() => _PaymentMasterTabState();
}

class _PaymentMasterTabState extends State<PaymentMasterTab> {
  bool usetaxservice = false;
  TextEditingController search = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 1, 138, 156),
        foregroundColor: Colors.white,
        splashColor: Colors.yellow,
        hoverColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreatePaymentTab(
                      pscd: widget.pscd,
                    )),
          ).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Setting piutang',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFieldMobile(
              label: 'Cari',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              child: FutureBuilder(
                future: ClassApi.getPaymentMaster(search.text),
                builder:
                    (context, AsyncSnapshot<List<PaymentMaster>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!.isNotEmpty) {
                      var data = snapshot.data;
                      return ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: ((context, index) {
                            return Card(
                                child: ListTile(
                                    title: Text(data[index].paymentdesc!)));
                          }));
                    } else {
                      return Container();
                    }
                  } else {
                    return Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.07,
                            child: CircularProgressIndicator()));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
