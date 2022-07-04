// ignore_for_file: unused_import, unused_element, avoid_function_literals_in_foreach_calls, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:posq/model.dart';
import 'package:sqflite/sqflite.dart';

var databasename = 'posq';

class DatabaseHandler {
  Future<Database> initializeDB(String dbname) async {
    //orignal path is documentsDirectory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // path is only test
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, '${dbname}.db'),
      onCreate: (
        database,
        version,
      ) async {
        await database.execute(
          "CREATE TABLE Outlet(id INTEGER PRIMARY KEY AUTOINCREMENT,outletcd varchar(20) NOT NULL, outletname varchar(100) ,telp INTEGER , alamat varchar(100) , kodepos varchar(20) ,trnonext INTEGER NOT NULL,trnopynext INTEGER NOT NULL)",
        );
        await database.execute(
          '''CREATE TABLE psspsitem(id INTEGER PRIMARY KEY AUTOINCREMENT
          ,outletcd varchar(100) NOT NULL, itemcd varchar(100) NOT NULL
          ,itemdesc varchar(100) NOT NULL, slsamt decimal NOT NULL, costamt decimal NOT NULL
          ,slsnett decimal NOT NULL,taxpct decimal NOT NULL,svchgpct decimal NOT NULL
          ,revenuecoa varchar(100) NOT NULL,taxcoa varchar(100) NOT NULL,svchgcoa varchar(100) NOT NULL
          ,slsfl INTEGER NOT NULL,costcoa varchar(100) NOT NULL,ctg varchar(100) NOT NULL
          ,stock double NOT NULL,pathimage varchar(100) NOT NULL,description Text,trackstock INTEGER NOT NULL,
          barcode varchar(100),SKU varchar(100)
          )''',
        );

        await database.execute(
          "CREATE TABLE registeritem(id INTEGER PRIMARY KEY AUTOINCREMENT,outletcd varchar(100) NOT NULL, itemcd varchar(100) NOT NULL,barcode varchar(200) NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE ctg(id INTEGER PRIMARY KEY AUTOINCREMENT,ctgcd varchar(100) NOT NULL, ctgdesc varchar(100) NOT NULL)",
        );

        await database.execute(
          '''CREATE TABLE iafjrndt(id INTEGER PRIMARY KEY AUTOINCREMENT,trdt varchar(100) NOT NULL,pscd varchar(100) NOT NULL
          , trno varchar(100) NOT NULL,split varchar(100) NOT NULL,trnobill varchar(100) NOT NULL,itemcd varchar(100) NOT NULL
          ,trno1 varchar(100) NOT NULL,itemseq INTEGER NOT NULL,cono varchar(100) NOT NULL
          ,waitercd varchar(100) NOT NULL,discpct decimal NOT NULL,discamt decimal NOT NULL
          ,qty INT NOT NULL,ratecurcd varchar(100) NOT NULL,ratebs1 decimal NOT NULL,ratebs2 decimal NOT NULL
          ,rateamtcost decimal NOT NULL,rateamt decimal NOT NULL
          ,rateamtservice decimal NOT NULL,rateamttax decimal NOT NULL
          ,rateamttotal decimal NOT NULL,rvnamt decimal NOT NULL,taxamt decimal NOT NULL
          ,serviceamt decimal NOT NULL,nettamt decimal NOT NULL,rebateamt decimal NOT NULL
          ,rvncoa varchar(100) NOT NULL,taxcoa varchar(100) NOT NULL,servicecoa varchar(100) NOT NULL
          ,costcoa varchar(100) NOT NULL,active varchar(100) NOT NULL,usercrt varchar(100) NOT NULL
          ,userupd varchar(100) NOT NULL,userdel varchar(100) NOT NULL,prnkitchen varchar(100) NOT NULL,prnkitchentm varchar(100) NOT NULL,confirmed varchar(100) NOT NULL,trdesc varchar(100) NOT NULL,taxpct decimal NOT NULL,servicepct decimal NOT NULL,statustrans varchar(100),time varchar(20) NOT NULl)''',
        );
        await database.execute(
          "CREATE TABLE iafjrnhd(id INTEGER PRIMARY KEY AUTOINCREMENT,trdt varchar(100) NOT NULL, trno varchar(100) NOT NULL, split varchar(100) NOT NULL, pscd varchar(100) NOT NULL, docno varchar(100), trtm varchar(100) NOT NULL, disccd varchar(100), pax varchar(100) NOT NULL, trdesc varchar(100), trdesc2 varchar(100), pymtmthd varchar(100) NOT NULL, currcd varchar(100) NOT NULL, currbs1 varchar(100), currbs2 varchar(100),ftotamt decimal NOT NULL,totalamt decimal NOT NULL,framtrmn decimal NOT NULL,amtrmn decimal NOT NULL,cardcd varchar(100),cardno varchar(100),cardnm varchar(100),cardexp varchar(100),dpno varchar(100),compcd varchar(100) NOT NULL,compdesc varchar(100),active varchar(100) NOT NULL,usercrt varchar(100) NOT NULL,slstp varchar(100) NOT NULL,guestname varchar(100),guestphone varchar(100),virtualaccount varchar(100),billerkey varchar(100),billercode varchar(100),qrcode varchar(200),statustrans varchar(200))",
        );
        await database.execute(
          "CREATE TABLE arscomp(id INTEGER PRIMARY KEY AUTOINCREMENT,compcd varchar(100) NOT NULL, compdesc varchar(100) NOT NULL, category varchar(100) NOT NULL, coaar varchar(100) NOT NULL, coapayment varchar(100), address varchar(100),telp varchar(100),pic varchar(100),email varchar(100), active INTEGER NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE ctgarscomp(id INTEGER PRIMARY KEY AUTOINCREMENT,ctgcd varchar(100) NOT NULL, ctgdesc varchar(100) NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE promo(id INTEGER PRIMARY KEY AUTOINCREMENT,promocd varchar(100) NOT NULL, promodesc varchar(100) NOT NULL,type varchar(100) NOT NULL,pct decimal NOT NULL,amount decimal NOT NULL,mindisc decimal NOT NULL,maxdisc  decimal NOT NULL )",
        );
        await database.execute(
          "CREATE TABLE customertemp(id INTEGER PRIMARY KEY AUTOINCREMENT,outletcd varchar(100) NOT NULL,trno varchar(100) NOT NULL,nama varchar(200),telp varchar(200),email varchar(200),alamat varchar(200))",
        );
        await database.execute(
          "CREATE TABLE gntrantp(id INTEGER PRIMARY KEY AUTOINCREMENT,trtp char(10) NOT NULL,ProgNm varchar(100) NOT NULL,reftp INTEGER NOT NULL,refprefix varchar(50) NOT NULL,trnonext INTEGER NOT NULL)",
        );
        await database.execute(
          '''CREATE TABLE glftrdt(id INTEGER PRIMARY KEY AUTOINCREMENT,trno varchar(50) NOT NULL
          ,prodcd varchar(50),proddesc varchar(200),subtrno varchar(50),cbcd char(10),supcd varchar(200)
          ,compcd varchar(50),whto varchar(50),whfr varchar(50),qtyconv decimal,unituse varchar(10),currcd varchar(50)
          ,baseamt1 decimal,baseamt2 decimal,unitamt decimal,totalprice decimal,taxpct decimal 
          , taxamt decimal ,discpct decimal , discamount decimal,totalaftdisctax decimal
          ,trcoa varchar(100) NOT NULL,fdbamt decimal,fcramt decimal,ldbamt decimal 
          ,lcramt decimal,trdt varchar(20),notes varchar(200),trtpcd char(10),active INTEGER NOT NULL
          ,prd varchar(20) NOT NULL,qtyremain decimal,itemseq INTEGER NOT NULL )''',
        );
      },
      version: 1,
    );
  }

  Future<void> deleteDB() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      print('deleting db');
      // db=null;
      deleteDatabase(documentsDirectory.path);
    } catch (e) {
      print(e.toString());
    }

    print('db is deleted');
  }

  Future<Database> upgradeDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'posq.db');
    var ourDb = await openDatabase(path, version: 2, onUpgrade: _onUpgrade);
    print(ourDb);
    return ourDb;
  }

  // UPGRADE DATABASE TABLES
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute(
          "ALTER TABLE Outlet ADD COLUMN outletcd varchar(100) NOT NULL;");
    }
  }

  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);

  Future<int> insertOutlet(List<Outlet> users) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var user in users) {
      result = await db.insert('Outlet', user.toMap());
      print(user.outletname);
    }
    return result;
  }

  Future<int> insertGntrantp(List<Gntrantp> transtype) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var user in transtype) {
      result = await db.insert('gntrantp', user.toMap());
      print(user.ProgNm);
    }
    return result;
  }

  Future<int> insertCustomers(List<Costumers> users) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var user in users) {
      result = await db.insert('arscomp', user.toMap());
      print(user.compdesc);
    }
    return result;
  }

  Future<int> insertCustomersTrno(List<CostumersSavedManual> users) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var user in users) {
      result = await db.insert('customertemp', user.toMap());
    }
    return result;
  }

  Future<int> registerItem(List<RegisterItem> items) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var user in items) {
      result = await db.insert('registeritem', user.toMap());
      print('item saved');
    }
    return result;
  }

  Future<int> insertItem(List<Item> items) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var item in items) {
      result = await db.insert('psspsitem', item.toMap());
      print(' ini barcode : ${item.barcode}');
    }
    return result;
  }

  Future<int> insertGltrdt(List<Glftrdt> items) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var item in items) {
      result = await db.insert('glftrdt', item.toMap());
      print(items.first.fdbamt);
    }
    return result;
  }

  // Future<int> insertGlftrdt(List<Glftrdt> items) async {
  //   int result = 0;
  //   final Database db = await initializeDB(databasename);
  //   for (var item in items) {
  //     result = await db.insert('glftrdt', item.toMap());
  //     print(item.trno);
  //   }
  //   return result;
  // }

  Future<int> insertPromo(List<Promo> items) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var item in items) {
      result = await db.insert('promo', item.toMap());
      print(item.promodesc);
    }
    return result;
  }

  Future<int> insertIafjrndt(List<IafjrndtClass> items) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var item in items) {
      result = await db.insert('iafjrndt', item.toMap());
      print(items.last.statustrans);
    }
    return result;
  }

  Future<int> insertIafjrnhd(List<IafjrnhdClass> items) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var item in items) {
      result = await db.insert('iafjrnhd', item.toMap());
    }
    print(items.first.trdesc);
    return result;
  }

  Future<int> insertCtg(List<Ctg> ctg) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var ctgs in ctg) {
      result = await db.insert('ctg', ctgs.toMap());
      print(ctgs.ctgcd);
    }
    return result;
  }

  Future<int> insertCtgArscomp(List<Ctg> ctg) async {
    int result = 0;
    final Database db = await initializeDB(databasename);
    for (var ctgs in ctg) {
      result = await db.insert('ctgarscomp', ctgs.toMap());
      print(ctgs.ctgcd);
    }
    return result;
  }

  Future<List<Outlet>> retrieveUsers() async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.query('Outlet');
    return queryResult.map((e) => Outlet.fromMap(e)).toList();
  }

  Future<List<Gntrantp>> retrivegntranstp() async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.query('gntrantp');
    return queryResult.map((e) => Gntrantp.fromMap(e)).toList();
  }

  Future<List<dynamic>> getDataRR() async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        '''select id, trno, prodcd, proddesc, subtrno ,cbcd, supcd, compcd, whto
        , whfr , sum(qtyconv) as qtyconv, unituse, currcd, baseamt1, baseamt2, unitamt, sum(totalprice) as totalprice, taxpct
        , taxamt, discpct, discamount, totalaftdisctax
        , trcoa, fdbamt, fcramt, ldbamt, lcramt, trdt, notes 
        , trtpcd, active, prd, sum(qtyremain) as qtyremain  from glftrdt where trcoa='Inventory' and trtpcd='7010' and active='1' group by trno ''');
    // print(queryResult);
    return queryResult;
  }

  Future<List<dynamic>> getDataReturnRR() async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        '''select id, trno, prodcd, proddesc, subtrno ,cbcd, supcd, compcd, whto
        , whfr , sum(qtyconv) as qtyconv, unituse, currcd, baseamt1, baseamt2, unitamt, sum(totalprice) as totalprice, taxpct
        , taxamt, discpct, discamount, totalaftdisctax
        , trcoa, fdbamt, fcramt, ldbamt, lcramt, trdt, notes 
        , trtpcd, active, prd, qtyremain from glftrdt where trcoa='Inventory' and trtpcd='7081' group by trno ''');
    // print(queryResult);
    return queryResult;
  }

  Future<List<dynamic>> getDataDetailTrnoGrouped(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        '''select * from glftrdt where active='1' and trtpcd='7010' and trcoa='AP-Pembelian' and trno='${trno}' ''');
    // print(queryResult);
    return queryResult;
  }

  Future<List<dynamic>> getDataDetailTrno(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        '''select * from glftrdt where active='1' and trtpcd='7010'  and trno='${trno}' ''');
    // print(queryResult);
    return queryResult;
  }

  Future<List<CostumersSavedManual>> retrieveGuestinfo(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("select * from customertemp where trno='${trno}' ");
    return queryResult.map((e) => CostumersSavedManual.fromMap(e)).toList();
  }

  Future<List<Promo>> retrievePromo(String query) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('select * from promo where promodesc like "%$query%"');
    return queryResult.map((e) => Promo.fromMap(e)).toList();
  }

  Future<List<Costumers>> retrieveListCustomers(String query) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('select * from arscomp where compdesc like "%$query%"');
    print(queryResult);
    return queryResult.map((e) => Costumers.fromMap(e)).toList();
  }

  Future<List<IafjrndtClass>> summarybill(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
select trno,sum(x.rvnamt) as rvnamt,sum(x.discamt) as discamt,sum(x.taxamt) as taxamt ,sum(x.serviceamt) as serviceamt ,sum(x.nettamt) as nettamt from
(select trno,sum(rvnamt) as rvnamt ,"0" as  discamt, sum(taxamt) as taxamt,sum(serviceamt) as serviceamt,sum(nettamt) as nettamt from iafjrndt where trno="$trno" 
        union 
         select trno, "0" as rvnamt ,ifnull(sum(ftotamt),0) as discamt,"0" as taxamt,"0" as serviceamt ,ifnull(sum(ftotamt),0) as nettamt from iafjrnhd where trno="$trno" and pymtmthd='Discount') as X

         
        ''');
    print(queryResult);
    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

  Future<List<IafjrnhdClass>> summaryPayment(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select sum(totalamt) as totalamt from iafjrnhd where trno="$trno" and pymtmthd<>"Discount" and active="1"');
    if (queryResult.first.isEmpty) {
      print('harusnya');
    }

    print(queryResult);
    return queryResult.map((e) => IafjrnhdClass.fromMap(e)).toList();
  }

  Future<List<Ctg>> retrieveCTG() async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.query('Ctg');

    return queryResult.map((e) => Ctg.fromMap(e)).toList();
  }

  Future<List<Ctg>> retrieveCtgArscomp() async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.query('ctgarscomp');

    return queryResult.map((e) => Ctg.fromMap(e)).toList();
  }

  Future<List<Item>> retrieveItems(String query) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('''select   Y.id as id,Y.itemcd as itemcd,
     itemdesc,
     slsamt,
     costamt,
     slsnett,
     taxpct,
     svchgpct,
     revenuecoa,
     taxcoa,
     svchgcoa,
     slsfl,
     costcoa,
     ctg,
     Y.outletcd as outletcd,
      Y.stock-ifnull(X.stock,0)+ifnull(Z.stock,0)-ifnull(Q.stock,0) as stock,
    pathimage,
    description,
    sku,
    barcode,
    trackstock from (select * from psspsitem)Y
        left join (select itemcd as itemcd,sum(qty) as stock from iafjrndt where active='1' group by itemcd) X 
        on Y.itemcd=X.itemcd
        left join (select prodcd as itemcd,sum(qtyconv) as stock from glftrdt where active='1'  and trtpcd='7010' and trcoa='Inventory')Z
        
        on x.itemcd=Z.itemcd
                left join (select prodcd as itemcd,sum(qtyconv) as stock from glftrdt where active='1'  and trtpcd='7081' and trcoa='AP-Pembelian')Q
            on x.itemcd=Q.itemcd
         where itemdesc like '%$query%' ''');

    return queryResult.map((e) => Item.fromMap(e)).toList();
  }

  Future<List<Item>> getSpesifikItem(String itemcd) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("select * from psspsitem where itemcd='${itemcd}'");
    print('hasil checkitem : ${queryResult.length}');
    if (queryResult.length == 0) {
      return [];
    } else {
      return queryResult.map((e) => Item.fromMap(e)).toList();
    }
  }

  Future<List<IafjrndtClass>> retrievetotaltransaksi(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "select trdt,count(trno) as trno,trdesc from iafjrndt where trno like '%$trno%' and active='1'");

    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

  Future<List<IafjrndtClass>> checktotalItem(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "select count(qty) as qty,trdesc from iafjrndt where trno like '%$trno%' and active='1'");

    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

  Future<List<Item>> getItemFromBarcode(String itemcd) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("select * from psspsitem where itemcd='${itemcd}'");

    return queryResult.map((e) => Item.fromMap(e)).toList();
  }

  Future<List<IafjrndtClass>> checktotalAmountNett(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
select sum(x.nettamt) as nettamt from
(select trno,sum(rvnamt) as rvnamt ,"0" as  discamt, sum(taxamt) as taxamt,sum(serviceamt) as serviceamt,sum(nettamt) as nettamt from iafjrndt where trno="$trno" and active='1'
        union 
         select trno, "0" as rvnamt ,ifnull(sum(ftotamt),0) as discamt,"0" as taxamt,"0" as serviceamt ,ifnull(sum(ftotamt),0) as nettamt from iafjrnhd where trno="$trno" and pymtmthd='Discount' and active='1') X

         
        ''');

    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

//   Future<List<Glftrdt>> getDataRR() async {
//     final Database db = await initializeDB(databasename);
//     final List<Map<String, Object?>> queryResult = await db.rawQuery('''
// select * from glftrdt where  active='1' and trtpcd='7010' and trcoa='AP-Pembelian'

//         ''');
//     print(queryResult);
//     return queryResult.map((e) => Glftrdt.fromMap(e)).toList();
//   }

  Future<List<Outlet>> getTrno(String pscd) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "select outletcd,outletname,telp,alamat,trnonext,kodepos,trnopynext from Outlet where outletcd='$pscd'");

    return queryResult.map((e) => Outlet.fromMap(e)).toList();
  }

  Future<List<Gntrantp>> getTrnoNextBO(String trtp) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("select * from gntrantp where trtp='${trtp}'");

    return queryResult.map((e) => Gntrantp.fromMap(e)).toList();
  }

  Future<List<IafjrndtClass>> retrieveDetailIafjrndt(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "select *  from iafjrndt where trno = '$trno' and active='1'");
    // print(queryResult.last['trno'].toString());

    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

  Future<List<IafjrndtClass>> retrieveDetailIafjrndt2(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        '''select trdesc,trno,trdt,pscd,itemcd,qty,rvnamt,taxamt,serviceamt,nettamt  from iafjrndt where trno = '$trno' and active='1'
        union
        select '' as trdesc,trno,trdt,pscd,'Discount' as itemcd,1 as qty,0 as rvnamt,0 as taxamt,0 as serviceamt,ftotamt as nettamt  from iafjrnhd where trno='$trno' and active='1' and pymtmthd='Discount'
        ''');
    // print(queryResult);

    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

  Future<List<RegisterItem>> retrieveRegisterItem(String itemcd) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery("select *  from registeritem where itemcd = '$itemcd' ");
    print(queryResult.last['barcode'].toString());

    return queryResult.map((e) => RegisterItem.fromMap(e)).toList();
  }

  Future<List<IafjrnhdClass>> retriveListHeader(String trdt) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        '''select iafjrndt.trno as trno,iafjrnhd.pymtmthd as pymtmthd,iafjrnhd.ftotamt as ftotamt from iafjrndt 
        left join iafjrnhd on iafjrnhd.trno=iafjrndt.trno  where iafjrndt.trdt='$trdt' and iafjrndt.active='1'  and pymtmthd<>'Discount'
        group by iafjrndt.trno order by pymtmthd,iafjrnhd.trno ''');
    print(queryResult);

    return queryResult.map((e) => IafjrnhdClass.fromMap(e)).toList();
  }

  Future<List<IafjrndtClass>> retriveSavedTransaction(String query) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        ''' select x.trdt,x.trno,z.trno as trno1,sum(x.nettamt) as nettamt,x.statustrans,x.time from iafjrndt x 
        left join iafjrnhd z on x.trno=z.trno where x.active='1' and (z.trno is null  or (pymtmthd='Discount'))   and (x.trno like '%$query%'  or x.statustrans like '%$query%') 
        
          group by x.trno''');
    print(queryResult);

    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

  Future<List<IafjrndtClass>> retriveSavedTransaction2(String query) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
select * from (select x.trdt as trdt,x.trno as trno, sum(x.nettamt) as nettamt,x.statustrans as statustrans,x.time as time from 
       ( select trdt,trno,sum(nettamt) as nettamt,statustrans,time from iafjrndt where (trno like '%$query%' or statustrans like '%$query%') and active='1'  group by trno
        union
        select trdt,trno,sum(totalamt) as nettamt,'' as statustrans,'' as time from iafjrnhd where (trno like '%$query%' or statustrans like '%$query%') and active='1' and pymtmthd='Discount' group by trno
        union
        select trdt,trno,sum(-totalamt) as nettamt,'' as statustrans,'' as time from iafjrnhd where (trno like '%$query%' or statustrans like '%$query%') and active='1' and pymtmthd<>'Discount' group by trno)X

    
group by x.trno)X

where x.nettamt<>0
      
          ''');
    print(queryResult);

    return queryResult.map((e) => IafjrndtClass.fromMap(e)).toList();
  }

  Future<List<IafjrnhdClass>> retriveListDetailPayment(String trno) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "select * from iafjrnhd where trno='${trno}' and active='1' and pymtmthd<>'Discount'");
    print(queryResult);

    return queryResult.map((e) => IafjrnhdClass.fromMap(e)).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'Outlet',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteCustomers(int id) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'arscomp',
      where: "id = ?",
      whereArgs: [id],
    );
  }

////update Class///////
  Future<void> updateItems(Item items) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE psspsitem 
    SET outletcd=?,itemcd=?,itemdesc = ?, description = ? 
    ,costamt=?,slsamt = ?,slsnett=?,taxpct=?,svchgpct=?
    ,revenuecoa=?,taxcoa=?,svchgcoa=?,slsfl=?,costcoa=?
    ,ctg=?,stock=?,pathimage=?,barcode=?,sku=?
    WHERE id = ?
    ''', [
      items.outletcd,
      items.itemcd,
      items.itemdesc,
      items.description,
      items.costamt,
      items.slsamt,
      items.slsnett,
      items.taxpct,
      items.svchgpct,
      items.revenuecoa,
      items.taxcoa,
      items.svchgcoa,
      items.slsfl,
      items.costcoa,
      items.ctg,
      items.stock,
      items.pathimage,
      items.barcode,
      items.sku,
      items.id,
    ]);
  }

  Future<void> updateQtyRemain(double qty, String trno, int itemseq) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE glftrdt 
    SET qtyremain=? WHERE trno=? and itemseq=?
    ''', [qty, '${trno}',itemseq]);
    print(qty);
    print(trno);
  }

  Future<void> activeZeroiafjrndt(IafjrndtClass iafjrndt) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE iafjrndt 
    SET active='0' WHERE id = ?
    ''', [
      iafjrndt.id,
    ]);
  }

  Future<void> activeZeroiafjrndttrno(IafjrndtClass iafjrndt) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE iafjrndt 
    SET active=? WHERE trno = ?
    ''', [
      iafjrndt.active,
      iafjrndt.trno,
    ]);
  }

  Future<void> activeZeroiafjrnhdtrno(IafjrnhdClass iafjrnhd) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE iafjrnhd 
    SET active=? WHERE trno = ?
    ''', [
      iafjrnhd.active,
      iafjrnhd.trno,
    ]);
  }

  Future<void> activeZeroGlftrdt(String trno) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE glftrdt 
    SET active=0 WHERE trno = ?
    ''', [
      trno,
    ]);
  }

  
  Future<void> activeZeroReceivingitemseq(String trno,int itemseq) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE glftrdt 
    SET active=0 WHERE trno = ? and itemseq=?
    ''', [
      trno,itemseq
    ]);
  }

  Future<void> updateTrnoNext(Outlet iafjrndt) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE Outlet 
    SET trnonext=? WHERE outletcd = ?
    ''', [
      iafjrndt.trnonext,
      iafjrndt.outletcd,
    ]);
  }

  Future<void> updateTrnoGntrantp(Gntrantp trno) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE gntrantp 
    SET trnonext=trnonext+1 WHERE trtp=?
    ''', [trno.trtp]);
  }

  Future<void> updateRRDebit(Glftrdt data) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE glftrdt 
    SET prodcd=?,proddesc=?,notes=?,supcd=?,qtyconv=?,unitamt=?,totalprice=?,totalaftdisctax=?,
    fdbamt=?,ldbamt=?,qtyremain=?
     WHERE trno=? and itemseq=? and trcoa='Inventory'
    ''', [
      data.prodcd,
      data.proddesc,
      data.notes,
      data.supcd,
      data.qtyconv,
      data.unitamt,
      data.totalprice,
      data.totalaftdisctax,
      data.fdbamt,
      data.ldbamt,
      data.qtyremain,
      data.trno,
      data.itemseq
    ]);
  }

  Future<void> updateRRCredit(Glftrdt data) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE glftrdt 
    SET prodcd=?,proddesc=?,notes=?,supcd=?,qtyconv=?,unitamt=?,totalprice=?,totalaftdisctax=?,
    fcramt=?,lcramt=?,qtyremain=?
     WHERE trno=?  and itemseq=? and trcoa='AP-Pembelian'
    ''', [
      data.prodcd,
      data.proddesc,
      data.notes,
      data.supcd,
      data.qtyconv,
      data.unitamt,
      data.totalprice,
      data.totalaftdisctax,
      data.fcramt,
      data.lcramt,
      data.qtyremain,
      data.trno,
      data.itemseq,
    ]);
  }

  Future<void> updateArscomp(Costumers pelanggan) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE arscomp 
    SET compdesc=?,address=?,email=?,telp=?,pic=?,active=? WHERE compcd =?
    ''', [
      pelanggan.compdesc,
      pelanggan.address,
      pelanggan.email,
      pelanggan.telp,
      pelanggan.pic,
      pelanggan.active,
      pelanggan.compcd,
    ]);
  }

  Future<void> updatePromo(Promo promo) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE promo 
    SET promocd=?,promodesc=?,amount=?,pct=?,type=?,maxdisc=?,mindisc=? WHERE id =?
    ''', [
      promo.promocd,
      promo.promodesc,
      promo.amount,
      promo.pct,
      promo.type,
      promo.maxdisc,
      promo.mindisc,
      promo.id,
    ]);
  }

  Future<void> updateIafjrndtitem(IafjrndtClass iafjrndt) async {
    final db = await initializeDB(databasename);
    await db.rawUpdate('''
    UPDATE iafjrndt 
    SET itemcd=?,trdesc=?,qty=?,rateamt=?,discamt=?,discpct=?,rvnamt=?,taxamt=?,serviceamt=?,nettamt=?,taxpct=?,servicepct=? WHERE id = ?
    ''', [
      iafjrndt.itemcd,
      iafjrndt.trdesc,
      iafjrndt.qty,
      iafjrndt.rateamt,
      iafjrndt.discamt,
      iafjrndt.discpct,
      iafjrndt.rvnamt,
      iafjrndt.taxamt,
      iafjrndt.serviceamt,
      iafjrndt.nettamt,
      iafjrndt.taxpct,
      iafjrndt.servicepct,
      iafjrndt.id
    ]);
    print('update iafjrndt success ${iafjrndt.id}');
  }

  Future<void> deleteCTG(int id) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'ctg',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteTrno(String trno) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'glftrdt',
      where: "trno = ?",
      whereArgs: [trno],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'psspsitem',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteiafjrndtItems(int id) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'iafjrndt',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deletepayment(int id) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'iafjrnhd',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deletepaPromo(String trno) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'iafjrnhd',
      where: "trno = ?",
      whereArgs: [trno],
    );
  }

  Future<void> deletePromo(int id) async {
    final db = await initializeDB(databasename);
    await db.delete(
      'promo',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deletePromoActive(String trno) async {
    final db = await initializeDB(databasename);
    print(trno);
    await db.rawDelete('delete from iafjrnhd where trno="$trno"');
  }

  Future queryCheckOutlet() async {
    var maxid;
    // get a reference to the database
    final Database db = await initializeDB(databasename);

    // raw query
    List<Map> result =
        await db.rawQuery('SELECT IFNULL(id,1) as id FROM Outlet');

    // print the results
    return result.map((e) => e['id']);
    // {_id: 2, name: Mary, age: 32}
  }

  Future queryCheckItem() async {
    var maxid;
    // get a reference to the database
    final Database db = await initializeDB(databasename);

    // raw query
    List<Map> result =
        await db.rawQuery('SELECT ifnull(max(id),0)+1 as id FROM psspsitem');

    // print the results
    return result.map((e) => e['id']);
    // {_id: 2, name: Mary, age: 32}
  }

  Future queryCheckRegister(String barcode) async {
    var maxid;
    // get a reference to the database
    final Database db = await initializeDB(databasename);

    // raw query
    List<Map> result =
        await db.rawQuery('select * from psspsitem where barcode="${barcode}"');

    // print the results
    print(result.isEmpty);
    if (result.isEmpty) {
      return 'Oke item masih kosong';
    } else {
      print(result);
      return result.first['itemcd'];
    }

    // {_id: 2, name: Mary, age: 32}
  }

  Future checkPendingTransaction(String query) async {
    final Database db = await initializeDB(databasename);
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
select * from (select x.trdt as trdt,x.trno as trno, sum(x.nettamt) as nettamt,x.statustrans as statustrans,x.time as time from 
       ( select trdt,trno,sum(nettamt) as nettamt,statustrans,time from iafjrndt where (trno like '%$query%' or statustrans like '%$query%') and active='1'  group by trno
        union
        select trdt,trno,sum(totalamt) as nettamt,'' as statustrans,'' as time from iafjrnhd where (trno like '%$query%' or statustrans like '%$query%') and active='1' and pymtmthd='Discount' group by trno
        union
        select trdt,trno,sum(-totalamt) as nettamt,'' as statustrans,'' as time from iafjrnhd where (trno like '%$query%' or statustrans like '%$query%') and active='1' and pymtmthd<>'Discount' group by trno)X

    
group by x.trno)X

where x.nettamt<>0
      
          ''');
    print(queryResult.length);

    return queryResult.length;
  }
}
