import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/frontend/Helpers/consumer/empty_cart.dart';
import 'package:zerowaste/frontend/Helpers/consumer/plant_gif.dart';
import 'package:zerowaste/frontend/Helpers/consumer/tab_display.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/color.dart';
import 'package:zerowaste/frontend/Helpers/style.dart';
import 'package:zerowaste/frontend/constants.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class ShoppingCart extends StatefulWidget {
  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DateTime selectedDate = DateTime.now();
  bool shouldPlant = false;
  bool couponApplied = false;
  String enteredCoupon = "";
  double total = 20;
  String error = "";
  double wallet = 0;
  List<bool> validity = [false, false, false, false, false];
  bool walletApplied = false;

  Razorpay razorpay = Razorpay();
  String quantity = "";

  final _formkey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchValidity() async {
    var docSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      setState(() {
        validity[0] = data['Coupon0'];
        validity[1] = data['Coupon1'];
        validity[2] = data['Coupon2'];
        validity[3] = data['Coupon3'];
        validity[4] = data['Coupon4'];
        wallet = data['wallet'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchValidity();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Meet Your Plant'),
      content: const Text(
          "Plant a Tree just at \u{20B9}5 and take a step towards Green India"),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                shouldPlant = true;
                total = total + 5;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) => PlantGIF(),
              );
            },
            child: const Text("Yes")),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          )),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    String time = DateFormat("hh:mm:ss a").format(DateTime.now());
    CollectionReference userCart = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Cart');
    userCart.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String date =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
        FirebaseData().addOrders(
            uid,
            doc['name'],
            doc['productId'],
            doc['categories'],
            doc['quantity'],
            time,
            doc['price'].toDouble(),
            date,
            doc['manufacturerId'],
            doc['image'],
            doc['weight'],
            doc['description']);
      });
    });

    CollectionReference newc = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Cart');
    newc.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('products')
            .doc(doc['productId'])
            .update({
          "quantity":
              FieldValue.increment(-int.parse(doc['quantity'].toString())),
        });
      });
    });

    //delete cart items
    FirebaseData().deleteWholeCart(uid);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Order Completed"),
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

  void handlerErrorFailure() {
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
      "key": dotenv.env['RAZORPAY_KEY'],
      "amount": total,
      "name": "Sample App",
      "description": "Payment for the some random product",
      "prefill": {"contact": await HelperFunctions().readPhonePref()},
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

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle(statusBarColor: Colors.grey.shade100);

    // get quantity field from products collection

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Cart')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(body: Loader());
          }
          if (snapshot.hasData) {
            CollectionReference userCart = FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('Cart');
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              total = 20.0 +
                  snapshot.data.docs[i]['price'] *
                      snapshot.data.docs[i]['quantity'];
            }
            return Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
                child: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => {
                      // go back page
                      Navigator.pop(context)
                    },
                  ),
                  title: const Text("My Cart"),
                ),
              ),
              body: Container(
                child: total == 0
                    ? const EmptyCart()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                // firebase length of itemcount
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  //    DocumentSnapshot doc = snapshot.data!.docs[index];
                                  DocumentSnapshot doc1 =
                                      snapshot.data!.docs[index];
                                  String name = doc1['name'];
                                  if (name.length > 9) {
                                    name = name.substring(0, 9) + "...";
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Card(
                                      margin: EdgeInsets.all(
                                          MediaQuery.of(context).size.height /
                                              100),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: Colors.white,

                                      //margin: EdgeInsets.only(left: 12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              margin: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      33),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.network(
                                                  doc1['image'],
                                                  fit: BoxFit.fitWidth,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.6,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              30),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            150),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          name,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  50,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const Spacer(),
                                                        InkWell(
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                right: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    100),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                await FirebaseData()
                                                                    .deleteSingleItemFromCart(
                                                                        uid,
                                                                        doc1.id);
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .delete_forever_rounded,
                                                                color:
                                                                    Colors.grey,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    35,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            50),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              50),
                                                  child: Text(
                                                    "Tag: " +
                                                        doc1['categories']
                                                            .toString(),
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            65,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            50),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        if (doc1['quantity'] >
                                                            1) {
                                                          // update data from flutter firebase

                                                          userCart
                                                              .doc(doc1.id)
                                                              .set(
                                                                  {
                                                                "quantity":
                                                                    doc1['quantity'] -
                                                                        1,
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                        } else if (doc1[
                                                                'quantity'] <=
                                                            0) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .doc(uid
                                                                  .toString())
                                                              .collection(
                                                                  'Cart')
                                                              .doc(doc1.id)
                                                              .delete();
                                                        }
                                                      },
                                                      child: const Icon(
                                                          CupertinoIcons
                                                              .minus_circle_fill),
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            100),
                                                    Text(doc1['quantity']
                                                        .toString()),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            100),
                                                    InkWell(
                                                      onTap: () {
                                                        // update data from flutter firebase
                                                        CollectionReference
                                                            pro1 =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products');
                                                        // get single field from product collection
                                                        pro1
                                                            .doc(doc1[
                                                                'productId'])
                                                            .get()
                                                            .then((value) {
                                                          if (value[
                                                                  'quantity'] >
                                                              doc1[
                                                                  'quantity']) {
                                                            userCart
                                                                .doc(doc1.id)
                                                                .set(
                                                                    {
                                                                  "quantity":
                                                                      doc1['quantity'] +
                                                                          1,
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                          } else {
                                                            //cart quantity is equal to product quantity
                                                            userCart
                                                                .doc(doc1.id)
                                                                .set(
                                                                    {
                                                                  "quantity":
                                                                      doc1['quantity'] -
                                                                          1,
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      'Select a lower quantity',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                      'Quantity exceeds the available stock',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      ElevatedButton(
                                                                        child: const Text(
                                                                            'OK'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                        });
                                                      },
                                                      child: const Icon(
                                                          CupertinoIcons
                                                              .plus_circle_fill),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            100),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '\u{20B9}',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              60),
                                                    ),
                                                    Text(
                                                        (doc1['price'] *
                                                                doc1[
                                                                    'quantity'])
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                60,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      color: AppColor.secondary,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    InkWell(
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: const [
                                                  TabTitle(
                                                      label: 'Meet Your Plant',
                                                      selected: true),
                                                  SizedBox(width: 8),
                                                ],
                                              ),
                                              Image.asset(
                                                "assets/images/plant.png",
                                                height: 40,
                                                width: 50,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            "Once an order is placed on our app, we initiate the process of planting and linking your order with your sapling. Within a few days, along with the delivery of your products, we will also share the details of your plant by email.",
                                            style: AppStyle.bodyText
                                                .copyWith(color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                        ]),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context),
                                          );
                                        }),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            child: Container(
                                              child: Text('Apply Coupon',
                                                  style: AppStyle.text.copyWith(
                                                      color: Colors.blue)),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                couponApplied = true;
                                              });
                                            }),
                                        couponApplied
                                            ? InkWell(
                                                child: Text('Remove',
                                                    style: AppStyle.text
                                                        .copyWith(
                                                            color: Colors.red)),
                                                onTap: () {
                                                  setState(() {
                                                    couponApplied = false;
                                                  });
                                                })
                                            : const Visibility(
                                                visible: false,
                                                child: Text('')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    couponApplied
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: TextFormField(
                                              style: AppStyle.text.copyWith(
                                                  color: Colors.white),
                                              onChanged: (val) {
                                                setState(
                                                    () => enteredCoupon = val);
                                              },
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColor.primary),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: AppColor.primary),
                                                ),
                                                labelText: 'ABC',
                                                labelStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(.5)),
                                              ),
                                            ),
                                          )
                                        : const Visibility(
                                            visible: false,
                                            child: SizedBox(height: 0)),
                                    couponApplied
                                        ? Center(
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    16))),
                                                    minimumSize:
                                                        MaterialStateProperty.all(
                                                            Size(
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    2.6,
                                                                37))),
                                                onPressed: () async {
                                                  setState(() {
                                                    error = '';
                                                  });
                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    if (AppConstants.coupons
                                                        .contains(
                                                            enteredCoupon)) {
                                                      int idx = AppConstants
                                                          .coupons
                                                          .indexOf(
                                                              enteredCoupon);

                                                      if (validity[idx] ==
                                                          true) {
                                                        setState(() {
                                                          //applied coupon amount

                                                          total = total *
                                                              (1 -
                                                                  AppConstants.couponValue[
                                                                          idx] /
                                                                      100);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          error =
                                                              'Invalid Coupon Code';
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        error =
                                                            'Invalid Coupon Code';
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Text('Apply',
                                                    style: AppStyle.h3.copyWith(
                                                        color: Colors.white))),
                                          )
                                        : const Visibility(
                                            visible: false, child: Text('')),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    (wallet > 0)
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                  child: Container(
                                                    child: Text(
                                                        'Use wallet money Rs.' +
                                                            '$wallet',
                                                        style: AppStyle.text
                                                            .copyWith(
                                                                color: Colors
                                                                    .blue)),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      walletApplied = true;

                                                      if (wallet > total) {
                                                        total = 0;
                                                      } else {
                                                        total = total - wallet;
                                                        wallet = 0;
                                                      }
                                                    });
                                                  }),
                                              walletApplied
                                                  ? InkWell(
                                                      child: Container(
                                                        child: Text('Remove',
                                                            style: AppStyle.text
                                                                .copyWith(
                                                                    color: Colors
                                                                        .red)),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          walletApplied = false;
                                                        });
                                                      })
                                                  : const Visibility(
                                                      visible: false,
                                                      child: Text('')),
                                            ],
                                          )
                                        : const Visibility(
                                            visible: false, child: Text('')),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ])),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text("Total",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Text('$total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text("Delivery Charges",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Text('20',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                              ],
                            ),
                            const Divider(),
                            shouldPlant
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 40),
                                          child: Text('Plant Contribution: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25,
                                              )),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                shouldPlant = false;
                                                total = total - 5;
                                              });
                                            },
                                            child: Text("Remove",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                ))),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(right: 40),
                                          child: Text("5",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25,
                                              )),
                                        ),
                                      ])
                                : const SizedBox(
                                    height: 16,
                                  ),
                            const Divider(),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        60),
                                width: MediaQuery.of(context).size.width / 1.5,
                                height: MediaQuery.of(context).size.height / 20,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await openCheckout();
                                  },
                                  child: const Text('Proceed to Checkout '),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black, // background
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ),
                                  ),
                                )),
                            Container(
                              margin: const EdgeInsets.all(10),
                            )
                          ],
                        ),
                      ),
              ),
            );
          }
          return const Scaffold(
              body:
                  Center(child: CircularProgressIndicator(color: Colors.grey)));
        });
  }
}
