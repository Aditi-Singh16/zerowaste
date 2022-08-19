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
        appBar: AppBar(title: Text("Add Requirements")),
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
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  var _name = "";
  var _quantity = "";
  var _category = "Books";
  var _description = "";

  // List of items in our dropdown menu
  var items = [
    'Books',
    'Cloths',
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
    _descriptionController.text = "";
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
                  labelText: 'Quantity Required',
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
                    return 'Please enter quantity required';
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
            // DropdownButton(
            //   value: _category,
            //   icon: const Icon(Icons.keyboard_arrow_down),
            //   items: items.map((String items) {
            //     return DropdownMenuItem(
            //       value: items,
            //       child: Text(items),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       _category = newValue!;
            //     });
            //   },
            // ),
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
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 2,
                            child: new Container(
                              padding:
                                  EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      CupertinoIcons.square_grid_2x2_fill,
                                      color: _category != null
                                          ? _focusColor
                                          : _defaultColor,
                                    ),
                                  ),
                                  new Text(
                                    "Category",
                                  ),
                                ],
                              ),
                            )),
                        new Expanded(
                          flex: 2,
                          child: DropdownButton(
                            value: _category,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                _category = newValue.toString();
                                print(_category);
                              });
                            },
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return new DropdownMenuItem<String>(
                                  value: document['name'],
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    height: 100.0,

                                    //color: primaryColor,
                                    child: new Text(
                                      document['name'],
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
                child: RaisedButton(
                    color: (color) ? Colors.black : Colors.grey,
                    child: Text('Add Requirement',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () => {
                          color ? ButtonValidate() : null,
                          FirebaseData().addRequirement({
                            "name": "john",
                            "email": "example@example.com",
                            "category": _category,
                            "quantity": _quantity,
                            "product_name": _name,
                            "description": _description,
                            "type": "NGO",
                            "is_satisfied": false
                          }),
                          _nameController.clear(),
                          _quantityController.clear(),
                          _descriptionController.clear(),
                        }))
          ])),
    );
  }
}
