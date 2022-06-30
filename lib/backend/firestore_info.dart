import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseData {
  Future<String> addRequirement(Map<String,dynamic> requirements) async {
    try {
      var res = await FirebaseFirestore.instance.collection("requirements").add(
        requirements
      );
      return res.id;
    } catch (e) {
      return e.toString();
    }
  }
}
