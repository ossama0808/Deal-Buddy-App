import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_note_app/Pages/SellerPages/PostItem.dart';

class AllItems extends StatefulWidget {
  const AllItems({required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;

  @override
  State<AllItems> createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff55b3bb),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'All Items',
            style: GoogleFonts.elMessiri(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.post_add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (BuildContext context) => PostItem(userData: widget.userData),
              ));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Items').where('SellerUID', isEqualTo: widget.userData.id).snapshots(),
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
                  onTap: (){
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => PostItem(
                        userData: widget.userData,
                        updateItemDoc: snapshot.data!.docs[index] as DocumentSnapshot<Map<String, dynamic>>?,
                      ),
                    ));
                  },
                  onLongPress: (){
                    final deleteDoc=snapshot.data!.docs[index] as DocumentSnapshot<Map<String, dynamic>>?;
                    deleteDoc?.reference.delete();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.green,
                      content: Center(child: Text('Item deleted successfully',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19,))),
                    ));
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(item['ItemImageUrl']), // Assuming 'ItemImageURL' is the field containing the image URL
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      title: Text(item['ItemName'],
                        style: GoogleFonts.elMessiri(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff08666E),
                        ),
                      ),
                      subtitle: Text(
                          'Price: ${item['ItemPrice']} SAR',
                        style: GoogleFonts.elMessiri(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff55b3bb),
                        ),
                      ),
                    ),
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
