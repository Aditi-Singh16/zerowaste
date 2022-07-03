

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_ProductList/ProductList.dart';



class GridItems extends StatefulWidget {





  @override
  State<GridItems> createState() => _GridItemsState();
}

class _GridItemsState extends State<GridItems> {

  @override
  void initState() {
    super.initState();
  }
// snapshot.data!.docs[index]['image'],
  @override
  Widget build(BuildContext context) {
    var size,height,width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return FutureBuilder<QuerySnapshot>(

        future:  FirebaseFirestore.instance.collection('products').orderBy('timestamp').get(),
        builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          debugPrint("length is " + snapshot.data!.docs.length.toString());

          if (snapshot.hasData) {
            if(snapshot.data != null){
              return Scrollbar(
                thickness: 5,
                child: GridView.builder(  padding: EdgeInsets.zero,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10, mainAxisSpacing: 10),  shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemCount: 6,itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30), //border corner radius

                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8),
                                  height: height/6,
                                  width: width/2.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!.docs[index]['image']),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //     right:20,
                                //     top:15,
                                //     child: Container(
                                //
                                //
                                //
                                //         child: Icon(Icons.favorite, color: Colors.red,
                                //         size:15),
                                //     )),
                              ],
                            ),
                            Text(snapshot.data!.docs[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: height/500,
                                )),
                          ],
                        ),
                      ),
                    );
                }),
              );
          }}
          return  new Text(
              'Error in receiving photos: ${snapshot.error}');
        }));
  }
}
