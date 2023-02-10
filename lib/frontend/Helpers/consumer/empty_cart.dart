import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 100, bottom: 20),
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.height / 7, // Image radius
            backgroundImage: const NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/zerowaste-6af31.appspot.com/o/categories%2Fcart.gif?alt=media&token=6ef4fdc0-b651-49a6-8f23-e09a67b86d54'),
          ),
        ),
        const Center(
          child: Text(
            "Your ZeroWaste cart is empty!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () {},
            child: InkWell(
                onTap: () {
                  // go back page
                  Navigator.pop(context);
                },
                child: const Text('Continue Shopping...')),
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // background
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
            ),
          ),
        )
      ],
    );
  }
}
