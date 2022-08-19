import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  final idKey = 'this_user_id';
  final nameKey = 'this_user_Name';
  final emailKey = 'this_user_email';
  final typeKey = 'this_user_type';
  final coupon0 = 'this_coupon0';
  final coupon1 = 'this_coupon1';
  final coupon2 = 'this_coupon2';
  final coupon3 = 'this_coupon3';
  final coupon4 = 'this_coupon4';
  final addrkey = 'this_addr';
  final phonekey = 'this_phone';

  Future<void> setUserIdPref(String? id) async {
    final prefs = await SharedPreferences.getInstance();

    if (id == null) {
      prefs.setString(idKey, '0');
    }
    prefs.setString(idKey, id!);
  }

  Future<void> setNamePref(String? userName) async {
    final prefs = await SharedPreferences.getInstance();

    if (userName == null) {
      prefs.setString(nameKey, '');
    }
    prefs.setString(nameKey, userName!);
  }

  Future<void> setEmailPref(String? email) async {
    final prefs = await SharedPreferences.getInstance();

    if (email == null) {
      prefs.setString(emailKey, '0');
    }
    prefs.setString(emailKey, email!);
  }

  Future<void> setAddrPref(String? addr) async {
    final prefs = await SharedPreferences.getInstance();

    if (addr == null) {
      prefs.setString(addrkey, '0');
    }
    prefs.setString(addrkey, addr!);
  }

  Future<void> setPhonePref(String? phone) async {
    final prefs = await SharedPreferences.getInstance();

    if (phone == null) {
      prefs.setString(phonekey, '0');
    }
    prefs.setString(phonekey, phone!);
  }

  Future<void> setType(String? userType) async {
    final prefs = await SharedPreferences.getInstance();

    if (userType == null) {
      prefs.setString(typeKey, '');
    }
    prefs.setString(typeKey, userType!);
  }

  Future<void> setCoupons(String? couponA, String? couponB, String? couponC,
      String? couponD, String? couponE) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(coupon0, couponA!);
    prefs.setString(coupon1, couponB!);
    prefs.setString(coupon2, couponC!);
    prefs.setString(coupon3, couponD!);
    prefs.setString(coupon4, couponE!);
  }

  readUserIdPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_user_id') ?? '0';
  }

  readNamePref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_user_Name') ?? '0';
  }

  readEmailPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_user_email') ?? '0';
  }

  readTypePref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_user_type') ?? '0';
  }

  readCoupon0Pref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_coupon0') ?? '0';
  }

  readCoupon1Pref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_coupon1') ?? '0';
  }

  readCoupon2Pref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_coupon2') ?? '0';
  }

  readCoupon3Pref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_coupon3') ?? '0';
  }

  readCoupon4Pref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_coupon4') ?? '0';
  }
}
