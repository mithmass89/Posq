import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/buttonclass.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/minibackoffice/lookupdetailproduct.dart';
// ignore: unused_import
import 'package:posq/minibackoffice/selectproduct.dart';
import 'package:posq/minibackoffice/Receiving/selecttransaksireceiving.dart';
import 'package:posq/model.dart';
import 'package:toast/toast.dart';

class ClassPengembalianPembelianMobile extends StatefulWidget {
  final Outlet pscd;
  final Gntrantp trtpcd;

  const ClassPengembalianPembelianMobile({
    Key? key,
    required this.pscd,
    required this.trtpcd,
  }) : super(key: key);

  @override
  State<ClassPengembalianPembelianMobile> createState() =>
      _ClassPengembalianPembelianMobileState();
}

class _ClassPengembalianPembelianMobileState
    extends State<ClassPengembalianPembelianMobile> {
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
  TextEditingController _trno = TextEditingController(text: 'pilih Transaksi');
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formatter2 = DateFormat('dd-MM-yyyy');
  var formaterprd = DateFormat('yyyyMM');
  var items;
  var _selectedtrans;
  var qtyfinal;
  var qtyremains;
  int itemseq = 1;
  int? idproduct;

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
    formattedDate = formatter2.format(now);
    formatdate = formatter.format(now);
    periode = formaterprd.format(now);
    handler = DatabaseHandler();
    ToastContext().init(context);
  }

  Future<int> addJournal(
    items,
  ) async {
    //stok tidak bertambah karena trtpcd tidak terbaca/////
    print(widget.trtpcd.progcd);
    Glftrdt debit = Glftrdt(
      trno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      prodcd: items['prodcd'],
      proddesc: items['proddesc'],
      subtrno: _trno.text,
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
      trtpcd: widget.trtpcd.progcd,
      active: 1,
      prd: periode!,
      qtyremain: qtyremains - double.parse(qty.text),
      itemseq: idproduct!,
    );
    Glftrdt credit = Glftrdt(
      trno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      prodcd: items['prodcd'],
      proddesc: items['proddesc'],
      subtrno: _trno.text,
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
      trtpcd: widget.trtpcd.progcd,
      active: 1,
      prd: periode!,
      qtyremain: qtyremains - double.parse(qty.text),
      itemseq: idproduct!,
    );
    List<Glftrdt> listtransaksi = [debit, credit];
    return await handler.insertGltrdt(listtransaksi);
  }

  Future<dynamic> insertALL(_selectedtrans) async {
    Glftrdt credit = Glftrdt(
      trno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      prodcd: _selectedtrans['prodcd'],
      proddesc: _selectedtrans['proddesc'],
      subtrno: _selectedtrans['trno'],
      cbcd: _selectedtrans['cbcd'],
      compcd: _selectedtrans['compcd'],
      supcd: _selectedtrans['supcd'],
      whto: _selectedtrans['whto'],
      whfr: _selectedtrans['whfr'],
      qtyconv: double.parse(_selectedtrans['qtyconv'].toString()),
      unituse: _selectedtrans['unituse'],
      currcd: _selectedtrans['currcd'],
      baseamt1: double.parse(_selectedtrans['baseamt1'].toString()),
      baseamt2: double.parse(_selectedtrans['baseamt2'].toString()),
      unitamt: double.parse(_selectedtrans['unitamt'].toString()),
      totalprice: double.parse(_selectedtrans['totalprice'].toString()),
      taxpct: double.parse(_selectedtrans['taxpct'].toString()),
      taxamt: double.parse(_selectedtrans['taxamt'].toString()),
      discpct: double.parse(_selectedtrans['discpct'].toString()),
      discamount: double.parse(_selectedtrans['discamount'].toString()),
      totalaftdisctax:
          double.parse(_selectedtrans['totalaftdisctax'].toString()),
      trcoa: 'Inventory',
      fdbamt: 0.0,
      fcramt: double.parse(_selectedtrans['fcramt'].toString()),
      ldbamt: 0.0,
      lcramt: double.parse(_selectedtrans['lcramt'].toString()),
      trdt: _selectedtrans['trdt'],
      notes: _selectedtrans['notes'],
      trtpcd: '7081',
      active: _selectedtrans['active'],
      prd: _selectedtrans['prd'],
      qtyremain: double.parse(_selectedtrans['qtyconv'].toString()),
      itemseq: idproduct!,
    );
    Glftrdt debit = Glftrdt(
      trno: widget.trtpcd.refprefix! +
          periode! +
          '-' +
          widget.trtpcd.trnonext.toString(),
      prodcd: _selectedtrans['prodcd'],
      proddesc: _selectedtrans['proddesc'],
      subtrno: _selectedtrans['trno'],
      cbcd: _selectedtrans['cbcd'],
      compcd: _selectedtrans['compcd'],
      supcd: _selectedtrans['supcd'],
      whto: _selectedtrans['whto'],
      whfr: _selectedtrans['whfr'],
      qtyconv: double.parse(_selectedtrans['qtyconv'].toString()),
      unituse: _selectedtrans['unituse'],
      currcd: _selectedtrans['currcd'],
      baseamt1: double.parse(_selectedtrans['baseamt1'].toString()),
      baseamt2: double.parse(_selectedtrans['baseamt2'].toString()),
      unitamt: double.parse(_selectedtrans['unitamt'].toString()),
      totalprice: double.parse(_selectedtrans['totalprice'].toString()),
      taxpct: double.parse(_selectedtrans['taxpct'].toString()),
      taxamt: double.parse(_selectedtrans['taxamt'].toString()),
      discpct: double.parse(_selectedtrans['discpct'].toString()),
      discamount: double.parse(_selectedtrans['discamount'].toString()),
      totalaftdisctax:
          double.parse(_selectedtrans['totalaftdisctax'].toString()),
      trcoa: _selectedtrans['trcoa'],
      fdbamt: double.parse(_selectedtrans['fdbamt'].toString()),
      fcramt: 0.0,
      ldbamt: double.parse(_selectedtrans['ldbamt'].toString()),
      lcramt: 0.0,
      trdt: _selectedtrans['trdt'],
      notes: _selectedtrans['notes'],
      trtpcd: '7081',
      active: _selectedtrans['active'],
      prd: _selectedtrans['prd'],
      qtyremain: double.parse(_selectedtrans['qtyconv'].toString()),
      itemseq: idproduct!,
    );

    List<Glftrdt> listtransaksi = [credit, debit];
    print(listtransaksi);
    return await handler.insertGltrdt(listtransaksi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Pengembalian Barang',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
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
            TextFieldMobileButton(
                hint: 'Pilih Transaksi',
                controller: _trno,
                typekeyboard: TextInputType.text,
                onChanged: (value) {},
                ontap: () async {
                  _selectedtrans = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PilihTransaksiReceiving(
                              pscd: widget.pscd,
                              trtpcd: widget.trtpcd,
                            )),
                  );
                  setState(() {
                    _trno.text = _selectedtrans['trno'];
                    _penjual.text = _selectedtrans['supcd'];
                  });
                }),
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
                        builder: (context) => LookUpDetailTrno(
                              trno: _trno.text,
                            )),
                  );
                  setState(() {
                    if (items != null) {
                      _product.text = items['proddesc'] ?? 'Pilih Produk';
                      qty.text = items['qtyremain'].toString();
                      unitprice.text = items['unitamt'].toString();
                      totalprice.text = items['totalprice'].toString();
                      qtyremains = items['qtyremain'];
                      _selectedtrans = null;
                      idproduct = items['itemseq'];
                    }
                    print('ini ID product ${idproduct}');
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
                      print(qty.text);
                      if (qty.text != '' ||
                          qty.text != '0' ||
                          qty.text.isNotEmpty) {
                        setState(() {
                          totalprice.text =
                              (num.parse(unitprice.text) * num.parse(qty.text))
                                  .toString();
                          if (num.parse(qty.text) > qtyremains) {
                            qty.text = qtyremains.toString();
                          }
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
                    readonly: true,
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
                    readonly: true,
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
                TextButton(
                    onPressed: () {},
                    child: Text(
                        'Jika tidak memilih produk berarti semua di kembalikan'))
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
                      await handler
                          .retrieveItems(_product.text)
                          .then((value) async {
                        print(value.first.stock);
                        print(qty.text);
                        setState(() {
                          qtyfinal = qtyremains! - num.parse(qty.text);
                        });
                        print(qtyfinal);

                        if (qtyfinal >= 0) {
                          await addJournal(items!).whenComplete(() async {
                            await handler.updateQtyRemain(
                                double.parse(qtyfinal.toString()),
                                _trno.text,
                                items['itemseq']);

                            Toast.show("Pengembalian Sukses",
                                duration: Toast.lengthLong,
                                gravity: Toast.center);
                            setState(() {
                              qty.clear();
                              _note.clear();
                              unitprice.clear();
                              totalprice.clear();
                              _product.text = 'Pilih Product';
                              itemseq++;
                            });
                          });
                        } else {
                          Toast.show(
                              "Stok yg ada tidak mencukupi, periksa stock barang anda",
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        }
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
                      if (_selectedtrans != null) {
                        //checking stok dulu//
                        await handler
                            .retrieveItems(_selectedtrans['proddesc'])
                            .then((value) {
                          print(value.first.stock);
                          print(qty.text);
                          setState(() {
                            qtyfinal = qtyremains! - num.parse(qty.text);
                          });
                          print(qtyfinal);
                          print(qtyfinal < 0);
                        }).whenComplete(() async {
                          //   setelah check stok baru insert all RR return
                          if (qtyfinal >= 0.0) {
                            Toast.show("Bisa Di proses pengembalian",
                                duration: Toast.lengthLong,
                                gravity: Toast.center);
                            await insertALL(_selectedtrans)
                                .whenComplete(() async {
                              await handler.updateTrnoGntrantp(Gntrantp(
                                progcd: '7081',
                              ));
                            });
                          } else {
                            Toast.show(
                                "Stok yg ada tidak mencukupi, periksa stock barang anda",
                                duration: Toast.lengthLong,
                                gravity: Toast.center);
                          }
                        });
                      } else if (items != null) {
                        await handler
                            .retrieveItems(items['proddesc'])
                            .then((value) {
                          print(value.first.stock);
                          print(qty.text);
                          setState(() {
                            qtyfinal = qtyremains! - num.parse(qty.text);
                          });
                          print(qtyfinal);
                          print(qtyfinal < 0);
                        }).whenComplete(() async {
                          //    setelah check stok baru insert all RR return
                          if (qtyfinal >= 0.0) {
                            Toast.show("Bisa Di proses pengembalian",
                                duration: Toast.lengthLong,
                                gravity: Toast.center);
                            await addJournal(items!).whenComplete(() async {
                              await handler.updateTrnoGntrantp(Gntrantp(
                                progcd: '7081',
                              ));

                              Toast.show("Pengembalian Sukses",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.center);
                              setState(() {
                                qty.clear();
                                _note.clear();
                                unitprice.clear();
                                totalprice.clear();
                              });
                            });
                            Navigator.of(context).pop();
                          } else {
                            Toast.show(
                                "Stok yg ada tidak mencukupi, periksa stock barang anda",
                                duration: Toast.lengthLong,
                                gravity: Toast.center);
                          }
                        });
                      } else {
                        await handler.updateTrnoGntrantp(Gntrantp(
                          progcd: '7081',
                        ));
                        Navigator.of(context).pop();
                      }
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
