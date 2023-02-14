import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/frontend/Helpers/loaders/loading.dart';
import 'package:zerowaste/frontend/consumer/consumerNavbar.dart';
import 'package:zerowaste/frontend/login/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zerowaste/frontend/manufacturer/manufacturerNavbar.dart';
import 'package:zerowaste/frontend/ngo/ngoNavbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  HelperFunctions _helperFunctions = HelperFunctions();
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
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
          emailController.text = value!;
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

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff00277d),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/images/logo.png",
                            height: MediaQuery.of(context).size.height * 0.2),
                        SizedBox(
                          height: 20,
                        ),
                        emailField,
                        SizedBox(
                          height: 20,
                        ),
                        passwordField,
                        SizedBox(
                          height: 20,
                        ),
                        loginButton,
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegistrationScreen()));
                                },
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      color: Color(0xff7dbeda),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ])
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    User? user = FirebaseAuth.instance.currentUser;
                    UserModel loggedInUser = UserModel();
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user!.uid)
                        .get()
                        .then((value) {
                      loggedInUser = UserModel.fromMap(value.data());

                      _helperFunctions
                          .setNamePref(loggedInUser.toMap()['name']);
                      _helperFunctions
                          .setEmailPref(loggedInUser.toMap()['email']);
                      _helperFunctions
                          .setUserIdPref(loggedInUser.toMap()['uid']);

                      _helperFunctions
                          .setAddrPref(loggedInUser.toMap()['addr']);
                      _helperFunctions
                          .setPhonePref(loggedInUser.toMap()['phone']);
                      _helperFunctions
                          .setWallet(loggedInUser.toMap()['wallet']);

                      if (loggedInUser.toMap()['type'] == 'Consumer') {
                        _helperFunctions.setType("Consumer");
                        _helperFunctions
                            .setEsvAir(loggedInUser.toMap()['esv_air']);
                        _helperFunctions
                            .setEsvCo2(loggedInUser.toMap()['esv_co2']);
                        _helperFunctions
                            .setEsvTree(loggedInUser.toMap()['esv_tree']);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConsumerNavbar()));
                      } else if (loggedInUser.toMap()['type'] ==
                          'Manufacturer') {
                        _helperFunctions.setCoupons([]);
                        _helperFunctions.setType("Manufacturer");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ManufacturerNavbar()));
                      } else if (loggedInUser.toMap()['type'] == 'NGO') {
                        _helperFunctions.setType("NGO");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NgoNavbar()));
                      }
                    });

                    return Loader();
                  })),
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
      }
    }
  }
}
