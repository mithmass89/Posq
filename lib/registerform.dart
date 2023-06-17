import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/subscriptionpage.dart';
import 'package:posq/userinfo.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namalengkap = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmationpass = TextEditingController();
  bool passwordlock = false;
  bool isRegistered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
        title: Text(''),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: Text(
                      'Segera gabung !',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Text(
                      'Kami senang jika anda bergabung dengan kami !',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.85,
                //   height: MediaQuery.of(context).size.height * 0.01,
                // ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFieldMobileLogin(
                    showpassword: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                    hint: 'User name',
                    prefixIcon: Icon(Icons.contact_mail),
                    controller: namalengkap,
                    onChanged: (String value) {},
                    typekeyboard: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFieldMobileLogin(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'E-mail kosong';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (!emailRegex.hasMatch(email.text)) {
                        return 'E-mail tidak valid';
                        // Email address is invalid, do something
                      } else {
                        print(value);
                      }
                    },
                    showpassword: true,
                    hint: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                    controller: email,
                    onChanged: (String value) async {
                      await ClassApi.checkEmailExist(email.text).then((value) {
                        if (value.isNotEmpty) {
                          print(value);
                          isRegistered = true;
                          Fluttertoast.showToast(
                              msg: "Email sudah terdaftar",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          print(value);
                          isRegistered = false;
                        }
                      });
                    },
                    typekeyboard: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFieldMobileLogin(
                    hint: 'password',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'password tidak boleh kosong';
                      }
                    },
                    showpassword: passwordlock,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        passwordlock ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          passwordlock = !passwordlock;
                        });
                      },
                    ),
                    controller: password,
                    onChanged: (String value) {},
                    typekeyboard: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFieldMobileLogin(
                    hint: 'Confirm password',
                    showpassword: passwordlock,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        passwordlock ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          passwordlock = !passwordlock;
                        });
                      },
                    ),
                    controller: confirmationpass,
                    onChanged: (String value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'confirmasi tidak boleh kosong';
                      }
                      if (value != password.text) {
                        return 'Password tidak sama';
                      }
                      return null;
                    },
                    typekeyboard: null,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Background color
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (isRegistered == true) {
                          Fluttertoast.showToast(
                              msg: "Email sudah terdaftar",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color.fromARGB(255, 11, 12, 14),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          await ClassApi.insertRegisterUserNew(email.text,
                                  namalengkap.text, password.text, 'Owner')
                              .then((_) async {
                            usercd = namalengkap.text;
                            print('ini usercode $usercd');
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => SubScribetionPage(
                                          username: namalengkap.text,
                                          email: email.text,
                                        )),
                                (Route<dynamic> route) => false);
                          });
                        }
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Text(
                          'Buat Akun ',
                          style: TextStyle(color: Colors.white),
                        ))),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: Text(
                      'Dengan Mendaftar , anda menyutujui Syarat dan Ketentuan kami',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
