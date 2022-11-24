import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/profile_helpers/esv_tab.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Cart/ShoppingCart.dart';
import 'package:zerowaste/frontend/consumer/color.dart';
import 'package:zerowaste/frontend/consumer/style.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zerowaste/frontend/consumer/Orders.dart';
import 'package:flutter/cupertino.dart';

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
      required this.isResell});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String eneteredcoupon = '';
  List validity = [false, false, false, false, false];
  List couponn = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
  List Value = [5, 10, 15, 20, 2];
  int wallet = 0;
  double amount = 1;
  double amountd = 0;
  double amountw = 0;
  bool coupon = false;
  bool plant = false;
  bool couponused = false;
  bool walletm = false;

  int indx = 0;
  late Razorpay razorpay;
  String quantity = "";
  int? previousquantity = -1;
  DateTime selectedDate = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  double beforediscount = 0;
  double afterdiscount = 0;
  String error = '';
  String phone_number = '';
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  String address = '';

  List<int>? esv_ls;
  int? weight;
  double w = 0;
  //get weight from product collection using product id
  void getweight() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productid)
        .get()
        .then((value) {
      setState(() {
        w = value['weight'];
      });
    });
  }

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
    //fetch weight from firebase product collection of current product id

    getweight();
    //multiple weight with esv list with index 0
  }

  @override
  void initState() {
    super.initState();
    fetch_validity();
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

  Widget _plantgif(BuildContext context) {
    return new AlertDialog(
      title: const Text('Congratulations!!!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset("assets/images/plantatree.gif"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Meet Your Plant'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Plant a Tree just at " +
              '\u{20B9}' +
              "5 and take a step towards Green India"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                plant = true;
                amountd = amount + 20 + 5;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) => _plantgif(context),
              );
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text("Yes")),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    String time = DateFormat("hh:mm:ss a").format(DateTime.now());
    String date =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    String docId = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .collection('Orders')
        .doc()
        .id;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .collection('Orders')
        .doc(docId)
        .set({
      "ProductName": widget.name,
      "ProductId": widget.productid,
      "Quantity": int.parse(quantity),
      "Time": time,
      "Amount": (walletm) ? amountw : amountd,
      "Date": date,
      "manufacturerId": widget.manufacturerid,
      "phone_number": phone_number,
      "address": address,
      "image": widget.image,
      "price": widget.price,
      "orderId": docId,
      "is_return": false,
      "category": widget.category,
      "Desc": widget.description,
      "weight": w,
      "is_resell": true,
      "uid": uid
    });

    await FirebaseFirestore.instance
        .collection("environment")
        .doc(widget.uid)
        .set({
      "air": FieldValue.increment(esv_ls![0] * w),
      "co2": FieldValue.increment(esv_ls![2] * w),
      "tree": FieldValue.increment(esv_ls![1] + w)
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .update({'phone': phone_number, 'addr': address});
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productid)
        .update({'quantity': (widget.q - int.parse(quantity))});
    if (walletm == true) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .update({'wallet': (wallet - amountd) > 0 ? wallet - amountd : 0});
    }
    if (beforediscount != afterdiscount) {
      String couponname = 'Coupon' + indx.toString();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .update({couponname: false});
    }
    if (widget.isResell == true) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.manufacturerid)
          .update({'wallet': amountw == 0 ? amountd : amountw});
    }
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
              Navigator.of(context).pushReplacement(
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
    // Toast.show("External Wallet", context);
  }

  Future<void> openCheckout() async {
    var options = {
      "key": "rzp_test_Ienn2nz5hJfAS1",
      "amount":
          (walletm) ? (amountw * 100).toString() : (amountd * 100).toString(),
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

  Future<void> fetch_validity() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
      setState(() {
        validity[0] = data['Coupon0'];
        validity[1] = data['Coupon1'];
        validity[2] = data['Coupon2'];
        validity[3] = data['Coupon3'];
        validity[4] = data['Coupon4'];
        _controller1.text = data['phone'];
        _controller2.text = data['addr'];
        phone_number = data['phone'];
        address = data['addr'];
        wallet = data['wallet'];
      });
    }
    var docSnapshot1 = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .collection('Cart')
        .doc(widget.productid)
        .get();
    if (docSnapshot1.exists) {
      Map<String, dynamic> data1 = docSnapshot1.data()!;
      setState(() {
        previousquantity = data1['quantity'];
      });
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
                const Spacing(),
                Form(
                  key: _formkey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      style: AppStyle.text.copyWith(color: Colors.white),
                      onChanged: (val) {
                        setState(() {
                          quantity = val;
                          amount = widget.price *
                              int.parse(val); //displaying the total amount
                          amountd = amount + 20;
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
                const Spacing(),
                Row(
                  children: const [
                    TabTitle(label: 'Details', selected: true),
                    SizedBox(width: 8),
                  ],
                ),
                const Spacing(),
                Text(
                  widget.description,
                  style: AppStyle.bodyText.copyWith(color: Colors.white),
                ),
                const Spacing(),

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
                          const Spacing(),
                          Text(
                            "Once an order is placed on our app, we initiate the process of planting and linking your order with your sapling. Within a few days, along with the delivery of your products, we will also share the details of your plant by email.",
                            style:
                                AppStyle.bodyText.copyWith(color: Colors.white),
                          ),
                          const Spacing(),
                        ]),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
                        })
                    : const Spacing(),

                ESVTab(
                  air: esv_ls![0] * w,
                  co2: esv_ls![2] * w,
                  tree: esv_ls![1] + w,
                  textColor: Colors.white,
                ),
                const Spacing(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        child: Container(
                          child: Text('Apply Coupon',
                              style:
                                  AppStyle.text.copyWith(color: Colors.blue)),
                        ),
                        onTap: () {
                          setState(() {
                            coupon = true;
                          });
                        }),
                    coupon
                        ? InkWell(
                            child: Text('Remove',
                                style:
                                    AppStyle.text.copyWith(color: Colors.red)),
                            onTap: () {
                              setState(() {
                                if (amount !=
                                    (widget.price * int.parse(quantity))) {
                                  amount = widget.price * int.parse(quantity);

                                  amountd =
                                      (plant) ? amount + 20 + 5 : amount + 20;
                                }
                              });
                            })
                        : Container(),
                  ],
                ),
                const Spacing(),

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
                                if (couponn.contains(eneteredcoupon)) {
                                  print('entered coupon is in coupon');
                                  indx = couponn.indexOf(eneteredcoupon);
                                  if (validity[indx] == true) {
                                    print(' entered coupon is valid coupon');
                                    setState(() {
                                      //applied coupon amount
                                      amount =
                                          widget.price * int.parse(quantity);
                                      beforediscount = amount;

                                      amount = amount -
                                          (amount * (Value[indx]) / 100);
                                      afterdiscount = amount;
                                      plant
                                          ? (amountd = amount + 5 + 20)
                                          : (amountd = amount + 20);
                                    });
                                  } else {
                                    setState(() {
                                      error = 'Invalid Coupon Code';
                                    });
                                  }
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
                const Spacing(),
                (amount == 1)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                          Text('0',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                          Text('$amount',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                        ],
                      ),

                plant
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(
                              'Plant Contribution: ',
                              style: AppStyle.h3.copyWith(color: Colors.white),
                            ),
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    plant = false;
                                    amountd = amountd - 5;
                                  });
                                },
                                child: Text("Remove",
                                    style: AppStyle.h3
                                        .copyWith(color: Colors.red))),
                            const Spacing(),
                            Text(
                              "5",
                              style: AppStyle.h3.copyWith(color: Colors.white),
                            ),
                          ])
                    : const Spacing(),

                // const Spacing(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charges:',
                        style: AppStyle.h3.copyWith(color: Colors.white)),
                    const Spacing(),
                    Text('20',
                        style: AppStyle.h3.copyWith(color: Colors.white)),
                  ],
                ),
                const Spacing(),
                (amount == 1)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Grand Total:',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                          Text('0',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Grand Total:',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                          Text('$amountd',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                        ],
                      ),
                const Spacing(),
                (wallet > 0)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              child: Container(
                                child: Text(
                                    'Use wallet money     Rs.' + '$wallet',
                                    style: AppStyle.text
                                        .copyWith(color: Colors.blue)),
                              ),
                              onTap: () {
                                setState(() {
                                  walletm = true;

                                  if (wallet > amountd) {
                                    amountw = 0;
                                  } else {
                                    amountw = amountd - wallet;
                                  }
                                });
                              }),
                          walletm
                              ? InkWell(
                                  child: Container(
                                    child: Text('Remove',
                                        style: AppStyle.text
                                            .copyWith(color: Colors.red)),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      walletm = false;
                                    });
                                  })
                              : const Visibility(
                                  visible: false, child: Text('')),
                        ],
                      )
                    : const Visibility(visible: false, child: const Text('')),

                const Spacing(),
                (walletm)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Final Total:',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                          Text('$amountw',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Final Total:',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                          Text('$amountd',
                              style: AppStyle.h3.copyWith(color: Colors.white)),
                        ],
                      ),

                const Spacing(),

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
                          int finalquantity = 0;
                          String uid = FirebaseAuth.instance.currentUser!.uid;

                          if (_formkey.currentState!.validate()) {
                            if (previousquantity != -1) {
                              finalquantity =
                                  previousquantity! + int.parse(quantity);
                              if (finalquantity > widget.q) {
                                finalquantity = widget.q;
                              }
                            } else {
                              finalquantity = int.parse(quantity);
                            }

                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(uid)
                                .collection('Cart')
                                .doc(widget.productid)
                                .set({
                              "categories": widget.category,
                              "image": widget.image,
                              "manufacturerId": widget.manufacturerid,
                              "name": widget.name,
                              "price": widget.price,
                              "productId": widget.productid,
                              "quantity": finalquantity,
                              "userId": uid,
                            });

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
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                              ),
                              context: context, // set this to true
                              builder: (_) {
                                return DraggableScrollableSheet(
                                  initialChildSize: 0.47,
                                  maxChildSize: 0.6,
                                  minChildSize: 0.3,
                                  expand: false,
                                  builder: (_, controller) {
                                    String pattern = r'(^[7-9][0-9]{9}$)';
                                    RegExp regExp = new RegExp(pattern);

                                    return Container(
                                        // rounded border container top
                                        // take input and button click to update data from flutter firebase
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Personal Details",
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Divider(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextField(
                                                    controller: _controller1,
                                                    decoration: InputDecoration(
                                                      enabled: true,
                                                      prefixIcon: const Icon(
                                                        CupertinoIcons
                                                            .phone_circle_fill,
                                                        size: 24,
                                                      ),
                                                      border:
                                                          const OutlineInputBorder(),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      labelText:
                                                          'Contact Number',
                                                      hintText:
                                                          'Enter Your Phone Number',
                                                    ),
                                                    onChanged: (text) {
                                                      phone_number =
                                                          text.toString();
                                                      text = text.toString();
                                                    },
                                                  ),
                                                ),
                                                const Divider(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: TextField(
                                                    controller: _controller2,
                                                    onChanged: (text) {
                                                      address = text;
                                                    },
                                                    decoration: InputDecoration(
                                                      enabled: true,
                                                      prefixIcon: const Icon(
                                                        CupertinoIcons.home,
                                                        size: 24,
                                                      ),
                                                      border:
                                                          const OutlineInputBorder(),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      labelText: 'Your Address',
                                                      hintText:
                                                          'Enter Your Address',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                CupertinoButton(
                                                    color: Colors.black,
                                                    child: const Text(
                                                        'Continue to Payment...'),
                                                    onPressed: () async {
                                                      if (phone_number !=
                                                              null &&
                                                          regExp.hasMatch(
                                                              phone_number
                                                                  .toString()) &&
                                                          address.length > 5) {
                                                        setState(() {
                                                          if (beforediscount ==
                                                              afterdiscount) {
                                                            amount = widget
                                                                    .price *
                                                                int.parse(
                                                                    quantity);
                                                            plant
                                                                ? (amountd =
                                                                    amount +
                                                                        5 +
                                                                        20)
                                                                : (amountd =
                                                                    amount +
                                                                        20);
                                                          }
                                                        });
                                                        if (walletm == true &&
                                                            amountw == 0) {
                                                          String time = DateFormat(
                                                                  "hh:mm:ss a")
                                                              .format(DateTime
                                                                  .now());
                                                          String date =
                                                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .doc(widget.uid)
                                                              .collection(
                                                                  'Orders')
                                                              .add({
                                                            "ProductName":
                                                                widget.name,
                                                            "ProductId": widget
                                                                .productid,
                                                            "category":
                                                                widget.category,
                                                            "Quantity":
                                                                quantity,
                                                            "Time": time,
                                                            "Amount": (walletm)
                                                                ? amountw
                                                                : amountd,
                                                            "Date": date,
                                                            "manufacturerId": widget
                                                                .manufacturerid,
                                                            "phone_number":
                                                                phone_number,
                                                            "address": address,
                                                            "image":
                                                                widget.image,
                                                            "uid": uid,
                                                            "Desc": widget
                                                                .description,
                                                            "weight": w,
                                                            "is_resell": true,
                                                          });

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .doc(widget.uid)
                                                              .update({
                                                            'wallet': (wallet -
                                                                        amountd) >
                                                                    0
                                                                ? wallet -
                                                                    amountd
                                                                : 0
                                                          });

                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                AlertDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              title: const Text(
                                                                  "Order Completed"),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pushReplacement(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const YourOrders()));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            14),
                                                                    child:
                                                                        const Text(
                                                                      "Continue",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          await openCheckout();
                                                        }
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (ctx) =>
                                                              AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            title: const Text(
                                                                "Incorrect Details"),
                                                            content: const Text(
                                                                "Please check your address and contact number!"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          ctx)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(14),
                                                                  child:
                                                                      const Text(
                                                                    "Continue",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    })
                                              ],
                                            )));
                                  },
                                );
                              },
                            );
                          }
                        },
                        child: Text('Buy Now',
                            style: AppStyle.h3.copyWith(color: Colors.white))),
                  ],
                ),

                FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('products')
                        .where('categories', isEqualTo: widget.category)
                        .where('quantity', isGreaterThan: 0)
                        .limit(5)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Loader();
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return SizedBox(
                          height: snapshot.data!.docs.indexWhere((element) =>
                                          element['productId'] ==
                                          widget.productid) ==
                                      0 &&
                                  snapshot.data!.docs.length == 1
                              ? 0
                              : MediaQuery.of(context).size.height * 0.2,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs.map((doc) {
                              return doc['productId'] == widget.productid
                                  ? Container()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), //border corner radius
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(8),
                                              height: height / 6,
                                              width: width / 2.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      doc['image']),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            }).toList(),
                          ),
                        );
                      }
                      return Container();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabTitle extends StatelessWidget {
  final String label;
  final bool selected;
  const TabTitle({
    Key? key,
    required this.label,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            label,
            style: AppStyle.text.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 4,
          ),
          if (selected)
            Container(
              width: 21,
              height: 2,
              decoration: const BoxDecoration(color: AppColor.primary),
            )
        ])
      ],
    );
  }
}

class Spacing extends StatelessWidget {
  const Spacing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
    );
  }
}

class RectButtonSelected extends StatelessWidget {
  final String label;
  const RectButtonSelected({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      height: 32,
      width: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9), gradient: AppColor.gradient),
      child: Center(
          child: Text(
        label,
        style: AppStyle.text,
      )),
    );
  }
}

class ProductNameAndPrice extends StatelessWidget {
  String name;
  double amount;
  String category;
  ProductNameAndPrice(
      {required this.amount, required this.name, required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: AppStyle.h1Light.copyWith(fontSize: 20),
        ),
        Text(
          ' $amount',
          style: AppStyle.h1Light
              .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
