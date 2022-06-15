class Outlet {
  final int? id;
  final String outletcd;
  final String? outletname;
  final num? telp;
  final String? alamat;
  final String? kodepos;
  final int? trnonext;
  final int? trnopynext;

  Outlet({
    this.id,
    required this.outletcd,
    this.outletname,
    this.telp,
    this.alamat,
    this.kodepos,
    this.trnonext,
    this.trnopynext,
  });

  Outlet.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        outletcd = res["outletcd"],
        outletname = res["outletname"],
        telp = res["telp"],
        alamat = res["alamat"],
        kodepos = res["kodepos"].toString(),
        trnonext = res["trnonext"],
        trnopynext = res["trnopynext"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'outletcd': outletcd,
      'outletname': outletname,
      'telp': telp,
      'alamat': alamat,
      'kodepos': kodepos.toString(),
      'trnonext': trnonext,
      'trnopynext': trnopynext
    };
  }
}

class Item {
  final int? id;
  final String outletcd;
  final String itemcd;
  final String itemdesc;
  final num? slsamt;
  final num? costamt;
  final num? slsnett;
  final num taxpct;
  final num svchgpct;
  final String revenuecoa;
  final String taxcoa;
  final String? svchgcoa;
  final int slsfl;
  final String costcoa;
  final String? ctg;
  final num? stock;
  final String? pathimage;
  final String? description;

  Item({
    this.id,
    required this.outletcd,
    required this.itemcd,
    required this.itemdesc,
    required this.slsamt,
    required this.costamt,
    required this.slsnett,
    required this.taxpct,
    required this.svchgpct,
    required this.revenuecoa,
    required this.taxcoa,
    required this.svchgcoa,
    required this.slsfl,
    required this.costcoa,
    required this.ctg,
    required this.stock,
    this.pathimage,
    this.description,
  });

  Item.fromMap(
    Map<String, dynamic> res,
  )   : id = res["id"],
        outletcd = res["outletcd"],
        itemcd = res["itemcd"],
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
        description = res["description"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'outletcd': outletcd,
      'itemcd': itemcd,
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

class Ctg {
  final int? id;
  final String ctgcd;
  final String ctgdesc;

  Ctg({
    this.id,
    required this.ctgcd,
    required this.ctgdesc,
  });

  Ctg.fromMap(
    Map<String, dynamic> res,
  )   : id = res["id"],
        ctgcd = res["ctgcd"],
        ctgdesc = res["ctgdesc"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'ctgcd': ctgcd,
      'ctgdesc': ctgdesc,
    };
  }
}

class IafjrndtClass {
  final int? id;
  final String? trdt;
  final String? pscd;
  late final String? trno;
  final String? split;
  final String? trnobill;
  final String? itemcd;
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
  final num? rateamt;
  final num? rateamtservice;
  final num? rateamttax;
  final num? rateamttotal;
  final num? rvnamt;
  final num? taxamt;
  final num? serviceamt;
  final num? nettamt;
  final num? rebateamt;
  final String? rvncoa;
  final String? taxcoa;
  final String? servicecoa;
  final String? costcoa;
  final String? active;
  final String? usercrt;
  final String? userupd;
  final String? userdel;
  final String? prnkitchen;
  final String? prnkitchentm;
  final String? confirmed;
  final String? trdesc;
  final num? taxpct;
  final num? servicepct;
  // final String? guestname;
  // final String? email;
  // final String? phone;

  IafjrndtClass({
    this.id,
    this.trdt,
    this.pscd,
    this.trno,
    this.split,
    this.trnobill,
    this.itemcd,
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
    this.rateamt,
    this.rateamtservice,
    this.rateamttax,
    this.rateamttotal,
    this.rvnamt,
    this.taxamt,
    this.serviceamt,
    this.nettamt,
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
    this.trdesc,
    this.taxpct,
    this.servicepct,
    // this.guestname,
    // this.email,
    // this.phone,
  });

  IafjrndtClass.fromMap(
    Map<String, dynamic> res,
  )   : id = res["id"],
        trdt = res["trdt"],
        pscd = res["pscd"],
        trno = res["trno"].toString(),
        split = res["split"],
        trnobill = res["trnobill"],
        itemcd = res["itemcd"],
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
        rateamt = res["rateamt"],
        rateamtservice = res["rateamtservice"],
        rateamttax = res["rateamttax"],
        rateamttotal = res["rateamttotal"],
        rvnamt = res["rvnamt"],
        taxamt = res["taxamt"],
        serviceamt = res["serviceamt"],
        nettamt = res["nettamt"],
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
        trdesc = res["trdesc"],
        taxpct = res["taxpct"],
        servicepct = res["servicepct"]
  // guestname = res['guestname'],
  // email = res['email'],
  // phone = res['phone']

  ;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'trdt': trdt,
      'pscd': pscd,
      'trno': trno,
      'split': split,
      'trnobill': trnobill,
      'itemcd': itemcd,
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
      'rateamt': rateamt,
      'rateamtservice': rateamtservice,
      'rateamttax': rateamttax,
      'rateamttotal': rateamttotal,
      'rvnamt': rvnamt,
      'taxamt': taxamt,
      'serviceamt': serviceamt,
      'nettamt': nettamt,
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
      'trdesc': trdesc,
      'taxpct': taxpct,
      'servicepct': servicepct
      // 'guestname': guestname,
      // 'email': email,
      // 'phone': phone,
    };
  }
}

class IafjrnhdClass {
  final int? id;
  final String? trdt;
  final String? trno;
  final String? split;
  final String? pscd;
  final String? docno;
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
  final String? active;
  final String? usercrt;
  final String? slstp;
  final String? guestname;
  final String? guestphone;
  final String? virtualaccount;
  final String? billerkey;
  final String? billercode;
  final String? qrcode;

  IafjrnhdClass({
    this.id,
    this.trdt,
    this.trno,
    this.split,
    this.pscd,
    this.docno,
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
  });

  IafjrnhdClass.fromMap(
    Map<String, dynamic> res,
  )   : id = res["id"],
        trdt = res["trdt"],
        trno = res["trno"],
        split = res["split"],
        pscd = res["pscd"],
        docno = res["docno"],
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
        qrcode = res['qrcode'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'trdt': trdt,
      'trno': trno,
      'split': split,
      'pscd': pscd,
      'docno': docno,
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
  final int? id;
  final String compcd;
  final String? compdesc;
  final String? category;
  final String? coaar;
  final String? coapayment;
  final String? address;
  final String? telp;
  final String? pic;
  final String? email;
  final int? active;

  Costumers({
    this.id,
    required this.compcd,
    this.compdesc,
    this.category,
    this.coaar,
    this.coapayment,
    this.address,
    this.telp,
    this.pic,
    this.email,
    this.active,
  });

  Costumers.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        compcd = res["compcd"],
        compdesc = res["compdesc"],
        category = res["category"],
        coaar = res["coaar"],
        coapayment = res["coapayment"],
        address = res["address"],
        telp = res["telp"],
        pic = res["pic"],
        email = res["email"],
        active = res["active"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'compcd': compcd,
      'compdesc': compdesc,
      'category': category,
      'coaar': coaar,
      'coapayment': coapayment,
      'address': address,
      'telp': telp,
      'pic': pic,
      'email': email,
      'active': active
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

  Promo.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        promocd = res["promocd"],
        promodesc = res["promodesc"],
        type = res["type"],
        pct = res["pct"],
        amount = res["amount"],
        mindisc = res["mindisc"],
        maxdisc = res["maxdisc"];

  Map<String, Object?> toMap() {
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
