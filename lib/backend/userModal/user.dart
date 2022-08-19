class UserModel {
  String? uid;
  String? email;
  String? name;
  String? type;
  String? Coupon0;
  String? Coupon1;
  String? Coupon2;
  String? Coupon3;
  String? Coupon4;
  String? addr;
  String? phone;

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
      this.phone});

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
        phone: map['phone']);
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
      'phone': phone
    };
  }
}
