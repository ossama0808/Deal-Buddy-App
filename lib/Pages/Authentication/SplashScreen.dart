import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Dashboard.dart';
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

  navigateAfterDuration() async{
    // Delay for splash screen
    await Future.delayed(Duration(seconds: 3));

    // Check if a user is already signed in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Accounts').doc(user.uid).get().then((userData) async {
        if (userData.exists==true){
          if (userData.data()?['IsActive'] == false) {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
          } else {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => Dashboard(userData: userData)));
          }
        }else{
          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
        }
      });
    } else {
      // If no user is signed in, navigate to the login page
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
    }
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
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 250,
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
