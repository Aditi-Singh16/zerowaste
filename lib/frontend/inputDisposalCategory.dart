import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/wasteDisposal.dart';

class InputCategory extends StatefulWidget {
  InputCategory({Key? key}) : super(key: key);

  @override
  State<InputCategory> createState() => _InputCategoryState();
}

class _InputCategoryState extends State<InputCategory> {
  var _category = null;
  Widget input() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('disposalCategories')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: const CupertinoActivityIndicator(),
            );
          var length = snapshot.data!.docs.length;
          DocumentSnapshot ds = snapshot.data!.docs[length - 1];

          return Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
            padding: EdgeInsets.only(bottom: 10.0, top: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Container(
                    padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                    child: new Text(
                      " Category of disposal unit",
                    ),
                  ),
                ),
                Expanded(
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
                    items: snapshot.data!.docs.map((DocumentSnapshot document) {
                      return new DropdownMenuItem<String>(
                          value: document['category'],
                          child: new Container(
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(5.0)),
                            height: 100.0,

                            //color: primaryColor,
                            child: new Text(
                              document['category'],
                            ),
                          ));
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 300),
          input(),
          InkWell(
            onTap: () {
              if (_category == null) {
                _category = "All";
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WasteDisposal(category: _category),
                ),
              );
            },
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Text("View Map"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
