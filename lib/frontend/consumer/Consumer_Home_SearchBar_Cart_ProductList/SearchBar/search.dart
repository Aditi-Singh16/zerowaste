import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';


class ProductSearch extends SearchDelegate{
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('products');



  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else{
            return ListView(
              children: [
                ...snapshot.data!.docs.where((element )=>element['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                    .map((document) {
                  final String name = document.get('name');
                  final String image = document.get('image');
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(document['Desc']),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(image),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PlayerSearch(
                      //       document['image'],
                      //       document['description'],
                      //       document['price'],
                      //       document['name'],
                      //       document['categories'],
                      //     ),
                      //   ),
                      // );
                    },
                  );
                }).toList(),
              ],
            );
          }
        }



    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text("Searching for: " + query));

  }

}

