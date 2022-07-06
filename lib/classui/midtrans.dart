// ignore_for_file: avoid_print, unused_import

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posq/model.dart';

var api = 'https://api.sandbox.midtrans.com/v2/charge';
var serverkeymidtrans = '';
var basicAuth = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));

class PaymentGate {
  static Future<dynamic> getStatusTransaction(String trno) async {
    final url = Uri.parse('https://api.sandbox.midtrans.com/v2/$trno/status');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      var status = json.decode(response.body);
      return status['transaction_status'];
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> goPayQris(
      String method,
      String guestname,
      String email,
      String phone,
      String trno,
      String totalamount,
      List<Midtransitem> data) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));
    var body = {
      "payment_type": "gopay",
      "transaction_details": {"order_id": trno, "gross_amount": totalamount},
      "item_details": data,
      "customer_details": {
        "first_name": guestname,
        "last_name": "",
        "email": email,
        "phone": phone
      },
      "gopay": {"enable_callback": false, "callback_url": "someapps://callback"}
    };

    final url = Uri.parse(
      api,
    );
    final response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'authorization': basicAuth
            },
            body: json.encode(body))
        .timeout(
          const Duration(seconds: 100),
        );

    if (response.statusCode == 200) {
      final rooms = json.decode(response.body);
      print(rooms);
      return rooms;
    } else {
      return response;
    }
  }

  static Future<dynamic> bankTransfer(
      String guestname,
      String bank,
      String phone,
      String email,
      String trno,
      String totalamount,
      List<Midtransitem> data) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));
    var body = {
      "payment_type": "bank_transfer",
      "transaction_details": {"gross_amount": totalamount, "order_id": trno},
      "customer_details": {
        "email": email,
        "first_name": guestname,
        "last_name": '',
        "phone": phone,
      },
      "item_details": data,
      "bank_transfer": {
        "bank": bank,
        "va_number": "12345678901",
        "free_text": {
          "inquiry": [
            {
              "id": "Your Custom Text in ID language",
              "en": "Your Custom Text in EN language"
            }
          ],
          "payment": [
            {
              "id": "Your Custom Text in ID language",
              "en": "Your Custom Text in EN language"
            }
          ]
        }
      }
    };

    final url = Uri.parse(
      api,
    );
    final response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'authorization': basicAuth
            },
            body: json.encode(body))
        .timeout(
          const Duration(seconds: 100),
        );

    if (response.statusCode == 200) {
      final rooms = json.decode(response.body);
      // print(rooms['va_numbers']);
      return rooms;
    }
  }

  static Future<dynamic> mandiribillers(
      String guestname,
      String phone,
      String email,
      String trno,
      String totalamount,
      List<Midtransitem> data) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));
    var body = {
      "payment_type": "echannel",
      "transaction_details": {"gross_amount": totalamount, "order_id": trno},
      "customer_details": {
        "email": email,
        "first_name": guestname,
        "last_name": "",
        "phone": phone
      },
      "item_details": data,
      "echannel": {"bill_info1": "Payment For:", "bill_info2": "Food"}
    };

    final url = Uri.parse(
      api,
    );
    final response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'authorization': basicAuth
            },
            body: json.encode(body))
        .timeout(
          const Duration(seconds: 100),
        );

    if (response.statusCode == 200) {
      final rooms = json.decode(response.body);
      // print(rooms['va_numbers']);
      return rooms;
    }
  }

  static Future<dynamic> getvaPermata(String guestname, String email,
      String phone, String trno, List<Midtransitem> data,String amount) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));
    var body = jsonEncode({
      "payment_type": "bank_transfer",
      "bank_transfer": {"bank": "permata", "va_number": "1234567890"},
      "transaction_details": {"order_id": trno, "gross_amount": amount},
      "customer_details": {
        "email": email,
        "first_name": guestname,
        "last_name": '',
        "phone": phone
      },
      "item_details": data,
    });

    final url = Uri.parse(
      api,
    );
    final response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'authorization': basicAuth
            },
            body: utf8.encode(body))
        .timeout(
          const Duration(seconds: 100),
        );
    print(body);
    if (response.statusCode == 200) {
      final rooms = json.decode(response.body);
      // print(rooms['va_numbers']);
      return rooms;
    }
  }
}
