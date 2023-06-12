import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/imagelogoprinter.dart';
import 'package:posq/image.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';
import 'package:posq/userinfo.dart';

// enum ImageSourceType { gallery, camera }

class TemplatePrinter extends StatefulWidget {
  const TemplatePrinter({Key? key}) : super(key: key);

  @override
  State<TemplatePrinter> createState() => _TemplatePrinterState();

  static _TemplatePrinterState? of(BuildContext context) =>
      context.findAncestorStateOfType<_TemplatePrinterState>();
}

class _TemplatePrinterState extends State<TemplatePrinter>
    with SingleTickerProviderStateMixin {
  TextEditingController header = TextEditingController();
  TextEditingController footer = TextEditingController();
  bool footerbold = false;
  bool headerbold = false;
  bool isi = false;
  int footerbolds = 0;
  int headerbolds = 0;

  String? imagepath =
      'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930';
  set string(String? value) {
    setState(() {
      imagepath = value;
    });
    print(" url gambar template $value");
  }

   getTemplatePrinter() {
    ClassApi.getTemplatePrinter().then((value) {
      if (value.isNotEmpty) {
        print(value[0]['logourl']);
        imagepath = value[0]['logourl'];
        header.text = value[0]['header'];
        footer.text = value[0]['footer'];
        headerbolds = value[0]['headerbold'];
        footerbolds = value[0]['footerbold'];
      }
      ;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTemplatePrinter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setelan'),
      ),
      body: FutureBuilder(
          future: ClassApi.getTemplatePrinter(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
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
                          child: ImageFromGalleryExPrinter(
                            ImageSourceType.gallery,
                            fromedit: false,
                            fromtemplateprint: true,
                            savingimage: imagepath,
                            imagepath: imagepath,
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
                            if (headerbold == true) {
                              headerbolds = 1;
                            } else {
                              headerbolds = 0;
                            }
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
                            if (footerbold == true) {
                              footerbolds = 1;
                            } else {
                              footerbolds = 0;
                            }
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
                    ElevatedButton(
                        onPressed: () async {
                          await ClassApi.updateTemplatePrinter(
                                  imagepath!,
                                  header.text,
                                  footer.text,
                                  headerbolds,
                                  footerbolds,
                                  dbname)
                              .whenComplete(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text('Simpan'))
                  ],
                ),
              );
            } else {
              return Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
