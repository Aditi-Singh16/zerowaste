// ignore_for_file: deprecated_member_use, prefer_const_constructors, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:zerowaste/backend/firestore_info.dart';

class AddRequirement extends StatefulWidget {
  const AddRequirement({Key? key}) : super(key: key);

  @override
  State<AddRequirement> createState() => _AddRequirementState();
}

class _AddRequirementState extends State<AddRequirement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(padding: const EdgeInsets.all(20), child: PageForm()));
  }
}

class PageForm extends StatefulWidget {
  @override
  _PageFormState createState() => _PageFormState();
}

class _PageFormState extends State<PageForm> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();


  var _name = "";
  var _quantity = "";
  var _category = "Books";
  

  // List of items in our dropdown menu
  var items = [
    'Books',
    'Clothes',
    'Stationary',
    'Hygiene',
    'Toys',
    'Accessories',
    'Bags',
    'Electronics'
  ];



  void ButtonValidate() {
    if (_formKey.currentState!.validate()) {
      // print('${user.name}:${user.phone}:${user.email}');

      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Requirement Added successfully!')));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Problem Adding Requirement :(')));
      setState(() {
        _autovalidate = true;
      });
    }
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
    super.dispose();
    _quantityFocus.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  var _autovalidate = false;
  bool color = false;

  @override
  Widget build(BuildContext context) {
    const _defaultColor = Colors.grey;
    const _focusColor = Colors.black;
    return SingleChildScrollView(
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
                  if (int.parse(value) < 0) {
                    return 'Quantity cannot be less than 0';
                  }
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter valid quantity';
                  }
                  return null;
                }),
            SizedBox(height: 20),
            DropdownButton(
                  value: _category,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
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
                    onPressed: () => {
                          color ? ButtonValidate() : null,
                          FirebaseData().addRequirement(
                            {
                              "name": "john",
                              "email": "example@example.com",
                              "category":_category,
                              "quantity":_quantity,
                              "product_name":_name,
                              "type":"Consumer",
                              "is_satisfied":false
                            }
                          )
                        }))
          ])),
    );
  }
}

