import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ProductList.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';

String query = '';
String cat = '';

class MySearchBarScreen extends StatelessWidget {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('products');

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
              showSearch(context: context, delegate: ProductSearch());
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Center(
        child: IndividualCategoryProductList(category: category),
      ),
    );
  }
}
