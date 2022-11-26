import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ProductList.dart';
import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class GridItems extends StatefulWidget {
  @override
  State<GridItems> createState() => _GridItemsState();
}

class _GridItemsState extends State<GridItems> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .orderBy('timestamp')
            .get(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Scrollbar(
                thickness: 5,
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                30), //border corner radius
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    child: InkWell(
                                      onTap: () async {
                                        double wallet = await HelperFunctions()
                                            .readWalletPref();
                                        print(wallet);
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => Details(
                                                      name: doc['name'],
                                                      description: doc['Desc'],
                                                      price: double.parse(doc[
                                                          'pricePerProduct']),
                                                      category:
                                                          doc['categories'],
                                                      productid:
                                                          doc['productId'],
                                                      uid: userauthid,
                                                      manufacturerid:
                                                          doc['manufacturerId'],
                                                      image: doc['image'],
                                                      isPlant: doc['is_plant'],
                                                      q: doc['quantity'],
                                                      isResell:
                                                          doc['is_resell'],
                                                      wallet: wallet,
                                                      weight: doc['weight'],
                                                    )));
                                      },
                                    ),
                                    margin: EdgeInsets.all(8),
                                    height:
                                        MediaQuery.of(context).size.height / 7,
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(snapshot
                                            .data!.docs[index]['image']),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(snapshot.data!.docs[index]['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: MediaQuery.of(context).size.height /
                                        1000,
                                  )),
                              Text(
                                  "\u{20B9} " +
                                      snapshot.data!.docs[index]
                                          ['pricePerProduct'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: MediaQuery.of(context).size.height /
                                        500,
                                    color: Color(0xFF008080),
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
          }
          return Loader();
        }));
  }
}
