

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:zerowaste/frontend/consumer/ProductList.dart';




class GridItems extends StatefulWidget {





  @override
  State<GridItems> createState() => _GridItemsState();
}

class _GridItemsState extends State<GridItems> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<QuerySnapshot>(
        future:  FirebaseFirestore.instance.collection('products').orderBy('timestamp').get(),
        builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          debugPrint("length is " + snapshot.data!.docs.length.toString());
          if (snapshot.hasData) {
            if(snapshot.data != null){
              return Scrollbar(
                thickness: 5,
                child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),physics: ScrollPhysics(),itemCount: 4,itemBuilder: (context,index){
                  return
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
/*
                          InkWell(
                             onTap: (){
                               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(snapshot.data!.docs[index]['image'],snapshot.data!.docs[index]['description'],snapshot.data!.docs[index]['price'],snapshot.data!.docs[index]['name'],snapshot.data!.docs[index]['categories'])));
                             }),*/
                      Padding(
                      padding: const EdgeInsets.all(5.0),
                        child: Column(
                    children: [
                    Container(
                        width: MediaQuery.of(context)
                        .size
                        .width /
                                 2,
                  height: MediaQuery.of(context)
                        .size
                        .height /
                                5.6,
                  decoration: BoxDecoration(

                        image: DecorationImage(
                        image: NetworkImage(
                          snapshot.data!.docs[index]['image'],
                  ),
                  fit: BoxFit.fill),
                  ),
                  ),
                  Container(
                  width: MediaQuery.of(context)
                        .size
                        .width /
                  2,
                  color: Colors.white,
                  child: Padding(
                  padding:
                  const EdgeInsets.all(1.0),
                  child: Text(  snapshot.data!.docs[index]['name'],style: TextStyle( color: Colors.black,
                  fontSize: MediaQuery.of(context)
                      .size
                      .width /
                      30,

                  fontWeight: FontWeight.bold, letterSpacing: 2,wordSpacing: 5),
                      textAlign:
                      TextAlign.center),

                  )),
                  ],
                  ),
                  )


                  ],
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



/*
GridView.builder(
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 3,
),
itemCount: 300,
itemBuilder: (BuildContext context, int index) {
return Card(
color: Colors.amber,
child: Center(child: Text('$index')),
);
return Text("loading");
}

);*/
