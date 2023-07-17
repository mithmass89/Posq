import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/classformat.dart';

class Outlet {
  final int? id;
  final String outletcd;
  final String? outletname;
  final num? telp;
  final String? alamat;
  final String? kodepos;
  final int? trnonext;
  final int? trnopynext;
  final int? slstp;
  final String? profile;

  Outlet({
    this.id,
    required this.outletcd,
    this.outletname,
    this.telp,
    this.alamat,
    this.kodepos,
    this.trnonext,
    this.trnopynext,
    this.slstp,
    this.profile,
  });

  Outlet.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        outletcd = res["outletcd"],
        outletname = res["outletname"],
        telp = res["telp"],
        alamat = res["alamat"],
        kodepos = res["kodepos"].toString(),
        trnonext = res["trnonext"],
        trnopynext = res["trnopynext"],
        slstp = res['slstp'],
        profile = res['profile'];

  @override
  String toString() {
    return '{"id": $id, "outletcd": $outletcd,"outletname": $outletname,"telp": $telp,"alamat": $alamat,"kodepos": $kodepos,"trnonext": $trnonext,"trnopynext": $trnopynext,slstp:$slstp,profile:$profile}';
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'outletcd': outletcd,
      'outletname': outletname,
      'telp': telp,
      'alamat': alamat,
      'kodepos': kodepos.toString(),
      'trnonext': trnonext,
      'trnopynext': trnopynext,
      'slstp': slstp,
      'profile': profile,
    };
  }
}

class Pegawai {
  final String? jobcode;
  final String joblevel;
  final String? note;

  Pegawai({
    this.jobcode,
    required this.joblevel,
    this.note,
  });

  Pegawai.fromJson(Map<String, dynamic> res)
      : jobcode = res["jobcode"],
        joblevel = res["joblevel"],
        note = res['note'];

  @override
  String toString() {
    return '{"jobcode": $jobcode, "joblevel": $joblevel,"note": $note}';
  }

  Map<String, Object?> toJson() {
    return {
      'jobcode': jobcode,
      'joblevel': joblevel,
      'note': note,
    };
  }
}

class AccessPegawai {
  late String? usercode;
  final String rolecode;
  final String? roledesc;
  final String? accesscode;
  final String accessdesc;
  late String? outletcd;
  final String? subscription;

  AccessPegawai({
    required this.usercode,
    required this.rolecode,
    required this.roledesc,
    required this.accesscode,
    required this.accessdesc,
    required this.outletcd,
    required this.subscription,
  });

  AccessPegawai.fromJson(Map<String, dynamic> res)
      : usercode = res["usercode"],
        rolecode = res["rolecode"],
        roledesc = res['roledesc'],
        accesscode = res["accesscode"],
        accessdesc = res["accessdesc"],
        outletcd = res['outletcd'],
        subscription = res['subscription'];

  @override
  String toString() {
    return '{"usercode": $usercode, "rolecode": $rolecode,"roledesc": $roledesc,"accesscode": $accesscode, "accessdesc": $accessdesc,"outletcd": $outletcd,"subscription": $subscription}';
  }

  Map<String, Object?> toJson() {
    return {
      'usercode': usercode,
      'rolecode': rolecode,
      'roledesc': roledesc,
      'accesscode': accesscode,
      'accessdesc': accessdesc,
      'outletcd': outletcd,
      'subscription': subscription,
    };
  }
}

class SelectedPegawai {
  late String? usercode;
  final String email;

  SelectedPegawai({
    required this.usercode,
    required this.email,
  });

  SelectedPegawai.fromJson(Map<String, dynamic> res)
      : usercode = res["usercode"],
        email = res["email"];

  @override
  String toString() {
    return '{"usercode": $usercode, "email":$email }';
  }

  Map<String, Object?> toJson() {
    return {
      'usercode': usercode,
      'email': email,
    };
  }
}

class ListUser {
  final String? usercd;
  final String? fullname;
  final String? email;
  final String? level;
  final String? expireddate;

  ListUser({
    this.usercd,
    this.fullname,
    this.email,
    this.level,
    this.expireddate,
  });

  ListUser.fromJson(Map<String, dynamic> res)
      : usercd = res["usercd"],
        fullname = res["fullname"],
        email = res["email"],
        level = res['level'],
        expireddate = res['expireddate'];

  @override
  String toString() {
    return '{"usercd": $usercd, "fullname": $fullname,"email": $email,"level": $level,"expireddate": $expireddate}';
  }

  Map<String, Object?> toJson() {
    return {
      'usercd': usercd,
      'fullname': fullname,
      'email': email,
      'level': level,
      'expireddate': expireddate,
    };
  }
}

class CombineDataRingkasan {
  final num? revenuegross;
  final num? pajak;
  final num? service;
  final num? totalnett;
  final num? totalpayment;

  CombineDataRingkasan({
    this.revenuegross,
    this.pajak,
    this.service,
    this.totalnett,
    this.totalpayment,
  });

  CombineDataRingkasan.fromJson(Map<String, dynamic> res)
      : revenuegross = res["revenuegross"],
        pajak = res["pajak"],
        service = res["service"],
        totalnett = res['totalnett'],
        totalpayment = res['totalpayment'];

  @override
  String toString() {
    return '{"revenuegross": $revenuegross, "pajak": $pajak,"service": $service,"totalnett": $totalnett,"totalpayment": $totalpayment}';
  }

  Map<String, Object?> toJson() {
    return {
      'revenuegross': revenuegross,
      'pajak': pajak,
      'service': service,
      'totalnett': totalnett,
      'totalpayment': totalpayment,
    };
  }
}

class TransaksiBO {
  final String? trdt;
  final String? transno;
  final String? documentno;
  final String? description;
  final String? type_tr;
  final String? product;
  final String? proddesc;
  late num? qty;
  final String? unit;
  final String? ctr;
  final String? subctr;
  late num? famount;
  late num? lamount;
  final String? note;
  final String? usercreate;
  final int? active;

  TransaksiBO({
    this.trdt,
    this.transno,
    this.documentno,
    this.description,
    this.type_tr,
    this.product,
    this.proddesc,
    this.qty,
    this.unit,
    this.ctr,
    this.subctr,
    this.famount,
    this.lamount,
    this.note,
    this.active,
    this.usercreate,
  });

  TransaksiBO.fromJson(Map<String, dynamic> res)
      : trdt = res["trdt"],
        transno = res["transno"],
        documentno = res["documentno"],
        description = res['description'],
        type_tr = res['type_tr'],
        product = res['product'],
        proddesc = res['proddesc'],
        qty = res["qty"],
        unit = res["unit"],
        ctr = res['ctr'],
        subctr = res["subctr"],
        famount = res["famount"],
        lamount = res['lamount'],
        note = res["note"],
        active = res["active"],
        usercreate = res["usercreate"];

  @override
  String toString() {
    return '{"trdt": $trdt, "transno": $transno,"documentno": $documentno,"description": $description,"type_tr": $type_tr,"product": $product,"proddesc": $proddesc,"qty": $qty,"unit": $unit,"ctr": $ctr,"subctr": $subctr,"famount": $famount,"lamount": $lamount,"note": $note,"active": $active,"usercreate":$usercreate}';
  }

  Map<String, Object?> toJson() {
    return {
      'trdt': trdt,
      'transno': transno,
      'documentno': documentno,
      'description': description,
      'type_tr': type_tr,
      'product': product,
      'proddesc': proddesc,
      'qty': qty,
      'unit': unit,
      'ctr': ctr,
      'subctr': subctr,
      'famount': famount,
      'lamount': lamount,
      'note': note,
      'active': active,
      'usercreate': usercreate
    };
  }
}

class Item {
  final int? id;
  final String? outletcode;
  final String? itemcode;
  final String? subitemcode;
  final String? itemdesc;
  final num? slsamt;
  final num? costamt;
  final num? slsnett;
  final num? taxpct;
  final num? svchgpct;
  final String? revenuecoa;
  final String? taxcoa;
  final String? svchgcoa;
  final int? slsfl;
  final String? costcoa;
  final String? ctg;
  final num? stock;
  late String? pathimage;
  final String? description;
  final int? trackstock;
  final String? barcode;
  final String? sku;
  final num? slsamt2;
  final num? slsnett2;
  final int? modifiers;
  final List<PriceList>? pricelist;
  final int multiprice;
  final int packageflag;

  Item({
    required this.multiprice,
    required this.packageflag,
    this.id,
    this.outletcode,
    this.itemcode,
    this.subitemcode,
    this.itemdesc,
    this.slsamt,
    this.costamt,
    this.slsnett,
    this.taxpct,
    this.svchgpct,
    this.revenuecoa,
    this.taxcoa,
    this.svchgcoa,
    this.slsfl,
    this.costcoa,
    this.ctg,
    this.stock,
    this.pathimage,
    this.description,
    this.trackstock,
    this.barcode,
    this.sku,
    this.slsamt2,
    this.slsnett2,
    this.modifiers,
    this.pricelist,
  });

  Item.fromJson(
    Map<String, dynamic> res,
  )   : id = res["id"],
        outletcode = res["outletcode"],
        itemcode = res["itemcode"],
        subitemcode = res["subitemcode"],
        itemdesc = res["itemdesc"],
        slsamt = res["slsamt"],
        costamt = res["costamt"],
        slsnett = res["slsnett"],
        taxpct = res["taxpct"],
        svchgpct = res["svchgpct"],
        revenuecoa = res["revenuecoa"],
        taxcoa = res["taxcoa"],
        svchgcoa = res["svchgcoa"],
        slsfl = res["slsfl"],
        costcoa = res["costcoa"],
        ctg = res["ctg"],
        stock = res["stock"],
        pathimage = res["pathimage"],
        description = res["description"],
        trackstock = res["trackstock"],
        barcode = res["barcode"],
        slsamt2 = res["slsamt2"],
        slsnett2 = res["slsnett2"],
        modifiers = res["modifiers"],
        sku = res["sku"],
        multiprice = res["multiprice"],
        packageflag = res["packageflag"],
        pricelist = List<PriceList>.from(
            jsonDecode(res['pricelist']).map((x) => PriceList.fromJson(x)));

  @override
  String toString() {
    return '{"id": $id, "outletcode": $outletcode,"itemcode": $itemcode,"subitemcode":$subitemcode,"itemdesc": $itemdesc,"slsamt": $slsamt,"costamt": $costamt,"slsnett": $slsnett,"taxpct": $taxpct,"svchgpct": $svchgpct,"revenuecoa": $revenuecoa,"taxcoa": $taxcoa,"svchgcoa": $svchgcoa,"slsfl": $slsfl,"costcoa": $costcoa,"ctg": $ctg,"stock": $stock,"pathimage": $pathimage,"description": $description,"trackstock": $trackstock,"barcode": $barcode,"sku": $sku,"slsnett2": $slsnett2,"slsamt2": $slsamt2,"modifiers": $modifiers,"pricelist":$pricelist,"multiprice":$multiprice,packageflag:$packageflag}';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'outletcode': outletcode,
      'itemcode': itemcode,
      'subitemcode': subitemcode,
      'itemdesc': itemdesc,
      'slsamt': slsamt,
      'costamt': costamt,
      'slsnett': slsnett,
      'taxpct': taxpct,
      'svchgpct': svchgpct,
      'revenuecoa': revenuecoa,
      'taxcoa': taxcoa,
      'svchgcoa': svchgcoa,
      'slsfl': slsfl,
      'costcoa': costcoa,
      'ctg': ctg,
      'stock': stock,
      'pathimage': pathimage,
      'description': description,
      'trackstock': trackstock,
      'barcode': barcode,
      'sku': sku,
      'slsnett2': slsnett2,
      'slsamt2': slsamt2,
      'modifiers': modifiers,
      'pricelist': List<dynamic>.from(pricelist!.map((x) => x.toJson())),
      'multiprice': multiprice,
      'packageflag': packageflag
    };
  }
}

class RegisterItem {
  final int? id;
  final String outletcd;
  final String itemcd;
  final String barcode;

  RegisterItem({
    this.id,
    required this.outletcd,
    required this.itemcd,
    required this.barcode,
  });

  RegisterItem.fromMap(
    Map<String, dynamic> res,
  )   : id = res["id"],
        outletcd = res["outletcd"],
        itemcd = res["itemcd"],
        barcode = res["barcode"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'outletcd': outletcd,
      'itemcd': itemcd,
      'barcode': barcode,
    };
  }
}

class Integrasi {
  final int? id;
  final String integrasi;
  final String keyapi;
  final String use;

  Integrasi({
    this.id,
    required this.integrasi,
    required this.keyapi,
    required this.use,
  });

  Integrasi.fromMap(
    Map<String, dynamic> res,
  )   : id = res["id"],
        integrasi = res["integrasi"],
        keyapi = res["keyapi"],
        use = res["use"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'integrasi': integrasi,
      'keyapi': keyapi,
      'use': use,
    };
  }
}

class Ctg {
  final int? id;
  final String ctgcd;
  final String ctgdesc;

  Ctg({
    this.id,
    required this.ctgcd,
    required this.ctgdesc,
  });

  Ctg.fromJson(
    Map<String, dynamic> res,
  )   : id = res["id"],
        ctgcd = res["ctgcd"],
        ctgdesc = res["ctgdesc"];

  @override
  String toString() {
    return '{"id": $id, "ctgcd": $ctgcd,"ctgdesc": $ctgdesc}';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'ctgcd': ctgcd,
      'ctgdesc': ctgdesc,
    };
  }
}

class Package {
  final String? packagecd;
  final String packagedesc;
  final String? packagenote;
  final String itemcode;
  final String itemdesc;
  final int active;
  final int slsfl;
  late int qty;

  Package({
    required this.packagecd,
    required this.packagedesc,
    required this.slsfl,
    this.packagenote,
    required this.itemcode,
    required this.itemdesc,
    required this.active,
    required this.qty,
  });

  Package.fromJson(
    Map<String, dynamic> res,
  )   : packagecd = res["packagecd"],
        packagedesc = res["packagedesc"],
        slsfl = res["slsfl"],
        packagenote = res["packagenote"],
        itemcode = res["itemcode"],
        itemdesc = res["itemdesc"],
        active = res["active"],
        qty = res["qty"];

  @override
  String toString() {
    return '{"packagecd": $packagecd, "packagedesc": $packagedesc,"packagenote": $packagenote,"itemcode": $itemcode,"itemdesc": $itemdesc,"qty": $qty,"active": $active,"slsfl": $slsfl}';
  }

  Map<String, Object?> toJson() {
    return {
      'packagecd': packagecd,
      'packagedesc': packagedesc,
      'packagenote': packagenote,
      'itemcode': itemcode,
      'itemdesc': itemdesc,
      'active': active,
      'slsfl': slsfl,
      'qty': qty,
    };
  }
}

class PriceList {
  final int? id;
  final String transtype;
  final String transdesc;
  late num amount;

  PriceList({
    this.id,
    required this.transtype,
    required this.transdesc,
    required this.amount,
  });

  PriceList.fromJson(
    Map<String, dynamic> res,
  )   : id = res["id"],
        transtype = res["transtype"],
        transdesc = res["transdesc"],
        amount = res["amount"];

  @override
  String toString() {
    return '{"id": $id, "transtype": $transtype,"transdesc": $transdesc,"amount": $amount}';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'transtype': transtype,
      'transdesc': transdesc,
      'amount': amount,
    };
  }
}

class Condiment_Map {
  final String? itemcode;
  final String condimentcode;

  Condiment_Map({
    this.itemcode,
    required this.condimentcode,
  });

  Condiment_Map.fromJson(
    Map<String, dynamic> res,
  )   : itemcode = res["itemcode"],
        condimentcode = res["condimentcode"];

  @override
  String toString() {
    return '{"itemcode": $itemcode, "condimentcode": $condimentcode,}';
  }

  Map<String, Object?> toJson() {
    return {
      'itemcode': itemcode,
      'condimentcode': condimentcode,
    };
  }
}

class Condiment {
  late String? itemcode;
  final String? condimentdesc;
  final String? optioncode;
  final String? optiondesc;
  final num? amount;
  late num? taxamount;
  late num? serviceamount;
  late num? taxpct;
  late num? servicepct;
  final num? qty;
  final num? totalcond;
  late num? nettamount;
  late String condimenttype;
  late bool? isSelected = false;
  final int? active;

  Condiment({
    this.active,
    this.itemcode,
    this.condimentdesc,
    this.optioncode,
    this.optiondesc,
    this.amount,
    this.taxamount,
    this.serviceamount,
    this.taxpct,
    this.servicepct,
    this.qty,
    this.totalcond,
    this.nettamount,
    required this.condimenttype,
    this.isSelected = false,
  });

  Condiment.fromJson(
    Map<String, dynamic> res,
  )   : itemcode = res["itemcode"],
        condimentdesc = res["condimentdesc"],
        optioncode = res["optioncode"],
        optiondesc = res["optiondesc"],
        qty = res["qty"],
        totalcond = res["totalcond"],
        amount = res["amount"],
        taxamount = res["taxamount"],
        serviceamount = res['serviceamount'],
        taxpct = res['taxpct'],
        servicepct = res['servicepct'],
        nettamount = res['nettamount'],
        condimenttype = res["condimenttype"],
        isSelected = res["isSelected"] = false,
        active = res['active'];

  @override
  String toString() {
    return '{"itemcode": $itemcode, "condimentdesc": $condimentdesc,"optioncode": $optioncode,"qty": $qty,"amount": $amount,"taxamount": $taxamount,"taxpct": $taxpct,"servicepct": $servicepct,"serviceamount": $serviceamount,"optiondesc": $optiondesc,"totalcond": $totalcond,"condimenttype": $condimenttype,"nettamount": $nettamount,"isSelected": $isSelected,active:$active}';
  }

  Map<String, Object?> toJson() {
    return {
      'itemcode': itemcode,
      'condimentdesc': condimentdesc,
      'optioncode': optioncode,
      'qty': qty,
      'amount': amount,
      'taxpct': taxpct,
      'servicepct': servicepct,
      'taxamount': taxamount,
      'serviceamount': serviceamount,
      'optiondesc': optiondesc,
      'totalcond': totalcond,
      'condimenttype': condimenttype,
      'nettamount': nettamount,
      'isSelected': isSelected = false,
      'active': active
    };
  }
}

class PosCondiment {
  late String? trdt;
  final String? transno;
  final String? outletcode;
  final String? itemcode;
  final String? condimentcode;
  final String? condimentdesc;
  final String? condimenttype;
  late num? qty;
  final num? rateamt;
  final num? rateamttax;
  final num? rateamtservice;
  late num? totalamt;
  late num? totaltaxamt;
  late num? totalserviceamt;
  final String? createdt;
  late num? totalnett;
  final String? optioncode;
  final String? optiondesc;
  final int itemseq;
  late bool? isSelected;
  late int? qtystarted;

  PosCondiment({
    this.trdt,
    this.transno,
    this.outletcode,
    this.itemcode,
    this.condimentcode,
    this.condimentdesc,
    this.condimenttype,
    required this.itemseq,
    this.qty,
    this.rateamt,
    this.rateamttax,
    this.rateamtservice,
    this.totalamt,
    this.totaltaxamt,
    this.totalserviceamt,
    this.createdt,
    this.totalnett,
    this.optioncode,
    this.optiondesc,
    this.isSelected,
    this.qtystarted,
  });

  PosCondiment.fromJson(
    Map<String, dynamic> res,
  )   : trdt = res["trdt"],
        transno = res["transno"],
        outletcode = res["outletcode"],
        itemcode = res["itemcode"],
        condimentdesc = res["condimentdesc"],
        condimentcode = res["condimentcode"],
        condimenttype = res["condimenttype"],
        itemseq = res["itemseq"],
        qty = res["qty"],
        rateamt = res["rateamt"],
        rateamttax = res["rateamttax"],
        rateamtservice = res["rateamtservice"],
        totalamt = res["totalamt"],
        totaltaxamt = res["totaltaxamt"],
        totalserviceamt = res["totalserviceamt"],
        createdt = res["createdt"],
        totalnett = res["totalnett"],
        optioncode = res["optioncode"],
        optiondesc = res["optiondesc"],
        isSelected = res["isSelected"],
        qtystarted = res['qtystarted'];

  @override
  String toString() {
    return '{"trdt": $trdt, "transno": $transno,"outletcode": $outletcode,"itemcode": $itemcode,"condimentcode": $condimentcode,condimentdesc:$condimentdesc,condimenttype:$condimenttype,qty:$qty,rateamt:$rateamt,rateamttax:$rateamttax,rateamtservice:$rateamtservice,totalamt:$totalamt,totaltaxamt:$totaltaxamt,totalserviceamt:$totalserviceamt,createdt:$createdt,totalnett:$totalnett,optioncode:$optioncode,optiondesc:$optiondesc,itemseq:$itemseq,isSelected:$isSelected,qtystarted:$qtystarted},}';
  }

  Map<String, Object?> toJson() {
    return {
      'trdt': trdt,
      'transno': transno,
      'outletcode': outletcode,
      'itemcode': itemcode,
      'condimentcode': condimentcode,
      'condimentdesc': condimentdesc,
      'condimenttype': condimenttype,
      'itemseq': itemseq,
      'qty': qty,
      'rateamt': rateamt,
      'rateamttax': rateamttax,
      'rateamtservice': rateamtservice,
      'totalamt': totalamt,
      'totaltaxamt': totaltaxamt,
      'totalserviceamt': totalserviceamt,
      "createdt": createdt,
      "totalnett": totalnett,
      "optioncode": optioncode,
      "optiondesc": optiondesc,
      "isSelected": isSelected,
      "qtystarted": qtystarted
    };
  }
}

class OptionsCond {
  final String? code;
  final String? description;
  final num? amount;
  final num? qty;

  OptionsCond({
    this.code,
    this.description,
    this.amount,
    this.qty,
  });

  OptionsCond.fromJson(
    Map<String, dynamic> res,
  )   : code = res["code"],
        description = res["description"],
        amount = res["amount"],
        qty = res["qty"];

  @override
  String toString() {
    return '{"code": $code, "description": $description,"amount": $amount,"qty": $qty}';
  }

  Map<String, Object?> toJson() {
    return {
      'code': code,
      'description': description,
      'amount': amount,
      'qty': qty,
    };
  }
}

class IafjrndtClass {
  final int? id;
  final String? trdt;
  final String? pscd;
  late final String? transno;
  final int? split;
  final String? transno1;
  final String? itemdesc;
  final String? itemcode;
  final String? trno1;
  final int? itemseq;
  final String? cono;
  final String? waitercd;
  final num? discpct;
  final num? discamt;
  final int? qty;
  final String? ratecurcd;
  final num? ratebs1;
  final num? ratebs2;
  final num? rateamtcost;
  final num? rateamtitem;
  final num? rateamtservice;
  final num? rateamttax;
  final num? rateamttotal;
  final num? revenueamt;
  final num? taxamt;
  final num? serviceamt;
  final num? totalaftdisc;
  final num? rebateamt;
  final String? rvncoa;
  final String? taxcoa;
  final String? servicecoa;
  final String? costcoa;
  final int? active;
  final String? usercrt;
  final String? userupd;
  final String? userdel;
  final int? prnkitchen;
  final String? prnkitchentm;
  final String? confirmed;
  final String? description;
  final num? taxpct;
  final num? svchgpct;
  final String? statustrans;
  final String? createdt;
  final String? guestname;
  final List<Condiment>? condimentlist;
  final String? typ;
  final String? optioncode;
  final int? havecond;
  final String? condimenttype;
  final List<PriceList>? pricelist;
  final int? multiprice;
  final String? salestype;
  final String? tablesid;
  final String? note;

  IafjrndtClass(
      {this.salestype,
      this.id,
      this.trdt,
      this.pscd,
      this.transno,
      this.split,
      this.transno1,
      this.itemcode,
      this.itemdesc,
      this.trno1,
      this.itemseq,
      this.cono,
      this.waitercd,
      this.discpct,
      this.discamt,
      this.qty,
      this.ratecurcd,
      this.ratebs1,
      this.ratebs2,
      this.rateamtcost,
      this.rateamtitem,
      this.rateamtservice,
      this.rateamttax,
      this.rateamttotal,
      this.revenueamt,
      this.taxamt,
      this.serviceamt,
      this.totalaftdisc,
      this.rebateamt,
      this.rvncoa,
      this.taxcoa,
      this.servicecoa,
      this.costcoa,
      this.active,
      this.usercrt,
      this.userupd,
      this.userdel,
      this.prnkitchen,
      this.prnkitchentm,
      this.confirmed,
      this.description,
      this.taxpct,
      this.svchgpct,
      this.statustrans,
      this.createdt,
      this.guestname,
      this.condimentlist,
      this.typ,
      this.optioncode,
      this.havecond,
      this.condimenttype,
      this.pricelist,
      this.multiprice,
      this.tablesid,
      this.note});

  IafjrndtClass.fromJson(
    Map<String, dynamic> res,
  )   : id = res["id"],
        trdt = res["trdt"],
        salestype = res["salestype"],
        pscd = res["pscd"],
        transno = res["transno"].toString(),
        split = res["split"],
        transno1 = res["transno"],
        itemcode = res["itemcode"],
        itemdesc = res["itemdesc"],
        trno1 = res["trno1"],
        itemseq = res["itemseq"],
        cono = res["cono"],
        waitercd = res["waitercd"],
        discpct = res["discpct"],
        discamt = res["discamt"],
        qty = res["qty"],
        ratecurcd = res["ratecurcd"],
        ratebs1 = res["ratebs1"],
        ratebs2 = res["ratebs2"],
        rateamtcost = res["rateamtcost"],
        rateamtitem = res["rateamtitem"],
        rateamtservice = res["rateamtservice"],
        rateamttax = res["rateamttax"],
        rateamttotal = res["rateamttotal"],
        revenueamt = res["revenueamt"],
        taxamt = res["taxamt"],
        serviceamt = res["serviceamt"],
        totalaftdisc = res["totalaftdisc"],
        rebateamt = res["rebateamt"],
        rvncoa = res["rvncoa"],
        taxcoa = res["taxcoa"],
        servicecoa = res["servicecoa"],
        costcoa = res["costcoa"],
        active = res["active"],
        usercrt = res["usercrt"],
        userupd = res["userupd"],
        userdel = res["userdel"],
        prnkitchen = res["prnkitchen"],
        prnkitchentm = res["prnkitchentm"],
        confirmed = res["confirmed"],
        description = res["description"],
        taxpct = res["taxpct"],
        svchgpct = res["svchgpct"],
        statustrans = res["statustrans"],
        createdt = res["createdt"],
        guestname = res['guestname'],
        condimentlist = res['condimentlist'],
        typ = res['typ'],
        optioncode = res['optioncode'],
        havecond = res['havecond'],
        condimenttype = res['condimenttype'],
        multiprice = res["multiprice"],
        tablesid = res["tablesid"],
        note = res["note"],
        pricelist = res['pricelist'] != null
            ? List<PriceList>.from(
                jsonDecode(res['pricelist']).map((x) => PriceList.fromJson(x)))
            : [];

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'trdt': trdt,
      'pscd': pscd,
      'transno': transno,
      'split': split,
      'transno1': transno,
      'itemcd': itemcode,
      'itemdesc': itemdesc,
      'trno1': trno1,
      'itemseq': itemseq,
      'cono': cono,
      'waitercd': waitercd,
      'discpct': discpct,
      'discamt': discamt,
      'qty': qty,
      'ratecurcd': ratecurcd,
      'ratebs1': ratebs1,
      'ratebs2': ratebs2,
      'rateamtcost': rateamtcost,
      'rateamtitem': rateamtitem,
      'rateamtservice': rateamtservice,
      'rateamttax': rateamttax,
      'rateamttotal': rateamttotal,
      'revenueamt': revenueamt,
      'taxamt': taxamt,
      'serviceamt': serviceamt,
      'totalaftdisc': totalaftdisc,
      'rebateamt': rebateamt,
      'rvncoa': rvncoa,
      'taxcoa': taxcoa,
      'servicecoa': servicecoa,
      'costcoa': costcoa,
      'active': active,
      'usercrt': usercrt,
      'userupd': userupd,
      'userdel': userdel,
      'prnkitchen': prnkitchen,
      'prnkitchentm': prnkitchentm,
      'confirmed': confirmed,
      'description': description,
      'taxpct': taxpct,
      'svchgpct': svchgpct,
      'statustrans': statustrans,
      'createdt': createdt,
      'guestname': guestname,
      'condimentlist': condimentlist,
      'typ': typ,
      'optioncode': optioncode,
      'havecond': havecond,
      'condimenttype': condimenttype,
      'pricelist': List<dynamic>.from(pricelist!.map((x) => x.toJson())),
      'multiprice': multiprice,
      'salestype': salestype,
      'tablesid': tablesid,
      'note': note
    };
  }

  @override
  String toString() {
    return '{"id": "$id","trdt": "$trdt", "transno": "$transno", "split": "$split","itemdesc": "$itemdesc", "description": "$description","qty": "$qty","rateamtitem": "$rateamtitem","totalaftdisc": "$totalaftdisc","guestname": "$guestname",condimentlist:$condimentlist,createdt:$createdt,typ:$typ,optioncode:$optioncode,havecond:$havecond,condimenttype:$condimenttype,svchgpct:$svchgpct,taxpct:$taxpct,multiprice:$multiprice,pricelist:$pricelist,salestype:$salestype,tablesid:$tablesid,guestname:$guestname,note:$note,revenueamt:$revenueamt,"itemseq":$itemseq}';
  }
}

class IafjrnhdClass {
  final int? id;
  final String? trdt;
  final String? transno;
  final String transno1;
  final int? split;
  final String? pscd;
  final String? docno;
  final String? email;
  final String? trtm;
  final String? disccd;
  final String? pax;
  final String? trdesc;
  final String? trdesc2;
  final String? pymtmthd;
  final String? currcd;
  final String? currbs1;
  final String? currbs2;
  final num? ftotamt;
  final num? totalamt;
  final num? framtrmn;
  final num? amtrmn;
  final String? cardcd;
  final String? cardno;
  final String? cardnm;
  final String? cardexp;
  final String? dpno;
  final String? compcd;
  final String? compdesc;
  final int? active;
  final String? usercrt;
  final String? slstp;
  final String? guestname;
  final String? guestphone;
  final String? virtualaccount;
  final String? billerkey;
  final String? billercode;
  final String? qrcode;
  final String? statustrans;

  IafjrnhdClass({
    this.id,
    this.trdt,
    this.transno,
    required this.transno1,
    this.split,
    this.pscd,
    this.docno,
    this.email,
    this.trtm,
    this.disccd,
    this.pax,
    this.trdesc,
    this.trdesc2,
    this.pymtmthd,
    this.currcd,
    this.currbs1,
    this.currbs2,
    this.ftotamt,
    this.totalamt,
    this.framtrmn,
    this.amtrmn,
    this.cardcd,
    this.cardno,
    this.cardnm,
    this.cardexp,
    this.dpno,
    this.compcd,
    this.compdesc,
    this.active,
    this.usercrt,
    this.slstp,
    this.guestname,
    this.guestphone,
    this.virtualaccount,
    this.billerkey,
    this.billercode,
    this.qrcode,
    this.statustrans,
  });

  IafjrnhdClass.fromJson(
    Map<String, dynamic> res,
  )   : id = res["id"],
        trdt = res["trdt"],
        transno = res["transno"],
        transno1 = res["transno1"],
        split = res["split"],
        pscd = res["pscd"],
        docno = res["docno"],
        email = res["email"],
        trtm = res["trtm"],
        disccd = res["disccd"],
        pax = res["pax"],
        trdesc = res["trdesc"],
        trdesc2 = res["trdesc2"],
        pymtmthd = res["pymtmthd"],
        currcd = res["currcd"],
        currbs1 = res["currbs1"],
        currbs2 = res["currbs2"],
        ftotamt = res["ftotamt"],
        totalamt = res["totalamt"],
        framtrmn = res["framtrmn"],
        amtrmn = res["amtrmn"],
        cardcd = res["cardcd"],
        cardno = res["cardno"],
        cardnm = res["cardnm"],
        cardexp = res["cardexp"],
        dpno = res["dpno"],
        compcd = res["compcd"],
        compdesc = res["compdesc"],
        active = res["active"],
        usercrt = res["usercrt"],
        slstp = res["slstp"],
        guestname = res["guestname"],
        guestphone = res["guestphone"],
        virtualaccount = res['virtualaccount'],
        billerkey = res['billerkey'],
        billercode = res['billercode'],
        qrcode = res['qrcode'],
        statustrans = res['statustrans'];

  @override
  String toString() {
    return '{ "transno": $transno,"transno1": $transno1,"pymtmthd": $pymtmthd,"ftotamt":"$ftotamt","totalamt":"$totalamt"}';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'trdt': trdt,
      'transno': transno,
      'transno1': transno1,
      'split': split,
      'pscd': pscd,
      'docno': docno,
      'email': email,
      'trtm': trtm,
      'disccd': disccd,
      'pax': pax,
      'trdesc': trdesc,
      'trdesc2': trdesc2,
      'pymtmthd': pymtmthd,
      'currcd': currcd,
      'currbs1': currbs1,
      'currbs2': currbs2,
      'ftotamt': ftotamt,
      'totalamt': totalamt,
      'framtrmn': framtrmn,
      'amtrmn': amtrmn,
      'cardcd': cardcd,
      'cardno': cardno,
      'cardnm': cardnm,
      'cardexp': cardexp,
      'dpno': dpno,
      'compcd': compcd,
      'compdesc': compdesc,
      'active': active,
      'usercrt': usercrt,
      'slstp': slstp,
      'guestname': guestname,
      'guestphone': guestphone,
      'virtualaccount': virtualaccount,
      'billerkey': billerkey,
      'billercode': billercode,
      'qrcode': qrcode,
    };
  }

  getIndex(int index) {
    switch (index) {
      case 0:
        return transno;
      case 1:
        return pymtmthd.toString();
      case 2:
        return CurrencyFormat.convertToIdr(ftotamt, 0);
    }
    return '';
  }

  final formatCurrency = new NumberFormat.currency(name: '', decimalDigits: 0);
}

class Midtransitem {
  final String id;
  final num price;
  final num? quantity;
  final String? name;

  Midtransitem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.name,
  });

  Midtransitem.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        price = res["price"],
        quantity = res["quantity"],
        name = res["name"];

  @override
  String toString() {
    return '{"id": "$id","price": $price, "quantity": $quantity,"name":"$name"}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'quantity': quantity,
        'name': name,
      };
}

class Getstatus {
  final String roomtpcd;
  final String roomno;
  final String roomsthk1;
  final String roomsthk2;
  final String roomsthk3;
  final String warna;
  final String floorcd;
  final String notes;
  final String foprd;
  final String roomstatus;
  final String remark;

  const Getstatus(
      {this.roomtpcd = '',
      this.roomno = '',
      this.roomstatus = '',
      this.roomsthk1 = '',
      this.roomsthk2 = '',
      this.roomsthk3 = '',
      this.warna = '',
      this.floorcd = '',
      this.notes = '',
      this.foprd = '',
      this.remark = ''});

  factory Getstatus.fromJson(Map<String, dynamic> json) => Getstatus(
      roomtpcd: json['roomtpcd'].toString(),
      roomno: json['roomno'].toString(),
      roomsthk1: json['roomsthk1'].toString(),
      roomsthk2: json['roomsthk2'].toString(),
      roomsthk3: json['roomsthk3'].toString(),
      warna: json['warna'].toString(),
      floorcd: json['floorcd'].toString(),
      notes: json['notes'].toString(),
      foprd: json['foprd'].toString(),
      remark: json['remark'].toString(),
      roomstatus: json['roomstatus'].toString());
  @override
  String toString() {
    return 'Fosroom{roomno: $roomno,  roomsthk1: $roomsthk2, roomsthk2: $roomsthk3,roomtpcd:$roomtpcd,floorcd:$floorcd,notes:$notes,foprd:$foprd,remark:$remark,roomstatus:$roomstatus}';
  }

  Map<String, dynamic> toJson() => {
        'roomno': roomno,
        'roomsthk1': roomsthk1,
        'roomsthk2': roomsthk2,
        'roomsthk3': roomsthk3,
        'roomtpcd': roomtpcd,
        'notes': notes,
        'remark': remark,
        'roomstatus': roomstatus
      };
}

class Costumers {
  final String? customercd;
  final String fullname;
  final String? title;
  final String? phone;
  final String? email;
  final String? workkom;
  final String? address;
  final num? points;
  final String? memberfrom;

  Costumers({
    this.customercd,
    required this.fullname,
    this.title,
    this.email,
    this.workkom,
    this.address,
    this.phone,
    this.points,
    this.memberfrom,
  });

  Costumers.fromJson(Map<String, dynamic> res)
      : customercd = res["customercd"],
        fullname = res["fullname"],
        title = res["title"],
        email = res["email"],
        workkom = res["workkom"],
        address = res["address"],
        phone = res["phone"],
        points = res["points"],
        memberfrom = res["memberfrom"];
  @override
  String toString() {
    return '{customercd: $customercd,  fullname: $fullname, title: $title,email:$email,workkom:$workkom,address:$address,phone:$phone,points:$points,memberfrom:$memberfrom}';
  }

  Map<String, Object?> toJson() {
    return {
      'customercd': customercd,
      'fullname': fullname,
      'title': title,
      'email': email,
      'workkom': workkom,
      'address': address,
      'phone': phone,
      'points': points,
      'memberfrom': memberfrom,
    };
  }
}

class CostumersSavedManual {
  final int? id;
  final String outletcd;
  final String? trno;
  final String? nama;
  final String? telp;
  final String? email;
  final String? alamat;

  CostumersSavedManual({
    this.id,
    required this.outletcd,
    this.trno,
    this.nama,
    this.telp,
    this.email,
    this.alamat,
  });

  CostumersSavedManual.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        outletcd = res["outletcd"],
        trno = res["trno"],
        nama = res["nama"],
        telp = res["telp"],
        email = res["email"],
        alamat = res["alamat"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'outletcd': outletcd,
      'trno': trno,
      'nama': nama,
      'telp': telp,
      'email': email,
      'alamat': alamat,
    };
  }
}

class RewardCLass {
  final String? loyalitycd;
  final String rewaradtype;
  final num? redempoint;
  final num? reward;
  final num? minimum;
  final String? note;

  RewardCLass({
    this.loyalitycd,
    required this.rewaradtype,
    required this.minimum,
    this.redempoint,
    this.reward,
    this.note,
  });

  RewardCLass.fromJson(Map<String, dynamic> res)
      : loyalitycd = res["loyalitycd"],
        rewaradtype = res["rewaradtype"],
        redempoint = res["redempoint"],
        reward = res["reward"],
        minimum = res["minimum"],
        note = res["note"];

  Map<String, Object?> toJson() {
    return {
      'loyalitycd': loyalitycd,
      'rewaradtype': rewaradtype,
      'redempoint': redempoint,
      'reward': reward,
      'note': note,
    };
  }
}

class PointSystem {
  final String? fromdate;
  final String todate;
  final num? type;
  final num? convamount;
  final num? point;
  final String? joinreward;

  PointSystem({
    this.fromdate,
    required this.todate,
    required this.type,
    this.convamount,
    this.point,
    this.joinreward,
  });

  PointSystem.fromJson(Map<String, dynamic> res)
      : fromdate = res["fromdate"],
        todate = res["todate"],
        type = res["type"],
        convamount = res["convamount"],
        point = res["point"],
        joinreward = res["joinreward"];

  Map<String, Object?> toJson() {
    return {
      'fromdate': fromdate,
      'todate': todate,
      'type': type,
      'convamount': convamount,
      'point': point,
      'joinreward': joinreward,
    };
  }
}

class Promo {
  final int? id;
  final String promocd;
  final String? promodesc;
  final String? type;
  final num? pct;
  final num? amount;
  final num? mindisc;
  final num? maxdisc;

  Promo({
    this.id,
    required this.promocd,
    this.promodesc,
    this.type,
    this.pct,
    this.amount,
    this.mindisc,
    this.maxdisc,
  });

  Promo.fromJson(Map<String, dynamic> res)
      : id = res["id"],
        promocd = res["promocd"],
        promodesc = res["promodesc"],
        type = res["type"],
        pct = res["pct"],
        amount = res["amount"],
        mindisc = res["mindisc"],
        maxdisc = res["maxdisc"];

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'promocd': promocd,
      'promodesc': promodesc,
      'type': type,
      'pct': pct,
      'amount': amount,
      'mindisc': mindisc,
      'maxdisc': maxdisc,
    };
  }
}

class Gntrantp {
  final int? id;
  final String progcd;
  final String? ProgNm;
  final String? refprefix;
  final String? profile;
  final int? trnonext;

  Gntrantp({
    this.id,
    required this.progcd,
    this.ProgNm,
    this.refprefix,
    this.trnonext,
    this.profile,
  });

  Gntrantp.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        progcd = res["progcd"],
        ProgNm = res["ProgNm"],
        refprefix = res["refprefix"],
        trnonext = res["trnonext"],
        profile = res["profile"];

  @override
  String toString() {
    return '{"progcd": $progcd,"ProgNm": $ProgNm,"refprefix": $refprefix,"trnonext": $trnonext,profile:$profile}';
  }

  /// toJson original to object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'progcd': progcd,
      'ProgNm': ProgNm,
      'refprefix': refprefix,
      'trnonext': trnonext,
      'profile': profile
    };
  }
}

class Glftrdt {
  final int? id;
  final String trno;
  final String? prodcd;
  final String? proddesc;
  final String? subtrno;
  final String? cbcd;
  final String? compcd;
  final String? whto;
  final String? whfr;
  final double? qtyconv;
  final String? unituse;
  final String? currcd;
  final double? baseamt1;
  final double? baseamt2;
  final double? unitamt;
  final double? totalprice;
  final double? taxpct;
  final double? taxamt;
  final double? discpct;
  final double? discamount;
  final double? totalaftdisctax;
  final String? trcoa;
  final double? fdbamt;
  final double? fcramt;
  final double? ldbamt;
  final double? lcramt;
  final String? trdt;
  final String? notes;
  final String? trtpcd;
  final int? active;
  final String? prd;
  final String? supcd;
  final double? qtyremain;
  final int itemseq;

  Glftrdt({
    this.id,
    required this.trno,
    this.prodcd,
    this.proddesc,
    this.subtrno,
    this.cbcd,
    this.compcd,
    this.whto,
    this.whfr,
    this.qtyconv,
    this.unituse,
    this.currcd,
    this.baseamt1,
    this.baseamt2,
    this.unitamt,
    this.totalprice,
    this.taxpct,
    this.taxamt,
    this.discpct,
    this.discamount,
    this.totalaftdisctax,
    this.trcoa,
    this.fdbamt,
    this.fcramt,
    this.ldbamt,
    this.lcramt,
    this.trdt,
    this.notes,
    this.trtpcd,
    this.active,
    this.prd,
    this.supcd,
    this.qtyremain,
    required this.itemseq,
  });

  Glftrdt.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        trno = res["trno"],
        prodcd = res["prodcd"],
        proddesc = res["proddesc"],
        subtrno = res["subtrno"],
        cbcd = res["cbcd"],
        compcd = res["compcd"],
        whto = res["whto"],
        whfr = res["whfr"],
        qtyconv = res["qtyconv"],
        unituse = res["unituse"],
        currcd = res["currcd"],
        baseamt1 = res["baseamt1"],
        baseamt2 = res["baseamt2"],
        unitamt = res["unitamt"],
        totalprice = res["totalprice"],
        taxpct = res["taxpct"],
        taxamt = res["taxamt"],
        discpct = res["discpct"],
        discamount = res["discamount"],
        totalaftdisctax = res["totalaftdisctax"],
        trcoa = res["trcoa"],
        fdbamt = res["fdbamt"],
        fcramt = res["fcramt"],
        ldbamt = res["ldbamt"],
        lcramt = res["lcramt"],
        trdt = res["trdt"],
        notes = res["notes"],
        trtpcd = res["trtpcd"],
        active = res["active"],
        prd = res["prd"],
        supcd = res["supcd"],
        qtyremain = res["qtyremain"],
        itemseq = res["itemseq"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'trno': trno,
      'prodcd': prodcd,
      'proddesc': proddesc,
      'subtrno': subtrno,
      'cbcd': cbcd,
      'compcd': compcd,
      'whto': whto,
      'whfr': whfr,
      'qtyconv': qtyconv,
      'unituse': unituse,
      'currcd': currcd,
      'baseamt1': baseamt1,
      'baseamt2': baseamt2,
      'unitamt': unitamt,
      'totalprice': totalprice,
      'taxpct': taxpct,
      'taxamt': taxamt,
      'discpct': discpct,
      'discamount': discamount,
      'totalaftdisctax': totalaftdisctax,
      'trcoa': trcoa,
      'fdbamt': fdbamt,
      'fcramt': fcramt,
      'ldbamt': ldbamt,
      'lcramt': lcramt,
      'trdt': trdt,
      'notes': notes,
      'trtpcd': trtpcd,
      'active': active,
      'prd': prd,
      'supcd': supcd,
      'qtyremain': qtyremain,
      'itemseq': itemseq,
    };
  }
}

class ItemMail {
  final String item;
  final num harga;

  ItemMail({
    required this.item,
    required this.harga,
  });

  ItemMail.fromMap(Map<String, dynamic> res)
      : item = res["item"],
        harga = res["harga"];

  @override
  String toString() {
    return '{"item": $item, "harga": $harga,}';
  }

  Map<String, dynamic> toJson() => {
        'item': item,
        'harga': harga,
      };
}

class PaymentEmail {
  final String metode;
  final num jumlah;

  PaymentEmail({
    required this.metode,
    required this.jumlah,
  });

  PaymentEmail.fromMap(Map<String, dynamic> res)
      : metode = res["metode"],
        jumlah = res["jumlah"];

  @override
  String toString() {
    return '{"metode": $metode, "jumlah": $jumlah,}';
  }

  Map<String, dynamic> toJson() => {
        'metode': metode,
        'jumlah': jumlah,
      };
}

class TransactionTipe {
  late String? transtype;
  late String? transdesc;
  final int? active;
  final int? id;

  TransactionTipe({this.transtype, this.transdesc, this.active, this.id});

  TransactionTipe.fromJson(Map<String, dynamic> res)
      : transtype = res["transtype"],
        transdesc = res["transdesc"],
        id = res["id"],
        active = res["active"];

  @override
  String toString() {
    return '{"transtype": $transtype, "transdesc": $transdesc, "active": $active,"id": $id,}';
  }

  Map<String, dynamic> toJson() => {
        'transtype': transtype,
        'transdesc': transdesc,
        'active': active,
        'id': id,
      };
}

class TableMaster {
  late String? tablecd;
  late String? sectioncd;
  final int? posx;
  final int? posy;
  final int? id;

  TableMaster({this.tablecd, this.sectioncd, this.posx, this.posy, this.id});

  TableMaster.fromJson(Map<String, dynamic> res)
      : tablecd = res["tablecd"],
        sectioncd = res["sectioncd"],
        posx = res["posx"],
        posy = res["posy"],
        id = res["id"];

  @override
  String toString() {
    return '{"tablecd": $tablecd, "sectioncd": $sectioncd, "posx": $posx,"posy": $posy,"id": $id,}';
  }

  Map<String, dynamic> toJson() => {
        'tablecd': tablecd,
        'sectioncd': sectioncd,
        'posx': posx,
        'posy': posy,
        'id': id
      };
}

class PaymentMaster {
  late String? paymentcd;
  late String? paymentdesc;
  final String? typ;
  final String? coacomp;
  final String? clactive;
  final int? active;
  final String? coapayment;
  final String? email;
  final String? telp;
  final num? limits;
  final String? pic;
  final int? id;

  PaymentMaster(
      {this.paymentcd,
      this.paymentdesc,
      this.typ,
      this.coacomp,
      this.clactive,
      this.active,
      this.coapayment,
      this.email,
      this.telp,
      this.limits,
      this.pic,
      this.id});

  PaymentMaster.fromJson(Map<String, dynamic> res)
      : paymentcd = res["paymentcd"],
        paymentdesc = res["paymentdesc"],
        typ = res["typ"],
        coacomp = res["coacomp"],
        active = res["active"],
        coapayment = res["coapayment"],
        email = res["email"],
        telp = res["telp"],
        limits = res["limits"],
        pic = res["pic"],
        id = res["id"],
        clactive = res["clactive"];

  @override
  String toString() {
    return '{"paymentcd": $paymentcd, "paymentdesc": $paymentdesc, "typ": $typ,"coacomp": $coacomp,"active": $active,"coapayment": $coapayment,"email": $email,"telp": $telp,"limits": $limits,"pic": $pic,"id": $id,"clactive": $clactive}';
  }

  Map<String, dynamic> toJson() => {
        'paymentcd': paymentcd,
        'paymentdesc': paymentdesc,
        'typ': typ,
        'coacomp': coacomp,
        'active': active,
        'coapayment': coapayment,
        'email': email,
        'telp': telp,
        'limits': limits,
        'pic': pic,
        'clactive': clactive,
        'id': id
      };
}

class Ringkasan {
  final String trdesc;
  final num amount;

  final num qtyterjual;
  final num totaltransaksi;

  Ringkasan({
    required this.trdesc,
    required this.amount,
    required this.qtyterjual,
    required this.totaltransaksi,
  });

  Ringkasan.fromMap(Map<String, dynamic> res)
      : trdesc = res["trdesc"],
        amount = res["amount"],
        qtyterjual = res["qtyterjual"],
        totaltransaksi = res["totaltransaksi"];

  @override
  String toString() {
    return '{"trdesc": $trdesc,"amount": $amount, "qtyterjual": $qtyterjual,"totaltransaksi": $totaltransaksi,}';
  }

  Map<String, dynamic> toJson() => {
        'trdesc': trdesc,
        'penjualan': amount,
        'qtyterjual': qtyterjual,
        'totaltransaksi': totaltransaksi,
      };
}

class TypeCondiment {
  final String opsidesc;
  final String opsitype;
  TypeCondiment({
    required this.opsidesc,
    required this.opsitype,
  });

  TypeCondiment.fromMap(Map<String, dynamic> res)
      : opsidesc = res["opsidesc"],
        opsitype = res["opsitype"];

  @override
  String toString() {
    return '{"opsidesc": $opsidesc,"opsitype": $opsitype}';
  }

  Map<String, dynamic> toJson() => {
        'opsidesc': opsidesc,
        'opsitype': opsitype,
      };
}

class SelectedItems {
  final String name;
  bool isSelected;

  SelectedItems({required this.name, this.isSelected = false});
}

class TextEditingCondiment {
  final String opsicode;
  final String opsidesc;
  final TextEditingController controller;

  TextEditingCondiment({
    required this.opsicode,
    required this.opsidesc,
    required this.controller,
  });

  TextEditingCondiment.fromMap(Map<String, dynamic> res)
      : opsicode = res["opsicode"],
        opsidesc = res["opsidesc"],
        controller = res["controller"];

  @override
  String toString() {
    return '{"opsicode": $opsicode,"opsidesc": $opsidesc,"controller": $controller}';
  }

  Map<String, dynamic> toJson() => {
        'opsicode': opsicode,
        'opsidesc': opsidesc,
        'controller': controller,
      };
}

class UserInfoSys {
  final String? usercode;
  final String fullname;
  final String? email;
  final String urlpic;
  final String uuid;
  final String token;
  final String lastsignin;

  UserInfoSys({
    this.usercode,
    required this.fullname,
    this.email,
    required this.urlpic,
    required this.uuid,
    required this.token,
    required this.lastsignin,
  });

  UserInfoSys.fromMap(Map<String, dynamic> res)
      : usercode = res["usercode"],
        fullname = res["fullname"],
        email = res["email"],
        urlpic = res["urlpic"],
        uuid = res["uuid"],
        token = res["token"],
        lastsignin = res["lastsignin"];

  @override
  String toString() {
    return '{"usercode": $usercode,"fullname": $fullname,"email": $email,"urlpic": $urlpic,"uuid": $uuid,"token": $token,"lastsignin": $lastsignin}';
  }

  Map<String, dynamic> toJson() => {
        'usercode': usercode,
        'fullname': fullname,
        'email': email,
        'urlpic': urlpic,
        'uuid': uuid,
        'token': token,
        'lastsignin': lastsignin,
      };
}
