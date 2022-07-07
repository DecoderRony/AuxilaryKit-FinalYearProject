import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectfinal/splash.dart';

import './datadisplay.dart';

bool visited = false;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String _id = "";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
              left: -310,
              top: 50,
              child: ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Colors.red, Colors.black],
                  ).createShader(bounds);
                },
                child: SvgPicture.asset(
                  'img/heart1.svg',
                  height: 650,
                  width: 650,
                  color: Colors.red[400],
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 70, left: 10),
                child: Text(
                  'Hello!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontStyle: FontStyle.italic),
                ),
              ),
              const Divider(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.all(16),
                            fillColor: Colors.white,
                            // labelText: 'Enter Seriel Number',
                            hintText: 'Enter Seriel Number'),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return ("Cannot be empty");
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() {
                          _id = text;
                        }),
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_id != "") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DataDisplay(id: _id)));
                              }

                              return;
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Connect",
                                style: TextStyle(
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ))),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
