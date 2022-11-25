class UserModel {
  String? uid;
  String? email;
  String? name;
  String? type;
  bool? Coupon0;
  bool? Coupon1;
  bool? Coupon2;
  bool? Coupon3;
  bool? Coupon4;
  String? addr;
  String? phone;
  double? wallet;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.type,
      this.Coupon0,
      this.Coupon1,
      this.Coupon2,
      this.Coupon3,
      this.Coupon4,
      this.addr,
      this.phone,
      this.wallet});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        type: map['type'],
        Coupon0: map['Coupon0'],
        Coupon1: map['Coupon1'],
        Coupon2: map['Coupon2'],
        Coupon3: map['Coupon3'],
        Coupon4: map['Coupon4'],
        addr: map['addr'],
        phone: map['phone'],
        wallet: double.parse(map['wallet'].toString()));
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'type': type,
      'Coupon0': Coupon0,
      'Coupon1': Coupon1,
      'Coupon2': Coupon2,
      'Coupon3': Coupon3,
      'Coupon4': Coupon4,
      'addr': addr,
      'phone': phone,
      'wallet': wallet
    };
  }
}
