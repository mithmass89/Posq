import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class ItemOnlineSetting extends StatefulWidget {
  const ItemOnlineSetting({Key? key}) : super(key: key);

  @override
  State<ItemOnlineSetting> createState() => _ItemOnlineSettingState();
}

class _ItemOnlineSettingState extends State<ItemOnlineSetting> {
  TextEditingController search = TextEditingController();
  List<Item> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    data = await ClassApi.getItemList(pscd, dbname, search.text);
    setState(() {});
  }

  bool onlineFlag(Item online) {
    if (online.onlineflag == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Setting item/produk online'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFieldMobileLogin(
              showpassword: true,
              hint: 'Search',
              prefixIcon: Icon(Icons.search),
              controller: search,
              onChanged: (String value) async {
                await getData();
                setState(() {});
              },
              typekeyboard: null,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'loading...');
                    for (var x in data) {
                      await ClassApi.updateOnlineItem(x.itemcode!, 1, dbname);
                    }
                    await getData();
                    setState(() {});
                    EasyLoading.dismiss();
                  },
                  child: Text('Pilih semua')),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ElevatedButton(
                onPressed: () async {
                  EasyLoading.show(status: 'loading...');
                  for (var x in data) {
                    await ClassApi.updateOnlineItem(x.itemcode!, 0, dbname);
                  }
                  await getData();
                  setState(() {});
                  EasyLoading.dismiss();
                },
                child: Text('Batalkan semua'),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].itemdesc!),
                    trailing: Checkbox(
                      onChanged: (value) async {
                        print(value);
                        if (value == true) {
                          await ClassApi.updateOnlineItem(
                              data[index].itemcode!, 1, dbname);
                          await getData();
                          setState(() {});
                        } else {
                          await ClassApi.updateOnlineItem(
                              data[index].itemcode!, 0, dbname);
                          await getData();
                          setState(() {});
                        }
                      },
                      value: onlineFlag(data[index]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
