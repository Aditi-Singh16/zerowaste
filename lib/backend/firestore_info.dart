import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

class FirebaseData {
  Future<String> addRequirement(Map<String, dynamic> requirements) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection("requirements")
          .add(requirements);
      return res.id;
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
