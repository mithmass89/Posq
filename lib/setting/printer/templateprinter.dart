import 'package:flutter/material.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/image.dart';

enum ImageSourceType { gallery, camera }

class TemplatePrinter extends StatefulWidget {
  const TemplatePrinter({Key? key}) : super(key: key);

  @override
  State<TemplatePrinter> createState() => _TemplatePrinterState();
}

class _TemplatePrinterState extends State<TemplatePrinter> {
  final TextEditingController header = TextEditingController();
  final TextEditingController footer = TextEditingController();
  bool footerbold = false;
  bool headerbold = false;
  bool isi = false;

  String? imagepath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setelan'),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text('Setelan Header dan Footer'),
            ),
            TextFieldMobile2(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              typekeyboard: TextInputType.number,
              onChanged: (value) {},
              controller: header,
              label: 'Header',
            ),
            TextFieldMobile2(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              typekeyboard: TextInputType.number,
              onChanged: (value) {},
              controller: footer,
              label: 'Footer',
            ),
            ListTile(
              title: Text('Setelan Image / Logo'),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Container(
                  color: Colors.grey,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ImageFromGalleryEx(
                    ImageSourceType.gallery,
                    savingimage: imagepath,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text('Setelan Text'),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Text(
                  'Header Bold',
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.46,
                ),
                Switch(
                  value: headerbold,
                  onChanged: (value) {
                    headerbold = value;
                    setState(() {});
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Text(
                  'Content Bold',
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                ),
                Switch(
                  value: isi,
                  onChanged: (value) {
                    isi = value;
                    setState(() {});
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Text(
                  'Footer Bold',
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.47,
                ),
                Switch(
                  value: footerbold,
                  onChanged: (value) {
                    footerbold = value;
                    setState(() {});
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            ElevatedButton(onPressed: () {}, child: Text('Simpan'))
          ],
        ),
      ),
    );
  }
}
