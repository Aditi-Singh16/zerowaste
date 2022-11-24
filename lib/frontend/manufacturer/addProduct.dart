import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:zerowaste/backend/userModal/user.dart';
import 'package:zerowaste/frontend/manufacturer/dashboard.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(padding: const EdgeInsets.all(20), child: PageForm()));
  }
}

class PageForm extends StatefulWidget {
  @override
  _PageFormState createState() => _PageFormState();
}

class _PageFormState extends State<PageForm> {
  sendData() async {
    if (_formKey.currentState!.validate() && image != null) {
      var storageImage = FirebaseStorage.instance.ref().child(image.path);
      var task = storageImage.putFile(image);
      imgUrl = await (await task).ref.getDownloadURL();
      String docId = FirebaseFirestore.instance.collection('products').doc().id;
      User? user = FirebaseAuth.instance.currentUser;
      UserModel loggedInUser = UserModel();
      FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        FirebaseFirestore.instance.collection("products").doc(docId).set({
          'name': _name,
          'Desc': _desc,
          'image': imgUrl,
          'categories': _category,
          'quantity': int.parse(_quantity),
          'pricePerProduct': _price,
          'manufacturerId': loggedInUser.uid,
          'timestamp': DateTime.now(),
          'productId': docId,
          'is_plant': true,
          'is_resell': false,
          'weight': double.parse(_weight),
        });
      });
    }
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _weightFocus = FocusNode();

  var _desc = "";
  var _name = "";
  var _quantity = "";
  var _price = "";
  var _weight = "";
  var _category;

  var manufacturerId = '';

  var image;
  String imgUrl = '';

  void buttonValidate() {
    if (_formKey.currentState!.validate() && image != null) {
      sendData();

      Scaffold.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product Added successfully!')));
      setState(() {
        _nameController.clear();
        _descController.clear();
        _quantityController.clear();
        _priceController.clear();
        _weightController.clear();
        image = null;
        imgUrl = '';
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      Scaffold.of(context).showSnackBar(const SnackBar(
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
    _weightController.text = "";
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
    _weightFocus.dispose();
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
                  radius: 70,
                  backgroundImage: image != null
                      ? FileImage(image)
                      : const NetworkImage(
                              'https://cdn5.vectorstock.com/i/thumb-large/68/34/add-photo-icon-on-white-vector-34216834.jpg')
                          as ImageProvider,
                )),
            const Center(child: Text("Add product photo")),
            const SizedBox(height: 20),
            TextFormField(
                focusNode: _nameFocus,
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.bag_fill,
                    size: 24,
                    color: _nameFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                  border: const OutlineInputBorder(),
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
            const SizedBox(height: 20),
            TextFormField(
                controller: _descController,
                focusNode: _descFocus,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.text_bubble_fill,
                    size: 24,
                    color: _descFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                  border: const OutlineInputBorder(),
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
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400)),
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 10.0, 10.0, 10.0),
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
                                  const Text(
                                    "Category",
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          flex: 3,
                          child: DropdownButton(
                            value: _category,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                _category = newValue;
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

                                    //color: primaryColor,
                                    child: Text(
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
            const SizedBox(height: 20),
            TextFormField(
                controller: _weightController,
                focusNode: _weightFocus,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.line_horizontal_3_decrease_circle_fill,
                    size: 20,
                    color: _weightFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Weight per unit in Kg',
                  labelStyle: TextStyle(
                    color: _weightFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                ),
                onChanged: (value) {
                  _weight = value;
                  setState(() {
                    color = true;
                  });
                },
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(_weightFocus);
                  });
                },
                validator: (value) {
                  String patttern = r'^[+-]?((\d+(\.\d*)?)|(\.\d+))$';
                  RegExp regExp = RegExp(patttern);
                  if (value!.isEmpty) {
                    return 'Please enter weight of the product';
                  }
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter valid weight';
                  }

                  return null;
                }),
            const SizedBox(height: 20),
            TextFormField(
                controller: _quantityController,
                focusNode: _quantityFocus,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.add,
                    size: 20,
                    color:
                        _quantityFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                  border: const OutlineInputBorder(),
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
                  RegExp regExp = RegExp(patttern);
                  if (value!.isEmpty) {
                    return 'Please enter quantity available';
                  }
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter valid quantity';
                  }
                  if (int.parse(value) < 50) {
                    return 'Quantity cannot be less than 50';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            TextFormField(
                controller: _priceController,
                focusNode: _priceFocus,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.creditcard_fill,
                    size: 20,
                    color: _priceFocus.hasFocus ? _focusColor : _defaultColor,
                  ),
                  border: const OutlineInputBorder(),
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
                  RegExp regExp = RegExp(patttern);
                  if (value!.isEmpty) {
                    return 'Please enter price per product';
                  }
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter valid price';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: (color) ? Colors.black : Colors.grey,
                    child: const Text('Add Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () => {
                          color ? buttonValidate() : null,
                        }))
          ])),
    );
  }
}
