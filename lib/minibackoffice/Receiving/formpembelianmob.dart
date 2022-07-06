import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/minibackoffice/selectproduct.dart';
import 'package:posq/model.dart';
import 'package:toast/toast.dart';

class ClassPembelianMobile extends StatefulWidget {
  final Outlet pscd;
  final Gntrantp trtpcd;
  final data;

  const ClassPembelianMobile({
    Key? key,
    required this.pscd,
    required this.trtpcd,
    this.data,
  }) : super(key: key);

  @override
  State<ClassPembelianMobile> createState() => _ClassPembelianMobileState();
}

class _ClassPembelianMobileState extends State<ClassPembelianMobile> {
  late DatabaseHandler handler;
  String query = '';
  String? formattedDate;
  String? formatdate;
  String? periode;
  TextEditingController _penjual = TextEditingController();
  TextEditingController _note = TextEditingController();
  TextEditingController _unit = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController unitprice = TextEditingController();
  TextEditingController totalprice = TextEditingController();
  TextEditingController _product = TextEditingController(text: 'pilih produk');
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formatter2 = DateFormat('dd-MM-yyyy');
  var formaterprd = DateFormat('yyyyMM');
  Item? items;
  int itemseq = 1;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != now) {
      setState(() {
        now = picked;
        formattedDate = formatter2.format(now);
        formatdate = formatter.format(now);
        periode = formaterprd.format(now);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      // items = widget.data;
      _penjual.text = widget.data!['supcd'];
      _note.text = widget.data!['notes'];
      _unit.text = widget.data!['unituse'];
      _product.text = widget.data!['proddesc'];
      qty.text = widget.data!['qtyconv'].toString();
      unitprice.text = widget.data!['unitamt'].toString();
      totalprice.text = widget.data!['totalprice'].toString();
    }
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    periode = formaterprd.format(now);
    handler = DatabaseHandler();
    ToastContext().init(context);
  }

  Future<int> addJournalDebit(
    Item items,
  ) async {
    print(items);
    //stok tidak bertambah karena trtpcd tidak terbaca/////
    print(widget.trtpcd.trtp);
    Glftrdt debit = Glftrdt(
      trno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      prodcd: items.itemcd,
      proddesc:  _product.text,
      subtrno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      cbcd: '',
      compcd: '',
      whto: widget.pscd.outletcd,
      whfr: '',
      supcd: _penjual.text,
      qtyconv: double.parse(qty.text),
      unituse: 'unit',
      currcd: 'Rupiah',
      baseamt1: 1,
      baseamt2: 1,
      unitamt: double.parse(unitprice.text),
      totalprice: double.parse(totalprice.text),
      taxpct: 0,
      taxamt: 0,
      discpct: 0,
      discamount: 0,
      totalaftdisctax: double.parse(totalprice.text),
      trcoa: 'Inventory',
      fdbamt: double.parse(totalprice.text),
      fcramt: 0,
      ldbamt: double.parse(totalprice.text),
      lcramt: 0,
      trdt: formatdate,
      notes: _note.text,
      trtpcd: widget.trtpcd.trtp,
      active: 1,
      prd: periode!,
      qtyremain: double.parse(qty.text),
      itemseq: itemseq,
    );

    List<Glftrdt> listtransaksi = [debit];

    return await handler.insertGltrdt(listtransaksi);
  }

  Future<int> addJournalCredit(
    Item items,
  ) async {
     print(items);
    Glftrdt credit = Glftrdt(
      trno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      prodcd: items.itemcd,
      proddesc:  _product.text,
      subtrno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      cbcd: '',
      compcd: '',
      supcd: _penjual.text,
      whto: widget.pscd.outletcd,
      whfr: '',
      qtyconv: double.parse(qty.text),
      unituse: 'Unit',
      currcd: 'Rupiah',
      baseamt1: 1,
      baseamt2: 1,
      unitamt: double.parse(unitprice.text),
      totalprice: double.parse(totalprice.text),
      taxpct: 0,
      taxamt: 0,
      discpct: 0,
      discamount: 0,
      totalaftdisctax: 0,
      trcoa: 'AP-Pembelian',
      fdbamt: 0,
      fcramt: double.parse(totalprice.text),
      ldbamt: 0,
      lcramt: double.parse(totalprice.text),
      trdt: formatdate,
      notes: _note.text,
      trtpcd: widget.trtpcd.trtp,
      active: 1,
      prd: periode!,
      qtyremain: double.parse(qty.text),
      itemseq: itemseq,
    );
    List<Glftrdt> listtransaksi = [credit];

    return await handler.insertGltrdt(listtransaksi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Pembelian Barang'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text('Tanggal Transaksi'),
                ),
                Container(
                  child: ButtonNoIcon(
                    name: formattedDate,
                    textcolor: Colors.blue,
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                    onpressed: () async {
                      await _selectDate(context);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Text('Nomer Transaksi : '),
                Text(widget.trtpcd.refprefix! +
                    periode! +
                    '-' +
                    widget.trtpcd.trnonext.toString())
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 1,
                  child: TextFieldMobile2(
                    label: 'Penjual',
                    controller: _penjual,
                    onChanged: (value) {},
                    typekeyboard: TextInputType.text,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 1,
                  child: TextFieldMobile2(
                    label: 'Catatan',
                    controller: _note,
                    onChanged: (value) {},
                    typekeyboard: TextInputType.text,
                  ),
                ),
              ],
            ),
            TextFieldMobileButton(
                hint: 'Pilih Produk',
                controller: _product,
                typekeyboard: TextInputType.text,
                onChanged: (value) {},
                ontap: () async {
                  items = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectProductMobile()),
                  );
                  setState(() {
                    if (items != null) {
                      _product.text = items!.itemdesc ?? 'Pilih Produk';
                      print(items!.itemdesc);
                    }
                  });
                }),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFieldMobile2(
                    label: 'Qty',
                    controller: qty,
                    onChanged: (value) {
                      if (qty.text != '' ||
                          qty.text != '0' ||
                          qty.text.isNotEmpty) {
                        setState(() {
                          totalprice.text =
                              (num.parse(unitprice.text) * num.parse(qty.text))
                                  .toString();
                        });
                      } else {}
                    },
                    typekeyboard: TextInputType.number,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextFieldMobile2(
                    readonly: true,
                    label: 'Unit',
                    controller: _unit,
                    onChanged: (value) {},
                    typekeyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: TextFieldMobile2(
                    label: 'Harga satuan',
                    controller: unitprice,
                    onChanged: (value) {
                      if (qty.text != '' ||
                          qty.text != '0' ||
                          qty.text.isNotEmpty) {
                        setState(() {
                          totalprice.text =
                              (num.parse(unitprice.text) * num.parse(qty.text))
                                  .toString();
                        });
                      } else {}
                    },
                    typekeyboard: TextInputType.number,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: TextFieldMobile2(
                    label: 'Harga total',
                    controller: totalprice,
                    onChanged: (value) {
                      if (qty.text != '' ||
                          qty.text != '0' ||
                          qty.text.isNotEmpty) {
                        setState(() {
                          unitprice.text =
                              (num.parse(totalprice.text) / num.parse(qty.text))
                                  .toString();
                        });
                      } else {}
                    },
                    typekeyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                TextButton(onPressed: () {}, child: Text('Detail Transaksi'))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: ButtonNoIcon2(
                    name: 'Simpan',
                    textcolor: Colors.blue,
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                    onpressed: () async {
                      await addJournalDebit(items!).whenComplete(() {
                        Toast.show("Pembelian Sukses",
                            duration: Toast.lengthLong, gravity: Toast.center);
                      });
                      await addJournalCredit(items!).whenComplete(() {
                        Toast.show("Pembelian Sukses",
                            duration: Toast.lengthLong, gravity: Toast.center);
                      });
                      setState(() {
                        qty.clear();
                        _note.clear();
                        unitprice.clear();
                        totalprice.clear();
                        itemseq++;
                      });
                    },
                  ),
                ),
                Container(
                  child: ButtonNoIcon2(
                    name: 'Selesai',
                    textcolor: Colors.white,
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.3,
                    onpressed: () async {
                      await addJournalDebit(items!).whenComplete(() async {
                        await addJournalCredit(items!).whenComplete(() async {
                          await handler.updateTrnoGntrantp(Gntrantp(
                            trtp: '7010',
                          ));
                          Toast.show("Pembelian Sukses",
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                          Toast.show("Selesai",
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                          Navigator.of(context).pop();
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
