import 'package:flutter/material.dart';

class PaymentSubscribtion extends StatefulWidget {
  final String subscribtion;
  final num amount;
  const PaymentSubscribtion(
      {Key? key, required this.subscribtion, required this.amount})
      : super(key: key);

  @override
  State<PaymentSubscribtion> createState() => _PaymentSubscribtionState();
}

class _PaymentSubscribtionState extends State<PaymentSubscribtion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}
