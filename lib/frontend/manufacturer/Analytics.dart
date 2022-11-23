import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/backend/userModal/user.dart';

class ManuFacture extends StatefulWidget {
  final BuildContext context;
  final String prodctId;
  const ManuFacture({
    Key? key,
    required this.context,
    required this.prodctId,
  }) : super(key: key);

  @override
  State<ManuFacture> createState() => _ManuFactureState();
}

class _ManuFactureState extends State<ManuFacture> {
  num? returns;
  num? sold;
  getDetails() async {
    var val1 = await FirebaseData().getProductReturnCount();
    var val2 = await FirebaseData().getProductSoldCount();
    setState(() {
      returns = val1;
      sold = val2;
    });
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String monthvalue = 'January';
  num totalReturnCount = 0;
  num totalSoldCount = 0;

  // List of items in our dropdown menu

  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Product Analytics'),
      content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              Card(
                  child: Container(
                color: const Color(0xffC87FFC),
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        sold.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Total Sales",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 20),
              Card(
                  child: Container(
                color: const Color(0xffFE9E87),
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        returns.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Total Returns",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          )),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
