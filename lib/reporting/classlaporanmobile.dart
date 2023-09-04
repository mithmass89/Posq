

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ClassLaporanMobile extends StatefulWidget {
  const ClassLaporanMobile({Key? key}) : super(key: key);

  @override
  State<ClassLaporanMobile> createState() => _ClassLaporanMobileState();
}

class _ClassLaporanMobileState extends State<ClassLaporanMobile> {
  @override
  void initState() {
    ToastContext().init(context);
    super.initState();
  }

  pesanBelumReady() {
    Toast.show("Module Belum Tersedia",
        duration: Toast.lengthLong, gravity: Toast.center);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Laporan'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Ringkasan'),
            subtitle: Text('Ringkasan penjualan Semua Outlet'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.of(context).pop('Ringkasan');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Summary Cashier'),
            subtitle: Text(
                'Rincian Penerimaan payment dan list cashier yg menerima pembayaran'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.of(context).pop('Summary Cashier');
            },
          ),
          Divider(),
          ListTile(
            subtitle: Text('Rincian Detail Penjualan item / product'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.of(context).pop('Detail Item Terjual');
            },
            title: Text('Detail Item Terjual'),
          ),
          ListTile(
            subtitle:
                Text('Rincian Detail Penjualan item / product dengan size cup'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.of(context).pop('Detail Item Terjual2');
            },
            title: Text('Detail Item Terjual(Cup size)'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Rincian Detail Condiment Terjual'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.of(context).pop('Detail condiment');
            },
            title: Text('Detail Condiment Terjual'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('melihat refund transaksi'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.of(context).pop('Refund transaksi');
            },
            title: Text('Refund transaksi'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Analisa Antara harga item terhadap COGS / COST'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.of(context).pop('Margin Item');
            },
            title: Text('Gross margin item'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Top 10 product/item yg paling laku terjual'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Top Ten Menu'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Ringkasan setiap Penjualan outlet'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Laporan Penjualan Harian'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Analisa antara penjualan dan HPP setiap product'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Analisa Menu/product'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Laporan Pembelian barang atau stock di outlet'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Pembelian Barang'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Laporan Laba Rugi Outlet'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('P&L Outlet'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Laporan Sirkulasi Keuangan outlet'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Cash Flow'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Laporan Absensi Karyawan'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Absensi'),
          ),
        ],
      ),
    );
  }
}
