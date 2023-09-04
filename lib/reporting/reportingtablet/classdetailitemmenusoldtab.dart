import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:toast/toast.dart';

class ClassCashierMenuSoldDetailTab extends StatefulWidget {
  final String fromdate;
  final String todate;
  final String itemcode;
  const ClassCashierMenuSoldDetailTab(
      {Key? key, required this.fromdate, required this.todate, required this.itemcode})
      : super(key: key);

  @override
  State<ClassCashierMenuSoldDetailTab> createState() =>
      _ClassCashierMenuSoldDetailTabState();
}

class _ClassCashierMenuSoldDetailTabState
    extends State<ClassCashierMenuSoldDetailTab> {
  String? query = '';
  TextEditingController _controller = TextEditingController();

  void initState() {
    super.initState();

    ToastContext().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi')),
      body: Container(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.095,
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFieldTab1(
                  suffixIcon: Icon(Icons.search),
                  hint: 'Cari transaksi',
                  controller: _controller,
                  onChanged: (value) {
                    query = value;
                    setState(() {});
                  },
                  typekeyboard: TextInputType.text,
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: FutureBuilder(
                  future: ClassApi.getReportDetailMenuSoldDetail(
                      widget.fromdate, widget.todate, dbname,widget.itemcode, query!),
                  builder:
                      (context, AsyncSnapshot<List<IafjrndtClass>> snapshot) {
                    var x = snapshot.data ?? [];
                    print({snapshot.data});
                    if (x.isNotEmpty) {
                      return ListView.builder(
                          itemCount: x.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                    dense: true,
                                    leading: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: AppColors.primaryColor,
                                      // backgroundImage: AssetImage(
                                      //   'assets/sheryl.png',
                                      // ),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(x[index].transno!),
                                    subtitle: Text(x[index].itemdesc!),
                                    trailing: Text(CurrencyFormat.convertToIdr(
                                        x[index].revenueamt, 0))),
                                Divider(),
                              ],
                            );
                          });
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
