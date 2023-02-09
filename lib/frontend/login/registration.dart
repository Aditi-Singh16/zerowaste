import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zerowaste/backend/local_data.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/frontend/consumer/consumerNavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zerowaste/frontend/manufacturer/manufacturerNavbar.dart';
import 'package:zerowaste/frontend/ngo/ngoNavbar.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // ignore: prefer_final_fields
  HelperFunctions _helperFunctions = HelperFunctions();
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final addrEditingController = TextEditingController();
  String typeEditingController = 'Consumer';
  final gstEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 1, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //phone no field
    final phoneField = TextFormField(
        autofocus: false,
        controller: phoneEditingController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Phone No.");
          }
          return null;
        },
        onSaved: (value) {
          phoneEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.call),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone No.",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //address field
    final addrField = TextFormField(
        autofocus: false,
        controller: addrEditingController,
        keyboardType: TextInputType.streetAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Address");
          }

          return null;
        },
        onSaved: (value) {
          addrEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.home),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //type field
    final typeField = DropdownButton<String>(
      value: typeEditingController,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 20,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        setState(() {
          typeEditingController = newValue!;
        });
      },
      items: <String>['Consumer', 'NGO', 'Manufacturer']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff00277d),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/logo.png",
                        height: MediaQuery.of(context).size.height * 0.1),
                    firstNameField,
                    emailField,
                    phoneField,
                    addrField,
                    passwordField,
                    confirmPasswordField,
                    typeField,
                    signUpButton,
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid GST");
      //Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => RegistrationScreen()));
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingController.text;
    userModel.type = typeEditingController;
    userModel.addr = addrEditingController.text;
    userModel.phone = phoneEditingController.text;
    userModel.wallet = 0;

    DataBaseHelper dataBaseHelper = DataBaseHelper.instance;

    await dataBaseHelper.insertUser({
      'uid': user.uid,
      'name': nameEditingController.text,
      'phone': phoneEditingController.text,
      'email': userModel.email,
      'type': typeEditingController,
      'addr': phoneEditingController.text,
    });
    await firebaseFirestore.collection("Users").doc(user.uid).set({
      'uid': user.uid,
      'name': nameEditingController.text,
      'phone': phoneEditingController.text,
      'email': userModel.email,
      'type': typeEditingController,
      'coupons': userModel.type == 'Consumer' ? [] : null,
      'addr': addrEditingController.text,
      'wallet': 0.0
    });

    Fluttertoast.showToast(msg: "Account created successfully :) ");
    await _helperFunctions.setNamePref(userModel.name);
    await _helperFunctions.setEmailPref(userModel.email);
    await _helperFunctions.setUserIdPref(userModel.uid);
    await _helperFunctions.setAddrPref(userModel.addr);
    await _helperFunctions.setPhonePref(userModel.phone);
    await _helperFunctions.setType(typeEditingController);
    if (userModel.type == 'Consumer') {
      await _helperFunctions.setCoupons(userModel.coupons!);
      await _helperFunctions.setEsvAir(userModel.esv_air);
      await _helperFunctions.setEsvCo2(userModel.esv_co2);
      await _helperFunctions.setEsvTree(userModel.esv_tree);
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      User? user = FirebaseAuth.instance.currentUser;
      UserModel loggedInUser = UserModel();
      FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());

        if (loggedInUser.toMap()['type'] == 'Consumer') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ConsumerNavbar()));
        } else if (loggedInUser.toMap()['type'] == 'Manufacturer') {
          _helperFunctions.setType('Manufacturer');
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ManufacturerNavbar()));
        } else if (loggedInUser.toMap()['type'] == 'NGO') {
          _helperFunctions.setType('NGO');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NgoNavbar()));
        }
        return SpinKitChasingDots(
          color: Colors.blue,
          size: 50.0,
        );
      });

      return SpinKitChasingDots(
        color: Colors.blue,
        size: 50.0,
      );
    }));
  }
}
