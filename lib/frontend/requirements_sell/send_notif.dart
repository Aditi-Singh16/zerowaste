import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';
import 'package:zerowaste/prefs/sharedPrefs.dart';

class SendNotification extends StatefulWidget {
  SendNotification({
    Key? key,
    this.user,
  }) : super(key: key);

  dynamic user;

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Details'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  print(widget.user.id);
                  await FirebaseFirestore.instance
                      .collection("requirements")
                      .doc(widget.user.id)
                      .set({
                    "requirement_satisfy": FieldValue.arrayUnion([
                      {
                        'email': await HelperFunctions().readEmailPref(),
                        'quantity': widget.user.data()['quantity'].toString(),
                        'uid': await HelperFunctions().readUserIdPref(),
                        'product_name': widget.user.data()['product_name']
                      }
                    ])
                  }, SetOptions(merge: true)).then((_) {
                    print("success!");
                  });

                  final Email email = Email(
                    body:
                        'Hi ${widget.user.data()['name']} I have the whole quantity of the product you require!',
                    subject: 'Request Fulfilment',
                    recipients: [widget.user.data()['email']],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email).then((val) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Emaile sent successfully!'),
                      duration: const Duration(seconds: 5),
                    ));
                  });
                },
                child: Text('I have the whole quantity')),
            Text('OR Enter custom quantity'),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                labelText: 'Quantity',
                labelStyle: TextStyle(color: Colors.blueGrey),
              ),
              onChanged: (value) {},
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Connect!'),
          onPressed: () async {
            if (_quantityController.text != '') {
              await FirebaseFirestore.instance
                  .collection("requirements")
                  .doc(widget.user.id)
                  .set({
                "requirement_satisfy": FieldValue.arrayUnion([
                  {
                    'email': await HelperFunctions()
                        .readEmailPref(), //loggedin widget.user.data() ka email after shared pref
                    'quantity': int.parse(_quantityController.text),
                    'uid': await HelperFunctions().readUserIdPref(),
                    'product_name': widget.user.data()['product_name']
                  }
                ])
              }, SetOptions(merge: true)).then((_) {
                print("success!");
              });

              final Email email = Email(
                body:
                    'Hi ${widget.user.data()['name']} I have ${_quantityController.text} of the product you require!',
                subject: 'Request Fulfilment',
                recipients: [widget.user.data()['email']],
                isHTML: false,
              );

              await FlutterEmailSender.send(email).then((val) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Email sent successfully!'),
                  duration: const Duration(seconds: 5),
                ));
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
