import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/tokoonline.dart/settingitemonline.dart';
import 'package:posq/userinfo.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class TokoOnlineMain extends StatefulWidget {
  const TokoOnlineMain({Key? key}) : super(key: key);

  @override
  State<TokoOnlineMain> createState() => _TokoOnlineMainState();
}

class _TokoOnlineMainState extends State<TokoOnlineMain> {
// Create a json web token
// Pass the payload to be sent in the form of a map
  final jwt = JWT({"outlet": dbname, "outletdesc": outletdesc});
  var token;

  @override
  void initState() {
    super.initState();
    token = jwt.sign(SecretKey('@Mitro100689'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting toko online'),
      ),
      body: ListView(children: [
        ListTile(
          title: Text('Dapatkan alamat toko online'),
          subtitle: Text(
              'Bagikan alamat toko online anda ke pelanggan untuk memesan sendiri'),
          trailing: IconButton(
            icon: Icon(Icons.copy),
            iconSize: 20,
            color: Colors.green,
            splashColor: Colors.purple,
            onPressed: () {
              Clipboard.setData(
                  ClipboardData(text: 'https://aovionline.web.app/?id=$token'));
              Fluttertoast.showToast(
                  msg: "Alamat web tersalin",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromARGB(255, 11, 12, 14),
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return ItemOnlineSetting();
            }));
          },
          title: Text('Setting menu online'),
          subtitle: Text('Setting menu / item yg akan dijual di online'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          onTap: () {
            Fluttertoast.showToast(
                msg: "Segera hadir",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 11, 12, 14),
                textColor: Colors.white,
                fontSize: 16.0);
          },
          title: Text('Setting Banner promosi'),
          subtitle: Text('Setting untuk banner yg tertampil di toko online'),
          trailing: Icon(Icons.arrow_forward_ios),
        )
      ]),
    );
  }
}
