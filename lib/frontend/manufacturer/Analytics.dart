import 'package:flutter/material.dart';
import 'package:zerowaste/backend/firestore_info.dart';
import 'package:zerowaste/frontend/consumer/color.dart';

class ManuFacture extends StatefulWidget {
  final BuildContext context;
  final String prodctId;
  const ManuFacture({
    Key? key,
    required this.context,
    required this.prodctId,
  }) : super(key: key);

  @override
  State<ManuFacture> createState() => _ManuFactureState();
}

class _ManuFactureState extends State<ManuFacture> {
  num? returns;
  num? sold;
  List<int> gridData = [];
  List<String> gridLabel = [
    "Total Sales",
    "Total Returns",
  ];
  getDetails() async {
    var val1 = await FirebaseData().getProductReturnCount();
    var val2 = await FirebaseData().getProductSoldCount();
    gridData.add(val2);
    gridData.add(val1);
    setState(() {});
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Product Analytics'),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: (1 / .8),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(2, (index) {
                return Card(
                  //elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: AppColor.popupGridColor[index])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          gridData[index].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          gridLabel[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              })),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
