// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final typekeyboard;
  const SearchWidget(
      {Key? key,
      this.label,
      this.hint,
      required this.controller,
      this.maxline,
      required this.onChanged,
      this.typekeyboard})
      : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 1,
        child: TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              hintText: widget.hint,
              labelText: widget.label.toString(),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              )),
        ),
      ),
    );
  }
}
class SearchWidgetSmall extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final typekeyboard;
  const SearchWidgetSmall(
      {Key? key,
      this.label,
      this.hint,
      required this.controller,
      this.maxline,
      required this.onChanged,
      this.typekeyboard})
      : super(key: key);

  @override
  State<SearchWidgetSmall> createState() => _SearchWidgetSmallState();
}

class _SearchWidgetSmallState extends State<SearchWidgetSmall> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.55,
        child: TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 15.0, color: Colors.white),
              hintText: widget.hint,
              // labelText: widget.label.toString(),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              )),
        ),
      ),
    );
  }
}
