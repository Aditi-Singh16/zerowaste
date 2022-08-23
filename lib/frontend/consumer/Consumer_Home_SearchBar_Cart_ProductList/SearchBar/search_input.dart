import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/AllProducts.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ProductList.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/custom_app_bar.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/my_Search_bar_screen.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/SearchBar/search.dart';
import 'package:zerowaste/frontend/consumer/details.dart';


String query='';

class SearchInput extends StatelessWidget {

  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('products');
  CollectionReference cat = FirebaseFirestore.instance
      .collection('categories');


  final tagsList = [
    'Silk',
    'Bags',
    'Books',
    'Electronics',
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
            child: Container(
              padding: EdgeInsets.only(left:5,right: 5,top:2,bottom: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    width: 3,
                  )),
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
          ),
          GestureDetector(
            onTap: () {
              //search depending on taglist value

              showSearch(
                  context: context, delegate: ProductSearch());

            },
            child: Row(
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
          ),

        ],

      ),
    );
  }
}