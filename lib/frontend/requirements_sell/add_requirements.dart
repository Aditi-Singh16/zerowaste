// ignore_for_file: deprecated_member_use, prefer_const_constructors, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class AddRequirement extends StatefulWidget {
  const AddRequirement({Key? key}) : super(key: key);

  @override
  State<AddRequirement> createState() => _AddRequirementState();
}

class _AddRequirementState extends State<AddRequirement> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  var _name = "";
  var _quantity = "";
  var _category = "Books";
  var _description = "";

  void buttonValidate() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('Requirement Added successfully!')));
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = "";
    _quantityController.text = "";
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _quantityFocus.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool color = false;

  @override
  Widget build(BuildContext context) {
    const _defaultColor = Colors.grey;
    const _focusColor = Colors.black;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      CupertinoIcons.person_fill,
                      size: 30,
                      color: _nameFocus.hasFocus ? _focusColor : _defaultColor,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Product Name',
                    labelStyle: TextStyle(
                      color: _nameFocus.hasFocus ? _focusColor : _defaultColor,
                    ),
                  ),
                  onChanged: (value) {
                    _name = value;
                    setState(() {
                      color = true;
                    });
                  },
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).requestFocus(_nameFocus);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Product Name';
                    }
                    if (!(value.length > 5)) {
                      return "Enter valid name of more than 5 characters!";
                    }
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  controller: _quantityController,
                  focusNode: _quantityFocus,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      CupertinoIcons.mail_solid,
                      size: 20,
                      color:
                          _quantityFocus.hasFocus ? _focusColor : _defaultColor,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Required Quantity',
                    labelStyle: TextStyle(
                      color:
                          _quantityFocus.hasFocus ? _focusColor : _defaultColor,
                    ),
                  ),
                  onChanged: (value) {
                    _quantity = value;
                    setState(() {
                      color = true;
                    });
                  },
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).requestFocus(_quantityFocus);
                    });
                  },
                  validator: (value) {
                    String patttern = r'^[0-9]+$';
                    RegExp regExp = RegExp(patttern);
                    if (value!.isEmpty) {
                      return 'Please enter quantity available';
                    }
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter valid quantity';
                    }
                    if (int.parse(value) < 0) {
                      return 'Quantity cannot be less than 0';
                    }
                    return null;
                  }),
              SizedBox(height: 20),
              TextFormField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      CupertinoIcons.doc_text,
                      size: 20,
                      color: _descriptionFocus.hasFocus
                          ? _focusColor
                          : _defaultColor,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelText: 'Description of Product',
                    labelStyle: TextStyle(
                      color: _descriptionFocus.hasFocus
                          ? _focusColor
                          : _defaultColor,
                    ),
                  ),
                  onChanged: (value) {
                    _description = value;
                    setState(() {
                      color = true;
                    });
                  },
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).requestFocus(_descriptionFocus);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please add the description of product';
                    }
                    return null;
                  }),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(
                        child: const CupertinoActivityIndicator(),
                      );
                    var length = snapshot.data!.docs.length;
                    DocumentSnapshot ds = snapshot.data!.docs[length - 1];

                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400)),
                      padding: EdgeInsets.only(bottom: 10.0, top: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        CupertinoIcons.square_grid_2x2_fill,
                                        color: _category != null
                                            ? _focusColor
                                            : _defaultColor,
                                      ),
                                    ),
                                    Text(
                                      "Category",
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                            flex: 2,
                            child: DropdownButton(
                              value: _category,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  _category = newValue.toString();
                                });
                              },
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem<String>(
                                    value: document['name'],
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      height: 100.0,
                                      child: Text(
                                        document['name'].toString().trim(),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ));
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: color ? Color(0xff001427) : Color(0xff808080),
                      ),
                      child: Text('Add Requirement',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: () async {
                        color ? buttonValidate() : null;
                        FirebaseData().addRequirement({
                          "uid": await HelperFunctions().readUserIdPref(),
                          "name": await HelperFunctions().readNamePref(),
                          "email": await HelperFunctions().readEmailPref(),
                          "category": _category,
                          "quantity": _quantity,
                          "product_name": _name,
                          "type": await HelperFunctions().readTypePref(),
                          "is_satisfied": false,
                          "description": _description
                        });
                        _nameController.clear();
                        _quantityController.clear();
                      }))
            ])),
      ),
    );
  }
}
