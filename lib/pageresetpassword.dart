import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';

class ResetPasswordClass extends StatefulWidget {
  const ResetPasswordClass({Key? key}) : super(key: key);

  @override
  State<ResetPasswordClass> createState() => _ResetPasswordClassState();
}

class _ResetPasswordClassState extends State<ResetPasswordClass> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset password'),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldMobileLogin(
                  validator: (value) {
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                    if (!emailRegex.hasMatch(email.text)) {
                      // Email address is invalid, do something
                      print(value);
                    } else {
                      print(value);
                    }
                  },
                  showpassword: true,
                  hint: 'e-mail',
                  prefixIcon: Icon(Icons.email),
                  controller: email,
                  onChanged: (String value) {},
                  typekeyboard: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor, // Background color
                    ),
                    onPressed: () async {
                      // await _lo
                      EasyLoading.show(status: 'Please wait...');
                      ClassApi.resetPassword(email.text);
                      Fluttertoast.showToast(
                          msg:
                              "Instruksi reset password sudah di kirim ke email anda",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 11, 12, 14),
                          textColor: Colors.white,
                          fontSize: 16.0);
                      EasyLoading.dismiss();
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Text(
                          'Reset ',
                          style: TextStyle(color: Colors.white),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
