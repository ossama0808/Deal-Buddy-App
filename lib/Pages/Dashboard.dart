import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_note_app/Pages/Authentication/ProfilePage.dart';
import 'package:smart_note_app/Pages/SellerPages/Alltems.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late TextEditingController _searchController;
  late List<Map<String, dynamic>> _allItems;
  List<Map<String, dynamic>> _filteredItems = [];
  QuerySnapshot<Map<String, dynamic>> ? sellerOrders;
  QuerySnapshot<Map<String, dynamic>> ? sellerItems;
  int sellerItemsCount=0;
  int sellerOrdersCount=0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadItems();
    if (widget.userData['AccountType']=='Seller'){
      getSellerDocs();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Items').get();
    _allItems = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      _filteredItems = _allItems;
    });
  }

  void _filterItems(String value) {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final String itemName = item['ItemName'].toLowerCase();
        final String lowerCaseValue = value.toLowerCase();
        final bool nameContainsValue = itemName.contains(lowerCaseValue);
        final bool nameStartsWithValue = itemName.startsWith(lowerCaseValue);
        return nameContainsValue || nameStartsWithValue;
      }).toList();
    });
  }

  getSellerDocs()async{
    FirebaseFirestore.instance.collection('Orders').where('SellerUID', isEqualTo: widget.userData.id)
        .snapshots()
        .listen((event) {
          setState(() {
            sellerOrders=event;
            sellerOrdersCount=event.docs.length;
          });
    });

    FirebaseFirestore.instance.collection('Items').where('SellerUID', isEqualTo: widget.userData.id)
        .snapshots()
        .listen((event) {
          setState(() {
            sellerItems=event;
            sellerItemsCount=event.docs.length;
          });
    });
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
            onPressed: () {
              showModalBottomSheet(
                context: context,
                elevation: 15,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProfilePage(userData: widget.userData),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: widget.userData['AccountType']=='Seller' ? sellerDash(context) : shopperDash(context)
      ),
    );
  }

  Widget sellerDash(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 3,
          color: Color(0xff55b3bb),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Items Count: ',
                  style: GoogleFonts.elMessiri(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                Text(
                  sellerItemsCount.toString(),
                  style: GoogleFonts.elMessiri(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 3,
          color: Color(0xff55b3bb),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Orders Count: ',
                  style: GoogleFonts.elMessiri(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                Text(
                  sellerOrdersCount.toString(),
                  style: GoogleFonts.elMessiri(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15,),
        Text(
          'Orders:',
          style: GoogleFonts.elMessiri(fontSize: 24, fontWeight: FontWeight.bold,color: Color(0xff55b3bb)),
        ),
        Divider(color: Color(0xff55b3bb),),
        if (sellerOrders !=null)
        Expanded(
          child: ListView.builder(
            itemCount: sellerOrdersCount,
            itemBuilder: (context,i) {
              return GestureDetector(
                child: Card(
                  elevation: 3,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              DateFormat('dd/MM/yyyy hh:mm a').format(sellerOrders!.docs[i].data()['OrderDate'].toDate()),
                              style: GoogleFonts.elMessiri(fontSize: 18, color: Color(0xff55b3bb)),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Order #: ',
                                style: GoogleFonts.elMessiri(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff55b3bb)),
                              ),
                              Text(
                                sellerOrders!.docs[i].data()['OrderNumber'].toString(),
                                style: GoogleFonts.elMessiri(fontSize: 21, color: Color(0xff55b3bb)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Shopper Name: ',
                                style: GoogleFonts.elMessiri(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff55b3bb)),
                              ),
                              Text(
                                sellerOrders!.docs[i].data()['ShopperName'].toString(),
                                style: GoogleFonts.elMessiri(fontSize: 21, color: Color(0xff55b3bb)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Order Amount: ',
                                style: GoogleFonts.elMessiri(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff55b3bb)),
                              ),
                              Text(
                                '${sellerOrders!.docs[i].data()['OrderAmount']} SAR',
                                style: GoogleFonts.elMessiri(fontSize: 21, color: Color(0xff55b3bb)),
                              ),
                            ],
                          ),
                          Divider(),
                          Text(
                            'Items: ',
                            style: GoogleFonts.elMessiri(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff55b3bb)),
                          ),
                          Text(
                            '- ${sellerOrders!.docs[i].data()['ItemName']}',
                            style: GoogleFonts.elMessiri(fontSize: 21, color: Color(0xff55b3bb)),
                          ),
                        ],
                      )
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget shopperDash(BuildContext context) {
    // Sort the filtered items based on the item price
    _filteredItems.sort((a, b) => (a['ItemPrice'] as double).compareTo(b['ItemPrice'] as double));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                fillColor: Color(0xff55b3bb),
                focusColor: Color(0xff55b3bb),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(14),
                ),
                hintText: 'Search by item name',
                labelStyle: GoogleFonts.elMessiri(
                  color: Color(0xff55b3bb),
                  fontSize: 17,
                ),
              ),
              cursorColor: Color(0xff55b3bb),
              onChanged: _filterItems,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              var item = _filteredItems[index];
              // Check if the current item is the one with the lowest price
              bool isBestDeal = index == 0;
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onLongPress: (){
                    showModalBottomSheet(
                      context: context,
                      elevation: 30,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/ThankYouImage.png',
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                'For your purchase!',
                                style: GoogleFonts.elMessiri(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'We appreciate your business and hope you enjoy your item.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.elMessiri(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  onTap: () async {
                    print(item.toString());
                    // Launch the URL in the browser
                    if (await canLaunchUrl(Uri.parse(item['ItemStoreURL']))) {
                      await launchUrl(Uri.parse(item['ItemStoreURL']));
                    } else {
                      // Handle if the URL can't be launched
                      print('Could not launch ${item['ItemStoreURL']}');
                    }
                    // Show dialog when user returns to the app
                    Future.delayed(Duration(seconds: 2),(){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Did you purchase the ${item['ItemName']}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () async{
                                  // Save order to the database
                                  await FirebaseFirestore.instance.collection('Orders').add({
                                    'OrderNumber':Random.secure().nextInt(9999999),
                                    'OrderDate':DateTime.now(),
                                    'OrderAmount':item['ItemPrice'],
                                    'SellerUID':item['SellerUID'],
                                    'ShopperUID':widget.userData.id,
                                    'ShopperName':widget.userData.data()?['UserName'],
                                    'ItemName':item['ItemName']
                                  }).then((value) {
                                    Navigator.of(context).pop(true);
                                  });
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      ).then((value) {
                        // Handle the result here
                        if (value != null) {
                          if (value) {
                            showBottomSheet(
                              context: context,
                              elevation: 20,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/ThankYouImage.png',
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Thank you for your purchase!',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'We appreciate your business and hope you enjoy your item.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                      });
                    });
                  },
                  leading: Container(
                    width: 60,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: NetworkImage(item['ItemImageUrl']),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isBestDeal && _searchController.text.isNotEmpty)
                        Text(
                          'Best Deal !',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Text(
                        item['ItemName'],
                        style: GoogleFonts.elMessiri(
                          fontSize: 20,
                          color: Color(0xff08666E),
                        ),
                      ),
                      Text(
                        item['ItemDescription'],
                        style: GoogleFonts.elMessiri(
                          fontSize: 16,
                          color: Color(0xff08666E),
                        ),
                      ),
                    ],
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
              );
            },
          ),
        ),
      ],
    );
  }

}
