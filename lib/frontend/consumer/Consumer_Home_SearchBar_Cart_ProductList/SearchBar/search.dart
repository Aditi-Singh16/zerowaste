import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';
import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class ProductSearch extends SearchDelegate {
  String userauthid = FirebaseAuth.instance.currentUser!.uid;

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
                  return ListTile(
                      title: Text(document.get('name')),
                      subtitle: Text(document['Desc']),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(document.get('image')),
                      ),
                      onTap: () async {
                        double wallet =
                            await HelperFunctions().readWalletPref();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Details(
                                  name: document.get('name'),
                                  description: document.get('Desc'),
                                  price: double.parse(
                                      document.get('pricePerProduct')),
                                  category: document.get('categories'),
                                  productid: document.get('productId'),
                                  uid: userauthid,
                                  manufacturerid:
                                      document.get('manufacturerId'),
                                  image: document.get('image'),
                                  isPlant: document.get('is_plant'),
                                  q: document.get('quantity'),
                                  isResell: document.get('is_resell'),
                                  wallet: wallet,
                                  weight: document.get('weight'),
                                )));
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
