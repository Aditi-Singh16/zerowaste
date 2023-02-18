// ignore_for_file: unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/frontend/Helpers/consumer/plant_gif.dart';
import 'package:zerowaste/frontend/Helpers/consumer/product_display.dart';
import 'package:zerowaste/frontend/Helpers/consumer/tab_display.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/profile_helpers/esv_tab.dart';
import 'package:zerowaste/frontend/constants.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/ShoppingCart.dart';
import 'package:zerowaste/frontend/Helpers/color.dart';
import 'package:zerowaste/frontend/Helpers/style.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zerowaste/frontend/consumer/Orders.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

var size, height, width;
List<int>? esv;

class Details extends StatefulWidget {
  int q;
  String name;
  String description;
  double price;
  String category;
  String productid;
  String uid;
  String manufacturerid;
  String image;
  bool isPlant;
  bool isResell;
  double wallet;
  double weight;

  Details(
      {required this.name,
      required this.description,
      required this.price,
      required this.category,
      required this.productid,
      required this.uid,
      required this.manufacturerid,
      required this.image,
      required this.isPlant,
      required this.q,
      required this.wallet,
      required this.isResell,
      required this.weight});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String eneteredcoupon = '';

  List allCoupons = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];

  double delivery = 20.0;
  double totalAmount = 20.0;
  bool coupon = false;
  bool plant = false;
  bool couponused = false;
  bool walletApplied = false;

  int indx = 0;
  late Razorpay razorpay;
  String quantity = "";
  DateTime selectedDate = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  String error = '';

  List<int>? esv_ls;
  int? weight;

  List<int> cat1 = [2, 1, 3];
  List<int> cat2 = [2, 1, 4];
  List<int> cat3 = [1, 2, 3];
  List<int> cat4 = [2, 1, 2];
  List<int> cat5 = [1, 1, 1];
  List<int> cat6 = [1, 1, 1];
  List<int> cat7 = [1, 1, 1];

  void setEsv() {
    if (widget.category == "Books") {
      esv_ls = cat1;
    } else if (widget.category == "Cotton Clothes") {
      esv_ls = cat2;
    } else if (widget.category == "Recycled Products") {
      esv_ls = cat3;
    } else if (widget.category == "Electronics") {
      esv_ls = cat4;
    } else if (widget.category == "Nylon Clothes") {
      esv_ls = cat5;
    } else if (widget.category == "Silk Clothes") {
      esv_ls = cat6;
    } else {
      esv_ls = cat7;
    }
  }

  @override
  void initState() {
    super.initState();
    setEsv();
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

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Meet Your Plant'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Plant a Tree just at " +
              '\u{20B9}' +
              "5 and take a step towards Green India"),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                plant = true;
                totalAmount = totalAmount + 2;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) => PlantGIF(),
              );
            },
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(AppColor.dropdown),
            ),
            child: const Text("Yes")),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    String uid = await HelperFunctions().readUserIdPref();
    String time = DateFormat("hh:mm:ss a").format(DateTime.now());
    String date =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    FirebaseData().addOrders(
        uid,
        widget.name,
        widget.productid,
        widget.category,
        quantity,
        time,
        totalAmount,
        date,
        widget.manufacturerid,
        widget.image,
        widget.weight,
        widget.description);

    await FirebaseFirestore.instance.collection("Users").doc(widget.uid).set({
      "esv_air": FieldValue.increment(esv_ls![0] * widget.weight),
      "esv_co2": FieldValue.increment(esv_ls![2] * widget.weight),
      "esv_tree": FieldValue.increment(esv_ls![1] + widget.weight)
    });

    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productid)
        .update({'quantity': (widget.q - int.parse(quantity))});
    // Toast.show("Pament success", context);
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const YourOrders()));
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

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet $response");
  }

  Future<void> openCheckout() async {
    var options = {
      "key": dotenv.env['RAZORPAY_KEY'],
      "totalAmount": totalAmount,
      "name": "Sample App",
      "description": "Payment for the some random product",
      'timeout': 300,
      "prefill": {"contact": "2323232323"},
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(widget.name)),
      body: SizedBox(
          height: height * 0.4,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child:
                Image(fit: BoxFit.fitHeight, image: NetworkImage(widget.image)),
          )),
      bottomSheet: Container(
        width: width,
        height: height * 0.5,
        decoration: const BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34), topRight: Radius.circular(34))),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 5,
                    width: 32 * 1.5,
                    decoration: BoxDecoration(
                      gradient: AppColor.gradient,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                ProductNameAndPrice(
                  amount: widget.price,
                  name: widget.name,
                  category: widget.category,
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Text('Category: ${widget.category}',
                        style: AppStyle.text.copyWith(color: Colors.white)),
                    const Spacer(),
                    Text('Quantity:  ${widget.q.toString()}',
                        style: AppStyle.text.copyWith(color: Colors.white))
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formkey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      style: AppStyle.text.copyWith(color: Colors.white),
                      onChanged: (val) {
                        setState(() {
                          quantity = val;
                          totalAmount = delivery +
                              widget.price *
                                  int.parse(
                                      val); //displaying the total totalAmount
                        });
                      },
                      validator: (val) {
                        if (val!.isEmpty || int.parse(val) > widget.q) {
                          return 'Enter correct quantity';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: AppColor.primary),
                        ),
                        labelText: 'Enter Quantity',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: const [
                    TabTitle(label: 'Details', selected: true),
                    SizedBox(width: 8),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.description,
                  style: AppStyle.bodyText.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                widget.isResell
                    ? Text(
                        'Second hand product!',
                        style: AppStyle.bodyText.copyWith(color: Colors.white),
                      )
                    : Container(),
                const SizedBox(
                  height: 16,
                ),

                //plant a tree
                (widget.isPlant == true)
                    ? InkWell(
                        child: Column(children: [
                          Row(
                            children: [
                              Row(
                                children: const [
                                  TabTitle(
                                      label: 'Meet Your Plant', selected: true),
                                  SizedBox(width: 8),
                                ],
                              ),
                              Image.asset(
                                "assets/images/plant.png",
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Once an order is placed on our app, we initiate the process of planting and linking your order with your sapling. Within a few days, along with the delivery of your products, we will also share the details of your plant by email.",
                            style:
                                AppStyle.bodyText.copyWith(color: Colors.white),
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
                        })
                    : Container(),

                ESVTab(
                  air: esv_ls![0] * widget.weight,
                  co2: esv_ls![2] * widget.weight,
                  tree: esv_ls![1] + widget.weight,
                  textColor: Colors.white,
                ),
                const SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          fillColor: MaterialStateProperty.all<Color>(
                              AppColor.appcolor1),
                          value: coupon,
                          onChanged: (bool? val) {
                            setState(() {
                              coupon = val!;
                            });
                          },
                        ),
                        Text('Apply Coupon',
                            style: TextStyle(color: AppColor.appcolor1))
                      ],
                    ),
                    widget.wallet > 0.0
                        ? Row(
                            children: [
                              Text('Apply Wallet',
                                  style: TextStyle(color: AppColor.appcolor1)),
                              Checkbox(
                                fillColor: MaterialStateProperty.all<Color>(
                                    AppColor.appcolor1),
                                value: walletApplied,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == false) {
                                      if (totalAmount == 0) {
                                        totalAmount = totalAmount +
                                            delivery +
                                            widget.price * int.parse(quantity);
                                      } else {
                                        totalAmount =
                                            totalAmount + widget.wallet;
                                      }
                                    } else if (totalAmount - widget.wallet >=
                                        0) {
                                      totalAmount = totalAmount - widget.wallet;
                                    } else if (totalAmount - widget.wallet <
                                        0) {
                                      totalAmount = 0;
                                    }
                                    walletApplied = value!;
                                  });
                                },
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),

                coupon
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          style: AppStyle.text.copyWith(color: Colors.white),
                          onChanged: (val) {
                            setState(() => eneteredcoupon = val);
                          },
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.primary),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: AppColor.primary),
                            ),
                            labelText: 'Code',
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(.5)),
                          ),
                        ),
                      )
                    : const Visibility(
                        visible: false, child: SizedBox(height: 0)),
                Text(error, style: const TextStyle(color: Colors.red)),

                coupon
                    ? Center(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16))),
                                minimumSize: MaterialStateProperty.all(
                                    Size(width / 2.6, 37))),
                            onPressed: () async {
                              setState(() {
                                error = '';
                              });
                              if (_formkey.currentState!.validate()) {
                                if (allCoupons.contains(eneteredcoupon)) {
                                  setState(() {
                                    totalAmount = totalAmount -
                                        (totalAmount *
                                            (AppConstants.couponValue[indx]) /
                                            100);
                                    coupon = !coupon;
                                  });
                                } else {
                                  setState(() {
                                    error = 'Invalid Coupon Code';
                                  });
                                }
                              }
                            },
                            child: Text('Apply',
                                style:
                                    AppStyle.h3.copyWith(color: Colors.white))),
                      )
                    : const Visibility(visible: false, child: const Text('')),
                const SizedBox(
                  height: 16,
                ),

                plant
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(
                              'Plant Contribution: ',
                              style: AppStyle.h3.copyWith(color: Colors.white),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    plant = false;
                                  });
                                },
                                child: Text("Remove",
                                    style: AppStyle.h3
                                        .copyWith(color: Colors.red))),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "5",
                              style: AppStyle.h3.copyWith(color: Colors.white),
                            ),
                          ])
                    : Container(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charges:',
                        style: AppStyle.h3.copyWith(color: Colors.white)),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('20',
                        style: AppStyle.h3.copyWith(color: Colors.white)),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Grand Total:',
                        style: AppStyle.h3.copyWith(color: Colors.white)),
                    Text((totalAmount).toString(),
                        style: AppStyle.h3.copyWith(color: Colors.white)),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColor.primary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16))),
                            minimumSize: MaterialStateProperty.all(
                                Size(width / 2.6, 37))),
                        onPressed: () async {
                          String uid = FirebaseAuth.instance.currentUser!.uid;

                          if (_formkey.currentState!.validate()) {
                            await FirebaseData().addToCart(
                                uid,
                                widget.productid,
                                widget.category,
                                widget.image,
                                widget.manufacturerid,
                                widget.name,
                                widget.price,
                                quantity,
                                widget.weight,
                                widget.description);

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ShoppingCart()));
                          }
                        },
                        child: Text('Add To Cart',
                            style: AppStyle.h3.copyWith(color: Colors.white))),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColor.primary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16))),
                            minimumSize: MaterialStateProperty.all(
                                Size(width / 2.6, 37))),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            String uid =
                                await HelperFunctions().readUserIdPref();
                            await FirebaseData()
                                .updateCoupons(uid, eneteredcoupon);

                            if (walletApplied) {
                              await FirebaseData().updateWallet(
                                  uid, totalAmount, widget.wallet);
                            }

                            await openCheckout();
                          }
                        },
                        child: Text('Buy Now',
                            style: AppStyle.h3.copyWith(color: Colors.white))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
