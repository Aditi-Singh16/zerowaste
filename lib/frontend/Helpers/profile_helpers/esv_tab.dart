import 'package:flutter/material.dart';
import 'package:zerowaste/frontend/Helpers/style.dart';

class ESVTab extends StatefulWidget {
  Color textColor;
  double air;
  double co2;
  double tree;
  ESVTab(
      {required this.air,
      required this.co2,
      required this.tree,
      required this.textColor,
      Key? key})
      : super(key: key);
  @override
  State<ESVTab> createState() => _ESVTabState();
}

class _ESVTabState extends State<ESVTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ESV (Environment Saving Values)  ',
              style: AppStyle.text.copyWith(
                  color: widget.textColor,
                  fontSize: MediaQuery.of(context).size.width * 0.033),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),

            // i icon button with alert dialogue
            IconButton(
              icon: const Icon(Icons.info_outline),
              color: widget.textColor,
              iconSize: MediaQuery.of(context).size.width * 0.05,
              alignment: Alignment.bottomRight,
              onPressed: () {
                //alert dialogue box pop up
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Center(
                        child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: widget.textColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.033),
                          children: [
                            TextSpan(
                                text: "Approximate values per product\n\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02)),
                            TextSpan(
                                text:
                                    "Air Pollution - numbers here shows the amount of air saved from making the product\n"
                                    "Trees Saved - numbers here shows the amount of trees saved from cutting in making this product\n"
                                    "CO2 - numbers here show the amount of CO2 saved while making this product",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015)),
                          ]),
                    )),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: widget.textColor,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(MediaQuery.of(context).size.width *
                        0.1), // Image radius
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2F11zon_cropped.png?alt=media&token=72d9009f-c528-4fd5-a638-e933dffee8f9',
                        fit: BoxFit.cover),
                  ),
                ),
                Text("Air Pollution",
                    style: TextStyle(color: widget.textColor)),
                Text(
                  (widget.air.toString()).substring(0, 3) + "aqi of Air",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.030,
                      color: widget.textColor),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(MediaQuery.of(context).size.width *
                        0.1), // Image radius
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2FPicsart_22-08-19_12-36-20-414.png?alt=media&token=cc0c00fb-a68a-4b69-84cd-2e60fd910215',
                        fit: BoxFit.cover),
                  ),
                ),
                Text("Tree", style: TextStyle(color: widget.textColor)),
                Text((widget.tree.toString()).substring(0, 3) + "Tree saved",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.030,
                        color: widget.textColor))
              ],
            ),
            const Spacer(),
            Column(
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(MediaQuery.of(context).size.width *
                        0.1), // Image radius
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/esv%20img%2FPicsart_22-08-19_12-43-19-549.png?alt=media&token=b05f3d35-67ee-451e-8737-08e14c13c5d5',
                        fit: BoxFit.cover),
                  ),
                ),
                Text("Co2", style: TextStyle(color: widget.textColor)),
                Text((widget.co2.toString()).substring(0, 3) + " ppm of Co2",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.030,
                        color: widget.textColor))
              ],
            ),
          ],
        )
      ],
    );
  }
}
