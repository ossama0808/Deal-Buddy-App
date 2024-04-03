import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_note_app/Pages/SellerPages/Alltems.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    print(widget.userData.data()?['UserName']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff55b3bb),
        title:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.userData['UserName'] ?? '',
            style: GoogleFonts.elMessiri(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ),
        actions: [
          Visibility(
            visible: widget.userData['AccountType']=='Seller' ? true : false,
            child: IconButton(
              icon: Icon(Icons.inventory,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => AllItems(userData: widget.userData)));
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.account_circle,color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:Column()
        ),
      ),
    );
  }

}
