import 'package:flutter/material.dart';

class PageFreeTrial extends StatelessWidget {
  final String username;
  final String email;
  const PageFreeTrial({Key? key, required this.username, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: TextButton(
        child: Text('Free Trial 7 Hari'),
        onPressed: () {},
      )),
    );
  }
}
