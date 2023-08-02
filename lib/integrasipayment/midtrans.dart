// ignore_for_file: avoid_print, unused_import

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posq/model.dart';

var apisnap = 'https://app.midtrans.com/snap/v1/transactions';
var api = 'https://api.midtrans.com/v2/charge';
var serverkeymidtrans = '';
var basicAuth = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));

class PaymentGate {
  static Future<dynamic> getStatusTransaction(String trno) async {
    final url = Uri.parse('https://api.midtrans.com/v2/$trno/status');
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
      // pembayaran GOPAY / QRIS
      String method,
      String guestname,
      String email,
      String phone,
      String trno,
      String totalamount,
      List<Midtransitem> data) async {
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode(
            '$serverkeymidtrans')); // server key uniqe perclient dari , di berikan ketika client daftar di midtrans
    var body = {
      "payment_type":
          "qris", // wajib di set gopay , tapi nantinya bisa di pakai di semua e-wallet dengan starndart QRIS
      "transaction_details": {
        "order_id": trno,
        "gross_amount": totalamount
      }, //trno bisa menyesuaikan dengan transaksi punya kita , dan total amount harus sesuai dengan total amount di list item
      "item_details": data,

      /// tipe data list //
      "customer_details": {
        "first_name": guestname,
        "last_name": "",
        "email": email, //bill akan di kirim email
        "phone": phone
      },
      "qris": {
        "acquirer": "gopay"
      } // jika memakai webhoook eneable callback yes
    };

    final url = Uri.parse(
      api,
    );
    print(json.encode(body));
    final response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'authorization': basicAuth // menggunakan auth tipe basic//
            },
            body: json.encode(body))
        .timeout(
          const Duration(seconds: 100),
        );
    print(api);
    if (response.statusCode == 200) {
      final _responsemidtrans = json.decode(response.body);
      print(response);
      return _responsemidtrans;
    } else {
      print(json.decode(response.body));
      return response;
    }
  }

  static Future<dynamic> snapWeb(
    // pembayaran GOPAY / QRIS
    // String method,

    String trno,
    String totalamount,
  ) async {
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode(
            '$serverkeymidtrans')); // server key uniqe perclient dari , di berikan ketika client daftar di midtrans
    var body = {
      "transaction_details": {"order_id": "$trno", "gross_amount": totalamount},

      "enabled_payments": ["gopay"],
      "credit_card": {
        "secure": true,
        "bank": "bca",
        "installment": {
          "required": false,
          "terms": {
            "bni": [3, 6, 12],
            "mandiri": [3, 6, 12],
            "cimb": [3],
            "bca": [3, 6, 12],
            "offline": [6, 12]
          }
        },
        "whitelist_bins": ["48111111", "41111111"]
      },
      "callbacks": {"finish": "https://demo.midtrans.com"},
      "expiry": {
        // "start_time": "2019-12-13 18:11:08 +0700",
        // "unit": "minutes",
        // "duration": 1
      },
      "custom_field1": "custom field 1 content",
      "custom_field2": "custom field 2 content",
      "custom_field3": "custom field 3 content"
    };

    final url = Uri.parse(
      apisnap,
    );
    final response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'authorization': basicAuth // menggunakan auth tipe basic//
            },
            body: json.encode(body))
        .timeout(
          const Duration(seconds: 100),
        );
    print(apisnap);

    print(response.statusCode);
    if (response.statusCode == 200) {
      final _responsemidtrans = json.decode(response.body);
      print(_responsemidtrans);
      return _responsemidtrans;
    } else {
      final _responsemidtrans = json.decode(response.body);
      print(_responsemidtrans);
      return _responsemidtrans;
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
      String phone, String trno, List<Midtransitem> data, String amount) async {
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

  static Future<dynamic> SnapLink(String trno, String amount) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));
    var body = jsonEncode({
      "transaction_details": {"order_id": "$trno", "gross_amount": amount},
      "enabled_payments": ["gopay"],
      "credit_card": {
        "secure": true,
        "bank": "bca",
        "installment": {
          "required": false,
          "terms": {
            "bni": [3, 6, 12],
            "mandiri": [3, 6, 12],
            "cimb": [3],
            "bca": [3, 6, 12],
            "offline": [6, 12]
          }
        },
        "whitelist_bins": ["48111111", "41111111"]
      },

      "callbacks": {"finish": "https://demo.midtrans.com"},
      "expiry": {
        // "start_time": "2019-12-13 18:11:08 +0700",
        // "unit": "minutes",
        // "duration": 1
      },
      "custom_field1": "custom field 1 content",
      "custom_field2": "custom field 2 content",
      "custom_field3": "custom field 3 content"
    });

    final url = Uri.parse(
      apisnap,
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
    print(apisnap);
    if (response.statusCode == 200) {
      final rooms = json.decode(response.body);
      // print(rooms['va_numbers']);
      print(rooms);
      return rooms;
    }
  }
}
