// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/customer/classcreatecustomermobile.dart';
import 'package:posq/setting/customer/classcustomersedit.dart';
import 'package:posq/setting/loyalityprogram/loyalityprogrammobile.dart';
import 'package:posq/setting/loyalityprogram/loyalitysteppermain.dart';

class ClassListCustomers extends StatefulWidget {
  const ClassListCustomers({Key? key}) : super(key: key);

  @override
  State<ClassListCustomers> createState() => _ClassListCustomersState();
}

class _ClassListCustomersState extends State<ClassListCustomers>
    with SingleTickerProviderStateMixin {
  String query = '';
  late TabController _tabController;
  List<Costumers> customers = [];
  int indextab = 0;
  List program = [];
  List<RewardCLass> datareward = [];

  @override
  void initState() {
    super.initState();
    getCustomers();
    getProgram();
    _tabController = TabController(length: 2, vsync: this);
        datareward=[];
  }

  getCustomers() async {
    customers = await ClassApi.getCustomers(query);
    setState(() {});
  }

  getProgram() async {
    datareward=[];
    program = await ClassApi.getLoyalityProgramActive();
    print('ini program active : $program');
    for (var x in program) {
      datareward.add(RewardCLass(
          redempoint: x['point'],
          loyalitycd: x['loyalitycd'],
          minimum: x['minimumamount'],
          rewaradtype: x['type']));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Loyality Program',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            onTap: (value) {
              print(value);
              indextab = value;
              setState(() {});
            },
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(
                text: "Customer",
              ),
              Tab(
                text: "Loyality",
              ),
            ],
          )),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab(
              child: ListView.builder(
            itemCount: customers.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassEditCustomers(
                              listdata: customers[index],
                            )),
                  ).then((_) async {
                    await getCustomers();
                    setState(() {});
                  });
                },
                child: Card(
                    child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Text(customers[index].fullname),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Text(customers[index].address.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text(customers[index].phone.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text(customers[index].email.toString()),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 20.0,
                  ),
                )),
              );
            },
          )),
          Tab(
            child: Container(
              child: LoyalityMainMobile(
                datareward: datareward,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          if (indextab == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ClassCreateCustomerMobile()),
            ).then((_) async {
              await getCustomers();
              setState(() {});
            });
          } else {
            if (program.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StepperLoyalityProgramMobile()),
              ).then((_) async {
                await getCustomers();
                setState(() {});
              });
            } else {
              var x = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogReward(
                      type: program[0]['type'].toString(),
                      amount: program[0]['convamount'],
                      fromdate: program[0]['fromdate'],
                      initialamount: program[0]['joinreward'],
                      point: program[0]['point'].toString(),
                      todate: program[0]['todate'],
                    );
                  }).then((_) async {
                await getProgram();
              });
            }
          }
        },
      ),
    );
  }
}
