import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:zerowaste/frontend/constants.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class FirebaseData {
  Future<String> addRequirement(Map<String, dynamic> requirements) async {
    try {
      var uid = await HelperFunctions().readUserIdPref();
      await FirebaseFirestore.instance
          .collection("requirements")
          .doc()
          .set(requirements);
      return uid;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<QueryDocumentSnapshot>> getProducts(String category) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection("products")
          .where("categories", isEqualTo: category)
          .get();
      return res.docs;
    } catch (e) {
      return [];
    }
  }

  Future<int> getManufactureSoldCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .get();
    int quantity = 0;
    res.docs.forEach((element) {
      quantity = quantity + (element['Quantity'] as int);
    });
    return quantity;
  }

  Future<int> getManufactureCustomerCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .get();
    List<String> uids = [];
    for (int i = 0; i < res.docs.length; i++) {
      if (!uids.contains(res.docs[i]['uid'])) {
        uids.add(res.docs[i]['uid']);
      }
    }
    return uids.length;
  }

  Future<int> getManufacureReturnCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .where('is_return', isEqualTo: true)
        .get();

    return res.docs.length;
  }

  Future<int> getManufactureDonationCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (res.data()!.containsKey("accepted_requests")) {
      return res['accepted_requests'].length;
    } else {
      return 0;
    }
  }

  Future<int> getProductSoldCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .get();

    return res.docs.length;
  }

  Future<int> getProductReturnCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collection('returns')
        .where('manufacturerId', isEqualTo: uid)
        .get();

    return res.docs.length;
  }

  Future<void> addCouponToDonors(var acceptedUid, var documentId, var uid,
      var index, var type, var acceptedMap) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(acceptedUid)
        .update({
      "coupons": FieldValue.arrayUnion([AppConstants.coupons[index]]),
      "accepted_requests": FieldValue.arrayUnion([acceptedMap]),
    });

    await FirebaseFirestore.instance
        .collection("requirements")
        .doc(documentId)
        .delete();
  }

  Future<void> addOrders(
      var uid,
      var name,
      var productid,
      var category,
      var quantity,
      var time,
      var amount,
      var date,
      var manufacturerid,
      var image,
      var w,
      var description) async {
    var docId = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Orders')
        .doc()
        .id;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Orders')
        .doc(docId)
        .set({
      "OrderId": docId,
      "ProductName": name,
      "ProductId": productid,
      "category": category,
      "Quantity": quantity,
      "Time": time,
      "Amount": amount,
      "Date": date,
      "manufacturerId": manufacturerid,
      "image": image,
      "uid": uid,
      "Desc": description,
      "weight": w,
      "is_resell": true,
      "is_return": false,
      "address": await HelperFunctions().readAddressPref(),
      "phone_no": await HelperFunctions().readPhonePref(),
    });
  }

  Future<void> deleteWholeCart(var uid) async {
    CollectionReference userCart = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Cart');
    await userCart.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        userCart.doc(doc.id).delete();
      });
    });
  }

  Future<void> deleteSingleItemFromCart(var uid, var docId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Cart')
        .doc(docId)
        .delete();
  }

  Future<void> addToCart(
      var uid,
      var productid,
      var category,
      var image,
      var manufacturerid,
      var name,
      var price,
      var quantity,
      var weight,
      var desc) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Cart')
        .doc(productid)
        .set({
      "categories": category,
      "image": image,
      "manufacturerId": manufacturerid,
      "name": name,
      "price": price,
      "productId": productid,
      "quantity": FieldValue.increment(int.parse(quantity)),
      "userId": uid,
      "weight": weight,
      "description": desc
    });
  }

  Future<void> updateWallet(var uid, var totalAmount, var wallet) async {
    if (totalAmount > wallet) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'wallet': 0});
    } else {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'wallet': wallet - totalAmount});
    }
  }

  Future<void> updateCoupons(var uid, var coupon) async {
    await FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'coupons': FieldValue.arrayRemove([coupon])
    });
  }

  Future<int> getUserOrdersCount(customer) async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .where('uid', isEqualTo: customer)
        .get();

    return res.docs.length;
  }

  Future<int> getUserReturnCount(customer) async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collection('returns')
        .where('manufacturerId', isEqualTo: uid)
        .where('userId', isEqualTo: customer)
        .get();

    return res.docs.length;
  }

  Future<dynamic> getReturnRate(uid) async {
    var totalProducts = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Orders')
        .get();

    var bought = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Orders')
        .where('is_return', isEqualTo: true)
        .get();
    double soldquantity = 0;
    totalProducts.docs.forEach((element) {
      soldquantity = soldquantity + element['Quantity'];
    });
    var res1 = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .where('is_return', isEqualTo: true)
        .get();
    double returnquantity = 0;
    res1.docs.forEach((element) {
      returnquantity = returnquantity + element['Quantity'];
    });
    double value = returnquantity / (returnquantity + soldquantity) * 100;
    print(value);
    return value;
  }

  CompanyTotalManu() async {
    var res = await FirebaseFirestore.instance
        .collection("Users")
        .where("type", isEqualTo: "Manufacturer")
        .get();
    return res.docs.length;
  }

  Future<int> CompanyTotalConsumer() async {
    var res = await FirebaseFirestore.instance
        .collection('Users')
        .where('type', isEqualTo: "Consumer")
        .get();
    return res.docs.length;
  }

  CompanyTotalNGO() async {
    var res = await FirebaseFirestore.instance
        .collection("Users")
        .where("type", isEqualTo: "NGO")
        .get();
    return res.docs.length;
  }

  CompanyTotalDonors() async {
    //var email = await HelperFunctions().readEmailPref();
    var res = await FirebaseFirestore.instance
        .collection('Users')
        .where("accepted_requests", isNotEqualTo: []).get();
    int count = 0;
    res.docs.forEach((element) {
      element['accepted_requests'].forEach((ele) {
        count = count + 1;
      });
    });
    return count;
  }

  Future<int> CompanyConsumerToConsumer() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('is_resell', isEqualTo: false)
        .get();

    return res.docs.length;
  }

  CompanyESVAir() async {
    double air = 0;

    var res = await FirebaseFirestore.instance.collection('environment').get();

    res.docs.forEach((element) {
      if (element['air'] != null) {
        air = air + element['air'];
      }
    });

    return air;
  }

  CompanyESVTree() async {
    double air = 0, tree = 0, co2 = 0;

    var res = await FirebaseFirestore.instance.collection('environment').get();

    res.docs.forEach((element) {
      if (element['tree'] != null) {
        tree = tree + element['tree'];
      }
    });

    return tree;
  }

  CompanyESVCo2() async {
    double air = 0, tree = 0, co2 = 0;

    var res = await FirebaseFirestore.instance.collection('environment').get();

    res.docs.forEach((element) {
      print(element['co2']);

      co2 = co2 + element['co2'];
      print(co2);
      print("for");
    });
    print("hiiii");
    print(co2);
    return co2;
  }

  TotalProds() async {
    num quant = 0;
    var res = await FirebaseFirestore.instance.collectionGroup("Orders").get();
    res.docs.forEach((element) {
      //print(element['co2']);

      quant = quant + element['Quantity'];
      print(quant);
      print("Tot prod");
      // print(co2);
      // print("for");
    });
    return quant;
  }
}
