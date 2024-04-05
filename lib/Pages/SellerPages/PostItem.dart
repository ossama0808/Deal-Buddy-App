import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PostItem extends StatefulWidget {
  const PostItem({required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  File? _itemImage;

  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _itemImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_itemImage == null) return null;

    try {
      // Get the file name and extension from the picked file's path
      String fileName = _itemImage!.path.split('/').last;
      // Create a reference to the Firebase Storage path with the same file name and extension
      final storageRef = FirebaseStorage.instance.ref().child('item_images/$fileName');

      // Upload the file to Firebase Storage
      await storageRef.putFile(_itemImage!);

      // Get the download URL of the uploaded file
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveNewItem() async {
    final itemName = _itemNameController.text;
    final itemDescription = _itemDescriptionController.text;
    final itemPrice = double.tryParse(_itemPriceController.text) ?? 0.0;

    if (itemName.isEmpty || itemDescription.isEmpty || itemPrice <= 0.0 || _itemImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(child: Text('All information should be filled',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19,))),
      ));
      return;
    }

    final imageUrl = await _uploadImageToStorage();
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(child: Text('Failed to upload image',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19,))),
      ));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Items').add({
        'ItemName': itemName,
        'ItemDescription': itemDescription,
        'ItemPrice': itemPrice,
        'ItemImageUrl': imageUrl,
        'SellerUID':widget.userData.id,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        content: Center(child: Text('Item Saved',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19,))),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving item: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        content: Center(child: Text('General Error Occur',style: GoogleFonts.elMessiri(color: Colors.white,fontSize: 19,))),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff55b3bb),
        title:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post New Item',
                style: GoogleFonts.elMessiri(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save,color: Colors.white,),
            onPressed: () async{
              await _saveNewItem();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _getImageFromGallery,
                child: _itemImage != null ? Image.file(_itemImage!, height: 300, width: double.infinity, fit: BoxFit.contain) : Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff55b3bb).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.add_a_photo, size: 50),
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
                  controller: _itemNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xff55b3bb),
                    focusColor: Color(0xff55b3bb),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                    labelStyle: GoogleFonts.elMessiri(
                      color: Color(0xff55b3bb),
                      fontSize: 17,
                    ),
                    hintText: 'Item Name',
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
                  controller: _itemDescriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xff55b3bb),
                    focusColor: Color(0xff55b3bb),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                    labelStyle: GoogleFonts.elMessiri(
                      color: Color(0xff55b3bb),
                      fontSize: 17,
                    ),
                    hintText: 'Item Description',
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
                  controller: _itemPriceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    fillColor: Color(0xff55b3bb),
                    focusColor: Color(0xff55b3bb),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff55b3bb), style: BorderStyle.solid), borderRadius: BorderRadius.circular(14)),
                    labelStyle: GoogleFonts.elMessiri(
                      color: Color(0xff55b3bb),
                      fontSize: 17,
                    ),
                    hintText: 'Item Price',
                  ),
                  cursorColor: Color(0xff55b3bb),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
