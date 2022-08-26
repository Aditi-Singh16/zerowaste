import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
}
