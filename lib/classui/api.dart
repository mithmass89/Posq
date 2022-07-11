import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posq/model.dart';

var api = 'http://emeraldsystem.id:9000';
var serverkey = '';
String username = 'massmith';
String password = 'massmith';
var basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

class ClassApi {
  static Future<dynamic> sendMail(
      List<PaymentEmail> pembayaran,
      List<ItemMail> item,
      String date,
      String outlet,
      String trno,
      num total,
      String emailto) async {
    var body = {
      "nomor": trno,
      "emailto": emailto,
      "tanggal": date,
      "outlet": outlet,
      "alamat": "",
      "pembayaran": pembayaran,
      "barang": item,
      "total": total
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/sendmail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);
      print(status);
      return status;
    } else {
      throw Exception();
    }
  }
}
