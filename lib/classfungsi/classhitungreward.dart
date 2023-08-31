import 'package:posq/userinfo.dart';

class Pembelian {
  num totalHarga;
  num minconvamount;
  num point;

  Pembelian(this.totalHarga, this.minconvamount, this.point);

  num hitungPoin() {
    print('ini rules active : ${rulesprogram.convamount}');
    if (totalHarga >= minconvamount) {
      print('Point bertambah : ${(totalHarga ~/ minconvamount) * point}');
      return (totalHarga ~/ minconvamount) * point;
    } else {
      return 0;
    }
  }
}
