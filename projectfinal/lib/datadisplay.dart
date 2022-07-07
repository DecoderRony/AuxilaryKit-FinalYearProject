import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// import 'package:firebase_core/firebase_core.dart';

class DataDisplay extends StatefulWidget {
  DataDisplay({Key? key, required this.id});
  dynamic id;
  @override
  State<StatefulWidget> createState() {
    return _DataDisplayState(ref: id);
  }
}

class _DataDisplayState extends State<DataDisplay> {
  var ref;
  _DataDisplayState({this.ref});
  final databaseReference = FirebaseDatabase.instance.reference();
  final databaseReference2 =
      FirebaseDatabase.instance.reference().child('MAX30100/SpO2');
  var HB = [];
  var SpO2 = [];
  bool flag = true;
  Future<void> showData() async {
    // print("laaaaaaaaaaaaaaaaawdddddddddddaaaaaaaaaaaaaaa\n");
    // print(ref);
    await databaseReference
        .child('$ref/HB/')
        .orderByKey()
        .once()
        .then((snapshot) {
      // print(snapshot.value);
      var temp = snapshot.value;
      // print(temp);
      if (temp == null) {
        flag = false;
      } else {
        temp.forEach((value) {
          HB.add(value);
        });
      }
    });

    await databaseReference
        .child('$ref/SpO2/')
        .orderByKey()
        .once()
        .then((snapshot) {
      var temp = snapshot.value;
      // print(temp);
      if (temp == null) {
        flag = false;
      } else {
        temp.forEach((value) {
          SpO2.add(value);
        });
      }
    });
  }

  Timer _tim = Timer.periodic(Duration(seconds: 0), (timer) {});

  @override
  void initState() {
    _tim = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      await showData();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tim.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SfRadialGauge(
                    title: const GaugeTitle(
                        text: 'Heart Beat',
                        textStyle: TextStyle(color: Colors.white)),
                    axes: <RadialAxis>[
                      RadialAxis(
                          startAngle: 90,
                          minimum: 0,
                          maximum: 150,
                          axisLabelStyle:
                              const GaugeTextStyle(color: Colors.white),
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 60,
                                color: Colors.orange,
                                startWidth: 10,
                                endWidth: 10),
                            GaugeRange(
                                startValue: 60,
                                endValue: 95,
                                color: Colors.green,
                                startWidth: 10,
                                endWidth: 10),
                            GaugeRange(
                                startValue: 95,
                                endValue: 150,
                                color: Colors.red,
                                startWidth: 10,
                                endWidth: 10)
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              enableAnimation: true,
                              value: HB.length == 0
                                  ? 0
                                  : double.parse(HB[HB.length - 1]),
                              needleColor: Colors.white,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text(
                                        HB.length == 0
                                            ? '0'
                                            : HB[HB.length - 1],
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                angle: 90,
                                positionFactor: 0.5)
                          ])
                    ],
                  ),
                  Divider(
                    height: 20,
                  ),
                  SfRadialGauge(
                    title: GaugeTitle(
                        text: 'SpO2',
                        textStyle: TextStyle(color: Colors.white)),
                    axes: <RadialAxis>[
                      RadialAxis(
                          startAngle: 90,
                          minimum: 0,
                          maximum: 150,
                          axisLabelStyle: GaugeTextStyle(color: Colors.white),
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 40,
                                color: Colors.red,
                                startWidth: 10,
                                endWidth: 10),
                            GaugeRange(
                                startValue: 40,
                                endValue: 95,
                                color: Colors.orange,
                                startWidth: 10,
                                endWidth: 10),
                            GaugeRange(
                                startValue: 95,
                                endValue: 100,
                                color: Colors.green,
                                startWidth: 10,
                                endWidth: 10),
                            GaugeRange(
                                startValue: 100,
                                endValue: 150,
                                color: Colors.red,
                                startWidth: 10,
                                endWidth: 10)
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              enableAnimation: true,
                              value: SpO2.length == 0
                                  ? 0
                                  : double.parse(SpO2[SpO2.length - 1]),
                              needleColor: Colors.white,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text(
                                        SpO2.length == 0
                                            ? '0'
                                            : SpO2[SpO2.length - 1],
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                angle: 90,
                                positionFactor: 0.5)
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
