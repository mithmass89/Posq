import 'package:flutter/material.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';

class Createctg extends StatefulWidget {
  const Createctg({Key? key}) : super(key: key);

  @override
  State<Createctg> createState() => _CreatectgState();
}

class _CreatectgState extends State<Createctg> {
  final _ctgcd = TextEditingController();
  final _ctgdesc = TextEditingController();
  late DatabaseHandler handler;
  String? ctgcd;
  String? ctgdesc;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<int> addCategory() async {
    Ctg ctg = Ctg(ctgcd: _ctgcd.text, ctgdesc: _ctgdesc.text);
    List<Ctg> listctg = [ctg];
    return await handler.insertCtg(listctg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          // TextFieldMobile(
          //   enable: false,
          //   label: 'Kode',
          //   controller: _ctgcd,
          //   onChanged: (String value) {
          //     setState(() {});
          //     print(value);
          //   },
          //   typekeyboard: TextInputType.text,
          // ),
          TextFieldMobile2(
            label: 'Deskripsi',
            controller: _ctgdesc,
            onChanged: (String value) {
              setState(() {
                _ctgcd.text = _ctgdesc.text.substring(0, 5).replaceAll(' ', '');
              });
            },
            typekeyboard: TextInputType.text,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonNoIcon(
              color: Colors.blue,
              textcolor: Colors.white,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              name: 'Save & Use',
              onpressed: () async {
                await addCategory();
                Navigator.of(context)
                    .pop(Ctg(ctgcd: _ctgcd.text, ctgdesc: _ctgdesc.text));
              },
            ),
          )
        ],
      ),
    );
  }
}

class CreatectgArscomp extends StatefulWidget {
  const CreatectgArscomp({Key? key}) : super(key: key);

  @override
  State<CreatectgArscomp> createState() => _CreatectgArscompState();
}

class _CreatectgArscompState extends State<CreatectgArscomp> {
  final _ctgcd = TextEditingController();
  final _ctgdesc = TextEditingController();
  late DatabaseHandler handler;
  String? ctgcd;
  String? ctgdesc;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<int> addCategory() async {
    Ctg ctg = Ctg(ctgcd: _ctgcd.text, ctgdesc: _ctgdesc.text);
    List<Ctg> listctg = [ctg];
    return await handler.insertCtgArscomp(listctg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          // TextFieldMobile(
          //   enable: false,
          //   label: 'Kode',
          //   controller: _ctgcd,
          //   onChanged: (String value) {
          //     setState(() {});
          //     print(value);
          //   },
          //   typekeyboard: TextInputType.text,
          // ),
          TextFieldMobile2(
            label: 'Deskripsi',
            controller: _ctgdesc,
            onChanged: (String value) {
              setState(() {
                _ctgcd.text = _ctgdesc.text.substring(0, 5).replaceAll(' ', '');
              });
              print(_ctgcd.text);
            },
            typekeyboard: TextInputType.text,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonNoIcon(
              color: Colors.blue,
              textcolor: Colors.white,
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.05,
              name: 'Save & Use',
              onpressed: () async {
                await addCategory();
                Navigator.of(context)
                    .pop(Ctg(ctgcd: _ctgcd.text, ctgdesc: _ctgdesc.text));
              },
            ),
          )
        ],
      ),
    );
  }
}
