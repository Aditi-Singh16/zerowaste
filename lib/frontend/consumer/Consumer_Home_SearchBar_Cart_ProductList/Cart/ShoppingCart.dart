import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ConsumerHome.dart';
import 'package:zerowaste/frontend/consumer/Orders.dart';
import 'package:zerowaste/frontend/consumer/color.dart';
import 'package:zerowaste/frontend/consumer/details.dart';
import 'package:zerowaste/frontend/consumer/style.dart';

String? name;
String phone_number = '';
TextEditingController _controller1 = TextEditingController();
TextEditingController _controller2 = TextEditingController();
String address = '';
bool checkifpayed = false;
num megatotal = 0;
String? name2;
String? phone_number2;
num quant2 = 0;
num price2 = 0;
var date = new DateTime.now().toString();
var dateParse = DateTime.parse(date);

List validity = [false, false, false, false, false];
List couponn = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
List Value = [5, 10, 15, 20, 2];
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

var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
int delivery_charges = 20;
String uid = FirebaseAuth.instance.currentUser!.uid;

DateTime selectedDate = DateTime.now();

CollectionReference products = FirebaseFirestore.instance
    .collection('Products')
    .doc('unfoWBpH8AidhiSmwx44')
    .collection('Products');

class ShoppingCart extends StatefulWidget {
  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  String productid = '6Ffxps7z7OvLjMtUwcxn';
  String manufacturerid = 'unfoWBpH8AidhiSmwx44';
  int amount = megatotal.toInt();

  Razorpay razorpay = Razorpay();
  String quantity = "";

  final _formkey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime selectedDate = DateTime.now();

  //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('test').snapshots();

  CollectionReference newu = FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('Cart');

  get async => null;
  Future<void> fetch_validity() async {
    var docSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();

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
  }

  @override
  void initState() {
    super.initState();
    fetch_validity();

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
                //amount1==0 means coupon is not applied
                plant = true;
                megatotal = (amount1 == 0) ? total + 20 + 5 : amount1 + 20 + 5;
              });
              print('Megatotal');
              print(megatotal);
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
    // loop through fields in a firebase document
    // and update the values
    checkifpayed = true;

    print("Payment success $response");

    String time = DateFormat("hh:mm:ss a").format(DateTime.now());
    newu.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("naaaaameeeeeeee");
        print(doc['name']);
        String quantity = doc['quantity'].toString();
        String date =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
        String docId = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Orders')
            .doc()
            .id;
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Orders')
            .doc(docId)
            .set({
          "image": doc['image'],
          "ProductName": doc['name'],
          "Quantity": doc['quantity'],
          "price": doc['price'].toDouble(),
          "address": address,
          "phone_number": phone_number,
          "Time": time,
          "manufacturerId": doc['manufacturerId'],
          "userId": uid,
          "Date": date,
          "orderId": docId,
          "is_return": false,
          "is_resell": true,
          "category": doc['categories'],
          "Desc": doc['description'],
          "weight": doc['weight'],
          "is_resell": true,
          "uid": uid
        });
      });
    });

    checkifpayed = true;
    CollectionReference newc = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Cart');
    newc.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("product id ${doc['productId']}");
        String productid = doc['productId'];
        String qua = doc['quantity'].toString();
        print("Quantity $qua");
        FirebaseFirestore.instance
            .collection('products')
            .doc(productid)
            .update({
          "quantity": FieldValue.increment(-int.parse(qua)),
        });
      });
    });
    //delete cart items
    newu.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        newu.doc(doc.id).delete();
      });
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({'phone': phone_number, 'addr': address});
    if (walletm == true) {
      await FirebaseFirestore.instance.collection('Users').doc(uid).update(
          {'wallet': (wallet - megatotal) > 0 ? wallet - megatotal : 0});
    }
    if (beforediscount != afterdiscount) {
      String couponname = 'Coupon' + indx.toString();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({couponname: false});
    }
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
      "key": "rzp_test_Ienn2nz5hJfAS1",
      "amount": (walletm)
          ? (amountw * 100).toString()
          : plant == true
              ? ((megatotal + 5) * 100).toString()
              : (megatotal * 100).toString(),
      "name": "Sample App",
      "description": "Payment for the some random product",
      "prefill": {"contact": phone_number},
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
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    num checkquantity = 0;
    CollectionReference product =
        FirebaseFirestore.instance.collection('products');
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
            return Center(
                child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => {},
                      ),
                      title: Text("Failed to load"),
                      backgroundColor: Colors.white,
                    ),
                    body: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black)))));
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
                preferredSize: Size.fromHeight(height * 0.06),
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
                                  radius: height / 7, // Image radius
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
                                                                        FlatButton(
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
                                                      height: height / 100),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '\u{20B9}',
                                                        style: TextStyle(
                                                            fontSize:
                                                                height / 60),
                                                      ),
                                                      Text(
                                                          (doc1['price'] *
                                                                  doc1[
                                                                      'quantity'])
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  height / 60,
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
                                    const Spacing(),
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
                                    const Spacing(),
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
                                                                size.width /
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
                                    const Spacing(),
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
                                    const Spacing(),
                                  ])),
                            ),
                            const Spacing(),
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
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                plant = false;
                                                megatotal = megatotal - 5;
                                              });
                                              print('Megatotal');
                                              print(megatotal);
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
                                        const Spacing(),
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
                                : const Spacing(),
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
                            const Spacing(),
                            Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        60),
                                width: MediaQuery.of(context).size.width / 1.5,
                                height: MediaQuery.of(context).size.height / 20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    //pull up card on button pressed
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
                                                            enabled: true,
                                                            decoration:
                                                                InputDecoration(
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
                                                                  10),
                                                          child: TextField(
                                                            controller:
                                                                _controller2,
                                                            onChanged: (text) {
                                                              address = text;
                                                            },
                                                            enabled: true,
                                                            decoration:
                                                                InputDecoration(
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
                                                              num? quant1 = 0;
                                                              num? total1 = 0;
                                                              String
                                                                  product_name;

                                                              for (int i = 0;
                                                                  i <
                                                                      snapshot
                                                                          .data
                                                                          .docs
                                                                          .length;
                                                                  i++) {
                                                                product_name = snapshot
                                                                        .data
                                                                        .docs[i]
                                                                        .data()[
                                                                    'name'];
                                                                quant1 = quant1! +
                                                                    snapshot
                                                                        .data
                                                                        .docs[i]
                                                                        .data()['quantity'];
                                                                total1 = snapshot
                                                                            .data
                                                                            .docs[i]
                                                                            .data()[
                                                                        'price'] *
                                                                    snapshot
                                                                        .data
                                                                        .docs[i]
                                                                        .data()['quantity'];
                                                              }

                                                              if (phone_number !=
                                                                      null &&
                                                                  regExp.hasMatch(
                                                                      phone_number
                                                                          .toString()) &&
                                                                  address.length >
                                                                      5) {
                                                                if (wallet ==
                                                                        true &&
                                                                    megatotal ==
                                                                        0) {
                                                                  String time = DateFormat(
                                                                          "hh:mm:ss a")
                                                                      .format(DateTime
                                                                          .now());
                                                                  newu.get().then(
                                                                      (QuerySnapshot
                                                                          querySnapshot) {
                                                                    querySnapshot
                                                                        .docs
                                                                        .forEach(
                                                                            (doc) {
                                                                      print(
                                                                          "naaaaameeeeeeee");
                                                                      print(doc[
                                                                          'name']);
                                                                      String
                                                                          quantity =
                                                                          doc['quantity']
                                                                              .toString();
                                                                      String
                                                                          date =
                                                                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                                                                      String docId = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Users')
                                                                          .doc(
                                                                              uid)
                                                                          .collection(
                                                                              'Orders')
                                                                          .doc()
                                                                          .id;
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Users')
                                                                          .doc(
                                                                              uid)
                                                                          .collection(
                                                                              'Orders')
                                                                          .doc(
                                                                              docId)
                                                                          .set({
                                                                        "image":
                                                                            doc['image'],
                                                                        "ProductName":
                                                                            doc['name'],
                                                                        "Quantity":
                                                                            doc['quantity'],
                                                                        "price":
                                                                            doc['price'].toDouble(),
                                                                        "address":
                                                                            address,
                                                                        "phone_number":
                                                                            phone_number,
                                                                        "Time":
                                                                            time,
                                                                        "manufacturerId":
                                                                            doc['manufacturerId'],
                                                                        "userId":
                                                                            uid,
                                                                        "Date":
                                                                            date,
                                                                        "orderId":
                                                                            docId,
                                                                        "is_return":
                                                                            false,
                                                                        "uid":
                                                                            uid
                                                                      });
                                                                    });
                                                                  });
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'Users')
                                                                      .doc(uid)
                                                                      .update({
                                                                    'wallet': (wallet -
                                                                                megatotal) >
                                                                            0
                                                                        ? wallet -
                                                                            megatotal
                                                                        : 0
                                                                  });

                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            AlertDialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      title: const Text(
                                                                          "Order Completed"),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => YourOrders()));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.black,
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(14),
                                                                            child:
                                                                                const Text(
                                                                              "Continue",
                                                                              style: TextStyle(color: Colors.white),
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
                                                                if (checkifpayed ==
                                                                    false) {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            AlertDialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
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
                                                                            Navigator.of(ctx).pop();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.black,
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(14),
                                                                            child:
                                                                                const Text(
                                                                              "Continue",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else if (checkifpayed ==
                                                                    true) {
                                                                  checkifpayed =
                                                                      false;
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            AlertDialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      title: const Text(
                                                                          "Order Placed"),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(ctx).pop();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.black,
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(14),
                                                                            child:
                                                                                const Text(
                                                                              "Continue",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                                checkifpayed =
                                                                    false;
                                                              }
                                                            })
                                                      ],
                                                    )));
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: plant == true
                                      ? Text('Proceed to Checkout ' +
                                          '\u{20B9}' +
                                          (megatotal + 5).toString() +
                                          " (" +
                                          quant.toString() +
                                          " Item) ")
                                      : Text('Proceed to Checkout ' +
                                          '\u{20B9}' +
                                          (megatotal).toString() +
                                          " (" +
                                          quant.toString() +
                                          " Item) "),
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
