import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posq/model.dart';

var host = '192.168.42.83';
var api = 'http://$host:8003';
var serverkey = '';
String username = 'massmith';
String password = 'massmith';
var basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

class ClassCloudApi {
  static Future<dynamic> createDB(String queryDB) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": ""},
      "query": "CREATE DATABASE $queryDB;"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> CreateOutlet(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE outlet(id INTEGER PRIMARY KEY AUTO_INCREMENT,outletcd varchar(20) NOT NULL, outletname varchar(100) ,telp BIGINT , alamat varchar(100) , kodepos varchar(20) ,trnonext INTEGER NOT NULL,trnopynext INTEGER NOT NULL);"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createPsspsitem(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE psspsitem(id INTEGER PRIMARY KEY AUTO_INCREMENT,outletcd varchar(100) NOT NULL, itemcd varchar(100) NOT NULL,itemdesc varchar(100) NOT NULL, slsamt decimal NOT NULL, costamt decimal NOT NULL,slsnett decimal NOT NULL,taxpct decimal NOT NULL,svchgpct decimal NOT NULL,revenuecoa varchar(100) NOT NULL,taxcoa varchar(100) NOT NULL,svchgcoa varchar(100) NOT NULL,slsfl INTEGER NOT NULL,costcoa varchar(100) NOT NULL,ctg varchar(100) NOT NULL,stock double NOT NULL,pathimage varchar(100) NOT NULL,description Text,trackstock INTEGER NOT NULL,barcode varchar(100),SKU varchar(100))"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createRegisterItem(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE registeritem(id INTEGER PRIMARY KEY AUTO_INCREMENT,outletcd varchar(100) NOT NULL, itemcd varchar(100) NOT NULL,barcode varchar(200) NOT NULL)"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTableCtgItem(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE ctg(id INTEGER PRIMARY KEY AUTO_INCREMENT,ctgcd varchar(100) NOT NULL, ctgdesc varchar(100) NOT NULL)"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTableIntegrasi(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE integrasi(id INTEGER PRIMARY KEY AUTO_INCREMENT,integrasi varchar(200), keyapi varchar(300),uses varchar(5))"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTableIafJrndt(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE iafjrndt(id INTEGER PRIMARY KEY AUTO_INCREMENT,trdt varchar(100) NOT NULL,pscd varchar(100) NOT NULL          , trno varchar(100) NOT NULL,split varchar(100) NOT NULL,trnobill varchar(100) NOT NULL,itemcd varchar(100) NOT NULL,trno1 varchar(100) NOT NULL,itemseq INTEGER NOT NULL,cono varchar(100) NOT NULL,waitercd varchar(100) NOT NULL,discpct decimal NOT NULL,discamt decimal NOT NULL,qty INT NOT NULL,ratecurcd varchar(100) NOT NULL,ratebs1 decimal NOT NULL,ratebs2 decimal NOT NULL,rateamtcost decimal NOT NULL,rateamt decimal NOT NULL,rateamtservice decimal NOT NULL,rateamttax decimal NOT NULL,rateamttotal decimal NOT NULL,rvnamt decimal NOT NULL,taxamt decimal NOT NULL,serviceamt decimal NOT NULL,nettamt decimal NOT NULL,rebateamt decimal NOT NULL,rvncoa varchar(100) NOT NULL,taxcoa varchar(100) NOT NULL,servicecoa varchar(100) NOT NULL,costcoa varchar(100) NOT NULL,active varchar(100) NOT NULL,usercrt varchar(100) NOT NULL,userupd varchar(100) NOT NULL,userdel varchar(100) NOT NULL,prnkitchen varchar(100) NOT NULL,prnkitchentm varchar(100) NOT NULL,confirmed varchar(100) NOT NULL,trdesc varchar(100) NOT NULL,taxpct decimal NOT NULL,servicepct decimal NOT NULL,statustrans varchar(100),time varchar(20) NOT NULL);"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTableIafjrnhd(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          " CREATE TABLE iafjrnhd(id INTEGER PRIMARY KEY AUTO_INCREMENT,trdt varchar(100) NOT NULL, trno varchar(100) NOT NULL, split varchar(100) NOT NULL, pscd varchar(100) NOT NULL, docno varchar(100), trtm varchar(100) NOT NULL, disccd varchar(100), pax varchar(100) NOT NULL, trdesc varchar(100), trdesc2 varchar(100), pymtmthd varchar(100) NOT NULL, currcd varchar(100) NOT NULL, currbs1 varchar(100), currbs2 varchar(100),ftotamt decimal NOT NULL,totalamt decimal NOT NULL,framtrmn decimal NOT NULL,amtrmn decimal NOT NULL,cardcd varchar(100),cardno varchar(100),cardnm varchar(100),cardexp varchar(100),dpno varchar(100),compcd varchar(100) NOT NULL,compdesc varchar(100),active varchar(100) NOT NULL,usercrt varchar(100) NOT NULL,slstp varchar(100) NOT NULL,guestname varchar(100),guestphone varchar(100),virtualaccount varchar(100),billerkey varchar(100),billercode varchar(100),qrcode varchar(200),statustrans varchar(200))"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTablearscomp(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE arscomp(id INTEGER PRIMARY KEY AUTO_INCREMENT,compcd varchar(100) NOT NULL, compdesc varchar(100) NOT NULL, category varchar(100) NOT NULL, coaar varchar(100) NOT NULL, coapayment varchar(100), address varchar(100),telp varchar(100),pic varchar(100),email varchar(100), active INTEGER NOT NULL)"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTablectgarscomp(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE ctgarscomp(id INTEGER PRIMARY KEY AUTO_INCREMENT,ctgcd varchar(100) NOT NULL, ctgdesc varchar(100) NOT NULL)"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTablepromo(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE promo(id INTEGER PRIMARY KEY AUTO_INCREMENT,promocd varchar(100) NOT NULL, promodesc varchar(100) NOT NULL,type varchar(100) NOT NULL,pct decimal NOT NULL,amount decimal NOT NULL,mindisc decimal NOT NULL,maxdisc  decimal NOT NULL )"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTableCustomerTemp(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE customertemp(id INTEGER PRIMARY KEY AUTO_INCREMENT,outletcd varchar(100) NOT NULL,trno varchar(100) NOT NULL,nama varchar(200),telp varchar(200),email varchar(200),alamat varchar(200))"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTableGntrantp(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE gntrantp(id INTEGER PRIMARY KEY AUTO_INCREMENT,trtp char(10) NOT NULL,ProgNm varchar(100) NOT NULL,reftp INTEGER NOT NULL,refprefix varchar(50) NOT NULL,trnonext INTEGER NOT NULL)"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> createTableGlftrdt(String dbname) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "query":
          "CREATE TABLE glftrdt(id INTEGER PRIMARY KEY AUTO_INCREMENT,trno varchar(50) NOT NULL,prodcd varchar(50),proddesc varchar(200),subtrno varchar(50),cbcd char(10),supcd varchar(200),compcd varchar(50),whto varchar(50),whfr varchar(50),qtyconv decimal,unituse varchar(10),currcd varchar(50),baseamt1 decimal,baseamt2 decimal,unitamt decimal,totalprice decimal,taxpct decimal , taxamt decimal ,discpct decimal , discamount decimal,totalaftdisctax decimal,trcoa varchar(100) NOT NULL,fdbamt decimal,fcramt decimal,ldbamt decimal ,lcramt decimal,trdt varchar(20),notes varchar(200),trtpcd char(10),active INTEGER NOT NULL,prd varchar(20) NOT NULL,qtyremain decimal,itemseq INTEGER NOT NULL )"
    };
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/query');
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

  static Future<dynamic> insertOutletCLD(String dbname, Outlet outlet) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "values": {
        "outletcd": "${outlet.outletcd}",
        "outletname": "${outlet.outletname}",
        "telp": "${outlet.telp}",
        "alamat": "${outlet.alamat}",
        "kodepos": "${outlet.kodepos}",
        "trnonext": "${outlet.trnonext}",
        "trnopynext": "${outlet.trnopynext}"
      }
    };
    print(body);
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/addoutlet');
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

  static Future<dynamic> insertTransTP(String dbname, List<Gntrantp> gntrantp) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "values": gntrantp
    };
    print(body);
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/addtrtpcd');
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

  Future<dynamic> insertProduct(String dbname, Item item) async {
    var body = {
      "db": {"user": "root", "password": "p3nd3kar", "database": "$dbname"},
      "values": {
     
        "outletcd": "${item.outletcode}",
        "itemcd": "${item.itemcode}",
        "itemdesc": "${item.itemdesc}",
        "slsamt": "${item.slsamt}",
        "costamt": "${item.costamt}",
        "slsnett": "${item.slsnett}",
        "taxpct": "${item.taxpct}",
        "svchgpct": "${item.svchgpct}",
        "revenuecoa": "${item.revenuecoa}",
        "taxcoa": "${item.taxcoa}",
        "svchgcoa": "${item.svchgcoa}",
        "slsfl": "${item.slsfl}",
        "costcoa": "${item.costcoa}",
        "ctg": "${item.ctg}",
        "stock": "${item.stock}",
        "pathimage": "${item.pathimage}",
        "description": "${item.description}",
        "trackstock": "${item.trackstock}",
        "barcode": "${item.barcode}",
        "sku": "${item.sku}",
      }
    };
    print(body);
    // print(json.encode(pembayaran));
    final url = Uri.parse('$api/additem');
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
