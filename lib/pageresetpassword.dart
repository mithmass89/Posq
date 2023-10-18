import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/userinfo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordClass extends StatefulWidget {
  const ResetPasswordClass({Key? key}) : super(key: key);

  @override
  State<ResetPasswordClass> createState() => _ResetPasswordClassState();
}

class _ResetPasswordClassState extends State<ResetPasswordClass> {
  DateTime now = DateTime.now();
  DateTime? expired;
  TextEditingController email = TextEditingController();
  final supabase = Supabase.instance.client;
  var token;
  var contohdata = {
    "email": "mithmass89@gmail.com",
    "expired": "2023-09-20 14:13:25.804"
  };

  forgetPassword() async {

    DateTime now = DateTime.now();
    expired = now.add(const Duration(hours: 1));
    final jwt = JWT({"email": emaillogin, "expired": expired.toString()});
    token = jwt.sign(SecretKey('@Mitro100689'));
    // await supabase.auth
    //     .resetPasswordForEmail(email.text, redirectTo: urlori)
    //     .onError((error, stackTrace) => print(error));
    await ClassApi.resetPassword(email.text, token);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset password',
          style: TextStyle(color: Colors.white),
        ),
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
                      backgroundColor:
                          AppColors.primaryColor, // Background color
                    ),
                    onPressed: () async {
                      // await _lo

                      EasyLoading.show(status: 'Please wait...');
                      // await ClassApi.resetPassword(email.text);
                      await forgetPassword();
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
