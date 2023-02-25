import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReturnOrder extends StatefulWidget {
  ReturnOrder(
      {required this.productName,
      required this.manufacturerId,
      required this.price,
      required this.address,
      required this.orderedQuantity,
      required this.orderId,
      required this.image});
  String productName;
  String manufacturerId;
  String address;
  double price;
  int orderedQuantity;
  String image;
  String orderId;

  @override
  State<ReturnOrder> createState() => _ReturnOrderState();
}

class _ReturnOrderState extends State<ReturnOrder> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final _formKey = GlobalKey<FormState>();
  var _quantity = "";
  var _autovalidate = false;
  @override
  void initState() {
    super.initState();
    _quantityController.text = "";
  }

  @override
  void dispose() {
    _quantityFocus.dispose();
    super.dispose();
  }

  void ButtonValidate() {
    if (_formKey.currentState!.validate()) {
      // print('${user.name}:${user.phone}:${user.email}');
      sendData();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Return request sent to the successfully!')));
      setState(() {
        _quantityController.clear();
      });
      Future.delayed(Duration(seconds: 3), () {
        // Your code
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Problem returning items :(')));
      setState(() {
        _autovalidate = true;
      });
    }
  }

  bool color = false;

  sendData() async {
    if (_formKey.currentState!.validate()) {
      String docId = FirebaseFirestore.instance.collection('returns').doc().id;

      await FirebaseFirestore.instance.collection("returns").doc(docId).set({
        'productName': widget.productName,
        'image': widget.image,
        'return_quantity': int.parse(_quantity),
        'price': widget.price,
        'timestamp': DateTime.now(),
        'returnId': docId,
        'manufacturerId': widget.manufacturerId,
        'address': widget.address,
        'orderId': widget.orderId,
        'userId': uid,
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Orders")
          .doc(widget.orderId)
          .update({"is_return": true});
    }
  }

  TextEditingController _quantityController = TextEditingController();
  final FocusNode _quantityFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    const _defaultColor = Colors.grey;
    const _focusColor = Colors.black;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff001427),
          leading: Image.asset(
            'assets/images/logo1.png',
            fit: BoxFit.contain,
          ),
          title: Text("Returns"),
        ),
        body: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // scrollDirection: Axis.vertical,
                children: [
                  Image.network(widget.image),
                  SizedBox(height: 20),
                  Text("Product Name: " + widget.productName),
                  Text(
                      "Ordered Quantity: " + widget.orderedQuantity.toString()),
                  Text("price/product: " + widget.price.toString()),
                  SizedBox(height: 10),
                  Text("Enter Quantity of products you want to return"),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _quantityController,
                    focusNode: _quantityFocus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      labelText: 'quantity you want to return',
                      labelStyle: TextStyle(
                        color: _quantityFocus.hasFocus
                            ? _focusColor
                            : _defaultColor,
                      ),
                    ),
                    onChanged: (value) {
                      _quantity = value;
                      setState(() {
                        color = true;
                      });
                    },
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(_quantityFocus);
                      });
                    },
                    validator: (value) {
                      String patttern = r'^[0-9]+$';
                      RegExp regExp = new RegExp(patttern);
                      if (value!.isEmpty) {
                        return 'Please enter quantity available';
                      }
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter valid quantity';
                      }
                      if (int.parse(_quantity) > widget.orderedQuantity) {
                        return "you cannot return more than you ordered";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                            color: (color) ? Colors.black : Colors.grey,
                          )),
                          child: Text('Return',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () => {
                                ButtonValidate(),
                              })),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                            color: Colors.red.shade300,
                          )),
                          child: Text('Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () => {Navigator.pop(context)}))
                ],
              ),
            ),
          ),
        ));
  }
}
