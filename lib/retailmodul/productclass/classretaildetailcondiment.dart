import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class CondimentDetail extends StatefulWidget {
  final Item data;
  const CondimentDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<CondimentDetail> createState() => _CondimentDetailState();
}

class _CondimentDetailState extends State<CondimentDetail> {
  List<Condiment> condimentdetail = [];
  String query = '';

  getDetailCondiment() async {
    condimentdetail =
        await ClassApi.getItemCondiment(widget.data.itemcode!, dbname, query);
  }

  @override
  void initState() {
    super.initState();
    getDetailCondiment();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: condimentdetail.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              dense: true,
              title: Text(condimentdetail[index].condimentdesc!),
            );
          }),
    );
  }
}
