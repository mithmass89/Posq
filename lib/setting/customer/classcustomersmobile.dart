// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/databasehandler.dart';
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
  @override
  void initState() {
    super.initState();
    getCustomers();
   getProgram();
    _tabController = TabController(length: 2, vsync: this);
  }

  getCustomers() async {
    customers = await ClassApi.getCustomers(query);
    setState(() {});
  }

    getProgram() async {
    program = await ClassApi.getLoyalityProgramActive();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: LoyalityMainMobile(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
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
            program.isEmpty?
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StepperLoyalityProgramMobile()),
            ).then((_) async {
              await getCustomers();
              setState(() {});
            }):null;
          }
        },
      ),
    );
  }
}
