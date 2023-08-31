import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

// var api = 'http://192.168.88.14:3000';
var ip = '192.168.1.11';
var api = 'http://$ip:3000';
var apiimage = 'http://$ip:5000';
var apiemail = 'http://$ip:4000';
// var api = 'http://147.139.163.18:3000';
var apiuploadPDF = 'http://digims.online:5005';
var serverkey = '';
String username = 'mitro';
String password = '@Mitro100689';
String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
var basicAuthMID = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));

class ClassApi {
  Future<Uint8List> fetchImage(String name) async {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    final response =
        await http.get(Uri.parse('http://$api:3000/getfile/$name'), headers: {
      'authorization': 'Basic $credentials',
    });
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<dynamic> uploadFiles(selectedFile, String namefile) async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    var url = Uri.parse("$apiimage/upload_files");
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'authorization': basicAuth,
    });
    request.files.add(
        http.MultipartFile.fromBytes("file", selectedFile, filename: namefile));

    request.send().then((response) {
      if (response.statusCode == 200) {
        print(response.request);
        return 'upload complate';
      }
      print('status code: ${response.statusCode}');
    });
  }

  Future<dynamic> uploadFilesLogo(selectedFile, String namefile) async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    var url = Uri.parse("$apiimage/uploadlogo");
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'authorization': basicAuth,
    });
    request.files.add(
        http.MultipartFile.fromBytes("file", selectedFile, filename: namefile));

    request.send().then((response) {
      if (response.statusCode == 200) {
        print(response.request);
        return 'upload complate';
      }
      print('status code: ${response.statusCode}');
    });
  }

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

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertItemFromHO() async {
    var body = {
      "dbname": dbname,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertItemFromHO');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertAccessToUser(
      String? usercode,
      String? rolecode,
      String? roledesc,
      String? accesscode,
      String? accessdesc,
      String? outlet,
      String? subscription) async {
    var body = {
      "usercode": usercode,
      "rolecode": rolecode.toString(),
      "roledesc": roledesc.toString(),
      "accesscode": accesscode,
      "accessdesc": accessdesc,
      "outlet": outlet,
      "subscription": subscription,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertAccessToUser');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertPromo(Promo data, String dbname) async {
    var body = {
      "dbname": dbname,
      "promocd": data.promocd,
      "promodesc": data.promodesc,
      "type": data.type,
      "pct": data.pct,
      "amount": data.amount,
      "mindisc": data.mindisc,
      "maxdisc": data.maxdisc,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertpromo');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertOpenCashier(
      OpenCashier data, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": data.trdt,
      "type": data.type,
      "amount": data.amount,
      "usercd": data.usercd,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertOpenCashier');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<List<OpenCashier>> checkOpen_cashier(
      String trdt, String usercd, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": trdt,
      "usercd": usercd,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/checkOpen_cashier');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);
      print(status);
      return status.map((json) => OpenCashier.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<OpenCashier>> checkCloseCashier(
      String trdt, String usercd, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": trdt,
      "usercd": usercd,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/checkCloseCashier');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);
      print(status);
      return status.map((json) => OpenCashier.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> getDetail_transaksiCashier(
      String trdt, String usercd, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": trdt,
      "usercd": usercd,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/getDetail_transaksiCashier');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);
      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> cancelClosing(
      String trdt, String usercd, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": trdt,
      "usercd": usercd,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/cancelClosing');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);
      return status;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> totalpengeluaranCashier(
      String trdt, String usercd, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": trdt,
      "usercd": usercd,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/totalpengeluaranCashier');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);
      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> getDetail_transaksiCashierSummary(
      String trdt, String usercd, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": trdt,
      "usercd": usercd,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/getDetail_transaksiCashierSummary');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);
      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> resetPassword(String email) async {
    Map<String, String> body = {
      "email": email,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$apiemail/reset-password');
    final response = await http.post(url,
        headers: <String, String>{
          // 'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body);

    if (response.statusCode == 200) {
      var status = response.body;

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertRegisterUser(
    String email,
    String usercd,
    String password,
    String level,
    String subscription,
    String paymentcheck,
    String frenchisecode,
  ) async {
    var body = {
      "email": email,
      "usercd": usercd,
      "password": password,
      "level": level,
      "subscription": subscription,
      "paymentcheck": paymentcheck,
      "frenchisecode": frenchisecode
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertRegisterUser');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertRegisterUserNew(
      String email,
      String usercd,
      String password,
      String level,
      String frenchisecode,
      String referral,
      String telp) async {
    var body = {
      "email": email,
      "usercd": usercd,
      "password": password,
      "level": level,
      "frenchisecode": frenchisecode,
      "referral": referral,
      "telp": telp,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertRegisterUserNew');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertRegisterCustomer(
    String customercd,
    String fullname,
    String title,
    String phone,
    String email,
    String workkom,
    String address,
    String points,
    String memberfrom,
  ) async {
    var body = {
      "dbname": dbname,
      "customercd": customercd,
      "fullname": fullname,
      "title": title,
      "phone": phone,
      "email": email,
      "workkom": workkom,
      "address": address,
      "points": points,
      "memberfrom": memberfrom,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertRegisterCustomer');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertLoyalityProgram(
    String loyalitycd,
    String loyaltiydesc,
    String fromdate,
    String todate,
    String type,
    num convamount,
    num point,
    num minimumamount,
    int useminimum,
    num joinreward,
  ) async {
    var body = {
      "dbname": dbname,
      "loyalitycd": loyalitycd,
      "loyaltiydesc": loyaltiydesc,
      "fromdate": fromdate,
      "todate": todate,
      "type": type,
      "convamount": convamount,
      "point": point,
      "minimumamount": minimumamount,
      "joinreward": joinreward,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertLoyalityProgram');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertAbsensi(
    String date,
    String email,
    String type,
    String actiontime,
    bool hasbeencheck,
  ) async {
    var body = {
      "dbname": dbname,
      "date": date,
      "email": email,
      "type": type,
      "actiontime": actiontime,
      "hasbeencheck": hasbeencheck,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertAbsensi');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertAccessCodeStrict(
    String usercode,
    String accesscode,
  ) async {
    var body = {
      "dbname": dbname,
      "usercode": usercode,
      "accesscode": accesscode,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertAccessCodeStrict');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertRewardSetting(
      String loyalitycd,
      String rewaradtype,
      num redempoint,
      num reward,
      String note,
      int useminimum,
      num minimumamount) async {
    var body = {
      "dbname": dbname,
      "loyalitycd": loyalitycd,
      "rewaradtype": rewaradtype,
      "redempoint": redempoint,
      "reward": reward,
      "note": note,
      "useminimum": useminimum,
      "minimumamount": minimumamount
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertRewardSetting');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

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

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertCondiment_Master(
      String dbname, List<Condiment> condiment) async {
    var body = {"dbname": dbname, "data": condiment};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertCondimentMaster');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insert_TransactionType(
      String dbname, List<TransactionTipe> transaksi) async {
    var body = {"dbname": dbname, "data": transaksi};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insert_transactiontype');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertTableMaster(
      String dbname, List<TableMaster> table) async {
    var body = {"dbname": dbname, "data": table};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertTableMaster');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> createPackageMenu(
      String dbname, List<Package> paket) async {
    var body = {"dbname": dbname, "data": paket};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/createPackageMenu');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insert_Poscondiment(
      String dbname, List<PosCondiment> condiment) async {
    var body = {"dbname": dbname, "data": condiment};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertPosCondiment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertAdujsmentStock(
      String dbname, List<TransaksiBO> condiment) async {
    var body = {"dbname": dbname, "data": condiment};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertAdujsmentStock');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertAccessUser(
      List<AccessPegawai> accesslist) async {
    var body = {"data": accesslist};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertAccessUser');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertAccessOutletUser(String usercode) async {
    var body = {"usercode": usercode};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertAccessOutletUser');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertCondiment_Map(
      String dbname, List<Condiment_Map> condiment) async {
    var body = {"dbname": dbname, "data": condiment};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertMapping');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertMapCondiment(
      String ctgcd, String itemcode, String dbname) async {
    var body = {"dbname": dbname, "ctgcd": ctgcd, "itemcode": itemcode};
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertMapping');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertOutletUser(String usercode, String pscd) async {
    var body = {"outletcode": pscd, "usercode": usercode};
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

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> createCompany(
      PaymentMaster data, String dbname) async {
    // print(json.encode(pembayaran));
    var body = {
      "dbname": dbname,
      "data": data,
    };
    final url = Uri.parse('$api/createCompany');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertAccessOutlet(
      String outletcode, String usercode) async {
    // print(json.encode(pembayaran));
    var body = {
      "outletcode": outletcode,
      "usercode": usercode,
    };
    print(body);
    final url = Uri.parse('$api/insertAccessOutlet');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

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
          data.active,
          data.usercrt,
          data.createdt,
          data.guestname,
          data.totalcost,
          data.ratecostamt
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

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertPosPayment(
      IafjrnhdClass data, String dbname) async {
    var body = {
      "dbname": dbname,
      "data": [
        [
          data.trdt,
          data.pscd,
          data.transno,
          data.transno,
          data.split,
          data.docno,
          data.trdesc,
          data.guestname,
          data.guestphone,
          data.email,
          data.cardno,
          data.compcd,
          data.compdesc,
          data.pymtmthd,
          'vchno',
          '1',
          data.totalamt,
          data.amtrmn,
          'docdt',
          'notes',
          data.slstp,
          data.virtualaccount,
          data.billerkey,
          data.billercode,
          data.qrcode,
          data.usercrt
        ]
      ]
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertpayment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);
      // IafjrndtClass data = status;

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

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateOnlineItem(
      String itemcode, int onlineflag, String dbname) async {
    var body = {
      "dbname": dbname,
      "itemcode": itemcode,
      "onlineflag": onlineflag,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateOnlineItem');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateUserGmail(
      UserInfoSys data, String dbname) async {
    var body = {
      "dbname": dbname,
      "data": data,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateUserGmail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> passwordreset(
      UserInfoSys password, String email) async {
    var body = {
      "password": password,
      "email": email,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/passwordreset');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateTemplatePrinter(String logourl, String header,
      String footer, int headerbold, int footerbold, String dbname) async {
    var body = {
      "dbname": dbname,
      "logourl": logourl,
      "header": header,
      "footer": footer,
      "headerbold": headerbold,
      "footerbold": footerbold,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateTemplatePrinter');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateCustomers(
      String fullname,
      String tittle,
      String phone,
      String email,
      String address,
      String customercd,
      String dbname) async {
    var body = {
      "dbname": dbname,
      "customercd": customercd,
      "fullname": fullname,
      "tittle": tittle,
      "phone": phone,
      "email": email,
      "address": address,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateCustomers');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updatePointCustomers(
      num points, String fullname) async {
    var body = {
      "dbname": dbname,
      "points": points,
      "fullname": fullname,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updatePointCustomers');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> insertPointguest(num pointconv, String fullname,
      String date, String transno, num totalbill) async {
    var body = {
      "dbname": dbname,
      "pointconv": pointconv,
      "guestname": fullname,
      "date": date,
      "transno": transno,
      "totalbill": totalbill
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/insertPointguest');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> checkUserFromOauth(String email, String dbname) async {
    var body = {
      "dbname": dbname,
      "email": email,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/checkUserFromOauth');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List user = json.decode(response.body);

      return user;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> checkPointCustomer(
      String fullname, String dbname) async {
    var body = {
      "dbname": dbname,
      "fullname": fullname,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/checkPointCustomer');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List user = json.decode(response.body);

      return user;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> getTemplatePrinter() async {
    var body = {
      "dbname": dbname,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/getTemplatePrinter');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List user = json.decode(response.body);

      return user;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> checkPhoneNumber(String phone) async {
    var body = {
      "dbname": dbname,
      "phone": phone,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/checkPhoneNumber');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List user = json.decode(response.body);

      return user;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> checkTypeLoyality() async {
    var body = {
      "dbname": dbname,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/checkTypeLoyality');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List user = json.decode(response.body);

      return user;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> checkProgramExist() async {
    var body = {
      "dbname": dbname,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/checkProgramExist');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List user = json.decode(response.body);

      return user;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> getTodaySales(String date, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": date,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/salestoday');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);

      return status.isNotEmpty
          ? status
          : [
              {'trdt': '2023-01-01'},
              {'totalaftdisc': 0}
            ];
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> getPenjualanRataRata(
      String date, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": date,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/getPenjualanRataRata');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);

      return status.isNotEmpty
          ? status
          : [
              {'trdt': '2023-01-01'},
              {'totalaftdisc': 0}
            ];
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> monthlysales(String date, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": date,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/salesmonthly');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      List status = json.decode(response.body);

      return status.isNotEmpty
          ? status
          : [
              {'trdt': '2023-01-01'},
              {'totalaftdisc': 0}
            ];
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> listdataChart(String date, String dbname) async {
    var body = {
      "dbname": dbname,
      "trdt": date,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/listdatachart');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updatePosDetail(
      IafjrndtClass data, String dbname) async {
    var body = {"dbname": dbname, "data": data};

    // print('ini payload $data');
    final url = Uri.parse('$api/updatePosDetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updatePromo(Promo data, String dbname) async {
    var body = {"dbname": dbname, "data": data};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updatePromo');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateTrno(String dbname) async {
    var body = {"dbname": dbname};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateTrno');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateSplit(
      String dbname, String transno, int itemseq) async {
    var body = {
      "dbname": dbname,
      "transno": transno,
      "itemseq": itemseq,
    };

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateSplit');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateSplitCondiment(
      String dbname, String transno, int itemseq) async {
    var body = {
      "dbname": dbname,
      "transno": transno,
      "itemseq": itemseq,
    };

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateSplitCondiment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateStrictUser(
      String dbname, String strictuser) async {
    var body = {
      "dbname": dbname,
      "strictuser": strictuser,
    };

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateStrictUser');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateTrnoGuest(
      String dbname, String trno, String guest) async {
    var body = {"dbname": dbname, "transno": trno, "guest": guest};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateTrnoGuest');
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

  static Future<dynamic> updateTablestrno(
      String dbname, String trno, String table) async {
    var body = {"dbname": dbname, "transno": trno, "table": table};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateTablestrno');
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

  static Future<dynamic> updateTables_use(
      String dbname, String transno, String tablecd) async {
    var body = {"dbname": dbname, "transno": transno, "tablecd": tablecd};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateTables_use');
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

  static Future<dynamic> cleartable(String dbname, String transno) async {
    var body = {
      "dbname": dbname,
      "transno": transno,
    };

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/cleartable');
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

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deleteAksesStaff(
      String usercode, int id, String dbname) async {
    var body = {"dbname": dbname, "usercode": usercode, "id": id};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deleteAksesStaff');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

    static Future<dynamic> deleteRewardTrans(
      String transno, String dbname) async {
    var body = {"dbname": dbname, "transno": transno,};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deleteRewardTrans');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> refundTrans(
      String transno, String reason, String dbname) async {
    var body = {"dbname": dbname, "transno": transno, "reason": reason};

    // print(json.encode(pembayaran));getStaff

    final url = Uri.parse('$api/refundTrans');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactiveTable(int id, String dbname) async {
    var body = {"dbname": dbname, "id": id};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactiveTable');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deActivePackageMenu(
      String itemcode, String dbname) async {
    var body = {"dbname": dbname, "itemcode": itemcode};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deActivePackageMenu');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactiveTableAll() async {
    var body = {"dbname": dbname};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactiveTableAll');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactiveTipeTrans(int id, String dbname) async {
    var body = {"dbname": dbname, "data": id};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactiveTipeTrans');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactivePoscondimentByID(
      String transno, String itemseq, String optioncode, String dbname) async {
    var body = {
      "dbname": dbname,
      "transno": transno,
      "itemseq": itemseq,
      "optioncode": optioncode
    };

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactivecondimentbyid');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactivePoscondimentByALL(
      String transno, String itemseq, String dbname) async {
    var body = {
      "dbname": dbname,
      "transno": transno,
      "itemseq": itemseq,
    };

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactiveCondimentByAll');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactivePosdetailtrans(
      String trno, String dbname) async {
    var body = {"dbname": dbname, "data": trno};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactiveposdetailTrans');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactivePosPaymenttrans(
      String trno, String dbname) async {
    var body = {"dbname": dbname, "data": trno};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactivepospaymentTrans');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updateCondimentTrno(
      String transno, String itemseq, String dbname) async {
    var body = {"dbname": dbname, "transno": transno, "itemseq": itemseq};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/updateCondiment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactivePromoTrno(
      String transno, String dbname) async {
    var body = {"dbname": dbname, "transno": transno};

    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactivepromoTrno');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

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

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deactiveCondiment(
      String dbname, String itemcode) async {
    var body = {
      "dbname": dbname,
      "itemcode": itemcode,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/deactivecondiment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deletePayment(String dbname, int id) async {
    var body = {
      "dbname": dbname,
      "id": id,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/delpayment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> deletePromo(String dbname, int id) async {
    var body = {
      "dbname": dbname,
      "id": id,
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/delpromo');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      var status = json.decode(response.body);

      return status;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> getOutlets(String email) async {
    // print(json.encode(pembayaran));
    var data = {"email": email};

    final url = Uri.parse('$api/outlet_user');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> getOutletUserSelected(
      String email, String outletcode) async {
    // print(json.encode(pembayaran));
    var data = {"email": email, "outletcode": outletcode};

    final url = Uri.parse('$api/getOutletUserSelected');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> getListStaffOutlet(String outletcode) async {
    // print(json.encode(pembayaran));
    var data = {"outletcode": outletcode};

    final url = Uri.parse('$api/getListStaffOutlet');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> checkVerifiedPayment(String email) async {
    // print(json.encode(pembayaran));
    var data = {"email": email};

    final url = Uri.parse('$api/checkVerifiedPayment');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> checkExpiredDate(String email) async {
    // print(json.encode(pembayaran));
    var data = {"email": email};

    final url = Uri.parse('$api/checkExpiredDate');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> checkEmailExist(String email) async {
    // print(json.encode(pembayaran));
    var data = {"email": email};

    final url = Uri.parse('$api/checkEmailExist');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> getAccessUser(String usercd) async {
    // print(json.encode(pembayaran));
    var data = {"usercd": usercd};

    final url = Uri.parse('$api/getAccessUser');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> getAccessSettingsUser() async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};

    final url = Uri.parse('$api/getAccessSettingsUser');
    print(url);
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

  static Future<List<dynamic>> getAccessCodevoid(String accesscode) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "accesscode": accesscode};

    final url = Uri.parse('$api/getAccessCodevoid');
    print(url);
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

  static Future<List<dynamic>> getLoyalityProgramActive() async {
    var data = {"dbname": dbname};

    final url = Uri.parse('$api/getLoyalityProgramActive');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List body = json.decode(response.body);
      print(body);
      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<TableMaster>> getTableList(String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/getTableList');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => TableMaster.fromJson(json)).where((items) {
        final itemdescLower = items.tablecd!.toLowerCase();
        final itemcodes = items.tablecd!.toLowerCase();
        final searchLower = query.toLowerCase();
        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<RewardCLass>> getRewardData(String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/getRewardData');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => RewardCLass.fromJson(json)).where((items) {
        // final itemdescLower = items.note!.toLowerCase();
        final itemcodes = items.redempoint!.toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return itemcodes.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<TableMaster>> getTablesNotUse(String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/getTablesNotUse');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => TableMaster.fromJson(json)).where((items) {
        final itemdescLower = items.tablecd!.toLowerCase();
        final itemcodes = items.tablecd!.toLowerCase();
        final searchLower = query.toLowerCase();
        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<PaymentMaster>> getPaymentMaster(String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/getPaymentMaster');
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
          .map((json) => PaymentMaster.fromJson(json))
          .where((items) {
        final itemdescLower = items.paymentdesc!.toLowerCase();
        final itemcodes = items.pic!.toLowerCase();
        final searchLower = query.toLowerCase();
        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> getUserinfofromManual(
      String email, String password) async {
    // print(json.encode(pembayaran));
    var data = {
      "email": email,
      "password": password,
    };

    final url = Uri.parse('$api/getUserinfofromManual');
    print(url);
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return body;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> getSumPyTrno(String transno) async {
    // print(json.encode(pembayaran));
    var data = {"transno": transno, "dbname": dbname};
    final url = Uri.parse('$api/getsumtrnopy');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(' ini body : $body');
      return body;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> checkTrno() async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/checktransno');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      return body;
    } else {
      throw Exception();
    }
  }

  static Future<List<Promo>> getPromoList(String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/promolist');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => Promo.fromJson(json)).where((items) {
        final itemdescLower = items.promodesc!.toLowerCase();
        final itemcodes = items.promocd.toLowerCase();
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

  static Future<List<Condiment>> getCondimentList(
      String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname};
    final url = Uri.parse('$api/condimentlist');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => Condiment.fromJson(json)).where((items) {
        final itemdescLower = items.condimentdesc!.toLowerCase();
        final itemcodes = items.itemcode!.toLowerCase();
        final searchLower = query.toLowerCase();
        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
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
      // print(bodyJson);
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

  static Future<List<StaffAccess>> getAccessStaffOutlet(
      String usercd, String outletcd, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "outletcd": outletcd, "usercd": usercd};
    final url = Uri.parse('$api/getAccessStaffOutlet');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      return bodyJson.map((json) => StaffAccess.fromJson(json)).where((items) {
        final itemdescLower = items.usercd!.toLowerCase();
        final itemcodes = items.accessdesc.toLowerCase();
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

  static Future<List<AksesMain>> getMainAccess(String query) async {
    // print(json.encode(pembayaran));
    var data = {
      "dbname": dbname,
    };
    final url = Uri.parse('$api/getMainAccess');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('ini API : $bodyJson');
      return bodyJson.map((json) => AksesMain.fromJson(json)).where((items) {
        final itemdescLower = items.accessname!.toLowerCase();
        final itemcodes = items.note.toLowerCase();
        final searchLower = query.toLowerCase();

        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<StaffAccess>> getStaff(
      String outletcd, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "outletcd": outletcd};
    final url = Uri.parse('$api/getStaff');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      return bodyJson.map((json) => StaffAccess.fromJson(json)).where((items) {
        final itemdescLower = items.usercd!.toLowerCase();
        final itemcodes = items.accessdesc.toLowerCase();
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

  static Future<List<Item>> checkStock(
      String itemcode, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "itemcode": itemcode};
    final url = Uri.parse('$api/checkStock');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      return bodyJson.map((json) => Item.fromJson(json)).toList();
      // List<Item> data = bodyJson.map((json) => Item.fromJson(json)).toList();
      // return data;
    } else {
      throw Exception();
    }
  }

  static Future<List<Pegawai>> getRoleStaff(String query) async {
    // print(json.encode(pembayaran));

    final url = Uri.parse('$api/getRoleStaff');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      return bodyJson.map((json) => Pegawai.fromJson(json)).where((items) {
        final itemdescLower = items.joblevel.toLowerCase();
        final itemcodes = items.note!.toLowerCase();
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

  static Future<List<dynamic>> getRoleAccessTemplate(
      String jobcode, String query) async {
    // print(json.encode(pembayaran));
    var data = {"jobcd": jobcode};
    final url = Uri.parse('$api/getRoleAccessTemplate');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      return bodyJson;
      // List<Item> data = bodyJson.map((json) => Item.fromJson(json)).toList();
      // return data;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> getAccessUserOutlet(
      String email, String outletcd, String query) async {
    // print(json.encode(pembayaran));
    var data = {"email": email, "outletcd": outletcd};
    final url = Uri.parse('$api/getAccessUserOutlet');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('ini accessuser $bodyJson');
      return bodyJson;
      // List<Item> data = bodyJson.map((json) => Item.fromJson(json)).toList();
      // return data;
    } else {
      throw Exception();
    }
  }

  static Future<List<ListUser>> getListUser(String query) async {
    // print(json.encode(pembayaran));
    var data = {
      "outletcode": pscd,
    };
    final url = Uri.parse('$api/getListUser');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      return bodyJson.map((json) => ListUser.fromJson(json)).where((items) {
        final itemdescLower = items.usercd!.toLowerCase();
        final itemcodes = items.level!.toLowerCase();
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

  static Future<List<Costumers>> getCustomers(String query) async {
    // print(json.encode(pembayaran));
    var data = {
      "dbname": dbname,
    };
    final url = Uri.parse('$api/getCustomers');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => Costumers.fromJson(json)).where((items) {
        final itemdescLower = items.fullname.toLowerCase();
        final itemcodes = items.memberfrom!.toLowerCase();
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

  static Future<List<Package>> getPackageMenu(
      String pscd, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "data": pscd};
    final url = Uri.parse('$api/getPackageMenu');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson.map((json) => Package.fromJson(json)).where((items) {
        final itemdescLower = items.itemcode.toLowerCase();
        final itemcodes = items.packagedesc.toLowerCase();
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

  static Future<List<Item>> getItemByCode(
      String pscd, String dbname, String itemcode, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "outletcd": pscd, "itemcode": itemcode};
    final url = Uri.parse('$api/getitemcode');
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

  static Future<List<Item>> getItemByBarCode(
      String pscd, String dbname, String barcode, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "outletcd": pscd, "barcode": barcode};
    final url = Uri.parse('$api/getitembybarcode');
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

  static Future<List<Condiment>> getItemCondiment(
      String itemcode, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {
      "dbname": dbname,
      "itemcode": itemcode,
    };
    final url = Uri.parse('$api/getCondimentItem');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      return bodyJson.map((json) => Condiment.fromJson(json)).where((items) {
        final itemdescLower = items.condimentdesc!.toLowerCase();
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

  static Future<List<IafjrndtClass>> getRefundTransaksi(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/getRefundTransaksi');
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

  static Future<List<dynamic>> getCashierSummary(
      String fromdate, String todate, String dbname) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/getCashierSummary');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print("ini data json summary $bodyJson");
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> CondimentDetail(
      String fromdate, String todate, String dbname) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/CondimentDetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print("ini data json summary $bodyJson");
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> condimentTransDetail(
      String fromdate, String todate, String dbname, String optiondesc) async {
    // print(json.encode(pembayaran));
    var data = {
      "dbname": dbname,
      "fromdate": fromdate,
      "todate": todate,
      "optiondesc": optiondesc
    };
    final url = Uri.parse('$api/condimentTransDetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print("ini data json summary $bodyJson");
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<List<IafjrnhdClass>> getSummaryCashierDetail(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/getSummaryCashierDetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      return bodyJson
          .map((json) => IafjrnhdClass.fromJson(json))
          .where((items) {
        final itemdescLower = items.transno!.toLowerCase();
        final itemcodes = items.pymtmthd!.toLowerCase();
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
      print('summary $bodyJson');
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

  static Future<List<dynamic>> ClosingCashFlow(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/ClosingCashFlow');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('summary $bodyJson');
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> ClosingCashFlowEsteh(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/ClosingCashFlowEsteh');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('summary $bodyJson');
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> ClosingOtherPayment(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/ClosingOtherPayment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('summary $bodyJson');
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<List<dynamic>> CLosingCondiment(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/CLosingCondiment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('summary $bodyJson');
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<List<IafjrndtClass>> getAnalisaRingkasan(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/getAnalisaRingkasan');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      // print('ringkasan  $bodyJson');
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

  static Future<List<IafjrndtClass>> getAnalisaRingkasanTopitem(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/getAnalisaRingkasanTopitem');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      // print('ringkasan  $bodyJson');
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

  static Future<List<IafjrndtClass>> getReportDetailMenuSold(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/getReportDetailMenuSold');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      // print('ringkasan  $bodyJson');
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

  static Future<List<IafjrnhdClass>> retriveListDetailPayment(
      String transno, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "transno": transno};
    final url = Uri.parse('$api/retriveListDetailPayment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      // print('ringkasan  $bodyJson');
      return bodyJson
          .map((json) => IafjrnhdClass.fromJson(json))
          .where((items) {
        final itemdescLower = items.transno!.toLowerCase();
        final searchLower = query.toLowerCase();
        return itemdescLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<IafjrndtClass>> getReportDetailMenuSoldDetail(
      String fromdate,
      String todate,
      String dbname,
      String itemdesc,
      String query) async {
    // print(json.encode(pembayaran));
    var data = {
      "dbname": dbname,
      "fromdate": fromdate,
      "todate": todate,
      "itemdesc": itemdesc
    };
    final url = Uri.parse('$api/getReportDetailMenuSoldDetail');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      // print('ringkasan  $bodyJson');
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

  static Future<List<IafjrndtClass>> getAnalisaRingkasanItemKuranglaku(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "fromdate": fromdate, "todate": todate};
    final url = Uri.parse('$api/getAnalisaRingkasanItemKuranglaku');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print(bodyJson);
      // print('ringkasan  $bodyJson');
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

  static Future<List<IafjrnhdClass>> getDetailPayment(
      String transno1, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "transno1": transno1};
    final url = Uri.parse('$api/detailpayment');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('punya body ${bodyJson}');
      return bodyJson.map((json) => IafjrnhdClass.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  //proses edit condiment//
  static Future<List<PosCondiment>> getDetailCondimentTrno(String transno,
      String itemcode, String itemseq, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {
      "dbname": dbname,
      "transno": transno,
      "itemcode": itemcode,
      "itemseq": itemseq
    };
    final url = Uri.parse('$api/getDetailCondimentTrno');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      return bodyJson.map((json) => PosCondiment.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  // static Future<List<IafjrnhdClass>> getCashierSummary(
  //     String trdt, String pscd, String dbname, String query) async {
  //   // print(json.encode(pembayaran));
  //   var data = {"dbname": dbname, "trdt": trdt, "pscd": pscd};
  //   final url = Uri.parse('$api/getcashiersummary');
  //   final response = await http.post(url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         // 'authorization': basicAuth
  //       },
  //       body: json.encode(data));

  //   if (response.statusCode == 200) {
  //     List bodyJson = json.decode(response.body);
  //     print(bodyJson);
  //     return bodyJson
  //         .map((json) => IafjrnhdClass.fromJson(json))
  //         .where((items) {
  //       final itemdescLower = items.transno!.toLowerCase();
  //       final itemcodes = items.pymtmthd!.toLowerCase();
  //       final searchLower = query.toLowerCase();
  //       return itemdescLower.contains(searchLower) ||
  //           itemcodes.contains(searchLower);
  //     }).toList();
  //   } else {
  //     throw Exception();
  //   }
  // }

  static Future<List<TransactionTipe>> getTransactionTipe(
      String pscd, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "pscd": pscd};
    final url = Uri.parse('$api/gettransaksiTipe');
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
          .map((json) => TransactionTipe.fromJson(json))
          .where((items) {
        final itemdescLower = items.transdesc!.toLowerCase();
        final itemcodes = items.transtype!.toLowerCase();
        final searchLower = query.toLowerCase();
        return itemdescLower.contains(searchLower) ||
            itemcodes.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<IafjrndtClass>> getOutstandingBill(
      String trno, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "data": trno};
    final url = Uri.parse('$api/outstandingBill');
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

  static Future<List<IafjrndtClass>> getOutstandingBillTransno(
      String transno, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "transno": transno};
    final url = Uri.parse('$api/getOutstandingBillTransno');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print('value : checkoutstanding : $bodyJson');
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

  static Future<dynamic> updatePaymentFirst(String subsrcription,
      String pytransaction, String paymentcheck, String email) async {
    // print(json.encode(pembayaran));
    var data = {
      "subsrcription": subsrcription,
      "pytransaction": pytransaction,
      "paymentcheck": paymentcheck,
      "email": email,
    };
    final url = Uri.parse('$api/updatePaymentFirst');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> Update7DayActive(
      String date, String email, String referral, String telp) async {
    // print(json.encode(pembayaran));
    var data = {
      "date": date,
      "email": email,
      "referral": referral,
      "telp": telp
    };
    final url = Uri.parse('$api/Update7DayActive');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<List<CombineDataRingkasan>> getReportRingkasan(
      String fromdate, String todate, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"fromdate": fromdate, "todate": todate, "dbname": dbname};
    final url = Uri.parse('$api/getReportRingkasan');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      // print('value : checkoutstanding : $bodyJson');
      return bodyJson
          .map((json) => CombineDataRingkasan.fromJson(json))
          .where((items) {
        final itemdescLower = items.revenuegross.toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return itemdescLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> DetailMenuItemTerjual(
      String fromdate, String todate, String dbname) async {
    // print(json.encode(pembayaran));
    var data = {
      "fromdate": fromdate,
      "todate": todate,
      "dbname": dbname,
    };
    final url = Uri.parse('$api/DetailMenuItemTerjual');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> DetailMenuWithSize(
      String fromdate, String todate, String dbname) async {
    // print(json.encode(pembayaran));
    var data = {
      "fromdate": fromdate,
      "todate": todate,
      "dbname": dbname,
    };
    final url = Uri.parse('$api/DetailMenuWithSize');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> grossMargin(
      String fromdate, String todate, String dbname) async {
    // print(json.encode(pembayaran));
    var data = {
      "fromdate": fromdate,
      "todate": todate,
      "dbname": dbname,
    };
    final url = Uri.parse('$api/grossMargin');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print('ini body ${bodyJson[0]['ratecostamt']}');
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> getTrnoBO(String type, String dbname) async {
    // print(json.encode(pembayaran));
    var data = {
      "type": type,
      "dbname": dbname,
    };
    final url = Uri.parse('$api/getTrnoBO');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson[0]['trnonext'];
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> updatePaymentVerification(
      String paymentcheck, String email) async {
    // print(json.encode(pembayaran));
    var data = {
      "paymentcheck": paymentcheck,
      "email": email,
    };
    final url = Uri.parse('$api/updatePaymentVerification');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> checkLastSplit(String dbname, String transno) async {
    // print(json.encode(pembayaran));
    var data = {
      "dbname": dbname,
      "transno": transno,
    };
    final url = Uri.parse('$api/checkLastSplit');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'authorization': basicAuth
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      var bodyJson = json.decode(response.body);
      print(bodyJson);
      return bodyJson;
    } else {
      throw Exception();
    }
  }

  static Future<dynamic> snapinMidtrans(
      num amount, String trno, String subscribetion) async {
    // print(json.encode(pembayaran));
    var data = {
      "transaction_details": {"order_id": '$trno', "gross_amount": amount},
      "credit_card": {"secure": true}
    };
    final url =
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization':
              'Basic U0ItTWlkLXNlcnZlci1KNFhKandjLXBUQlFZc1k0aFVGenRDUC06'
        },
        body: json.encode(data));

    if (response.statusCode == 200) {
      List bodyJson = json.decode(response.body);
      print(bodyJson);
      return json.decode(response.body)['redirect_url'];
    } else {
      print(json.decode(response.body)['redirect_url']);
      return json.decode(response.body)['redirect_url'];
    }
  }

  static Future<dynamic> getStatusTransactionSubscribe(String trno) async {
    final url = Uri.parse('https://api.sandbox.midtrans.com/v2/$trno/status');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization':
            'Basic U0ItTWlkLXNlcnZlci1KNFhKandjLXBUQlFZc1k0aFVGenRDUC06'
      },
    );

    if (response.statusCode == 200) {
      var status = json.decode(response.body);
      return status['transaction_status'];
    } else {
      return response.statusCode;
    }
  }

  static Future<dynamic> uploadFilesLogoPDF(
      selectedFile, String namefile) async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    var url = Uri.parse("$apiuploadPDF/upload_files");
    print(url);
    var request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'authorization': basicAuth,
    });
    request.files.add(
        http.MultipartFile.fromBytes("file", selectedFile, filename: namefile));

    request.send().then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.request);
        return 'upload complate';
      }
    });
  }
}
