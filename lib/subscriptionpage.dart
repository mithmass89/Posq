import 'dart:async';
import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/login.dart';
import 'package:posq/setting/classsetupprofilemobile.dart';
import 'package:posq/userinfo.dart';
import 'package:url_launcher/url_launcher.dart';

class SubScribetionPage extends StatefulWidget {
  final String email;
  final String fullname;
  const SubScribetionPage(
      {Key? key, required this.fullname, required this.email})
      : super(key: key);

  @override
  State<SubScribetionPage> createState() => _SubScribetionPageState();
}

class _SubScribetionPageState extends State<SubScribetionPage> {
  StreamController<String>? _streamController;
  Timer? _timer;
  List hasil = [];
  List<String> fiturebasic = [
    'Transaksi Standart',
    'Payment Gateway',
    'Live chat support',
    'Kirim struk via email',
    'Unlimited storage cloud',
    'More'
  ];
  List<String> fiturepro = [
    'Fitur yg ada di Paket Basic',
    'Integrasi dengan Online Food',
    'Send Struk via Whatsapp',
    'Toko Online',
    'Promo Management',
    'More',
  ];

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  getPayment() async {
    hasil = await ClassApi.checkVerifiedPayment(widget.email);
    setState(() {});
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {

    dynamicLinks.onLink.listen((dynamicLinkData) {
      Navigator.pushNamed(context, dynamicLinkData.link.path);
      print('ini dynamic link $dynamicLinkData');
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    _streamController = StreamController<String>();
    _timer = Timer.periodic(
        Duration(seconds: 3),
        (_) async =>
            await getPayment()); // Change the duration as per your needs
  }

  @override
  void dispose() {
    _streamController!.close();
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController!.stream,
        builder: (context, AsyncSnapshot snapshot) {
          print(hasil);
          if (hasil.isNotEmpty) {
            if (hasil[0]['paymentcheck'] == 'settlement') {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Text(
                        'Pembayaran Anda terverifikasi',
                        style: TextStyle(fontSize: 16),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        child: Text(
                          'Lanjut Ke Setup',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _streamController!.close();
                          _timer!.cancel();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassSetupProfileMobile(
                                  fullname: widget.fullname,
                                      email: widget.email,
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Berlangganan (Demo Free)',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                body: LayoutBuilder(
                    builder: (context, BoxConstraints constraints) {
                  if (constraints.maxWidth <= 480) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView(
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.80,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ), //BorderRadius.Only
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                // bottomLeft: Radius.circular(10),
                                                // bottomRight: Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.80,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Basic Rp 150.000',
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Per Outlet /  Month',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Paket Basic , paket yg akan memenuhi\n kebutuhan usaha dasarmu',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.48,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            child: ListView.builder(
                                                itemCount: fiturebasic.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    dense: true,
                                                    leading: Icon(Icons.send),
                                                    title: Text(
                                                        fiturebasic[index]),
                                                  );
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .blue, // Background color
                                                ),
                                                onPressed: () async {
                                                  Random random = new Random();
                                                  int randomNumber = random.nextInt(
                                                      100); // from 0 upto 99 included
                                                  await ClassApi.snapinMidtrans(
                                                          150000,
                                                          '${widget.email}$randomNumber',
                                                          'Subscribtion Basic AOVI')
                                                      .then((value) async {
                                                    final Uri _url =
                                                        Uri.parse(value);
                                                    await _launchInBrowser(
                                                        _url);

                                                    await ClassApi
                                                        .updatePaymentFirst(
                                                            'Basic',
                                                            '${widget.email}$randomNumber',
                                                            'pending',
                                                            widget.email);
                                                    await ClassApi
                                                            .getAccessUser(
                                                                usercd)
                                                        .then((valueds) {
                                                      print(valueds);
                                                      for (var x in valueds) {
                                                        accesslist
                                                            .add(x['access']);
                                                      }
                                                    });
                                                    await ClassApi
                                                            .getAccessSettingsUser()
                                                        .then((valuess) {
                                                      strictuser = valuess[0]
                                                              ['strictuser']
                                                          .toString();
                                                    });
                                                    print(value);
                                                  });
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      'Bayar',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                          )
                                        ],
                                      ), //declare your widget here
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.80,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Pro Rp 250.000',
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Per Outlet /  Month',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Paket Pro , Tingkatkan effesiensi\n usaha anda dan bawa bisnis anda\n kelevel lebih tinggi',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.48,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            child: ListView.builder(
                                                itemCount: fiturepro.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    dense: true,
                                                    leading: Icon(Icons.send),
                                                    title:
                                                        Text(fiturepro[index]),
                                                  );
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Background color
                                                ),
                                                onPressed: () async {
                                                  Random random = new Random();
                                                  int randomNumber = random.nextInt(
                                                      100); // from 0 upto 99 included
                                                  await ClassApi.snapinMidtrans(
                                                          250000,
                                                          '${widget.email}$randomNumber',
                                                          'Subscribtion Pro AOVI')
                                                      .then((value) async {
                                                    final Uri _url =
                                                        Uri.parse(value);
                                                    await _launchInBrowser(
                                                        _url);
                                                    print(value);
                                                  });
                                                  await ClassApi.updatePaymentFirst(
                                                      'Pro',
                                                      '${widget.email}$randomNumber',
                                                      'pending',
                                                      widget.email);
                                                  // Navigator.of(context)
                                                  //     .pushAndRemoveUntil(
                                                  //         MaterialPageRoute(
                                                  //             builder:
                                                  //                 (context) =>
                                                  //                     Login()),
                                                  //         (Route<dynamic>
                                                  //                 route) =>
                                                  //             false);
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      'Bayar',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                          )
                                        ],
                                      ), //declare your widget here
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (constraints.maxWidth >= 800) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.83,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView(
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.white,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.80,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ), //BorderRadius.Only
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                // bottomLeft: Radius.circular(10),
                                                // bottomRight: Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.80,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Basic Rp 150.000',
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Per Outlet /  Month',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Paket Basic , paket yg akan memenuhi\n kebutuhan usaha dasarmu',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.48,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            child: ListView.builder(
                                                itemCount: fiturebasic.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    dense: true,
                                                    leading: Icon(Icons.send),
                                                    title: Text(
                                                        fiturebasic[index]),
                                                  );
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .blue, // Background color
                                                ),
                                                onPressed: () async {
                                                  Random random = new Random();
                                                  int randomNumber = random.nextInt(
                                                      100); // from 0 upto 99 included
                                                  await ClassApi.snapinMidtrans(
                                                          150000,
                                                          '${widget.email}$randomNumber',
                                                          'Subscribtion Basic AOVI')
                                                      .then((value) async {
                                                    final Uri _url =
                                                        Uri.parse(value);
                                                    await _launchInBrowser(
                                                        _url);

                                                    await ClassApi
                                                        .updatePaymentFirst(
                                                            'Basic',
                                                            '${widget.email}$randomNumber',
                                                            'pending',
                                                            widget.email);
                                                    print(value);
                                                  });
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      'Bayar',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                          )
                                        ],
                                      ), //declare your widget here
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.80,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Pro Rp 250.000',
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Per Outlet /  Month',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Paket Pro , Tingkatkan effesiensi usaha anda dan bawa bisnis anda\n kelevel lebih tinggi',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.48,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ), //BorderRadius.Only
                                            ),
                                            child: ListView.builder(
                                                itemCount: fiturepro.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    dense: true,
                                                    leading: Icon(Icons.send),
                                                    title:
                                                        Text(fiturepro[index]),
                                                  );
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Background color
                                                ),
                                                onPressed: () async {
                                                  Random random = new Random();
                                                  int randomNumber = random.nextInt(
                                                      100); // from 0 upto 99 included
                                                  await ClassApi.snapinMidtrans(
                                                          250000,
                                                          '${widget.email}$randomNumber',
                                                          'Subscribtion Pro AOVI')
                                                      .then((value) async {
                                                    final Uri _url =
                                                        Uri.parse(value);
                                                    await _launchInBrowser(
                                                        _url);
                                                    print(value);
                                                  });
                                                  await ClassApi.updatePaymentFirst(
                                                      'Pro',
                                                      '${widget.email}$randomNumber',
                                                      'pending',
                                                      widget.email);
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Login()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                      'Bayar',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                          )
                                        ],
                                      ), //declare your widget here
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
              );
            }
          } else {
            return Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.08,
                    child: CircularProgressIndicator()));
          }
        });
  }
}
