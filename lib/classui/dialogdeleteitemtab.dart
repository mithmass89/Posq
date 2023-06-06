import 'package:flutter/material.dart';

class DialogDeleteItem extends StatefulWidget {
  final String itemdesc;
  final Function(String password) onPasswordEntered;

  DialogDeleteItem({required this.onPasswordEntered, required this.itemdesc});

  @override
  _DialogDeleteItemState createState() => _DialogDeleteItemState();
}

class _DialogDeleteItemState extends State<DialogDeleteItem> {
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hapus item'),
      content: Text(widget.itemdesc),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            String password = 'oke';
            widget.onPasswordEntered(password);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
