import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zerowaste/frontend/consumer/color.dart';
import 'package:zerowaste/frontend/consumer/style.dart';
import 'package:intl/intl.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String quantity = "";
  DateTime selectedDate = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  String image = 'assets/images/Image_1.png';
  String image1 = 'assets/images/Image_1.png';
  String image2 = 'assets/images/Image_2.png';
  String image3 = 'assets/images/Image_3.png';
  String image4 = 'assets/images/Image_4.png';
  String name = "Jogger Lilac";
  String productid = '6Ffxps7z7OvLjMtUwcxn';
  int amount = 15;
  Razorpay razorpay = Razorpay();
  @override
  void initState() {
    super.initState();

    image = image1;
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  void handlerPaymentSuccess() {
    print("Pament success");
    // Toast.show("Pament success", context);
  }

  void handlerErrorFailure() {
    print("Pament error");
    // Toast.show("Pament error", context);
  }

  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void handlerExternalWallet() {
    print("External Wallet");
    // Toast.show("External Wallet", context);
  }

  Future<void> openCheckout() async {
    var options = {
      "key": "rzp_test_Ienn2nz5hJfAS1",
      "amount": amount,
      "name": "Sample App",
      "description": "Payment for the some random product",
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
                      image: AssetImage(image))),
            ),
          ),
          Positioned(
              top: 60,
              right: 20,
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 128, 128),
                    borderRadius: BorderRadius.circular(11)),
                child: Image.asset('assets/images/Bag.png'),
              )),
          Positioned(
            top: 145,
            right: 24,
            child: Container(
              height: 276,
              width: 73,
              decoration: BoxDecoration(
                  gradient: AppColor.gradient,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    height: 61,
                    width: 61,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.primary, width: 2),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/Image_1.png'))),
                  ),
                  onTap: () {
                    setState(() {
                      image = image1;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    height: 61,
                    width: 61,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.primary, width: 2),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/Image_2.png'))),
                  ),
                  onTap: () {
                    setState(() {
                      image = image2;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    height: 61,
                    width: 61,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.primary, width: 2),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/Image_3.png'))),
                  ),
                  onTap: () {
                    setState(() {
                      image = image3;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    height: 61,
                    width: 61,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.primary, width: 2),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/Image_4.png'))),
                  ),
                  onTap: () {
                    setState(() {
                      image = image4;
                    });
                  },
                ),
              ]),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                height: size.height / 2.2,
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
                          margin: const EdgeInsets.only(bottom: 16),
                          height: 5,
                          width: 32 * 1.5,
                          decoration: BoxDecoration(
                            gradient: AppColor.gradient,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const ProductNameAndPrice(),
                      const SizedBox(
                        height: 7,
                      ),
                      Text('Quantity',
                          style: AppStyle.text.copyWith(color: Colors.white)),
                      const Spacing(),
                      Form(
                        key: _formkey,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() => quantity = val);
                            },
                            validator: (val) =>
                                val!.isEmpty ? "Enter quantity" : null,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.primary),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColor.primary),
                              ),
                              labelText: '50',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(.5)),
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
                        'This is weekdays design-your go-to for all the latest trends, no matter who you are.',
                        style: AppStyle.bodyText.copyWith(color: Colors.white),
                      ),
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
                              onPressed: () {},
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
                                  print("ccneakc");
                                  await openCheckout();
                                  // String uid = 'bcbF3NkrUnQqqeqO49pb';
                                  // amount *= int.parse(quantity);
                                  // String time = DateFormat("hh:mm:ss a")
                                  //     .format(DateTime.now());
                                  // String date =
                                  //     "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

                                  // await FirebaseFirestore.instance
                                  //     .collection('Users')
                                  //     .doc(uid)
                                  //     .collection('Orders')
                                  //     .add({
                                  //   "ProductName": name,
                                  //   "ProductId": productid,
                                  //   "Quantity": quantity,
                                  //   "Time": time,
                                  //   "Amount": amount,
                                  //   "Date": date
                                  // });
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
  const ProductNameAndPrice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Jogger Lilac',
          style: AppStyle.h1Light,
        ),
        Text(
          '15.00',
          style: AppStyle.h1Light
              .copyWith(color: AppColor.primary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
