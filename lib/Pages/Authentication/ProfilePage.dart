import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_note_app/Pages/Authentication/LoginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xff55b3bb),
                child: Text(
                  widget.userData['UserName'][0].toUpperCase(),
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Profile',
                style: GoogleFonts.elMessiri(fontSize: 27, fontWeight: FontWeight.bold,color: Color(0xff55b3bb)),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Name: ${widget.userData['UserName']}',
                        style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xff55b3bb)),
                      ),
                    ],
                  )
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Email: ${widget.userData['UserEmail']}',
                        style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xff55b3bb)),
                      ),
                    ],
                  )
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Account Type: ${widget.userData['AccountType']}',
                        style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xff55b3bb)),
                      ),
                    ],
                  )
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: ()async{
                  await _auth.signOut();
                  Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
                },
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign Out',
                          style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
                        ),
                        Icon(Icons.logout, color: Colors.red,)
                      ],
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
