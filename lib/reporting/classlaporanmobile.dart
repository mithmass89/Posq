import 'package:flutter/material.dart';
import 'package:posq/reporting/classsummaryreport.dart';
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
            subtitle: Text(
                'Ringkasan penjualan dan pengeluaran'),
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
              pesanBelumReady();
            },
            title: Text('Detail Item Sold'),
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
            subtitle: Text('Summary setiap Penjualan outlet'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Daily Sales Summary'),
          ),
          Divider(),
          ListTile(
            subtitle: Text('Detail setiap Penjualan outlet'),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              pesanBelumReady();
            },
            title: Text('Daily Sales Detail'),
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
