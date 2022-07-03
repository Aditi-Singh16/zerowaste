class UserModel {
  String? uid;
  String? email;
  String? name;
  String? type;

  UserModel({this.uid, this.email, this.name, this.type});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        type: map['type']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name, 'type': type};
  }
}
