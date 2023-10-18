import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Guage extends StatefulWidget {
  final double height;
  final double valuemax;
  final double pointer;
  final double startpoint;
  final double starpointnotgood;
  final double notgood;
  final double starpointnotcomfort;
  final double comfort;
  final double starpointgoodbisnis;
  final double goodbisnis;
  const Guage(
      {super.key,
      required this.height,
      required this.valuemax,
      required this.pointer,
      required this.startpoint,
      required this.notgood,
      required this.comfort,
      required this.goodbisnis,
      required this.starpointnotgood,
      required this.starpointnotcomfort,
      required this.starpointgoodbisnis});

  @override
  State<Guage> createState() => _GuageState();
}

class _GuageState extends State<Guage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * widget.height,
        child: SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: widget.valuemax, ranges: <GaugeRange>[
            GaugeRange(
                startValue: widget.starpointnotgood,
                endValue: widget.notgood,
                color: Colors.red),
            GaugeRange(
                startValue: widget.starpointnotcomfort,
                endValue: widget.comfort,
                color: Colors.orange),
            GaugeRange(
                startValue: widget.starpointgoodbisnis,
                endValue: widget.goodbisnis,
                color: Colors.green)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: widget.pointer)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Text(widget.pointer.toString(),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]));
  }
}
