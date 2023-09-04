import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AttendanceDialog extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();
  localAuth() async {
    final bool didAuthenticate = await auth.authenticate(
      // biometricOnly: true,
      localizedReason: 'Please authenticate AOVIPOS',
    );
    print(didAuthenticate);
    return didAuthenticate;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Attendance'),
      children: <Widget>[
        buildOption(context, 'Check-in'),
        buildOption(context, 'Breakout'),
        buildOption(context, 'Breakin'),
        buildOption(context, 'Checkout'),
      ],
    );
  }

  Widget buildOption(BuildContext context, String label) {
    return Card(
      child: SimpleDialogOption(
        onPressed: () async {
          await localAuth();
          Navigator.pop(context,
              label); // Close the dialog and return the selected label.
        },
        child: Text(label, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
