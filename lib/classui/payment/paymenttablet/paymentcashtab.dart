import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posq/classui/dialogclass.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';

class PaymentCashTabs extends StatefulWidget {
  late TextEditingController controller;
  final String trno;
  final Outlet outletinfo;
  final TextEditingController dialog;
  final int? itemlenght;
  final Function resetTextEditing;
  PaymentCashTabs({
    Key? key,
    required this.controller,
    required this.trno,
    required this.outletinfo,
    required this.dialog,
    this.itemlenght,
    required this.resetTextEditing,
  }) : super(key: key);

  @override
  State<PaymentCashTabs> createState() => _PaymentCashTabsState();
}

class _PaymentCashTabsState extends State<PaymentCashTabs> {
  @override
  Widget build(BuildContext context) {
    return Numpad(
      resetTextEditing: widget.resetTextEditing,
      controller: widget.controller,
      trno: widget.trno,
      itemlenght: widget.itemlenght,
      onChanged: (value) {
        // lakukan sesuatu dengan nilai yang dihasilkan
        print('Nilai baru: $value');
        widget.controller.text = value.toString();
      },
      outletinfo: widget.outletinfo,
      dialog: widget.dialog,
    );
  }
}

class Numpad extends StatefulWidget {
  final Function resetTextEditing;
  final int? itemlenght;
  final TextEditingController dialog;
  final Outlet outletinfo;
  final String trno;
  final ValueSetter<double> onChanged;
  late TextEditingController controller;

  Numpad(
      {Key? key,
      required this.onChanged,
      required this.trno,
      required this.controller,
      required this.outletinfo,
      required this.dialog,
      this.itemlenght,
      required this.resetTextEditing})
      : super(key: key);

  @override
  _NumpadState createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  double _value = 0.0;

  void _handleKeyPress(String keyValue) async {
    if (keyValue == 'C') {
      setState(() {
        _value = 0.0;
      });
    } else if (keyValue == '<') {
      setState(() {
        _value = (_value ~/ 10).toDouble();
      });
    } else if (keyValue == 'Simpan') {
      final IafjrndtClass results = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogClassRetailDesc(
              itemlenght: widget.itemlenght,
              trno: widget.trno,
              cleartext: () {
                widget.resetTextEditing();
              },
              outletinfo: widget.outletinfo,
              result: double.parse(
                  widget.controller.text == '' ? '0' : widget.controller.text),
              controller: widget.dialog,
              callback: (IafjrndtClass val) {},
            );
          });

      ClassRetailMainMobile.of(context)!.string = results;
    } else {
      final newValue = double.tryParse(keyValue);
      if (newValue != null) {
        setState(() {
          _value = _value * 10 + newValue;
        });
      }
    }
    widget.onChanged(_value);
  }

  String _formatValue(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.grey[300],
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.height * 1,
            child: Text(
              _formatValue(_value),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildKey('7'),
                _buildKey('8'),
                _buildKey('9'),
                _buildKeyBig('<'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildKey('4'),
                _buildKey('5'),
                _buildKey('6'),
                _buildKeyBig('C'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildKey('1'),
                _buildKey('2'),
                _buildKey('3'),
                _buildSimpan('Simpan'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildKey('0'),
                _buildKey('00'),
                _buildKey('.'),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String keyValue) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.115,
      width: MediaQuery.of(context).size.width * 0.11,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // <-- Radius
            ),
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white
            // Background color
            ),
        onPressed: () => _handleKeyPress(keyValue),
        child: Text(
          keyValue,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 160, 147),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpan(String keyValue) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // <-- Radius
          ),
          padding: EdgeInsets.zero,
          backgroundColor: Color.fromARGB(255, 0, 160, 147),
          // Background color
        ),
        onPressed: () => _handleKeyPress(keyValue),
        child: Text(
          keyValue,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildKeyBig(String keyValue) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // <-- Radius
            ),
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white
            // Background color
            ),
        onPressed: () => _handleKeyPress(keyValue),
        child: Text(keyValue),
      ),
    );
  }
}
