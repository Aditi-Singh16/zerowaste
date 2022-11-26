import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  final idKey = 'this_user_id';
  final nameKey = 'this_user_Name';
  final emailKey = 'this_user_email';
  final typeKey = 'this_user_type';
  final couponkey = 'this_coupons';
  final addrkey = 'this_addr';
  final phonekey = 'this_phone';
  final walletkey = 'this_wallet';
  final esvAirkey = 'this_esvAir';
  final esvTreekey = 'this_esvTree';
  final esvCo2key = 'this_esvCo2';

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

  Future<void> setCoupons(List<dynamic> coupons) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(couponkey, coupons.map((e) => e.toString()).toList());
  }

  Future<void> setWallet(double? wallet) async {
    final prefs = await SharedPreferences.getInstance();

    if (wallet == null) {
      prefs.setDouble(walletkey, 0.0);
    }
    prefs.setDouble(walletkey, wallet!);
  }

  Future<void> setEsvAir(double? esvAir) async {
    final prefs = await SharedPreferences.getInstance();

    if (esvAir == null) {
      prefs.setDouble(esvAirkey, 0.0);
    }
    prefs.setDouble(esvAirkey, esvAir!);
  }

  Future<void> setEsvTree(double? esvTree) async {
    final prefs = await SharedPreferences.getInstance();

    if (esvTree == null) {
      prefs.setDouble(esvTreekey, 0.0);
    }
    prefs.setDouble(esvTreekey, esvTree!);
  }

  Future<void> setEsvCo2(double? esvCo2) async {
    final prefs = await SharedPreferences.getInstance();

    if (esvCo2 == null) {
      prefs.setDouble(esvCo2key, 0.0);
    }
    prefs.setDouble(esvCo2key, esvCo2!);
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

  readAddressPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_addr') ?? '0';
  }

  readPhonePref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_phone') ?? '0';
  }

  readTypePref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('this_user_type') ?? '0';
  }

  readCouponPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('this_coupons') ?? [];
  }

  readWalletPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('this_wallet') ?? 0.0;
  }

  readEsvAirPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('this_esvAir') ?? 0.0;
  }

  readEsvCo2Pref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('this_esvCo2') ?? 0.0;
  }

  readEsvTreePref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('this_esvTree') ?? 0.0;
  }
}
