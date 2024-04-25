import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;
  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff55b3bb),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'All Orders',
            style: GoogleFonts.elMessiri(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Orders').where('ShopperUID', isEqualTo: widget.userData.id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var item = snapshot.data!.docs[index];
                // Customize card design here
                return GestureDetector(
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      children: [
                        Center(
                          child: Text(item['OrderNumber'].toString(),
                            style: GoogleFonts.elMessiri(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff08666E),
                            ),
                          ),
                        ),
                        SizedBox(height: 3,),
                        Center(
                          child: Text(DateFormat('dd/MM/yyyy hh:mm a').format(item['OrderDate'].toDate()),
                            style: GoogleFonts.elMessiri(
                              fontSize: 20,
                              color: Color(0xff08666E),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Item Name: ${item['ItemName']}',
                            style: GoogleFonts.elMessiri(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff08666E),
                            ),
                          ),
                          subtitle: Text(
                            'Price: ${item['OrderAmount']} SAR',
                            style: GoogleFonts.elMessiri(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff55b3bb),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
