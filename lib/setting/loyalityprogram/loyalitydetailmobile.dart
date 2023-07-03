import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/setting/loyalityprogram/rewardmobile.dart';

class Loyalityprogramdetail extends StatefulWidget {
  final String type;
  const Loyalityprogramdetail({Key? key, required this.type}) : super(key: key);

  @override
  State<Loyalityprogramdetail> createState() => _LoyalityprogramdetailState();
}

class _LoyalityprogramdetailState extends State<Loyalityprogramdetail> {
  DateTime selectedDate = DateTime.now();
  TextEditingController fromdate =
      TextEditingController(text: 'Pilih tanggal start porgram');
  TextEditingController todate =
      TextEditingController(text: 'Pilih tanggal stop porgram');
  TextEditingController point = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController initialjoin = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat('#,###');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List program = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2300),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkProgramActive();
  }

  checkProgramActive() async {
    program = await ClassApi.checkProgramExist();
    print(program);
  }

  @override
  Widget build(BuildContext context) {
    final formateddatefrom = DateFormat('yyyy-MM-dd').format(selectedDate);
    final formateddateto = DateFormat('yyyy-MM-dd').format(selectedDate);
    final datetextfrom = DateFormat('dd-MM-yyyy').format(selectedDate);
    final datetextto = DateFormat('dd-MM-yyyy').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Loyality Program'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Informasi Program'),
                ),
              ),
              TextFieldMobileButton(
                  hint: 'Program Aktif',
                  controller: fromdate,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {},
                  ontap: () async {
                    await _selectDate(context);
                    fromdate.text = datetextfrom;
                    setState(() {});
                  }),
              TextFieldMobileButton(
                  hint: 'Program berakir',
                  controller: todate,
                  typekeyboard: TextInputType.text,
                  onChanged: (value) {},
                  ontap: () async {
                    await _selectDate(context);
                    todate.text = datetextto;
                    setState(() {});
                  }),
              Container(
                // alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.05,
                child: const Text('Conversion Point'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      controller: amount,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _NumberFormatter(),
                      ],
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Amount',
                        prefixText: 'Rp',
                      ),
                    )),
                    Expanded(
                        child: TextFormField(
                      controller: point,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Point',
                        prefixText: 'pts ',
                      ),
                    )),
                  ],
                ),
              ),
              Container(
                // alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                      'Tawarkan Customer untuk join dengan bonus point '),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: initialjoin,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _NumberFormatter(),
                  ],
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'initial join point',
                    prefixText: 'pts',
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (program.isEmpty) {
                              ClassApi.insertLoyalityProgram(
                                  '01-01',
                                  'Loyality Program',
                                  formateddatefrom,
                                  formateddateto,
                                  widget.type,
                                  int.parse(amount.text.replaceAll(',', '')),
                                  int.parse(point.text),
                                  0,
                                  0,
                                  num.parse(initialjoin.text));
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RewardMobile(
                                        type: widget.type,
                                        amount: num.parse(amount.text.replaceAll(',', '')),
                                        fromdate: formateddatefrom,
                                        initialamount: num.parse(initialjoin.text),
                                        point: point.text,
                                        todate: formateddateto,
                                      )),
                            ).then((_) async {
                              setState(() {});
                            });
                          }
                        },
                        child: Text('Selanjutnya')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int selectionIndex = newValue.selection.end;
    String formattedValue = newValue.text;

    if (formattedValue.isNotEmpty) {
      final numberValue = int.tryParse(formattedValue.replaceAll(',', ''));
      if (numberValue != null) {
        final NumberFormat numberFormat = NumberFormat('#,###');
        formattedValue = numberFormat.format(numberValue);
      }
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
