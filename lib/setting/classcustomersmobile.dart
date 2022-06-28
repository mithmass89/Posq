// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/setting/classcreatecustomermobile.dart';
import 'package:posq/setting/classcustomersedit.dart';

class ClassListCustomers extends StatefulWidget {
  const ClassListCustomers({Key? key}) : super(key: key);

  @override
  State<ClassListCustomers> createState() => _ClassListCustomersState();
}

class _ClassListCustomersState extends State<ClassListCustomers> {
  late DatabaseHandler handler;
  String query = '';

  @override
  void initState() {
    super.initState();

    this.handler = DatabaseHandler();
    handler.initializeDB(databasename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customers List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: this.handler.retrieveListCustomers(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Costumers>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this
                        .handler
                        .deleteCustomers(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClassEditCustomers(
                                  listdata: snapshot.data![index],
                                )),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    child: Card(
                        child: ListTile(
                      leading:
                          Text(snapshot.data![index].id.toString()),
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text(snapshot.data![index].compdesc!),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text(snapshot.data![index].address.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              Text(snapshot.data![index].telp.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              Text(snapshot.data![index].email.toString()),
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
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Container(
              child: Text('Nothing here'),
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ClassCreateCustomerMobile()),
          ).then((_) {
            setState(() {});
          });
        },
      ),
    );
  }
}
