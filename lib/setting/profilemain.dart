// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:posq/setting/classprofilemobile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 480) {
            return Profilemobile();
          }
          return Container();
        },
      ),
    );
  }
}
