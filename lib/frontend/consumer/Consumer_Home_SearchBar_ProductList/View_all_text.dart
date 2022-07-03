import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final String title;
  CategoryList(this.title);
  @override
  Widget build(BuildContext context) {
    var size,height,width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(title,
            style: TextStyle(
              fontSize: height/45,
              fontWeight: FontWeight.bold,
              color: Colors.black,

            )),
            Container(
              child: title== 'Category' ? Container(
              ):Row(
                children: [
                  Text('View All',
                    style: TextStyle(
                        color: Color(0xFF001427),
                        fontWeight: FontWeight.bold,
                        fontSize:height/52
                    ),),
                  SizedBox(
                    width: height/45,
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF001427),
                    ),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white,
                        size:height/55),
                  )
                ],
              ),
            ),
        ]
    ),
    );

  }
}