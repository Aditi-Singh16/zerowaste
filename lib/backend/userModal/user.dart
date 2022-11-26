class UserModel {
  String? uid;
  String? email;
  String? name;
  String? type;
  List<dynamic>? coupons;
  String? addr;
  String? phone;
  double? wallet;
  double? esv_air;
  double? esv_tree;
  double? esv_co2;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.type,
      this.coupons,
      this.addr,
      this.phone,
      this.wallet,
      this.esv_air,
      this.esv_co2,
      this.esv_tree});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      type: map['type'],
      coupons: map['coupons'],
      addr: map['addr'],
      phone: map['phone'],
      wallet: double.parse(map['wallet'].toString()),
      esv_air: map['esv_air'] == null
          ? 0.0
          : double.parse(map['esv_air'].toString()),
      esv_co2: map['esv_co2'] == null
          ? 0.0
          : double.parse(map['esv_co2'].toString()),
      esv_tree: map['esv_tree'] == null
          ? 0.0
          : double.parse(map['esv_tree'].toString()),
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'type': type,
      'coupons': coupons,
      'addr': addr,
      'phone': phone,
      'wallet': wallet,
      'esv_air': esv_air,
      'esv_tree': esv_tree,
      'esv_co2': esv_co2
    };
  }
}
