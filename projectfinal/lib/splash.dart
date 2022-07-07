import 'package:flutter/material.dart';
import 'package:projectfinal/main.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/splash.png',
              height: 200,
              width: 200,
            ),
            Text(
              'Auxliary',
              style: GoogleFonts.lobster(color: Colors.white, fontSize: 36),
            ),
            Text(
              'We got you covered',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
