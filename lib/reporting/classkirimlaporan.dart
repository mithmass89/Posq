import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';
import 'package:printing/printing.dart';

class ClassKirimLaporan extends StatefulWidget {
  final List<IafjrnhdClass> datapayment;
  const ClassKirimLaporan({Key? key, required this.datapayment})
      : super(key: key);

  @override
  State<ClassKirimLaporan> createState() => _ClassKirimLaporanState();
}

class _ClassKirimLaporanState extends State<ClassKirimLaporan> {
  List<IafjrnhdClass> cash = [];
  List<IafjrnhdClass> DebitCard = [];
  List<IafjrnhdClass> creditcard = [];
  List<IafjrnhdClass> ewallet = [];
  List<IafjrnhdClass> transfer = [];
  List<IafjrnhdClass> payment = [];
  num sumcash = 0;
  num sumcreditcard = 0;
  num sumdebitcard = 0;
  num sumewallet = 0;
  num sumtransfer = 0;
  final formatCurrency = new NumberFormat.currency(name: '', decimalDigits: 0);

  void initState() {
    super.initState();
    generateData();
  }

  generateData() {
    List.generate(widget.datapayment.length, (index) {
      if (widget.datapayment[index].pymtmthd!.contains('CASH')) {
        return cash.add(widget.datapayment[index]);
      }
    });
    for (var i = 0; i < cash.length; i++) {
      if (cash[i].pymtmthd!.contains('CASH')) {
        sumcash += cash[i].ftotamt!;
      }
    }

    List.generate(widget.datapayment.length, (index) {
      if (widget.datapayment[index].pymtmthd!.contains('Debit Card')) {
        return DebitCard.add(widget.datapayment[index]);
      }
    });
    for (var i = 0; i < DebitCard.length; i++) {
      if (DebitCard[i].pymtmthd!.contains('Debit Card')) {
        sumdebitcard += DebitCard[i].ftotamt!;
      }
    }
    print(DebitCard);

    List.generate(widget.datapayment.length, (index) {
      if (widget.datapayment[index].pymtmthd!.contains('Credit Card')) {
        return creditcard.add(widget.datapayment[index]);
      }
    });
    for (var i = 0; i < creditcard.length; i++) {
      if (creditcard[i].pymtmthd!.contains('Credit Card')) {
        sumcreditcard += creditcard[i].ftotamt!;
      }
    }

    List.generate(widget.datapayment.length, (index) {
      if (widget.datapayment[index].pymtmthd!.contains('Transfer')) {
        return transfer.add(widget.datapayment[index]);
      }
    });
    for (var i = 0; i < transfer.length; i++) {
      if (transfer[i].pymtmthd!.contains('Transfer')) {
        sumtransfer += transfer[i].ftotamt!;
      }
    }

    List.generate(widget.datapayment.length, (index) {
      if (widget.datapayment[index].pymtmthd!.contains('E-Wallet')) {
        return ewallet.add(widget.datapayment[index]);
      }
    });
    for (var i = 0; i < ewallet.length; i++) {
      if (ewallet[i].pymtmthd!.contains('E-Wallet')) {
        sumewallet += ewallet[i].ftotamt!;
      }
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title,
      List<IafjrnhdClass> payment, num sumcash) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, //atur luas halaman
        build: (context) => pw.SizedBox(
          height: 200 * PdfPageFormat.mm,
          // _contentHeader(context, myImage),
          // _buildHeader(context),
          child: _contentTable(context, sumcash),
          // _contentFooter(context)
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _contentTable(pw.Context context, num sumcash) {
    const tableHeaders = [
      'Trx ',
      'Type',
      'Amount',
    ];
    return pw.Column(children: [
      _contentCash(context),
      pw.Divider(),
      _contentDebit(context),
      pw.Divider(),
      _contentCredit(context),
      pw.Divider(),
      _contentEwallet(context),
      pw.Divider(),
      _contentTransfer(context),
    ]);

    // return pw.Container(
    //     child: pw.Column(children: [
    //   _contentHeader(context),
    //   pw.Table.fromTextArray(
    //     border: null,
    //     cellAlignment: pw.Alignment.centerLeft,
    //     headerDecoration: pw.BoxDecoration(
    //       borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
    //       color: PdfColors.black,
    //     ),
    //     headerHeight: 25,
    //     cellHeight: 20,
    //     cellAlignments: {
    //       0: pw.Alignment.topLeft,
    //       1: pw.Alignment.center,
    //       2: pw.Alignment.centerRight,
    //     },
    //     headerStyle: pw.TextStyle(
    //       color: PdfColors.white,
    //       fontSize: 8,
    //       fontWeight: pw.FontWeight.bold,
    //     ),
    //     cellStyle: const pw.TextStyle(
    //       color: PdfColors.black,
    //       fontSize: 6.3,
    //     ),
    //     // rowDecoration: pw.BoxDecoration(
    //     //   border: pw.Border(
    //     //     bottom: pw.BorderSide(
    //     //       color: PdfColors.black,
    //     //       width: 0.5,
    //     //     ),
    //     //   ),
    //     // ),
    //     headers: List<String>.generate(
    //       tableHeaders.length,
    //       (col) => tableHeaders[col],
    //     ),
    //     data: List<List<String>>.generate(
    //       payment.length,
    //       (row) => List<String>.generate(
    //         tableHeaders.length,
    //         (col) => payment[row].getIndex(col),
    //       ),
    //     ),
    //   ),
    // ]));
  }

  pw.Widget _contentCash(pw.Context context) {
    const tableHeaders = [
      'Trx ',
      'Type',
      'Amount',
    ];

    return pw.Container(
        child: pw.Column(children: [
      // _contentHeader(context),
      pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: PdfColors.black,
        ),
        headerHeight: 25,
        cellHeight: 20,
        cellAlignments: {
          0: pw.Alignment.topLeft,
          1: pw.Alignment.center,
          2: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 8.3,
        ),
        // rowDecoration: pw.BoxDecoration(
        //   border: pw.Border(
        //     bottom: pw.BorderSide(
        //       color: PdfColors.black,
        //       width: 0.5,
        //     ),
        //   ),
        // ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          cash.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => cash[row].getIndex(col),
          ),
        ),
      ),
      pw.Divider(),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Text('Total Cash'.padRight(30)),
        pw.Text(CurrencyFormat.convertToIdr(sumcash, 0),
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            )),
      ]),
    ]));
  }

  pw.Widget _contentDebit(pw.Context context) {
    const tableHeaders = [
      '',
      '',
      '',
    ];

    return pw.Container(
        child: pw.Column(children: [
      pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: PdfColors.white,
        ),
        headerHeight: 0,
        cellHeight: 0,
        cellAlignments: {
          0: pw.Alignment.topLeft,
          1: pw.Alignment.center,
          2: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 8.3,
        ),
        // rowDecoration: pw.BoxDecoration(
        //   border: pw.Border(
        //     bottom: pw.BorderSide(
        //       color: PdfColors.black,
        //       width: 0.5,
        //     ),
        //   ),
        // ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          DebitCard.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => DebitCard[row].getIndex(col),
          ),
        ),
      ),
      pw.Divider(),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Text('Total Debit Card'.padRight(30)),
        pw.Text(CurrencyFormat.convertToIdr(sumdebitcard, 0),
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            )),
      ]),
    ]));
  }

  pw.Widget _contentCredit(pw.Context context) {
    const tableHeaders = [
      '',
      '',
      '',
    ];

    return pw.Container(
        child: pw.Column(children: [
      pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: PdfColors.white,
        ),
        headerHeight: 0,
        cellHeight: 0,
        cellAlignments: {
          0: pw.Alignment.topLeft,
          1: pw.Alignment.center,
          2: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 8.3,
        ),
        // rowDecoration: pw.BoxDecoration(
        //   border: pw.Border(
        //     bottom: pw.BorderSide(
        //       color: PdfColors.black,
        //       width: 0.5,
        //     ),
        //   ),
        // ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          creditcard.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => creditcard[row].getIndex(col),
          ),
        ),
      ),
      pw.Divider(),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Text('Total Credit Card'.padRight(30)),
        pw.Text(CurrencyFormat.convertToIdr(sumcreditcard, 0),
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            )),
      ]),
    ]));
  }

  pw.Widget _contentEwallet(pw.Context context) {
    const tableHeaders = [
      '',
      '',
      '',
    ];

    return pw.Container(
        child: pw.Column(children: [
      pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: PdfColors.white,
        ),
        headerHeight: 0,
        cellHeight: 0,
        cellAlignments: {
          0: pw.Alignment.topLeft,
          1: pw.Alignment.center,
          2: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 8.3,
        ),
        // rowDecoration: pw.BoxDecoration(
        //   border: pw.Border(
        //     bottom: pw.BorderSide(
        //       color: PdfColors.black,
        //       width: 0.5,
        //     ),
        //   ),
        // ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          ewallet.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => ewallet[row].getIndex(col),
          ),
        ),
      ),
      pw.Divider(),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Text('Total E-Wallet'.padRight(30)),
        pw.Text(CurrencyFormat.convertToIdr(sumewallet, 0),
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            )),
      ]),
    ]));
  }

  pw.Widget _contentTransfer(pw.Context context) {
    const tableHeaders = [
      '',
      '',
      '',
    ];

    return pw.Container(
        child: pw.Column(children: [
      pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: PdfColors.white,
        ),
        headerHeight: 0,
        cellHeight: 0,
        cellAlignments: {
          0: pw.Alignment.topLeft,
          1: pw.Alignment.center,
          2: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 8.3,
        ),
        // rowDecoration: pw.BoxDecoration(
        //   border: pw.Border(
        //     bottom: pw.BorderSide(
        //       color: PdfColors.black,
        //       width: 0.5,
        //     ),
        //   ),
        // ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          transfer.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => transfer[row].getIndex(col),
          ),
        ),
      ),
      pw.Divider(),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Text('Total Transfer'.padRight(30)),
        pw.Text(CurrencyFormat.convertToIdr(sumtransfer, 0),
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            )),
      ]),
    ]));
  }

  

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Container(
        child: pw.Column(children: [
      // pw.Container(
      //   margin: const pw.EdgeInsets.symmetric(horizontal: 20),
      //   height: 100,
      //   child: pw.FittedBox(
      //     child: pw.Image(myImage),
      //   ),
      // ),
      pw.Container(
        margin: pw.EdgeInsets.only(bottom: 10),
        child: pw.RichText(
            text: pw.TextSpan(
                text: 'Kopi Gratisan',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 8,
                ),
                children: [
              const pw.TextSpan(
                text: '\n',
                style: pw.TextStyle(
                  fontSize: 5,
                ),
              ),
            ])),
      ),
      pw.Container(
        margin: pw.EdgeInsets.only(bottom: 10),
        child: pw.RichText(
            text: pw.TextSpan(
                text: 'Cashier Summary',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 8,
                ),
                children: [
              const pw.TextSpan(
                text: '\n',
                style: pw.TextStyle(
                  fontSize: 5,
                ),
              ),
            ])),
      ),
      // pw.Row(
      //   crossAxisAlignment: pw.CrossAxisAlignment.center,
      //   children: [
      //     pw.Container(
      //       child: pw.FittedBox(
      //         child: pw.Text(
      //           'ANJANI SPA',
      //           style: pw.TextStyle(
      //             color: PdfColors.black,
      //             fontStyle: pw.FontStyle.italic,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('KIRIM LAPORAN')),
        body: PdfPreview(
          build: (format) =>
              _generatePdf(format, 'KIRIM LAPORAN', payment, sumcash),
        ));
  }
}
