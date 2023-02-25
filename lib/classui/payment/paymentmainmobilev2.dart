import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/payment/classpaymentsuccessmobile.dart';
import 'package:posq/classui/payment/nontunaimobile.dart';
import 'package:posq/classui/payment/paymentcashv2.dart';
import 'package:posq/classui/payment/slideuppanelpaymentmobile.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PaymentV2MobileClass extends StatefulWidget {
  final String trno;
  final String pscd;
  final String trdt;
  final num balance;
  final String? outletname;
  final Outlet? outletinfo;
  final List<IafjrndtClass> datatrans;

  const PaymentV2MobileClass({
    Key? key,
    required this.trno,
    required this.pscd,
    required this.trdt,
    required this.balance,
    this.outletname,
    this.outletinfo,
    required this.datatrans,
  }) : super(key: key);

  @override
  State<PaymentV2MobileClass> createState() => _PaymentV2MobileClassState();
}

class _PaymentV2MobileClassState extends State<PaymentV2MobileClass>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  bool additional = false;
  bool discbyamount = true;
  TextEditingController discountpct = TextEditingController(text: '0');
  TextEditingController discountamount = TextEditingController(text: '0');
  TextEditingController amountcash = TextEditingController();
  TextEditingController ongkir = TextEditingController(text: '0');
  num? result = 0;
  final PanelController _pc = PanelController();
  bool _scrollisanimated = false;
  late DatabaseHandler handler;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var formattedDate;
  bool zerobill = false;
  List<IafjrndtClass> listdata = [];
  List<IafjrndtClass> listdatabill = [];
  String serverkeymidtrans = '';
  bool midtransonline = false;
  String pymtmthd = '';
  String compcode = '';
  String compdescription = '';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    formattedDate = formatter.format(now);
    loadKey();
    getDataTransaksi();
    result = widget.balance;
    _controller = TabController(length: 2, vsync: this);
    // result = widget.balance - num.parse(amountcash.text);
    amountcash.addListener(() {
      setState(() {
        result = widget.balance - num.parse(amountcash.text);
      });
      checkbalance();
    });
    handler = DatabaseHandler();
    checkbalance();
  }

  getDataTransaksi() {
    handler.retrieveDetailIafjrndt2(widget.trno.toString()).then((isi) {
      print(List.generate(isi.length, (index) => isi[index].id));
      setState(() {
        listdata = isi;
      });
    });
  }

  Future<dynamic> checkbalance() async {
    await ClassApi.getSumPyTrno(widget.trno).then((value) {
      print('ini value check ${value.first.totalamt}');
      if (value.first.totalamt != null) {
        setState(() {
          result = widget.balance - value.first.totalamt!;
        });
        if (result == 0) {
          setState(() {
            zerobill = true;
          });
        }
      } else {
        setState(() {
          zerobill = false;
        });
      }
    });
  }

  Future<int> insertIafjrnhd() async {
    IafjrnhdClass iafjrnhd = IafjrnhdClass(
        trdt: formattedDate,
        transno: '${widget.trno}',
        transno1: '${widget.trno}',
        split: 'A',
        pscd: '${widget.pscd}',
        trtm: now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString(),
        disccd: '',
        pax: '1',
        pymtmthd: pymtmthd,
        ftotamt: double.parse(widget.balance.toString()),
        totalamt: double.parse(widget.balance.toString()),
        framtrmn: double.parse(widget.balance.toString()),
        amtrmn: double.parse(widget.balance.toString()),
        trdesc: '$pymtmthd ${widget.trno}',
        trdesc2: '$pymtmthd ${widget.trno}',
        compcd: compcode,
        compdesc: compdescription,
        active: 1,
        usercrt: 'Admin',
        slstp: '1',
        currcd: 'IDR');
    IafjrnhdClass listiafjrnhd = iafjrnhd;
    print(iafjrnhd);
    return await ClassApi.insertPosPayment(listiafjrnhd, pscd);
  }

  loadKey() async {
    final midtranskey = await SharedPreferences.getInstance();
    serverkeymidtrans = midtranskey.getString('serverkey') == null
        ? ''
        : midtranskey.getString('serverkey')!;
    if (serverkeymidtrans != '') {
      setState(() {
        midtransonline = true;
      });
    } else {
      setState(() {
        midtransonline = false;
      });
    }
  }

  checkSelected(String? compcd, String? compdesc, String methode) {
    setState(() {
      compcode = compcd!;
      compdescription = compdesc!;
      pymtmthd = methode;
      zerobill = true;
    });
    print('main $compdescription');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SlidingUpPanel(
            minHeight: MediaQuery.of(context).size.height * 0.15,
            maxHeight: MediaQuery.of(context).size.height * 0.35,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            panelBuilder: (_pc) {
              return _scrollisanimated == true
                  ? SlideupPayment(
                      callback: checkbalance,
                      controllers: _pc,
                      trno: widget.trno,
                    )
                  : Column(
                      children: [
                        Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                            ),
                            iconSize: 25,
                            color: Colors.blue,
                            splashColor: Colors.transparent,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    );
            },
            collapsed: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.height * 0.35,
            ),
            onPanelSlide: (value) {
              print(value);
              if (value > 0.5) {
                setState(() {
                  _scrollisanimated = true;
                });
                print(_scrollisanimated);
              } else {
                setState(() {
                  _scrollisanimated = false;
                });
              }
            },
            controller: _pc,
            body: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.loose,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.06,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Total tagihan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.09,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${CurrencyFormat.convertToIdr(widget.balance, 0)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.19,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      controller: _controller,
                      tabs: [Text('Tunai'), Text('Non Tunai')],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.26,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width * 0.90,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        PaymentCashV2Mobile(
                          datatrans: listdata,
                          callback: checkbalance,
                          zerobill: zerobill,
                          result: result!,
                          outletinfo: widget.outletinfo!,
                          pscd: widget.pscd,
                          trno: widget.trno,
                          balance: widget.balance,
                          amountcash: amountcash,
                        ),
                        NonTunaiMobile(
                          pymtmthd: pymtmthd,
                          compcode: compcode,
                          compdescription: compdescription,
                          checkselected: checkSelected,
                          midtransonline: midtransonline,
                          datatrans: listdata,
                          callback: checkbalance,
                          zerobill: zerobill,
                          result: result!,
                          outletinfo: widget.outletinfo!,
                          pscd: widget.pscd,
                          trno: widget.trno,
                          balance: widget.balance,
                          amountcash: amountcash,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.92,
              left: MediaQuery.of(context).size.width * 0.07,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton(
                  onPressed: zerobill == true
                      ? () async {
                          print('ini compcode $compcode');
                          if (compcode != '' || compcode.isNotEmpty) {
                            await insertIafjrnhd().whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ClassPaymetSucsessMobile(
                                            datatrans: listdata,
                                            frombanktransfer: false,
                                            cash: true,
                                            outletinfo: widget.outletinfo,
                                            outletname: widget.outletname,
                                            outletcd: widget.pscd,
                                            amount: amountcash.text == '' ||
                                                    amountcash.text.isEmpty
                                                ? widget.balance
                                                : double.parse(amountcash.text),
                                            paymenttype: pymtmthd,
                                            trno: widget.trno.toString(),
                                            trdt: formattedDate,
                                          )));
                            });
                          } else {
                            print('dari  cash');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClassPaymetSucsessMobile(
                                        datatrans: listdata,
                                        frombanktransfer: false,
                                        cash: true,
                                        outletinfo: widget.outletinfo,
                                        outletname: widget.outletname,
                                        outletcd: widget.pscd,
                                        amount: amountcash.text == '' ||
                                                amountcash.text.isEmpty
                                            ? widget.balance
                                            : double.parse(amountcash.text),
                                        paymenttype: pymtmthd,
                                        trno: widget.trno.toString(),
                                        trdt: formattedDate,
                                      )),
                            );
                          }
                        }
                      : null,
                  child: Text('Selesaikan'),
                ),
              ))
        ],
      ),
    );
  }
}
