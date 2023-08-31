import 'package:flutter/material.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

class SettingTableMain extends StatefulWidget {
  final String pscd;
  const SettingTableMain({Key? key, required this.pscd}) : super(key: key);

  @override
  State<SettingTableMain> createState() => _SettingTableMainState();
}

class _SettingTableMainState extends State<SettingTableMain> {
  List<TableMaster> table = [];
  List<TextEditingController> controller = [];
  bool isLoading = false;
  int startindex = 0;

  @override
  void initState() {
    super.initState();

    getTable();
  }

  getTable() async {
    table = await ClassApi.getTableList('');
    if (table.isNotEmpty) {
      for (var x in table) {
        controller.add(TextEditingController(text: x.tablecd));
      }
      startindex = table.length;
    } else {
      // controller.add(TextEditingController());
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
        title: Text('Buat Table / Order'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                  itemCount: controller.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFieldMobile2(
                            label: 'Table Name',
                            controller: controller[index],
                            onChanged: (String value) {
                              print(index);
                              table[index].tablecd = value;
                              print(table);
                            },
                            typekeyboard: TextInputType.text,
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: () async {
                                  controller.removeAt(index);
                                  // ClassApi.deactiveTable(
                                  //   table[index].id!,
                                  //   dbname,
                                  // );
                                  table.removeAt(index);
                                  setState(() {});
                                },
                                icon: Icon(Icons.close))),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LoadingButton(
                  isLoading: isLoading,
                  color: Colors.white,
                  textcolor: AppColors.primaryColor,
                  name: 'Simpan',
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.3,
                  onpressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await ClassApi.deactiveTableAll();
                    await ClassApi.insertTableMaster(dbname, table);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ButtonNoIcon2(
                  color: AppColors.primaryColor,
                  textcolor: Colors.white,
                  name: 'Add table',
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.6,
                  onpressed: () {
                    controller.add(TextEditingController());
                    table.add(TableMaster(
                      tablecd: controller[startindex].text,
                      sectioncd: '',
                      posx: 1,
                      posy: 1,
                    ));
                    print(table);
                    startindex++;
                    setState(() {});
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
