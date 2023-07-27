// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_this, must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/setting/menupackage/createpackagemobile.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';
import 'package:posq/menu.dart';
import 'package:posq/setting/product_master/classeditproductv2mob.dart';

import 'setting/menupackage/classtab/createpackagetab.dart';
import 'setting/printer/templateprinter.dart';

ClassApi? hosts;

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  final savingimage;
  final double? height;
  final double? width;
  final bool? fromedit;
  final bool? frompaket;
  final bool? frompakettab;
  late String? imagepath;
  final bool fromtemplateprint;
  ImageFromGalleryEx(this.type,
      {Key? key,
      this.callback,
      this.savingimage,
      this.height,
      this.width,
      this.imagepath,
      this.fromedit,
      required this.fromtemplateprint,
      required this.frompaket,
      this.frompakettab})
      : super(key: key);
  final StringCallback? callback;
  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(
        this.type,
      );
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;
  List<int>? _selectedFile;
  String namefile = '';
  callbackTitle(outletname) {
    // ignore: avoid_print
    print(outletname);
    Createproduct.of(context)!.string = outletname;
  }

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    hosts = ClassApi();
    imagePicker = ImagePicker();
    if (widget.savingimage != null) {
      _image = File(widget.savingimage);
    }
    print(widget.fromedit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // color: Colors.blue,
                width: widget.width,
                height: widget.height,
                // decoration: BoxDecoration(color: Colors.red[200]),
                child: widget.imagepath != null
                    ? Container(
                        width: widget.width,
                        height: widget.height,
                        child: Image.file(File(_image.path)),
                        // child: Image.network(
                          
                        //   widget.imagepath!,
                        //   isAntiAlias: true,
                        //   fit: BoxFit.fill,
                        //   filterQuality: FilterQuality.high,
                        //   errorBuilder: (BuildContext context, Object exception,
                        //       StackTrace? stackTrace) {
                        //         print(stackTrace);
                        //     return Image.network(
                        //       'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930',
                        //       fit: BoxFit.fill,
                        //     );
                        //   },
                        //   loadingBuilder: (BuildContext context, Widget child,
                        //       ImageChunkEvent? loadingProgress) {
                        //     if (loadingProgress == null) return child;
                        //     return Center(
                        //       child: CircularProgressIndicator(
                        //         value: loadingProgress.expectedTotalBytes !=
                        //                 null
                        //             ? loadingProgress.cumulativeBytesLoaded /
                        //                 loadingProgress.expectedTotalBytes!
                        //             : null,
                        //       ),
                        //     );
                        //   },
                        // ),
                      )
                    : Container(
                        // decoration: BoxDecoration(color: Colors.grey[200]),
                        width: widget.width,
                        height: widget.height,
                        child: Icon(
                          Icons.image,
                          // color: Colors.grey[800],
                          size: 50,
                        ),
                      ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var source = type == ImageSourceType.camera
                        ? ImageSource.camera
                        : ImageSource.gallery;
                    XFile image = await imagePicker.pickImage(
                        source: source,
                        imageQuality: 50,
                        preferredCameraDevice: CameraDevice.front);

                    setState(() {
                      _image = File(image.path);
                      print('ini imagepath ${image.path}');
                    });
                    namefile = image.name;
                    _selectedFile = await image.readAsBytes();
                    // print(_selectedFile);
                    await hosts!
                        .uploadFiles(_selectedFile, namefile)
                        .whenComplete(() {
                      widget.imagepath = '$api/getfile/$namefile';
                      // Editproduct.of(context)!.string =
                      //     '$api/getfile/$namefile';
                      // print('ini url barang : $api/getfile/$namefile');
                      setState(() {});
                    }).whenComplete(() {

                    if (widget.fromedit == true) {
                      Editproduct.of(context)!.string =
                          '$api/getfile/$namefile';
                    } else if (widget.fromtemplateprint == true) {
                      TemplatePrinter.of(context)!.string =
                          '$api/getfile/$namefile';
                    } else if (widget.frompaket == true) {
                      BuatPaketMobile.of(context)!.string =
                          '$api/getfile/$namefile';
                    } else if (widget.frompakettab == true) {
                      BuatPaketTab.of(context)!.string =
                          '$api/getfile/$namefile';
                    } else {
                      Createproduct.of(context)!.string =
                          '$api/getfile/$namefile';
                    }
                    });

                  },
                  child: Text('Pilih Foto'))
            ],
          )
        ],
      ),
    );
  }
}
