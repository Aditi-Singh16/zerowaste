import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/ProductList.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/search.dart';
String query='';
String cat='';
class MySearchBarScreen extends StatelessWidget {

  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('products');

  @override
  String category;

  MySearchBarScreen({required this.category});


  // get list of document fields from firebase
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Color(0xFF001427),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: ProductSearch());
            },
            icon: Icon(Icons.search),
          )
        ],
        centerTitle: true,

      ),
      body: Center(

        child: ListPlaces(category: category),
      ),
    );
  }

}