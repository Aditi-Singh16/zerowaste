import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/frontend/Helpers/consumer/tab_display.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/Helpers/color.dart';
import 'package:zerowaste/frontend/Helpers/style.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

String? name;

num megatotal = 0;

List validity = [false, false, false, false, false];
List couponn = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
int wallet = 0;
double amount1 = 0;
double amountd = 0;
int amountw = 0;
bool coupon = false;
bool plant = false;
bool couponused = false;
bool walletm = false;
String eneteredcoupon = '';
int indx = 0;
num beforediscount = 0;
num afterdiscount = 0;
String error = '';
late num total;

class ShoppingCart extends StatefulWidget {
  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DateTime selectedDate = DateTime.now();
  int amount = megatotal.toInt();

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

  Widget _plantgif(BuildContext context) {
    return AlertDialog(
      title: const Text('Congratulations!!!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset("assets/images/plantatree.gif"),
        ],
      ),
      actions: <Widget>[
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

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Meet Your Plant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Plant a Tree just at " +
              '\u{20B9}' +
              "5 and take a step towards Green India"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                //amount1==0 means coupon is not applied
                plant = true;
                megatotal = (amount1 == 0) ? total + 20 + 5 : amount1 + 20 + 5;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) => _plantgif(context),
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
    FirebaseData().deleteFromCart(uid);

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

    // Toast.show("Pament success", context);
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
    print("Pament error");
    // Toast.show("Pament error", context);
  }

  void handlerExternalWallet() {
    print("External Wallet");
    // Toast.show("External Wallet", context);
  }

  Future<void> openCheckout() async {
    var options = {
      "key": dotenv.env['RAZORPAY_KEY'],
      "amount": (walletm)
          ? (amountw * 100).toString()
          : plant == true
              ? ((megatotal + 5) * 100).toString()
              : (megatotal * 100).toString(),
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
            //uid of user
            .doc(uid)
            .collection('Cart')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          CollectionReference n = FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Cart');

          if (!snapshot.hasData) {
            return Scaffold(body: Loader());
          }
          if (snapshot.hasData) {
            // get length of douments firebas
            total = 0;
            num? quant = 0;
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              quant = quant! + snapshot.data.docs[i].data()['quantity'];
              total = total +
                  snapshot.data.docs[i].data()['price'] *
                      snapshot.data.docs[i].data()['quantity'];
              megatotal = total + 20;
            }

            return Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
                child: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => {
                      // go back page
                      Navigator.pop(context)
                    },
                  ),
                  title: Text("My Cart"),
                ),
              ),
              body: Container(
                child: total == 0
                    ? Scaffold(
                        body: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 100, bottom: 20),
                                child: CircleAvatar(
                                  radius: MediaQuery.of(context).size.height /
                                      7, // Image radius
                                  backgroundImage: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/categories%2Fcart.gif?alt=media&token=6ef4fdc0-b651-49a6-8f23-e09a67b86d54'),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Your ZeroWaste cart is empty!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: InkWell(
                                      onTap: () {
                                        // go back page
                                        Navigator.pop(context);
                                      },
                                      child: Text('Continue Shopping...')),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black, // background
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                // firebase length of itemcount
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  //    DocumentSnapshot doc = snapshot.data!.docs[index];
                                  DocumentSnapshot doc1 =
                                      snapshot.data!.docs[index];

                                  print(doc1.id);
                                  String name = doc1['name'];
                                  if (name.length > 9) {
                                    name = name.substring(0, 9) + "...";
                                  }
                                  return Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
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
                                      child: InkWell(
                                        onTap: () {
                                          //  Navigator.of(context).push(
                                          //  MaterialPageRoute(
                                          //   builder: (context) => DetailsPage(detail: doc),
                                          //  ),
                                          //  );
                                        },
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3,
                                                    width:
                                                        MediaQuery.of(context)
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
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            30),

                                                    // child: InkWell(
                                                    //   onTap: (){
                                                    //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(snapshot[name],snapshot[description],snapshot[price],snapshot[categories])));
                                                    //   },

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
                                                                fontSize: MediaQuery
                                                                            .of(
                                                                                context)
                                                                        .size
                                                                        .height /
                                                                    50,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Spacer(),
                                                          InkWell(
                                                            child: Container(
                                                              margin: EdgeInsets.only(
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      100),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'Users')
                                                                      .doc(uid)
                                                                      .collection(
                                                                          'Cart')
                                                                      .doc(doc1
                                                                          .id)
                                                                      .delete();
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever_rounded,
                                                                  color: Colors
                                                                      .grey,
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
                                                        right: MediaQuery.of(
                                                                    context)
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
                                                            newu.doc(doc1.id).set(
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
                                                        child: Icon(CupertinoIcons
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
                                                              newu.doc(doc1.id).set(
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
                                                              newu.doc(doc1.id).set(
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
                                                                          Text(
                                                                        'Select a lower quantity',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        'Quantity exceeds the available stock',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        ElevatedButton(
                                                                          child:
                                                                              Text('OK'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        )
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          });
                                                        },
                                                        child: Icon(CupertinoIcons
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
                                                              color:
                                                                  Colors.black,
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
                                    ),
                                  );
                                }),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
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
                                    Divider(),
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
                                                coupon = true;
                                              });
                                            }),
                                        coupon
                                            ? InkWell(
                                                child: Container(
                                                  child: Text('Remove',
                                                      style: AppStyle.text
                                                          .copyWith(
                                                              color:
                                                                  Colors.red)),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    coupon = false;
                                                    if (beforediscount !=
                                                        afterdiscount) {
                                                      amount1 = 0;

                                                      megatotal = (plant)
                                                          ? (amount1 == 0)
                                                              ? total + 20 + 5
                                                              : amount1 + 20 + 5
                                                          : (amount1 == 0)
                                                              ? total + 20
                                                              : amount1 + 20;
                                                    }
                                                  });
                                                })
                                            : Visibility(
                                                visible: false,
                                                child: Text('')),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    coupon
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
                                                    () => eneteredcoupon = val);
                                              },
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColor.primary),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                        : Visibility(
                                            visible: false,
                                            child: SizedBox(height: 0)),
                                    Text(error,
                                        style: TextStyle(color: Colors.red)),
                                    coupon
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
                                                    if (couponn.contains(
                                                        eneteredcoupon)) {
                                                      print(
                                                          'entered coupon is in coupon');
                                                      indx = couponn.indexOf(
                                                          eneteredcoupon);
                                                      if (validity[indx] ==
                                                          true) {
                                                        print(
                                                            ' entered coupon is valid coupon');
                                                        setState(() {
                                                          //applied coupon amount

                                                          beforediscount =
                                                              total;

                                                          amount1 = (total -
                                                              (total *
                                                                  (Value[
                                                                      indx]) /
                                                                  100));
                                                          afterdiscount =
                                                              amount1;
                                                          plant
                                                              ? megatotal =
                                                                  (amount1 == 0)
                                                                      ? total +
                                                                          5 +
                                                                          20
                                                                      : amount +
                                                                          5 +
                                                                          20
                                                              : megatotal =
                                                                  (amount1 == 0)
                                                                      ? total +
                                                                          20
                                                                      : amount +
                                                                          20;
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
                                        : Visibility(
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
                                                        'Use wallet money     Rs.' +
                                                            '$wallet',
                                                        style: AppStyle.text
                                                            .copyWith(
                                                                color: Colors
                                                                    .blue)),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      walletm = true;

                                                      if (wallet > megatotal) {
                                                        amountw = 0;
                                                      } else {
                                                        amountw =
                                                            megatotal.floor() -
                                                                wallet;
                                                      }
                                                    });
                                                  }),
                                              walletm
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
                                                          walletm = false;
                                                        });
                                                      })
                                                  : Visibility(
                                                      visible: false,
                                                      child: Text('')),
                                            ],
                                          )
                                        : Visibility(
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
                                  padding: EdgeInsets.only(left: 40),
                                  child: Text("Total",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 40),
                                  child: Text(
                                      (amount1 == 0)
                                          ? total.toString()
                                          : amount1.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 40),
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
                                  padding: EdgeInsets.only(right: 40),
                                  child: Text(delivery_charges.toString(),
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
                            Divider(),
                            (plant)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 40),
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
                                                plant = false;
                                                megatotal = megatotal - 5;
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
                                          padding: EdgeInsets.only(right: 40),
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
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Text("Sub-Total",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 40),
                                  child: Text(megatotal.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      )),
                                ),
                              ],
                            ),
                            Divider(),
                            (walletm)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 40),
                                        child: Text('Final Total:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 40),
                                        child: Text('$amountw',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            )),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 40),
                                        child: Text('Final Total:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 40),
                                        child: plant == true
                                            ? Text((megatotal + 5).toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                ))
                                            : Text((megatotal).toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                )),
                                      ),
                                    ],
                                  ),
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
                                  child: Text('Proceed to Checkout '),
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
                              margin: EdgeInsets.all(10),
                            )
                          ],
                        ),
                      ),
              ),
            );
          }
          return Scaffold(
              body:
                  Center(child: CircularProgressIndicator(color: Colors.grey)));
        });
  }
}
