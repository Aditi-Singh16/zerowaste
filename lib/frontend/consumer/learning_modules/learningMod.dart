import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const learningMod());
}

// ignore: camel_case_types
class learningMod extends StatelessWidget {
  const learningMod({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePager(title: 'Flutter Demo Home Page', type: 1),
    );
  }
}

class MyHomePager extends StatefulWidget {
  const MyHomePager({Key? key, required this.title, required this.type})
      : super(key: key);

  final String title;
  final int type;
  @override
  State<MyHomePager> createState() => _MyHomePagerState();
}

var _ids = [
  'nPt8bK2gbaU',
  'gQDByCdjUXw',
  'iLnmTe5Q2Qw',
  '_WoCV4c6XOE',
  'KmzdUe0RSJo',
  '6jZDSSZZxjQ',
  'p2lYr3vM_1w',
  '7QUtEmBT_-w',
  '34_PXCzGw1M',
];

class _MyHomePagerState extends State<MyHomePager> {
  final Stream<QuerySnapshot> urls =
      FirebaseFirestore.instance.collection('urls').snapshots();
  @override
  Widget build(BuildContext context) {
    var url = YoutubePlayer.convertUrlToId(
            "https://www.youtube.com/watch?v=V89BOZhJFlI&t=8s") ??
        '';
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: url,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255)
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            /* body: ListView.builder(
            itemCount: _ids.length,
            itemBuilder: (BuildContext context, int index) {
              YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId: _ids.elementAt(index),
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  mute: true,
                ),
              );
              return ListTile(
                title: YoutubePlayer(
                  controller: _controller,
                  liveUIColor: Colors.amber,
                ),
              );
            },
          )
          */
            body: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('urls').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.requireData;
                  var url = data.docs[widget.type]['links'];
                  return ListView.builder(
                      itemCount: url.length,
                      itemBuilder: (BuildContext context, int index) {
                        YoutubePlayerController _controller =
                            YoutubePlayerController(
                          initialVideoId:
                              YoutubePlayer.convertUrlToId(url[index]) ?? '',
                          flags: YoutubePlayerFlags(
                            autoPlay: false,
                            mute: true,
                          ),
                        );

                        return ListTile(
                            title: Column(
                          children: <Widget>[
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .02),
                            YoutubePlayer(
                              controller: _controller,
                              liveUIColor: Colors.amber,
                            ),
                            Text(_controller.metadata.title),
                          ],
                        ));
                      });
                })));
  }
}
