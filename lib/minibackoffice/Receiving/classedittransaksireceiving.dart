import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/minibackoffice/selectproduct.dart';
import 'package:posq/model.dart';
import 'package:toast/toast.dart';

class ClassEditTransaksi extends StatefulWidget {
  final Outlet pscd;
  final Gntrantp trtpcd;
  final data;

  const ClassEditTransaksi({
    Key? key,
    required this.pscd,
    required this.trtpcd,
    this.data,
  }) : super(key: key);

  @override
  State<ClassEditTransaksi> createState() => _ClassEditTransaksiState();
}

class _ClassEditTransaksiState extends State<ClassEditTransaksi> {
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
  num? variance;

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
      print(widget.data);
      items = Item(
        packageflag: 0,
          multiprice: 0,
          itemcode: widget.data['prodcd'], itemdesc: widget.data['proddesc']);
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
    variance = widget.data['qtyconv'];
    ToastContext().init(context);
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
                          variance =
                              num.parse(qty.text) - widget.data['qtyconv'];
                          print(variance);
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
                    textcolor: Colors.white,
                    color: Colors.blue,
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.85,
                    onpressed: () async {
                      await handler.updateJournalDebit(Glftrdt(
                          trno: widget.data['trno'],
                          itemseq: widget.data['itemseq'],
                          prodcd: items!.itemcode,
                          proddesc: items!.itemdesc,
                          notes: _note.text,
                          supcd: _penjual.text,
                          qtyconv: double.parse(qty.text),
                          unitamt: double.parse(unitprice.text),
                          totalprice: double.parse(totalprice.text),
                          totalaftdisctax: double.parse(totalprice.text),
                          fdbamt: double.parse(totalprice.text),
                          ldbamt: double.parse(totalprice.text),
                          qtyremain: double.parse(
                                  widget.data['qtyremain'].toString()) +
                              variance!.toDouble(),
                          trcoa: 'inventory'));
                      await handler
                          .updatejournalCredit(Glftrdt(
                              trno: widget.data['trno'],
                              itemseq: widget.data['itemseq'],
                              prodcd: items!.itemcode,
                              proddesc: items!.itemdesc,
                              notes: _note.text,
                              supcd: _penjual.text,
                              qtyconv: double.parse(qty.text),
                              unitamt: double.parse(unitprice.text),
                              totalprice: double.parse(totalprice.text),
                              totalaftdisctax: double.parse(totalprice.text),
                              fcramt: double.parse(totalprice.text),
                              lcramt: double.parse(totalprice.text),
                              qtyremain: double.parse(
                                      widget.data['qtyremain'].toString()) +
                                  variance!.toDouble(),
                              trcoa: 'AP-Pembelian'))
                          .whenComplete(() {
                        Navigator.of(context).pop();
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
