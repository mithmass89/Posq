// ignore_for_file: unused_field, unused_element, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:posq/classfungsi/classbiometrik.dart';
import 'package:posq/classfungsi/classsesilogin.dart';
import 'package:posq/classui/api.dart';
import 'package:posq/classui/classtextfield.dart';
import 'package:posq/classui/color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:posq/mainapps.dart';
import 'package:posq/model.dart';
import 'package:posq/pageresetpassword.dart';
import 'package:posq/paymentcheck.dart';
import 'package:posq/registerform.dart';
import 'package:posq/setting/classsetupprofilemobile.dart';
import 'package:posq/userinfo.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String username = '';
  Color color1 = HexColor("b74093");
  Color color2 = HexColor("#b74093");
  Color color3 = HexColor("#88b74093"); // If you wish to use ARGB format
  bool passwordlock = false;
  bool usernames = true;
  DateTime currentTime = DateTime.now();
  String? aktif = 'tidak aktif';
  bool isregistered = false;

  Future<void> _login() async {
    try {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: 'mithmass89@gmail.com');
      // AuthCredential credential = EmailAuthProvider.credential(
      //     email: 'mithmass89@gmail.com', password: '123456');
      // await FirebaseAuth.instance.currentUser!
      //     .reauthenticateWithCredential(credential);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: 'Mitro100689',
      );
      print('User Firebase ${userCredential.user!} logged in');
      // Navigate to home page
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  final BiometricRegistration _biometricRegistration = BiometricRegistration();

  void _registerBiometrics() async {
    bool registered = await _biometricRegistration.registerBiometrics(context);

    if (registered) {
      // Biometric registration successful. Implement your logic here.
      print('Biometric registration successful!');
    } else {
      // Biometric registration failed or canceled.
      print('Biometric registration failed or canceled.');
    }
  }

  Future<void> _checkBiometric() async {
    final LocalAuthentication localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        // Check if fingerprint is an available biometric type
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();
        bool hasFingerprint =
            availableBiometrics.contains(BiometricType.fingerprint);

        if (hasFingerprint) {
          print("Fingerprint authentication is available on this device.");
        } else {
          print("Fingerprint authentication is not available on this device.");
        }
      } else {
        print("Biometric is not available on this device.");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  // ···
  localAuth() async {
    final bool didAuthenticate = await auth.authenticate(
      biometricOnly: true,
      localizedReason: 'Please authenticate AOVIPOS',
    );
    print(didAuthenticate);
    return didAuthenticate;
  }

  bool validateEmail(String email) {
    // regex pattern for validating email address
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    // create a RegExp object with the pattern
    final regExp = RegExp(pattern);

    // use the RegExp object to match the email address
    return regExp.hasMatch(email);
  }

  String formatDate(DateTime dateTime) {
    // Format the DateTime object using intl package.
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String? formattedCurrentTime;

  @override
  void initState() {
    super.initState();
    LogOut.signOut(context: context);
    formattedCurrentTime = formatDate(currentTime);
    loadSession();
  }

  loadSession() async {
    email.text = (await LoginSession.getEmail())!;
    password.text = (await LoginSession.getPassword())!;
  }

  Future<String> expiredDate(String email) async {
    int differenceInDays = 0;
    // email = 'mithmass89@gmail.com';
    await ClassApi.checkExpiredDate(email).then((value) {
      if (value.isNotEmpty) {
        expireddate = value[0]['expireddate'];
        var expired = DateTime.parse(value[0]['expireddate']);
        var sekarang = DateTime.parse(formattedCurrentTime!);
        Duration difference = expired.difference(sekarang);
        differenceInDays = difference.inDays;

        if (differenceInDays > 3) {
          aktif = 'aktif';

          Fluttertoast.showToast(
              msg: "Sisa masa aktif $differenceInDays",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 11, 12, 14),
              textColor: Colors.white,
              fontSize: 16.0);
          print('masih aktif seharusnya  ');

          return aktif;
        } else if (differenceInDays <= 0) {
          aktif = 'tidak aktif';
          Fluttertoast.showToast(
              msg: "Expired",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 11, 12, 14),
              textColor: Colors.white,
              fontSize: 16.0);
          print('masih expired  ');
          return aktif;
        } else {
          aktif = 'aktif';
          print('masih aktif  ');
          return aktif;
        }
      }
      aktif = 'tidak terdaftar';
      return aktif;
    });
    print('ini aktif $aktif');
    return aktif!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (
          context,
          BoxConstraints constraints,
        ) {
          if (constraints.maxWidth <= 480) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.orange, Colors.orange])),
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'AOVIPOS',
                          style: TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
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
                        child: TextFieldMobileLogin(
                          hint: 'password',
                          showpassword: passwordlock,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordlock
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            // await _lo
                            // ClassApi.checkExpiredDate(email.text)
                            //     .then((value) {});

                            aktif = await expiredDate(email.text);
                            print(aktif);
                            if (aktif == 'aktif') {
                              EasyLoading.show(status: 'loading...');
                              await ClassApi.getUserinfofromManual(
                                      email.text, password.text)
                                  .then((value) async {
                                if (value.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Username / password salah",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Color.fromARGB(255, 11, 12, 14),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  usercd = value[0]['usercd'];
                                  await ClassApi.checkUserFromOauth(
                                          email.text, 'profiler')
                                      .then((values) async {
                                    if (values.isNotEmpty) {
                                      print(values);

                                      setState(() {
                                        usercd = values[0]['usercd'];
                                        imageurl = values[0]['urlpict'];
                                        emaillogin = email.text;
                                        subscribtion = value[0]['subscription'];
                                        paymentcheck = value[0]['paymentcheck'];
                                        level = value[0]['level'];
                                        corporatecode =
                                            value[0]['frenchisecode'];
                                        referrals = value[0]['referral'];
                                        telp = value[0]['telp'];
                                        LoginSession.saveLoginInfo(
                                          emaillogin,
                                          password.text,
                                          dbname,
                                          pscd,
                                        );
                                      });
                                      await ClassApi.checkVerifiedPayment(
                                              emaillogin)
                                          .then((value) async {
                                        if (value[0]['paymentcheck'] ==
                                                'pending' ||
                                            value[0]['paymentcheck'] == '') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentChecks(
                                                      email: emaillogin,
                                                      fullname: values[0]
                                                          ['usercd'],
                                                      trno: value[0]
                                                          ['pytransaction'],
                                                    )),
                                          );
                                        } else {
                                          await ClassApi.getOutlets(email.text)
                                              .then((valued) async {
                                            if (valued.length != 0) {
                                              dbname = valued[0]['outletcode'];
                                              pscd = valued[0]['outletcode'];
                                              outletdesc =
                                                  valued[0]['outletdesc'];
                                              for (var x in valued) {
                                                listoutlets
                                                    .add(x['outletcode']);
                                              }
                                              await ClassApi.getAccessUser(
                                                      email.text)
                                                  .then((valueds) {
                                                for (var x in valueds) {
                                                  accesslist.add(x['access']);
                                                }
                                              });
                                              accesslistuser = [];
                                              await ClassApi
                                                      .getAccessUserOutlet(
                                                          email.text, pscd, '')
                                                  .then((valuesx) {
                                                for (var z in valuesx) {
                                                  print(
                                                      'ini access : $valuesx');
                                                  accesslistuser
                                                      .add(z['accesscode']);
                                                }
                                              });
                                              await ClassApi
                                                      .getAccessSettingsUser()
                                                  .then((valuess) {
                                                for (var x in valuess) {
                                                  strictuser = valuess[0]
                                                          ['strictuser']
                                                      .toString();
                                                }
                                              });
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Mainapps(
                                                                fromretailmain:
                                                                    false,
                                                              )),
                                                      (Route<dynamic> route) =>
                                                          false);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClassSetupProfileMobile(
                                                          email: email.text,
                                                          fullname: usercd,
                                                        )),
                                              );
                                            }
                                          });
                                        }
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Username / password salah",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Color.fromARGB(255, 11, 12, 14),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  });
                                  print(value);
                                }
                              });
                              emaillogin = email.text;
                              EasyLoading.dismiss();
                            } else if (aktif == 'tidak aktif') {
                              Fluttertoast.showToast(
                                  msg: "Masa Aktif habis",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Color.fromARGB(255, 11, 12, 14),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (aktif == 'tidak terdaftar') {
                              Fluttertoast.showToast(
                                  msg: "E-mail tidak valid",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Color.fromARGB(255, 11, 12, 14),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Text(
                                'Masuk ',
                                style: TextStyle(color: Colors.orange),
                              ))),
                      TextButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordClass()),
                            );
                          },
                          child: Text('Lupa Password ?',
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Background color
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterForm()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: Wrap(
                            children: <Widget>[
                              Text("Daftar",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.orange, // Background color
                      //   ),
                      //   onPressed: () async {
                      //     // _registerBiometrics();
                      //     // _checkBiometric();
                      //     localAuth();
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     width: MediaQuery.of(context).size.width * 0.70,
                      //     child: Wrap(
                      //       children: <Widget>[
                      //         Text("Absensi",
                      //             style: TextStyle(
                      //                 fontSize: 20, color: Colors.white)),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                )
              ],
            );
          } else if (constraints.maxWidth >= 800) {
            return Container(
              color: Colors.white,
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.white])),
                  height: MediaQuery.of(context).size.height * 0.68,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'AOVIPOS',
                          style: TextStyle(fontSize: 24, color: Colors.orange),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
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
                        child: TextFieldMobileLogin(
                          hint: 'password',
                          showpassword: passwordlock,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordlock
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.01,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.orange, // Background color
                            ),
                            onPressed: () async {
                              aktif = await expiredDate(email.text);
                              print(aktif);
                              if (aktif == 'aktif') {
                                EasyLoading.show(status: 'loading...');
                                await ClassApi.getUserinfofromManual(
                                        email.text, password.text)
                                    .then((value) async {
                                  if (value.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Username / password salah",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Color.fromARGB(255, 11, 12, 14),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    usercd = value[0]['usercd'];
                                    corporatecode = value[0]['frenchisecode'];
                                    await ClassApi.checkUserFromOauth(
                                            email.text, 'profiler')
                                        .then((values) async {
                                      if (values.isNotEmpty) {
                                        print(values);
                                        LoginSession.saveLoginInfo(
                                          email.text,
                                          password.text,
                                          dbname,
                                          pscd,
                                        );
                                        // usercd = value[0]['usercd'];
                                        setState(() {
                                          usercd = values[0]['usercd'];
                                          imageurl = values[0]['urlpict'];
                                          emaillogin = email.text;
                                          subscribtion =
                                              value[0]['subscription'];
                                          paymentcheck =
                                              value[0]['paymentcheck'];
                                          corporatecode =
                                              value[0]['frenchisecode'];
                                        });
                                        await ClassApi.checkVerifiedPayment(
                                                emaillogin)
                                            .then((value) async {
                                          if (value[0]['paymentcheck'] ==
                                                  'pending' ||
                                              value[0]['paymentcheck'] == '') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentChecks(
                                                        fullname: username,
                                                        email: emaillogin,
                                                        trno: value[0]
                                                            ['pytransaction'],
                                                      )),
                                            );
                                          } else if (value[0]['paymentcheck'] ==
                                              'settlement') {
                                            await ClassApi.getOutlets(
                                                    email.text)
                                                .then((value) async {
                                              if (value.isNotEmpty) {
                                                await ClassApi.getOutlets(
                                                        email.text)
                                                    .then((valued) {
                                                  dbname =
                                                      valued[0]['outletcode'];
                                                  pscd =
                                                      valued[0]['outletcode'];
                                                  outletdesc =
                                                      valued[0]['outletdesc'];
                                                  for (var x in valued) {
                                                    listoutlets
                                                        .add(x['outletcode']);
                                                  }
                                                });
                                                await ClassApi.getAccessUser(
                                                        email.text)
                                                    .then((valueds) {
                                                  for (var x in valueds) {
                                                    accesslist.add(x['access']);
                                                  }
                                                });
                                                accesslistuser = [];
                                                await ClassApi
                                                        .getAccessUserOutlet(
                                                            email.text,
                                                            pscd,
                                                            '')
                                                    .then((valuesx) {
                                                  for (var z in valuesx) {
                                                    accesslistuser
                                                        .add(z['accesscode']);
                                                  }
                                                });
                                                await ClassApi
                                                        .getAccessSettingsUser()
                                                    .then((valuess) {
                                                  strictuser = valuess[0]
                                                          ['strictuser']
                                                      .toString();
                                                });

                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Mainapps(
                                                                      fromretailmain:
                                                                          false,
                                                                    )),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ClassSetupProfileMobile(
                                                              fullname: usercd,
                                                              email:
                                                                  email.text)),
                                                );
                                              }
                                            });
                                          } else {
                                            await ClassApi.getOutlets(
                                                    email.text)
                                                .then((valued) {
                                              dbname = valued[0]['outletcode'];
                                              pscd = valued[0]['outletcode'];
                                              outletdesc =
                                                  valued[0]['outletdesc'];
                                              for (var x in valued) {
                                                listoutlets
                                                    .add(x['outletcode']);
                                              }
                                            });
                                            await ClassApi.getAccessUser(
                                                    email.text)
                                                .then((valueds) {
                                              for (var x in valueds) {
                                                accesslist.add(x['access']);
                                              }
                                            });
                                            accesslistuser = [];
                                            await ClassApi.getAccessUserOutlet(
                                                    email.text, pscd, '')
                                                .then((valuesx) {
                                              for (var z in valuesx) {
                                                accesslistuser
                                                    .add(z['accesscode']);
                                              }
                                            });
                                            await ClassApi
                                                    .getAccessSettingsUser()
                                                .then((valuess) {
                                              strictuser = valuess[0]
                                                      ['strictuser']
                                                  .toString();
                                            });
                                            await ClassApi
                                                    .getLoyalityProgramActive()
                                                .then((rules) {
                                              rulesprogram = PointSystem(
                                                fromdate: rules[0]['fromdate'],
                                                type: rules[0]['type'],
                                                todate: rules[0]['todate'],
                                                convamount: rules[0]
                                                    ['convamount'],
                                                point: rules[0]['point'],
                                                joinreward: rules[0]
                                                    ['joinreward'],
                                              );
                                            });
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Mainapps(
                                                              fromretailmain:
                                                                  false,
                                                            )),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Username / password salah",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromARGB(255, 11, 12, 14),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    });
                                    print(value);
                                  }
                                });
                                emaillogin = email.text;
                                EasyLoading.dismiss();
                              } else if (aktif == 'tidak aktif') {
                                Fluttertoast.showToast(
                                    msg: "Masa Aktif habis",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 12, 14),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (aktif == 'tidak terdaftar') {
                                Fluttertoast.showToast(
                                    msg: "E-mail tidak valid",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 12, 14),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Text(
                                  'Masuk ',
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ),

                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordClass()),
                            );
                          },
                          child: Text('Lupa Password ?',
                              style: TextStyle(color: Colors.orange)))
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.02,
                        // ),
                        //   ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white, // Background color
                        //   ),
                        //   onPressed: () async {
                        //     await LogOut.signOut(context: context);
                        //     await Authentication.signInWithGoogle(
                        //             context: context)
                        //         .then((value) async {
                        //       if (value!.email == null) {
                        //         Fluttertoast.showToast(
                        //             msg: "Email is not Verified",
                        //             toastLength: Toast.LENGTH_LONG,
                        //             gravity: ToastGravity.CENTER,
                        //             timeInSecForIosWeb: 1,
                        //             backgroundColor:
                        //                 Color.fromARGB(255, 11, 12, 14),
                        //             textColor: Colors.white,
                        //             fontSize: 16.0);
                        //       } else {
                        //         await ClassApi.updateUserGmail(
                        //             UserInfoSys(
                        //                 fullname: value.displayName!,
                        //                 token: '',
                        //                 lastsignin: '',
                        //                 urlpic: value.photoURL!,
                        //                 uuid: value.uid),
                        //             'profiler');
                        //         await ClassApi.checkUserFromOauth(
                        //                 value.email!, 'profiler')
                        //             .then((values) async {
                        //           if (values.isNotEmpty) {
                        //             print(values);
                        //             setState(() {
                        //               usercd = values[0]['usercd'];
                        //               imageurl = value.photoURL!;
                        //               emaillogin = value.email!;
                        //               print('ini urlpics : $imageurl');
                        //             });
                        //             await ClassApi.checkVerifiedPayment(
                        //                     emaillogin)
                        //                 .then((value) async {
                        //               print(value[0]['paymentcheck']);
                        //               if (value[0]['paymentcheck'] == 'pending' ||
                        //                   value[0]['paymentcheck'] == '') {
                        //                 Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                       builder: (context) => PaymentChecks(
                        //                             username: username,
                        //                             email: emaillogin,
                        //                             trno: value[0]
                        //                                 ['pytransaction'],
                        //                           )),
                        //                 );
                        //                 Fluttertoast.showToast(
                        //                     msg: "Memverifikasi pembayaran",
                        //                     toastLength: Toast.LENGTH_LONG,
                        //                     gravity: ToastGravity.CENTER,
                        //                     timeInSecForIosWeb: 1,
                        //                     backgroundColor:
                        //                         Color.fromARGB(255, 11, 12, 14),
                        //                     textColor: Colors.white,
                        //                     fontSize: 16.0);
                        //               } else {
                        //                 await ClassApi.getOutlets(usercd)
                        //                     .then((valued) async {
                        //                   if (valued.length != 0) {
                        //                     dbname = valued[0]['outletcode'];
                        //                     pscd = valued[0]['outletcode'];
                        //                     for (var x in valued) {
                        //                       listoutlets.add(x['outletcode']);
                        //                     }
                        //                     await ClassApi.getAccessUser(usercd)
                        //                         .then((valueds) {
                        //                       for (var x in valueds) {
                        //                         accesslist.add(x['access']);
                        //                       }
                        //                     });
                        //                     await ClassApi.getAccessSettingsUser()
                        //                         .then((valuess) {
                        //                       strictuser = valuess[0]
                        //                               ['strictuser']
                        //                           .toString();
                        //                     });
                        //                     Navigator.of(context)
                        //                         .pushAndRemoveUntil(
                        //                             MaterialPageRoute(
                        //                                 builder: (context) =>
                        //                                     Mainapps()),
                        //                             (Route<dynamic> route) =>
                        //                                 false);
                        //                   } else {
                        //                     Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                           builder: (context) =>
                        //                               ClassSetupProfileMobile(
                        //                                 username: username,
                        //                               )),
                        //                     );
                        //                   }
                        //                 });
                        //               }
                        //             });
                        //           } else {
                        //             Fluttertoast.showToast(
                        //                 msg: "User Not Found",
                        //                 toastLength: Toast.LENGTH_LONG,
                        //                 gravity: ToastGravity.CENTER,
                        //                 timeInSecForIosWeb: 1,
                        //                 backgroundColor:
                        //                     Color.fromARGB(255, 11, 12, 14),
                        //                 textColor: Colors.white,
                        //                 fontSize: 16.0);
                        //             LogOut.signOut(context: context);
                        //           }
                        //         });
                        //       }
                        //     });
                        //   },
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     width: MediaQuery.of(context).size.width * 0.24,
                        //     height: MediaQuery.of(context).size.height * 0.04,
                        //     child: Wrap(
                        //       children: <Widget>[
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height * 0.05,
                        //           child: ImageIcon(
                        //             AssetImage("assets/google.png"),
                        //             size: 20,
                        //             color: Colors.orange,
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height * 0.05,
                        //           child: Text("masuk dengan gmail",
                        //               style: TextStyle(
                        //                   fontSize: 13, color: Colors.orange)),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Belum Punya Akun ? ",
                                  style: TextStyle(fontSize: 14)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterForm()),
                                  );
                                },
                                child: Text(" Daftar ",
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ]),
            );
          }
          return Center(
            child: Text('Device Not Supported yet'),
          );
        }));
  }
}

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        await user?.sendEmailVerification();
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          print(e);
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          print(e);
        }
      } catch (e) {
        // handle the error here
        print(e);
      }
    }

    return user;
  }
}

class LogOut {
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   Authentication.customSnackBar(
      //     content: 'Error signing out. Try again.',
      //   ),
      // );
      print(e);
    }
  }
}
