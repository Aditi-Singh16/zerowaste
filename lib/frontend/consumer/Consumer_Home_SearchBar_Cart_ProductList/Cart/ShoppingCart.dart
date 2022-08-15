import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/frontend/consumer/Consumer_Home_SearchBar_Cart_ProductList/Home/ConsumerHome.dart';
import 'package:zerowaste/frontend/consumer/details.dart';

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

var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
int delivery_charges = 20;
String uid =
    FirebaseAuth.instance.currentUser!.uid;

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

  @override
  void initState() {
    _controller1.text = address;
    _controller2.text = phone_number;
    super.initState();

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
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Orders')
            .add({
          "image": doc['image'],
          "ProductName": doc['name'],
          "Quantity": doc['quantity'],
          "price": doc['price'],
          "address": address,
          "phone_number": phone_number,
          "Time": time,
          "manufacturerId": doc['manufacturerId'],
          "userId": uid,
          "Date": date,
          "delivery_status":"Shipped",
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
        }

        );

      });

    });
    //delete cart items
    newu.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        newu.doc(doc.id).delete();
      });
    });
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
      "amount": megatotal * 100,
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
    CollectionReference product = FirebaseFirestore.instance
        .collection('products');
    // get quantity field from products collection

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
        //uid of user
            .doc(uid)
            .collection('Cart')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          CollectionReference n= FirebaseFirestore.instance
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black)))));
          }
          if (snapshot.hasData) {
            // get length of douments firebas
            num? total = 0;
            num? quant = 0;
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              quant = quant! + snapshot.data.docs[i].data()['quantity'];
              total = total! +
                  snapshot.data.docs[i].data()['price'] *
                      snapshot.data.docs[i].data()['quantity'];
            }
            megatotal = delivery_charges + total!;
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
                                                        0 ) {
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

                                                    newu.doc(doc1.id).set(
                                                        {
                                                          "quantity":
                                                          doc1['quantity'] +
                                                              1,
                                                        },
                                                        SetOptions(
                                                            merge: true));




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
                            child: Text(total.toString(),
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
                                      20,
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
                                      20,
                                )),
                          ),
                        ],
                      ),
                      Divider(),
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
                                    initialChildSize: 0.37,
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
                                              padding: EdgeInsets.all(15),
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
                                                        15),
                                                    child: TextField(
                                                      controller:
                                                      _controller2,
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
                                                        15),
                                                    child: TextField(
                                                      controller:
                                                      _controller1,
                                                      onChanged: (text) {
                                                        address = text;
                                                      },
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
                                                    height: height / 45,
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

                                                        if (megatotal >
                                                            0 &&
                                                            phone_number !=
                                                                null &&
                                                            regExp.hasMatch(
                                                                phone_number
                                                                    .toString()) &&
                                                            address.length>5) {
                                                          await openCheckout();
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
                            child: Text('Proceed to Checkout ' +
                                '\u{20B9}' +
                                megatotal.toString() +
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
