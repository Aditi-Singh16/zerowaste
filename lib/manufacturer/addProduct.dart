import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {},
          ),
          title: Text("Add Product"),
          backgroundColor: Color(0xff001427),
        ),
        body: Padding(padding: const EdgeInsets.all(20), child: PageForm()));
  }
}

class PageForm extends StatefulWidget {
  @override
  _PageFormState createState() => _PageFormState();
}

class _PageFormState extends State<PageForm> {
  sendData() async {
    if (_formKey.currentState!.validate()) {
      var storageImage = FirebaseStorage.instance.ref().child(image.path);
      var task = storageImage.putFile(image);
      imgUrl = await (await task).ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("products").add({
        'name': _name,
        'Desc': _desc,
        'image': imgUrl,
        'categories': _category,
        'quantity': _quantity,
        'pricePerProduct': _price,
        'timestamp': DateTime.now()
      });
    }
  }

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _quantityController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();

  var _desc = "";
  var _name = "";
  var _quantity = "";
  var _price = "";
  var _category = null;

  var image;
  String imgUrl = '';

  void ButtonValidate() {
    if (_formKey.currentState!.validate()) {
      // print('${user.name}:${user.phone}:${user.email}');

      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product Added successfully!')));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Problem Adding the product :(')));
      setState(() {
        _autovalidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _descController.text = "";
    _nameController.text = "";
    _quantityController.text = "";
    _priceController.text = "";
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    super.dispose();
    _descFocus.dispose();
    super.dispose();
    _quantityFocus.dispose();
    super.dispose();
    _priceFocus.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  var _autovalidate = false;
  bool color = false;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    var img = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    const _defaultColor = Colors.grey;
    const _focusColor = Colors.black;
    return SingleChildScrollView(
      child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Column(children: <Widget>[
            InkWell(
                onTap: () => getImage(),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: image != null
                      ? FileImage(image)
                      : NetworkImage(
                              'https://cdni.iconscout.com/illustration/premium/thumb/add-photo-2670583-2215267.png')
                          as ImageProvider,
                )),
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
                controller: _descController,
                focusNode: _descFocus,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.phone_fill,
                    size: 20,
                    color: _descFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Product Description',
                  labelStyle: TextStyle(
                    color: _descFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                ),
                onChanged: (value) {
                  _desc = value;
                  setState(() {
                    color = true;
                  });
                },
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(_descFocus);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Product Description';
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

                  return new Container(
                    padding: EdgeInsets.only(bottom: 16.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 2,
                            child: new Container(
                              padding:
                                  EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                              child: new Text(
                                "Category",
                              ),
                            )),
                        new Expanded(
                          flex: 2,
                          child: DropdownButton(
                            value: _category,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                _category = newValue;
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
                  labelText: 'Available Quantity',
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
                  RegExp regExp = new RegExp(patttern);
                  if (value!.isEmpty) {
                    return 'Please enter quantity available';
                  }
                  if (int.parse(value) < 50) {
                    return 'Quantity cannot be less than 50';
                  }
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter valid quantity';
                  }
                  return null;
                }),
            SizedBox(height: 20),
            TextFormField(
                controller: _priceController,
                focusNode: _priceFocus,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.mail_solid,
                    size: 20,
                    color: _priceFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Price per product',
                  labelStyle: TextStyle(
                    color: _priceFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                ),
                onChanged: (value) {
                  _price = value;
                  setState(() {
                    color = true;
                  });
                },
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(_priceFocus);
                  });
                },
                validator: (value) {
                  String patttern = r'^[0-9]+$';
                  RegExp regExp = new RegExp(patttern);
                  if (value!.isEmpty) {
                    return 'Please enter price per product';
                  }
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter valid price';
                  }
                  return null;
                }),
            SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: (color) ? Colors.black : Colors.grey,
                    child: Text('Add Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () => {
                          color ? ButtonValidate() : null,
                          sendData(),
                        }))
          ])),
    );
  }
}
