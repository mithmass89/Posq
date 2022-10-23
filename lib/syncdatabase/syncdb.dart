import 'package:flutter/material.dart';
import 'package:posq/classui/cloudapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

ClassCloudApi? apicloud;

class SyncDatabaseClass extends StatefulWidget {
 
  const SyncDatabaseClass({Key? key, }) : super(key: key);

  @override
  State<SyncDatabaseClass> createState() => _SyncDatabaseClassState();
}

class _SyncDatabaseClassState extends State<SyncDatabaseClass> {
String? databasename;

  @override
  void initState() {
    apicloud = ClassCloudApi();
    super.initState();
    checkSF() ;
  }

  Future<dynamic> checkSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dbpref = prefs.getString('database') ?? "";
    if (dbpref.isNotEmpty) {
      setState(() {
        databasename = dbpref;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Text(databasename!),
    );
  }
}
