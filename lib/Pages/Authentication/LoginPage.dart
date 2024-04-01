import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Dashboard.dart';
import 'SignUpPage.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15,),
                Container(
                  height: 225,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Logo1.png'),
                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    'Login',
                    style: GoogleFonts.elMessiri(
                      color: Color(0xff55b3bb),
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Color(0xff55b3bb),
                        focusColor: Color(0xff55b3bb),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                        hintText: 'Email',
                        labelStyle: GoogleFonts.elMessiri(
                          color: Color(0xff55b3bb),
                          fontSize: 17,
                        ),
                      ),
                      cursorColor: Color(0xff55b3bb),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Color(0xff55b3bb),
                        focusColor: Color(0xff55b3bb),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                        labelStyle: GoogleFonts.elMessiri(
                          color: Color(0xff55b3bb),
                          fontSize: 17,
                        ),
                        hintText: 'Password',
                      ),
                      cursorColor: Color(0xff55b3bb),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text(
                    'Don\'t have an account ?',
                    style: GoogleFonts.elMessiri(
                      color: Color(0xff55b3bb),
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => SignUpPage()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 35, right: 35),
                  child: InkWell(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xff55b3bb)),
                      child: Center(
                        child: Text(
                          'Login',
                          style: GoogleFonts.elMessiri(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      initiateLoginProcess();
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  initiateLoginProcess() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString()
      ).then((value) async {
        final user = value.user;
        if (user != null) {
          await FirebaseFirestore.instance.collection('Accounts').doc(user.uid).get().then((userData) async {
            if (userData.data()?['IsActive'] == false) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 4),
                backgroundColor: Colors.red,
                content: Center(child: Text('Your account is not active, please contact the administrator',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19))),
              ));
            } else {
              print('Account passed');
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => Dashboard(userData: userData)));
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            content: Center(child: Text('An error occur while login you',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19,))),
          ));
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(child: Text('Invalid email or password',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19,))),
      ));
    }
  }
}
