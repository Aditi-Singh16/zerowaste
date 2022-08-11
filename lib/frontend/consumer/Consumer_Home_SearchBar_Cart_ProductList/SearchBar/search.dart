import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';
import 'package:zerowaste/frontend/consumer/details.dart';

class ProductSearch extends SearchDelegate {
  String userauthid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('products');

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .snapshots()
            .asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((element) => element['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .map((document) {
                  final String name = document.get('name');
                  final String image = document.get('image');
                  final String description = document.get('Desc');
                  final String prod_id = document.get('productId');
                  final String manufacturerid = document.get('manufacturerId');
                  final String price = document.get('pricePerProduct');
                  final String category = document.get('categories');
                  return ListTile(
                      title: Text(name),
                      subtitle: Text(document['Desc']),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Details(
                                name: name,
                                description: description,
                                price: double.parse(price),
                                category: category,
                                productid: prod_id,
                                uid: userauthid,
                                manufacturerid: manufacturerid,
                                image: image)));
                      });
                }).toList(),
              ],
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text("Searching for: " + query));
  }
}
