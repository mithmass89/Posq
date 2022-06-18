// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_this
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posq/setting/classcreateproduct.dart';
import 'package:posq/menu.dart';

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  final savingimage;
  final double? height;
  final double? width;
  const ImageFromGalleryEx(this.type,
      {Key? key, this.callback, this.savingimage, this.height, this.width})
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
  callbackTitle(outletname) {
    // ignore: avoid_print
    print(outletname);
    Createproduct.of(context)!.string = outletname;
  }

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    if (widget.savingimage != null) {
      _image = File(widget.savingimage);
    }
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
                child: _image != null
                    ? Image.file(
                        _image,
                        width: widget.width,
                        height: widget.height,
                        fit: BoxFit.fill,
                      )
                    : Container(
                        // decoration: BoxDecoration(color: Colors.grey[200]),
                        width: widget.width,
                        height: widget.height,
                        child: Icon(
                          Icons.picture_in_picture,
                          // color: Colors.grey[800],
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

                      Createproduct.of(context)!.string =
                          image.path.toString();
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
