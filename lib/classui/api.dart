import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:posq/integrasipayment/midtrans.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';

// var api = 'http://192.168.88.14:3000';
var api = 'http://192.168.234.2:3000';
var apiimage = 'http://192.168.234.2:5000';
// var api = 'http://147.139.163.18:3000';

var serverkey = '';
String username = 'mitro';
String password = '@Mitro100689';
var basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
var basicAuthMID = 'Basic ' + base64Encode(utf8.encode(serverkeymidtrans));

class ClassApi {
 Future<Uint8List> fetchImage(String name) async {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(Uri.parse('http://$api:3000/getfile/$name'), headers: {
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

  static Future<dynamic> insertRegisterUser(
      String email, String usercd, String password) async {
    var body = {
      "email": email,
      "usercd": usercd,
      "password": password,
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

  static Future<dynamic> createCompany(PaymentMaster data, String dbname) async {
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
          data.guestname
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

  static Future<List<dynamic>> getOutlets(String usercd) async {
    // print(json.encode(pembayaran));
    var data = {"usercd": usercd};

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
      return bodyJson.map((json) => PaymentMaster.fromJson(json)).where((items) {
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

  static Future<List<IafjrnhdClass>> getCashierSummary(
      String trdt, String pscd, String dbname, String query) async {
    // print(json.encode(pembayaran));
    var data = {"dbname": dbname, "trdt": trdt, "pscd": pscd};
    final url = Uri.parse('$api/getcashiersummary');
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

  
}
