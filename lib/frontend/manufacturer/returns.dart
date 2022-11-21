import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

late Razorpay razorpay;
String currDoc = "";
String curr_user = "";
num total = 0;
var productName1;
var contact1;

class Returns extends StatefulWidget {
  @override
  State<Returns> createState() => _ReturnsState();
}

class _ReturnsState extends State<Returns> {
//get price field from return collection in firebase
  //get user id from firebase auth
  String usid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    CollectionReference pay = FirebaseFirestore.instance.collection('Users');
    //get phone number from pay collection
    pay.doc(usid).get().then((value) {
      contact1 = value['phone'];
    });
    await pay.doc(curr_user).update({'wallet': FieldValue.increment(total)});

    //delete document from return collection where user id is equal to current user i
    CollectionReference newc = FirebaseFirestore.instance.collection('returns');
    newc.doc(currDoc).delete();
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    // Toast.show("Pament error", context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Transaction failed"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handlerExternalWallet() {
    print("External Wallet");
  }

  Future<void> openCheckout() async {
    var options = {
      "key": "rzp_test_Ienn2nz5hJfAS1",
      "amount": total * 100,
      "name": productName1,
      "description": "Payment for return of product",
      'timeout': 300,
      "prefill": {"contact": contact1},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  String manufacturerId = FirebaseAuth.instance.currentUser!.uid;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('returns')
                .where('manufacturerId', isEqualTo: manufacturerId)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((doc) {
                          currDoc = doc['returnId'];
                          double amount =
                              doc['price'] * doc['return_quantity'] * 0.65;
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 15),
                            child: Card(
                                color: Color(0xffD5EAEF),
                                child: ListTile(
                                  leading: Icon(Icons.assignment_return_rounded,
                                      size: 30, color: Color(0xff265D80)),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text("Product: " + doc['productName'],
                                            style: TextStyle(
                                                // color: Color(0xff265D80),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Return Quantity: " +
                                              doc['return_quantity'].toString(),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Price: \u{20B9}" +
                                              doc['price'].toString() +
                                              "/product",
                                        ),
                                        SizedBox(height: 10),
                                        Text("pickup Address: " +
                                            doc['address']),
                                        SizedBox(height: 10),
                                        Text("Amount to be paid: \u{20B9}" +
                                            amount.toString()),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                            onPressed: () async {
                                              curr_user = doc['userId'];
                                              //get price field from return collection in firebase
                                              total = doc['price'] *
                                                  doc['return_quantity'] *
                                                  0.65;
                                              print("toattttttttttal");
                                              print(total);

                                              await openCheckout();
                                              //delete returns document from return collection
                                            },
                                            child: Text("Accept Returns"))
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }).toList(),
                      ),
                    )
                  : const SpinKitChasingDots(
                      color: Colors.blue,
                      size: 50.0,
                    );
            }));
  }

  //delete returns doc from firebase

}
