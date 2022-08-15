import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Cart/ShoppingCart.dart';
import 'package:zerowaste/frontend/consumer/color.dart';
import 'package:zerowaste/frontend/consumer/style.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zerowaste/frontend/consumer/Orders.dart';
import 'package:flutter/cupertino.dart';

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
  String is_plant;
  Details(
      {required this.name,
      required this.description,
      required this.price,
      required this.category,
      required this.productid,
      required this.uid,
      required this.manufacturerid,
      required this.image,
      required this.is_plant,
      required this.q});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String eneteredcoupon = '';
  List validity = [false, false, false, false, false];
  List couponn = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
  List Value = [5, 10, 15, 20, 2];

  double amount = 1;
  double amountd = 0;
  bool coupon = false;
  bool plant = false;
  bool couponused = false;
  int indx = 0;
  late Razorpay razorpay;
  String quantity = "";
  DateTime selectedDate = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  double beforediscount = 0;
  double afterdiscount = 0;
  String error = '';
  String phone_number = '';
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  String address = '';

  @override
  void initState() {
    super.initState();
    fetch_validity();
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
          Text("Plant a Tree just at " +
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
            child: const Text("Yes")),
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

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success $response");
    String time = DateFormat("hh:mm:ss a").format(DateTime.now());
    String date =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .collection('Orders')
        .add({
      "ProductName": widget.name,
      "ProductId": widget.productid,
      "Quantity": quantity,
      "Time": time,
      "Amount": amountd,
      "Date": date,
      "manufacturerId": widget.manufacturerid,
      "phone_number": phone_number,
      "address": address,
      "image": widget.image
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .update({'phone': phone_number, 'addr': address});
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => YourOrders()));
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
    print("Payment error $response");
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
      "amount": (amountd * 100).toString(),
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
      });
      print(validity);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Positioned(
              top: 0,
              child: Container(
                alignment: Alignment.topCenter,
                height: size.height - 300,
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.bottomRight,
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.image))),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: AppColor.secondary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34))),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
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
                            category: widget.category),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            Text('Category:  ',
                                style: AppStyle.text
                                    .copyWith(color: Colors.white)),
                            const Spacing(),
                            Text(widget.category,
                                style: AppStyle.text
                                    .copyWith(color: Colors.white)),
                          ],
                        ),
                        const Spacing(),
                        Row(
                          children: [
                            Text('Quantity:  ',
                                style: AppStyle.text
                                    .copyWith(color: Colors.white)),
                            const Spacing(),
                            Text(widget.q.toString(),
                                style: AppStyle.text
                                    .copyWith(color: Colors.white)),
                          ],
                        ),
                        const Spacing(),
                        Form(
                          key: _formkey,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              style:
                                  AppStyle.text.copyWith(color: Colors.white),
                              onChanged: (val) {
                                setState(() {
                                  quantity = val;
                                  amount = widget.price *
                                      int.parse(
                                          val); //displaying the total amount
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
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColor.primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: AppColor.primary),
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
                          style:
                              AppStyle.bodyText.copyWith(color: Colors.white),
                        ),
                        const Spacing(),

                        //plant a tree
                        (widget.is_plant == 'true')
                            ? InkWell(
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
                                  const Spacing(),
                                  Text(
                                    "Once an order is placed on our app, we initiate the process of planting and linking your order with your sapling. Within a few days, along with the delivery of your products, we will also share the details of your plant by email.",
                                    style: AppStyle.bodyText
                                        .copyWith(color: Colors.white),
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                child: Container(
                                  child: Text('Apply Coupon',
                                      style: AppStyle.text
                                          .copyWith(color: Colors.blue)),
                                ),
                                onTap: () {
                                  setState(() {
                                    coupon = true;
                                  });
                                }),
                            coupon
                                ? InkWell(
                                    child: Container(
                                      child: Text('Remove',
                                          style: AppStyle.text
                                              .copyWith(color: Colors.red)),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        coupon = false;
                                        if (amount !=
                                            (widget.price *
                                                int.parse(quantity))) {
                                          amount = widget.price *
                                              int.parse(quantity);

                                          amountd = (plant)
                                              ? amount + 20 + 5
                                              : amount + 20;
                                        }
                                      });
                                    })
                                : Visibility(visible: false, child: Text('')),
                          ],
                        ),
                        const Spacing(),
                        coupon
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  style: AppStyle.text
                                      .copyWith(color: Colors.white),
                                  onChanged: (val) {
                                    setState(() => eneteredcoupon = val);
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColor.primary),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: AppColor.primary),
                                    ),
                                    labelText: 'ABC',
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(.5)),
                                  ),
                                ),
                              )
                            : Visibility(
                                visible: false, child: SizedBox(height: 0)),
                        Text(error, style: TextStyle(color: Colors.red)),
                        coupon
                            ? Center(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16))),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(size.width / 2.6, 37))),
                                    onPressed: () async {
                                      setState(() {
                                        error = '';
                                      });
                                      if (_formkey.currentState!.validate()) {
                                        if (couponn.contains(eneteredcoupon)) {
                                          print('entered coupon is in coupon');
                                          indx =
                                              couponn.indexOf(eneteredcoupon);
                                          if (validity[indx] == true) {
                                            print(
                                                ' entered coupon is valid coupon');
                                            setState(() {
                                              //applied coupon amount
                                              amount = widget.price *
                                                  int.parse(quantity);
                                              beforediscount = amount;

                                              amount = amount -
                                                  (amount *
                                                      (Value[indx]) /
                                                      100);
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
                                        style: AppStyle.h3
                                            .copyWith(color: Colors.white))),
                              )
                            : Visibility(visible: false, child: Text('')),
                        const Spacing(),
                        (amount == 1)
                            ? Text('Total: 0',
                                style:
                                    AppStyle.h3.copyWith(color: Colors.white))
                            : Text('Total: $amount',
                                style:
                                    AppStyle.h3.copyWith(color: Colors.white)),

                        const Spacing(),
                        plant
                            ? Row(children: [
                                Text('Plant Contribution: ' + '\u{20B9}' + "5",
                                    style: AppStyle.h3
                                        .copyWith(color: Colors.white)),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        plant = false;
                                        amountd = amountd - 5;
                                      });
                                    },
                                    child: Text("Remove",
                                        style: AppStyle.h3
                                            .copyWith(color: Colors.white)))
                              ])
                            : Visibility(
                                visible: false,
                                child: const Spacing(),
                              ),

                        Row(
                          children: [
                            Text('Delivery Charges: ',
                                style:
                                    AppStyle.h3.copyWith(color: Colors.white)),
                            const Spacing(),
                            Text('20',
                                style:
                                    AppStyle.h3.copyWith(color: Colors.white)),
                          ],
                        ),
                        const Spacing(),
                        (amount == 1)
                            ? Text('Grand Total: 0',
                                style:
                                    AppStyle.h3.copyWith(color: Colors.white))
                            : Text('Grand Total: $amountd',
                                style:
                                    AppStyle.h3.copyWith(color: Colors.white)),

                        const Spacing(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColor.primary),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16))),
                                    minimumSize: MaterialStateProperty.all(
                                        Size(size.width / 2.6, 37))),
                                onPressed: () async {
                                  String uid =
                                      FirebaseAuth.instance.currentUser!.uid;

                                  if (_formkey.currentState!.validate()) {
                                    print('heyy');
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(uid)
                                        .collection('Cart')
                                        .add({
                                      "categories": widget.category,
                                      "image": widget.image,
                                      "manufacturerId": widget.manufacturerid,
                                      "name": widget.name,
                                      "price": widget.price,
                                      "productId": widget.productid,
                                      "quantity": int.parse(quantity),
                                      "userId": uid,
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShoppingCart()));
                                  }
                                },
                                child: Text('Add To Cart',
                                    style: AppStyle.h3
                                        .copyWith(color: Colors.white))),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColor.primary),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16))),
                                    minimumSize: MaterialStateProperty.all(
                                        Size(size.width / 2.6, 37))),
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
                                            String pattern =
                                                r'(^[7-9][0-9]{9}$)';
                                            RegExp regExp = new RegExp(pattern);

                                            return Container(
                                                // rounded border container top
                                                // take input and button click to update data from flutter firebase
                                                child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          "Personal Details",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Divider(),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: TextField(
                                                            controller:
                                                                _controller1,
                                                            decoration:
                                                                InputDecoration(
                                                              enabled: true,
                                                              prefixIcon: Icon(
                                                                CupertinoIcons
                                                                    .phone_circle_fill,
                                                                size: 24,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                              labelText:
                                                                  'Contact Number',
                                                              hintText:
                                                                  'Enter Your Phone Number',
                                                            ),
                                                            onChanged: (text) {
                                                              phone_number = text
                                                                  .toString();
                                                              text = text
                                                                  .toString();
                                                            },
                                                          ),
                                                        ),
                                                        Divider(),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: TextField(
                                                            controller:
                                                                _controller2,
                                                            onChanged: (text) {
                                                              address = text;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              enabled: true,
                                                              prefixIcon: Icon(
                                                                CupertinoIcons
                                                                    .home,
                                                                size: 24,
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                              labelText:
                                                                  'Your Address',
                                                              hintText:
                                                                  'Enter Your Address',
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        CupertinoButton(
                                                            color: Colors.black,
                                                            child: Text(
                                                                'Continue to Payment...'),
                                                            onPressed:
                                                                () async {
                                                              if (phone_number !=
                                                                      null &&
                                                                  regExp.hasMatch(
                                                                      phone_number
                                                                          .toString()) &&
                                                                  address.length >
                                                                      5) {
                                                                setState(() {
                                                                  if (beforediscount ==
                                                                      afterdiscount) {
                                                                    amount = widget
                                                                            .price *
                                                                        int.parse(
                                                                            quantity);
                                                                    plant
                                                                        ? (amountd = amount +
                                                                            5 +
                                                                            20)
                                                                        : (amountd =
                                                                            amount +
                                                                                20);
                                                                  }
                                                                });
                                                                await openCheckout();

                                                                if (beforediscount !=
                                                                    afterdiscount) {
                                                                  String
                                                                      couponname =
                                                                      'Coupon' +
                                                                          indx.toString();
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'Users')
                                                                      .doc(widget
                                                                          .uid)
                                                                      .update({
                                                                    couponname:
                                                                        false
                                                                  });
                                                                }
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      AlertDialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    title: const Text(
                                                                        "Incorrect Details"),
                                                                    content:
                                                                        const Text(
                                                                            "Please check your address and contact number!"),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(ctx)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(14),
                                                                          child:
                                                                              const Text(
                                                                            "Continue",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
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
                                    style: AppStyle.h3
                                        .copyWith(color: Colors.white))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
          ],
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

class RectButton extends StatelessWidget {
  final String label;
  const RectButton({
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
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColor.primary)),
      child: Center(
          child: Text(
        label,
        style: AppStyle.text.copyWith(color: Colors.white),
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
          style: AppStyle.h1Light,
        ),
        Text(
          ' $amount',
          style: AppStyle.h1Light
              .copyWith(color: AppColor.primary, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
