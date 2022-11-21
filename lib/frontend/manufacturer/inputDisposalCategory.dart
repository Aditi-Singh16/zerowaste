import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/manufacturer/wasteDisposal.dart';

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
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                        '"Take a step to save the environment and recycle products!"',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.green)),
                  ),
                  // SizedBox(height: 25),

                  Image.network(
                      'https://static.vecteezy.com/system/resources/previews/003/207/736/original/waste-collection-segregation-and-recycling-illustration-garbage-vector.jpg'),
                  const SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400)),
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                          child: const Text(
                              " Select the Category of recycling unit",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        DropdownButton(
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
                                value: document['category'],
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  height: 100.0,

                                  //color: primaryColor,
                                  child: Text(
                                    document['category'],
                                  ),
                                ));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            input(),
            InkWell(
              onTap: () {
                _category ??= "All";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WasteDisposal(category: _category),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                        child: Container(
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("View Map ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  Icon(Icons.map_outlined, color: Colors.white)
                                ],
                              ),
                            ))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
