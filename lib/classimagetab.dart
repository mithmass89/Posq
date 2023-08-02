// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_this, must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/menu.dart';
import 'setting/product_master/tabletclass/classeditproducttab.dart';
import 'setting/product_master/tabletclass/createproducttab.dart';

ClassApi? host;

class ImageFromGalleryExTab extends StatefulWidget {
  final type;
  final savingimage;
  final double? height;
  final double? width;
  final bool? fromedit;
  late String imagepath;
  ImageFromGalleryExTab(this.type,
      {Key? key,
      this.callback,
      this.savingimage,
      this.height,
      this.width,
      this.fromedit,
      required this.imagepath})
      : super(key: key);
  final StringCallback? callback;
  @override
  ImageFromGalleryExTabState createState() => ImageFromGalleryExTabState(
        this.type,
      );
}

class ImageFromGalleryExTabState extends State<ImageFromGalleryExTab> {
  var imagePicker;
  var type;
  List<int>? _selectedFile;
  String namefile = '';
  ImageFromGalleryExTabState(type);
  callbackTitle(outletname) {
    // ignore: avoid_print
    print(outletname);
    Createproducttab.of(context)!.string = outletname;
  }

  String urlpic = '';
  var _image;
  @override
  void initState() {
    super.initState();
    host = ClassApi();
    print(widget.imagepath);
    imagePicker = ImagePicker();
    if (widget.savingimage != null) {}
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
                width: widget.width,
                height: widget.height,
                // decoration: BoxDecoration(color: Colors.red[200]),
                child: widget.imagepath != '' && _image!=null
                    ? Image.file(File(_image.path)) // ? Image.network(
                    //     widget.imagepath,
                    //     fit: BoxFit.fill,
                    //          filterQuality: FilterQuality.low,
                    //       errorBuilder: (BuildContext context, Object exception,
                    //           StackTrace? stackTrace) {
                    //         return Image.network(
                    //           'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930',
                    //           fit: BoxFit.fill,
                    //         );
                    //       },
                    //     loadingBuilder: (BuildContext context, Widget child,
                    //         ImageChunkEvent? loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return Center(
                    //         child: CircularProgressIndicator(
                    //           value: loadingProgress.expectedTotalBytes != null
                    //               ? loadingProgress.cumulativeBytesLoaded /
                    //                   loadingProgress.expectedTotalBytes!
                    //               : null,
                    //         ),
                    //       );
                    //     },
                    //   )
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
                    print('ini imagepath ${image.path}');
                    setState(() {
                      _image = File(image.path);
                      print('ini imagepath ${image.path}');
                    });
                    namefile = image.name;
                    _selectedFile = await image.readAsBytes();
                    print(_selectedFile);
                    await host!
                        .uploadFiles(_selectedFile, namefile)
                        .whenComplete(() {
                      widget.imagepath = '$api/getfile/$namefile';
                      EditproductTab.of(context)!.string =
                          '$api/getfile/$namefile';
                      print('ini url barang : $api/getfile/$namefile');
                      setState(() {});
                    });
                    if (widget.fromedit == true) {
                      EditproductTab.of(context)!.string =
                          '$api/getfile/$namefile';
                      // await host!.uploadFiles(_selectedFile, namefile);
                    } else {
                      Createproducttab.of(context)!.string =
                          '$api/getfile/$namefile';
                    }
                    setState(() {});
                  },
                  child: Text('Pilih Foto'))
            ],
          )
        ],
      ),
    );
  }
}
