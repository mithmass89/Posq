// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_this, must_be_immutable
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/setting/printer/templateprinter.dart';
import 'package:posq/setting/product_master/classcreateproduct.dart';
import 'package:posq/menu.dart';

ClassApi? hosts;

class ImageFromGalleryExPrinter extends StatefulWidget {
  final type;
  final savingimage;
  final double? height;
  final double? width;
  final bool? fromedit;
  late String? imagepath;
  final bool fromtemplateprint;
  ImageFromGalleryExPrinter(this.type,
      {Key? key,
      this.callback,
      this.savingimage,
      this.height,
      this.width,
      this.imagepath,
      this.fromedit,
      required this.fromtemplateprint})
      : super(key: key);
  final StringCallback? callback;
  @override
  ImageFromGalleryExPrinterState createState() =>
      ImageFromGalleryExPrinterState(
        this.type,
      );
}

class ImageFromGalleryExPrinterState extends State<ImageFromGalleryExPrinter> {
  var imagePicker;
  var type;
  String namefile = '';
  callbackTitle(outletname) {
    // ignore: avoid_print
    print(outletname);
    Createproduct.of(context)!.string = outletname;
  }

  ImageFromGalleryExPrinterState(this.type);

  @override
  void initState() {
    super.initState();
    hosts = ClassApi();
    imagePicker = ImagePicker();
    if (widget.savingimage != null) {
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
                        child: Image.network(
                          widget.imagepath!,
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
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
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowMultiple: false,
                      allowedExtensions: ['png'],
                    );

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      List<int> fileBytes = await file.readAsBytes();
                      String fileName = result.files.first.name;
                      print(fileName); // Output: The selected file name
                      // Process the file bytes
                      // ...
                      await hosts!
                          .uploadFilesLogo(fileBytes, fileName)
                          .whenComplete(() {
                        widget.imagepath = '$api/getlogo/$fileName';
                        // Editproduct.of(context)!.string =
                        //     '$api/getfile/$namefile';
                        print('ini url barang : $api/getlogo/$fileName');
                        setState(() {});
                      });

                      TemplatePrinter.of(context)!.string =
                          '$api/getlogo/$fileName';
                    }
                    // var source = type == ImageSourceType.camera
                    //     ? ImageSource.camera
                    //     : ImageSource.gallery;
                    // XFile image = await imagePicker.pickImage(
                    //   source: source,
                    //   imageQuality: 20,
                    //   preferredCameraDevice: CameraDevice.front,
                    // );

                    // namefile = image.name;
                    // _selectedFile = await image.readAsBytes();
                    // img.Image? jpeg = img.decodeImage(_selectedFile!);
                    // if (jpeg != null) {
                    //   // Create a new image in PNG format
                    //   img.Image png = img.copyResize(jpeg,
                    //       width: jpeg.width, height: jpeg.height);
                    //   List<int> pngBytes = img.encodePng(png);

                    // print(namefile);
                    // String pngFileName = namefile.replaceFirst('.jpg', '.png');
                  },
                  child: Text('Pilih Foto'))
            ],
          )
        ],
      ),
    );
  }
}
