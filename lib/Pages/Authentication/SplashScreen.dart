import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    navigateAfterDuration();
    super.initState();
  }

  navigateAfterDuration() {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 275,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/Logo1.png'))),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.8,
            ),
            LoadingAnimationWidget.beat(
              color: Color(0xff55b3bb),
              size: 75,
            ),
            SizedBox(
              height: 45,
            ),
            Text(
              'Loading....',
              style: GoogleFonts.elMessiri(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Color(0xff55b3bb),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
