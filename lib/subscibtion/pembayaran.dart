import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/userinfo.dart';
import 'package:url_launcher/url_launcher.dart';

class PembayaranAovi extends StatefulWidget {
  const PembayaranAovi({super.key});

  @override
  State<PembayaranAovi> createState() => _PembayaranAoviState();
}

class _PembayaranAoviState extends State<PembayaranAovi> {
  String tanggalHasil = '';
  String expired = '';
  Future<String> url() async {
    if (Platform.isAndroid) {
      print(Platform.isAndroid);
      // add the [https]
      await launch(
          'whatsapp://send?phone=6285156428885&text=${Uri.encodeFull('saya ingin mengikuti affliate aovipos')}');
      return "whatsapp://send?phone=6285156428885&text=${Uri.encodeFull('saya ingin mengikuti affliate aovipos')}";
    } else {
      // add the [https]
      // return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      return 'oke';
    }
  }

  checkExpired() async {
    await ClassApi.checkExpiredDate(emaillogin).then((value) {
      print(value[0]['expireddate']);
      expired = value[0]['expireddate'];
      print('ini tanggal hasil $expired');
    });
  }

  String tambah31HariKeTanggal(String tanggalAwal) {
    // Ubah tanggalAwal menjadi objek DateTime
    DateTime tanggal = DateTime.parse(tanggalAwal);
    // Tambahkan 31 hari
    DateTime tanggalHasil = tanggal.add(Duration(days: 31));
    // Format ulang tanggalHasil ke dalam string
    String tanggalHasilString = DateFormat('yyyy-MM-dd').format(tanggalHasil);
    return tanggalHasilString;
  }

  String tambahYearHariKeTanggal(String tanggalAwal) {
    // Ubah tanggalAwal menjadi objek DateTime
    DateTime tanggal = DateTime.parse(tanggalAwal);
    // Tambahkan 31 hari
    DateTime tanggalHasil = tanggal.add(Duration(days: 361));
    // Format ulang tanggalHasil ke dalam string
    String tanggalHasilString = DateFormat('yyyy-MM-dd').format(tanggalHasil);
    return tanggalHasilString;
  }

  @override
  void initState() {
    super.initState();
    checkExpired();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Text(
                  'Perpanjang Layanan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        tanggalHasil = tambah31HariKeTanggal(expired);
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogBayarAovi(
                                amount: 100000,
                                user: usercd,
                                dateexpired: tanggalHasil,
                              );
                            });
                      },
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // SizedBox(
                              //   height:
                              //       MediaQuery.of(context).size.height * 0.01,
                              // ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  '1 Bulan',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  'Rp 150,000',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  'Harga belum termasuk PPN',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  Color.fromARGB(255, 248, 133, 66)
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.4, 0.7],
                                tileMode: TileMode.decal,
                              ),
                              border: Border.all(color: Colors.grey)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.06,
                    ),
                    GestureDetector(
                      onTap: () async {
                        tanggalHasil = tambahYearHariKeTanggal(expired);
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogBayarAovi(
                                dateexpired: tanggalHasil,
                                amount: 900000,
                                user: usercd,
                              );
                            });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  '1 Tahun',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  'Rp 1,400,000',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  'Harga belum termasuk PPN',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.secondaryColor,
                                  Color.fromARGB(255, 0, 153, 130),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.4, 0.7],
                                tileMode: TileMode.decal,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Text(
                  'Term & Condition',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Text(
                        '- Dengan berlangganan berarti menyetujui syarat kami berikan',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Text(
                        '- Pembayaran tidak bisa di refund',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Text(
                        '- Biaya belum termasuk PPN',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Text(
                  'Ikuti Affliate Program kami',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Text(
                  'Dapatkan Komisi dari aovipos / bulan,  Selama refferal anda memakai aovipos',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Text(
                  'Info lebih Lanjut',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 1,
                child: IconButton(
                  icon: Image.asset(
                    'assets/whatsapp.png',
                    height: MediaQuery.of(context).size.height * 0.08,
                  ), // Gantilah dengan nama dan lokasi gambar Anda
                  iconSize: 20,
                  onPressed: () async {
                    await url();
                    // Tindakan yang ingin Anda lakukan ketika tombol di tekan
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
