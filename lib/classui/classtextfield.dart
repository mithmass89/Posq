// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors_in_immutables, sized_box_for_whitespace, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TextFieldMobile extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSumbit;
  final typekeyboard;
  final bool? enable;

  TextFieldMobile({
    Key? key,
    this.label,
    required this.controller,
    required this.onChanged,
    required this.typekeyboard,
    this.maxline,
    this.hint,
    this.enable = true,
    this.onSumbit,
  }) : super(key: key);

  @override
  State<TextFieldMobile> createState() => _TextFieldMobileState();
}

class _TextFieldMobileState extends State<TextFieldMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          enableInteractiveSelection:
              widget.enable!, // will disable paste operation
          // enabled: widget.enable,
          maxLines: widget.maxline,
          keyboardType: widget.typekeyboard,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSumbit,
          controller: widget.controller,
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

class TextFieldMobileButton extends StatefulWidget {
  final String? hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback ontap;
  final typekeyboard;
  final suffixicone;

  TextFieldMobileButton({
    Key? key,
    this.hint,
    required this.controller,
    required this.onChanged,
    required this.typekeyboard,
    required this.ontap,
    this.suffixicone,
  }) : super(key: key);

  @override
  State<TextFieldMobileButton> createState() => _TextFieldMobileButtonState();
}

class _TextFieldMobileButtonState extends State<TextFieldMobileButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        onTap: widget.ontap,
        readOnly: true,
        keyboardType: widget.typekeyboard,
        onChanged: widget.onChanged,
        controller: widget.controller,
        autofocus: false,
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: widget.suffixicone == null
              ? const Icon(Icons.arrow_right)
              : widget.suffixicone,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class TextFieldMobileCustome extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSumbit;
  final validator;
  final typekeyboard;
  final double? width;
  final double? height;
  final double? outline;
  final onsave;
  TextFieldMobileCustome({
    Key? key,
    this.label,
    this.validator,
    required this.controller,
    required this.onChanged,
    required this.typekeyboard,
    this.maxline,
    this.hint,
    this.width,
    this.height,
    this.outline,
    this.onSumbit,
    this.onsave,
  }) : super(key: key);

  @override
  State<TextFieldMobileCustome> createState() => _TextFieldMobileCustomeState();
}

class _TextFieldMobileCustomeState extends State<TextFieldMobileCustome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: widget.height,
        width: widget.width,
        child: TextFormField(
          onSaved: widget.onsave,
          validator: widget.validator,
          onFieldSubmitted: widget.onSumbit,
          maxLines: widget.maxline,
          keyboardType: widget.typekeyboard,
          onChanged: widget.onChanged,
          controller: widget.controller,
          decoration: InputDecoration(
              hintText: widget.hint,
              labelText: widget.label.toString(),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: widget.outline!, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: widget.outline!, color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              )),
        ),
      ),
    );
  }
}

class TextFieldMobile2 extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final typekeyboard;
  final bool? enable;
  final double? height;
  final double? width;
  final suffixIcon;
  late bool? readonly;
  late FocusNode? focus;
  var expands;
  var minLines;
  var validator;

  TextFieldMobile2(
      {Key? key,
      this.label,
      required this.controller,
      required this.onChanged,
      required this.typekeyboard,
      this.maxline,
      this.hint,
      this.enable = true,
      this.height,
      this.width,
      this.suffixIcon,
      this.readonly,
      this.focus,
      this.validator,
      this.expands,
      this.minLines})
      : super(key: key);

  @override
  State<TextFieldMobile2> createState() => _TextFieldMobile2State();
}

class _TextFieldMobile2State extends State<TextFieldMobile2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        validator: widget.validator,
        // expands: widget.expands,
        // minLines: widget.minLines,
        // maxLines: widget.maxline,

        focusNode: widget.focus,
        readOnly: widget.readonly ?? false,
        keyboardType: widget.typekeyboard,
        onChanged: widget.onChanged,
        controller: widget.controller,
        // autofocus: false,
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          hintText: widget.hint,
          label: widget.label != null ? Text(widget.label.toString()) : null,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          // contentPadding:
          //     const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 0.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class TextFieldMobile3 extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final typekeyboard;
  final bool? enable;
  final double? height;
  final double? width;
  final suffixIcon;
  late bool? readonly;
  late FocusNode? focus;
  var expands;
  var minLines;
  var validator;

  TextFieldMobile3(
      {Key? key,
      this.label,
      required this.controller,
      required this.onChanged,
      required this.typekeyboard,
      this.maxline,
      this.hint,
      this.enable = true,
      this.height,
      this.width,
      this.suffixIcon,
      this.readonly,
      this.focus,
      this.validator,
      this.expands,
      this.minLines})
      : super(key: key);

  @override
  State<TextFieldMobile3> createState() => _TextFieldMobile3State();
}

class _TextFieldMobile3State extends State<TextFieldMobile3> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        textAlign: TextAlign.center,
        validator: widget.validator,
        // expands: widget.expands,
        // minLines: widget.minLines,
        // maxLines: widget.maxline,

        focusNode: widget.focus,
        readOnly: widget.readonly ?? false,
        keyboardType: widget.typekeyboard,
        onChanged: widget.onChanged,
        controller: widget.controller,
        // autofocus: false,
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          hintText: widget.hint,
          label: widget.label != null ? Text(widget.label.toString()) : null,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          // contentPadding:
          //     const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 0.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class TextFieldTab1 extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final typekeyboard;
  final bool? enable;
  final double? height;
  final double? width;
  final suffixIcon;
  late bool? readonly;
  late FocusNode? focus;
  var expands;
  var minLines;
  var validator;

  TextFieldTab1(
      {Key? key,
      this.label,
      required this.controller,
      required this.onChanged,
      required this.typekeyboard,
      this.maxline,
      this.hint,
      this.enable = true,
      this.height,
      this.width,
      this.suffixIcon,
      this.readonly,
      this.focus,
      this.validator,
      this.expands,
      this.minLines})
      : super(key: key);

  @override
  State<TextFieldTab1> createState() => _TextFieldTab1State();
}

class _TextFieldTab1State extends State<TextFieldTab1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        validator: widget.validator,
        // expands: widget.expands,
        // minLines: widget.minLines,
        // maxLines: widget.maxline,

        focusNode: widget.focus,
        readOnly: widget.readonly ?? false,
        keyboardType: widget.typekeyboard,
        onChanged: widget.onChanged,
        controller: widget.controller,
        // autofocus: false,
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          hintText: widget.hint,
          label: widget.label != null ? Text(widget.label.toString()) : null,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 0.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}


class TextFieldTab2 extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final typekeyboard;
  final bool? enable;
  final double? height;
  final double? width;
  final suffixIcon;
  late bool? readonly;
  late FocusNode? focus;
  var expands;
  var minLines;
  var validator;

  TextFieldTab2(
      {Key? key,
      this.label,
      required this.controller,
      required this.onChanged,
      required this.typekeyboard,
      this.maxline,
      this.hint,
      this.enable = true,
      this.height,
      this.width,
      this.suffixIcon,
      this.readonly,
      this.focus,
      this.validator,
      this.expands,
      this.minLines})
      : super(key: key);

  @override
  State<TextFieldTab2> createState() => _TextFieldTab2State();
}

class _TextFieldTab2State extends State<TextFieldTab2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        validator: widget.validator,
        // expands: widget.expands,
        // minLines: widget.minLines,
        // maxLines: widget.maxline,

        focusNode: widget.focus,
        readOnly: widget.readonly ?? false,
        keyboardType: widget.typekeyboard,
        onChanged: widget.onChanged,
        controller: widget.controller,
        // autofocus: false,
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          hintText: widget.hint,
          label: widget.label != null ? Text(widget.label.toString()) : null,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 0.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}


class TextFieldMobileLogin extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final int? maxline;
  final ValueChanged<String> onChanged;
  final typekeyboard;
  final bool? enable;
  final double? height;
  final double? width;
  final suffixIcon;
  final prefixIcon;
  late bool? readonly;
  late FocusNode? focus;
  final bool? showpassword;
  var expands;
  var minLines;
  var validator;

  TextFieldMobileLogin(
      {Key? key,
      this.label,
      required this.controller,
      required this.onChanged,
      required this.typekeyboard,
      this.maxline,
      this.hint,
      this.enable = true,
      this.height,
      this.width,
      this.suffixIcon,
      this.readonly,
      this.focus,
      this.validator,
      this.expands,
      this.minLines,
      this.showpassword,
      this.prefixIcon})
      : super(key: key);

  @override
  State<TextFieldMobileLogin> createState() => _TextFieldMobileLoginState();
}

class _TextFieldMobileLoginState extends State<TextFieldMobileLogin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        validator: widget.validator,

        obscureText: !widget.showpassword!, //This will obscure text dynamically
        focusNode: widget.focus,
        readOnly: widget.readonly ?? false,
        keyboardType: widget.typekeyboard,
        onChanged: widget.onChanged,
        controller: widget.controller,
        // autofocus: false,
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hint,
          label: widget.label != null ? Text(widget.label.toString()) : null,
          // border: InputBorder.none,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          filled: true,
          fillColor: Colors.white,
          // contentPadding:
          //     const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 0.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
