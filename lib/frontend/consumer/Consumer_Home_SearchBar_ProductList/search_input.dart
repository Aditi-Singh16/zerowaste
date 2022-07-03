import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/search.dart';


String query='';

class SearchInput extends StatelessWidget {

  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('products');
  final tagsList = [
    'Bags',
    'Clothing',
    'Electronics',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    var size,height,width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Container(
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showSearch(
                  context: context, delegate: ProductSearch());
            },
            child: Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        showSearch(
                            context: context, delegate: ProductSearch());
                      }, icon: Icon(
                      Icons.search,
                    ),),


                  ],
                ),
                Flexible(
                  child: Text("Search..                                                                                                                                     ",
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, fontWeight: FontWeight.bold))
            ,),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
    color: Color(0xFF001427),
                    borderRadius: BorderRadius.circular(15),

                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,

                  ),
                )
              ],
            ),
          ),
          Row(
            children:
              tagsList
                  .map((e)=> Container(

                margin: EdgeInsets.only(top: 10,right:10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF001427),
                ),
                child: Text(e,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height/80
                ),
                ),
              ))
              .toList(),


          ),
          
        ],
        
      ),
    );
  }
}