import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<num> getManufactureSoldCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    print(uid);
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .get();
    num quantity = 0;
    res.docs.forEach((element) {
      quantity = quantity + element['Quantity'];
    });
    return quantity;
  }

  Future<int> getManufactureCustomerCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .get();
    return res.docs.length;
  }

  Future<int> getManufacureReturnCount() async {
    var uid = await HelperFunctions().readUserIdPref();
    var res = await FirebaseFirestore.instance
        .collectionGroup('Orders')
        .where('manufacturerId', isEqualTo: uid)
        .where('is_return', isEqualTo: true)
        .get();

    print(res.docs.length);
    return res.docs.length;
  }

  Future<int> getManufactureDonationCount() async {
    var email = await HelperFunctions().readEmailPref();
    var uid = await HelperFunctions().readUserIdPref();
    var res =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    int count = 0;
    if (res['accepted_requests'].length > 0) {
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
                        .where('is_return',isEqualTo: true)
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
}
