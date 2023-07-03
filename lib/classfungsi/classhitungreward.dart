import 'package:posq/userinfo.dart';

class Pembelian {
  num totalHarga;

  Pembelian(this.totalHarga);

  num hitungPoin() {
    if (totalHarga >= rulesprogram.convamount!) {
      return (totalHarga ~/ rulesprogram.convamount!) * rulesprogram.point!;
    } else {
      return 0;
    }
  }
}
