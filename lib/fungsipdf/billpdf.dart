import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';
import 'package:printing/printing.dart';
// ignore: unused_shown_name
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class BillPdfGenerator {
  Future<File> generatePDF(
      String outletname,
      String address,
      List<IafjrndtClass> data,
      List<IafjrndtClass> summary,
      List<IafjrnhdClass> payment) async {
    // Buat dokumen PDF
    final pdf = pw.Document();
    final response =
        await http.get(Uri.parse('https://api.freelogodesign.org/assets/thumb/logo/a17b07eb64d341ffb1e09392aa3a1698_400.png'));
    var image;
    // Tambahkan halaman ke dokumen
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, //atur luas halaman
        build: (context) {
          if (response.statusCode == 200) {
            image = PdfImage.file(
              pdf.document,
              bytes: response.bodyBytes,
            );
            image= response.bodyBytes;
          }

          return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  width: 100.0, // Adjust the width and height as needed
                  height: 100.0,
                  child: pw.Image(pw.MemoryImage(image)),
                ),
                pw.Container(
                    alignment: pw.Alignment.center,
                    child:
                        pw.Text(outletname, style: pw.TextStyle(fontSize: 12))),
                pw.SizedBox(height: 20),
                pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text(address, style: pw.TextStyle(fontSize: 12))),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return pw.Column(children: [
                        pw.Row(children: [
                          pw.Container(
                              child: data[index].condimenttype != ''
                                  ? pw.Text(
                                      '*** ${data[index].itemdesc!} ***'
                                          .padRight(26, ' '),
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal))
                                  : pw.Text(
                                      data[index].itemdesc!.padRight(26, ' '),
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal))),
                          pw.SizedBox(width: 10),
                        ]),
                        pw.Container(
                            child: pw.Row(children: [
                          pw.SizedBox(width: 120),
                          pw.Text("X ${data[index].qty}".padRight(5, ' '),
                              style: pw.TextStyle(fontSize: 10)),
                          pw.Text(
                              "${CurrencyFormat.convertToIdr(data[index].rateamtitem, 0)}"
                                  .padRight(20, ' '),
                              style: pw.TextStyle(fontSize: 10))
                        ])),
                      ]);
                    }),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.ListView.builder(
                    itemCount: summary.length,
                    itemBuilder: (context, index) {
                      return pw.Column(children: [
                        pw.Row(children: [
                          pw.Container(
                            child: pw.Text('Total'.padRight(18, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Container(
                            child: pw.Text(
                                CurrencyFormat.convertToIdr(
                                        summary[0].revenueamt, 0)
                                    .padLeft(40, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Container(
                            child: pw.Text('Discount'.padRight(15, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Container(
                            child: pw.Text(
                                CurrencyFormat.convertToIdr(
                                        summary[0].discamt, 0)
                                    .padLeft(40, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Container(
                            child: pw.Text('Grand total'.padRight(15, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Container(
                            child: pw.Text(
                                CurrencyFormat.convertToIdr(
                                        summary[0].totalaftdisc, 0)
                                    .padLeft(40, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                        ]),
                      ]);
                    }),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.ListView.builder(
                    itemCount: payment.length,
                    itemBuilder: (context, index) {
                      return pw.Container(
                          child: pw.Row(children: [
                        pw.Row(children: [
                          pw.Container(
                            child: pw.Text(
                                payment[index].trdesc!.padLeft(15, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                          pw.SizedBox(width: 47),
                          pw.Container(
                            child: pw.Text(
                                CurrencyFormat.convertToIdr(
                                        payment[index].totalamt, 0)
                                    .padLeft(20, ' '),
                                style: pw.TextStyle(fontSize: 10)),
                          ),
                        ]),
                      ]));
                    }),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text('Terima kasih atas kunjungannya',
                        style: pw.TextStyle(fontSize: 12))),
                pw.SizedBox(height: 10),
              ]);
        },
      ),
    );

    // Simpan PDF ke penyimpanan lokal
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}

class PdfPrinter {
  Future<void> printPdf() async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    final Uint8List uint8List = await File(file.path).readAsBytes();

    await Printing.sharePdf(
      bytes: uint8List,
      filename: 'example.pdf', // Replace with your desired filename
    );
  }
}

class PdfViewer extends StatelessWidget {
  final String pdfFilePath;
  PdfViewer(this.pdfFilePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: Center(
        child: PdfPreview(
          // initialData: PdfPreviewData(Uint8List.fromList([])),
          build: (format) => _buildPdfPreview(format, pdfFilePath),
        ),
      ),
    );
  }

  Future<Uint8List> _buildPdfPreview(
      PdfPageFormat format, String filePath) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    final Uint8List uint8List = await File(file.path)
        .readAsBytes(); // Load the PDF from the specified file path
    return uint8List.buffer.asUint8List();
  }
}
