// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';

class ButtonClassAction extends StatefulWidget {
  final VoidCallback? onpressed;
  final String? iconasset;
  final double? height;
  final double? widht;
  final String? name;
  final color;
  late bool? splash;
  ButtonClassAction(
      {Key? key,
      this.onpressed,
      this.height,
      this.widht,
      this.name,
      this.iconasset,
      this.splash,
      this.color})
      : super(key: key);

  @override
  State<ButtonClassAction> createState() => _ButtonClassActionState();
}

class _ButtonClassActionState extends State<ButtonClassAction> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.orange,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35)),
      onTap: widget.onpressed,
      child: Container(
        height: widget.height,
        width: widget.widht,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:  Colors.blueGrey ,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(widget.iconasset.toString()),
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  widget.name.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                height: widget.height,
                width: widget.widht,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ))
          ],
        ),
      ),
    );
  }
}

class ButtonNoIcon extends StatefulWidget {
  final VoidCallback? onpressed;
  final String? iconasset;
  final double? height;
  final double? width;
  final String? name;
  final color;
  final textcolor;
  final widget;
  const ButtonNoIcon(
      {Key? key,
      this.onpressed,
      this.height,
      this.width,
      this.name,
      this.iconasset,
      this.color,
      this.textcolor,
      this.widget})
      : super(key: key);

  @override
  State<ButtonNoIcon> createState() => _ButtonNoIconState();
}

class _ButtonNoIconState extends State<ButtonNoIcon> {
  @override
  Widget build(BuildContext context) {
    return Material(
      //  elevation: 2,
      child: InkWell(
        onTap: widget.onpressed,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            widget.name.toString(),
            style: TextStyle(color: widget.textcolor),
          ),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: widget.color),
        ),
      ),
    );
  }
}

class ButtonNoIconAnimated extends StatefulWidget {
  final VoidCallback? onpressed;
  final String? iconasset;
  final double? height;
  final double? width;
  final String? name;
  final color;
  final textcolor;
  final widget;
  final int duration;
  final curve;
  const ButtonNoIconAnimated(
      {Key? key,
      this.onpressed,
      this.height,
      this.width,
      this.name,
      this.iconasset,
      this.color,
      this.textcolor,
      this.widget,
      required this.duration,
      required this.curve})
      : super(key: key);

  @override
  State<ButtonNoIconAnimated> createState() => _ButtonNoIconAnimatedState();
}

class _ButtonNoIconAnimatedState extends State<ButtonNoIconAnimated> {
  @override
  Widget build(BuildContext context) {
    return Material(
      //  elevation: 2,
      child: InkWell(
        onTap: widget.onpressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              curve: widget.curve,
              alignment: Alignment.center,
              child: Text(
                widget.name.toString(),
                style: TextStyle(color: widget.textcolor),
              ),
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: widget.color),
              duration: Duration(milliseconds: widget.duration),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonNoIcon2 extends StatefulWidget {
  final VoidCallback? onpressed;
  final String? iconasset;
  final double? height;
  final double? width;
  final String? name;
  final color;
  final textcolor;
  final widget;

  const ButtonNoIcon2({
    Key? key,
    this.onpressed,
    this.height,
    this.width,
    this.name,
    this.iconasset,
    this.color,
    this.textcolor,
    this.widget,
  }) : super(key: key);

  @override
  State<ButtonNoIcon2> createState() => _ButtonNoIcon2State();
}

class _ButtonNoIcon2State extends State<ButtonNoIcon2> {
  @override
  Widget build(BuildContext context) {
    return Material(
      //  elevation: 2,
      child: InkWell(
        onTap: widget.onpressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.name.toString(),
                style: TextStyle(color: widget.textcolor),
              ),
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: widget.color),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors_in_immutables

class Bouncing extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onPress;

  Bouncing({@required this.child, Key? key, this.onPress})
      : assert(child != null),
        super(key: key);

  @override
  _BouncingState createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  double? _scale;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.15,
    );
    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller!.value;
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if (widget.onPress != null) {
          _controller!.forward();
        }
      },
      onPointerUp: (PointerUpEvent event) {
        if (widget.onPress != null) {
          _controller!.reverse();
          widget.onPress!();
        }
      },
      child: Transform.scale(
        scale: _scale!,
        child: widget.child,
      ),
    );
  }
}

class NumPad extends StatelessWidget {
  final double buttonSizewidth;
  final double buttonSizeheight;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;
  final Function clear;

  const NumPad({
    Key? key,
    this.buttonSizewidth = 80,
    this.buttonSizeheight = 50,
    this.buttonColor = Colors.blueAccent,
    this.iconColor = Colors.white,
    required this.delete,
    required this.onSubmit,
    required this.controller,
    required this.clear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: 1,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 2,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 3,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 4,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 5,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 6,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 7,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 8,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 9,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // this button is used to delete the last number
              // IconButton(
              //   onPressed: () => delete(),
              //   icon: Container(
              //     color: Colors.blue,
              //     height: buttonSizeheight,
              //     width: buttonSizewidth,
              //     child: Icon(
              //       Icons.backspace,
              //       color: iconColor,
              //     ),
              //   ),
              //   iconSize: 35,
              // ),
              SizedBox(
                height: buttonSizeheight,
                width: buttonSizewidth,
                child: ElevatedButton(
                  onPressed: () {
                    delete();
                  },
                  child: Icon(
                    Icons.backspace,
                    color: Colors.black,
                  ),
                ),
              ),

              NumberButton(
                number: 0,
                heightsize: buttonSizeheight,
                widthsize: buttonSizewidth,
                color: buttonColor,
                controller: controller,
              ),
              // this button is used to submit the entered value
              SizedBox(
                height: buttonSizeheight,
                width: buttonSizewidth,
                child: ElevatedButton(
                    onPressed: () {
                      clear();
                    },
                    child: Text('C',
                        style: TextStyle(color: Colors.black, fontSize: 20))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// define NumberButton widget
// its shape is round
class NumberButton extends StatelessWidget {
  final int number;
  final double heightsize;
  final double widthsize;
  final Color color;
  final TextEditingController controller;
  final Icon? icon;

  const NumberButton({
    Key? key,
    required this.number,
    required this.color,
    required this.controller,
    required this.heightsize,
    required this.widthsize,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthsize,
      height: heightsize,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(size / 2),
          // ),
        ),
        onPressed: () {
          if (controller.text.isNotEmpty && controller.text.startsWith('0')) {
            controller.text = '';
          } else {
            controller.text += number.toString();
          }
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class ButtonClassPayment extends StatefulWidget {
  final VoidCallback? onpressed;
  final String? iconasset;
  final double? height;
  final double? width;
  final String? name;
  final styleasset;
  final colors;
  const ButtonClassPayment(
      {Key? key,
      this.onpressed,
      this.height,
      this.width,
      this.name,
      this.iconasset,
      this.styleasset,
      this.colors})
      : super(key: key);

  @override
  State<ButtonClassPayment> createState() => _ButtonClassPaymentState();
}

class _ButtonClassPaymentState extends State<ButtonClassPayment> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: InkWell(
        onTap: widget.onpressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.center,
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  scale: 4,
                  image: AssetImage(widget.iconasset.toString()),
                  fit: widget.styleasset ?? BoxFit.scaleDown,
                )),
          ),
        ),
      ),
    );
  }
}

class ButtonClassPayment2 extends StatefulWidget {
  final VoidCallback? onpressed;
  final String? iconasset;
  final double? height;
  final double? width;
  final String? name;
  final styleasset;
  const ButtonClassPayment2(
      {Key? key,
      this.onpressed,
      this.height,
      this.width,
      this.name,
      this.iconasset,
      this.styleasset})
      : super(key: key);

  @override
  State<ButtonClassPayment2> createState() => _ButtonClassPayment2State();
}

class _ButtonClassPayment2State extends State<ButtonClassPayment2> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: InkWell(
        onTap: widget.onpressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: Text(widget.name.toString(),
                style: TextStyle(fontWeight: FontWeight.bold)),
            alignment: Alignment.center,
            height: widget.height,
            width: widget.width,
          ),
        ),
      ),
    );
  }
}

class LoadingButton extends StatefulWidget {
  final VoidCallback? onpressed;
  final String? iconasset;
  final double? height;
  final double? width;
  final String? name;
  final color;
  final textcolor;
  final widget;
  late bool? isLoading;
  LoadingButton({
    this.onpressed,
    this.height,
    this.width,
    this.name,
    this.iconasset,
    this.color,
    this.textcolor,
    this.widget,
    this.isLoading,
  });

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: InkWell(
        onTap: widget.isLoading! ? null : widget.onpressed!,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          alignment: Alignment.center,
          height: widget.height,
          width: widget.width,
          child: widget.isLoading!
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  widget.name.toString(),
                  style: TextStyle(color: widget.textcolor),
                ),
        ),
      ),
    );
  }
}
