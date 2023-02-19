import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

// var api = 'http://192.168.88.24:3000';
var api = 'http://192.168.1.16:3000';
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

  static Future<dynamic> insertOutlet(Outlet data) async {
    var body = {
      "dbname": data.outletcd.toString(),
      "outletcd": data.outletcd.toString(),
      "outletdesc": data.outletname.toString(),
      "profile": data.profile,
      "telp": data.telp.toString(),
      "alamat": data.alamat.toString(),
      "kodepos": data.kodepos.toString(),
      "slstp": '0',
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/addoutlet');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> insertCategory(Ctg data, String dbname) async {
    var body = {"dbname": dbname, "ctgcd": data.ctgcd, "ctgdesc": data.ctgdesc};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/category');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> insertOutletUser(String data) async {
    var body = {
      "dbname": data,
      "usercode": usercd,
      "outletcd": data,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/addoutletuser');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> insertTranstype(List<List> data, String dbname) async {
    // print(json.encode(pembayaran));
    var body = {
      "dbname": dbname,
      "data": data,
    };
    final url = Uri.parse('$api/addtrtpcd');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> insertProduct(Item data, String dbname) async {
    var body = {
      "dbname": dbname,
      "data": data,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/additem');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> insertPosDetail(
      IafjrndtClass data, String dbname) async {
    var body = {
      "dbname": dbname,
      "data": [
        [
          data.trdt,
          data.pscd,
          data.transno,
          data.transno1,
          data.itemseq,
          data.itemcode,
          data.itemdesc,
          data.description,
          data.qty,
          data.rvncoa,
          data.taxcoa,
          data.servicecoa,
          'othercoa',
          data.rateamtitem,
          data.rateamtservice,
          data.rateamttax,
          data.revenueamt,
          data.serviceamt,
          data.taxamt,
          0,
          data.discpct,
          data.discamt,
          data.totalaftdisc,
          data.transno,
          data.active
        ]
      ]
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertdetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);
      // IafjrndtClass data = status;
      print(status);
      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateProduct(Item data, String dbname) async {
    var body = {
      "dbname": dbname,
      "data": data,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateitem');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> updatePosDetail(
      IafjrndtClass data, String dbname) async {
    var body = {"dbname": dbname, "data": data};
    print(body);
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updatePosDetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> deactivePosdetail(int id, String dbname) async {
    var body = {"dbname": dbname, "data": id};
    print(body);
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactiveposdetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> deleteCTG(String dbname, int id) async {
    var body = {
      "dbname": dbname,
      "id": id,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/delctg');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<dynamic> deleteItem(String dbname, int id) async {
    var body = {
      "dbname": dbname,
      "id": id,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/delitem');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
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

  static Future<List<dynamic>> getOutlets(String usercd) async {
    // print(json.encode(pembayaran));
    var data = {"usercd": usercd};
    final url = Uri.parse('$api/outlet_user');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<Ctg>> getCTG(String dbname) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/getctg');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      List<Ctg> data = bodyJson.map((json) => Ctg.fromJson(json)).toList();
      return data;
    } else {
      throw Exception();
    }
  }

  static Future<List<Item>> getItemList(
      String pscd, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "data": pscd};
    final url = Uri.parse('$api/getitem');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => Item.fromJson(json)).where((items) {
        final itemdescLower = items.itemdesc!.toLowerCase();
        final itemcodes = items.itemcode!.toLowerCase();
        final searchLower = query.toLowerCase();

        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
      // List<Item> data = bodyJson.map((json) => Item.fromJson(json)).toList();
      // return data;
    } else {
      throw Exception();
    }
  }

  static Future<List<IafjrndtClass>> getTrnoDetail(
      String trno, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "data": trno};
    final url = Uri.parse('$api/detailtrno');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson
          .map((json) => IafjrndtClass.fromJson(json))
          .where((items) {
        final itemdescLower = items.transno!.toLowerCase();
        final itemcodes = items.itemcode!.toLowerCase();
        final searchLower = query.toLowerCase();

        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<IafjrndtClass>> getSumTrans(
      String trno, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "data": trno};
    final url = Uri.parse('$api/sumtrans');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson
          .map((json) => IafjrndtClass.fromJson(json))
          .where((items) {
        final itemdescLower = items.transno!.toLowerCase();

        final searchLower = query.toLowerCase();

        return itemdescLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
