import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Dashboard.dart';
import 'LoginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstLastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? accountType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
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
                'SignUp',
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    value: 'Shopper',
                    groupValue: accountType,
                    onChanged: (value) {
                      setState(() {
                        accountType = value;
                      });
                    },
                  ),
                  Text('Shopper'),
                  SizedBox(width: 15,),
                  Radio(
                    value: 'Seller',
                    groupValue: accountType,
                    onChanged: (value) {
                      setState(() {
                        accountType = value;
                      });
                    },
                  ),
                  Text('Seller'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextFormField(
                  controller: firstLastNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    fillColor: Color(0xff55b3bb),
                    focusColor: Color(0xff55b3bb),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                    hintText: 'First & Last Name',
                    labelStyle: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  cursorColor: Color(0xff55b3bb),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4),
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
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                    hintText: 'Email',
                    labelStyle: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  cursorColor: Color(0xff55b3bb),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xff55b3bb),
                    focusColor: Color(0xff55b3bb),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                    hintText: 'Password',
                    labelStyle: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  cursorColor: Color(0xff55b3bb),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: TextButton(
                child: Text(
                  'Have an account ?',
                  style: GoogleFonts.elMessiri(
                    color: Color(0xff55b3bb).withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 35, right: 35),
              child: InkWell(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xff55b3bb)),
                  child: Center(
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.elMessiri(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  validateEntities();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  validateEntities() {
    // Check account type value before SignUp
    if (accountType==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(child: Text('Account type is mandatory', style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 19))),
      ));
    } else if (firstLastNameController.text.length < 6 ) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(
          child: Text(
            'First and last name is too short',
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
        ),
      ));
    } else if (emailController.text.contains('.com') == false || emailController.text.contains('@') == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(
          child: Text(
            'Email is invalid',
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
        ),
      ));
    } else if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(
          child: Text(
            'Password is invalid',
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
        ),
      ));
    } else {
      createAccountProcess();
    }
  }

  createAccountProcess() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      ).then((value) async {
        final user = value.user;
        if (user != null) {
          await FirebaseFirestore.instance.collection('Accounts').doc(user.uid).set({
              'UserID': user.uid,
              'UserName': firstLastNameController.text,
              'UserEmail': emailController.text,
              'CreatedAt': DateTime.now(),
              'IsActive': true,
              'AccountType':accountType
              }).then((metaData) async {
            await FirebaseFirestore.instance.collection('Accounts').doc(user.uid).get().then((userData) {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => Dashboard(userData: userData)));
            });
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            content: Center(child: Text('An error occur while creating your account', style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 19))),
          ));
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(child: Text(e.toString().toUpperCase(), style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 19))),
      ));
    } catch (s){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(child: Text('Sign Up process failed', style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 19))),
      ));
    }
  }
}
