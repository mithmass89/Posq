import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Guage extends StatefulWidget {
  final double height;
  final double valuemax;
  final double pointer;
  final double startpoint;
  const Guage(
      {super.key,
      required this.height,
      required this.valuemax,
      required this.pointer,
      required this.startpoint});

  @override
  State<Guage> createState() => _GuageState();
}

class _GuageState extends State<Guage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * widget.height,
          child: SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
            RadialAxis(
                minimum: 0,
                maximum: widget.valuemax,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: widget.startpoint,
                      endValue: widget.valuemax,
                      color: Colors.red),
                  GaugeRange(
                      startValue: widget.startpoint,
                      endValue: widget.valuemax,
                      color: Colors.orange),
                  GaugeRange(
                      startValue: widget.startpoint,
                      endValue: widget.valuemax,
                      color: Colors.green)
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(value: widget.pointer)
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                          child: Text(widget.pointer.toString(),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold))),
                      angle: 90,
                      positionFactor: 0.5)
                ])
          ])),
    );
  }
}
