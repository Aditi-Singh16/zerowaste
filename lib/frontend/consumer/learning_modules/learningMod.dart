import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePager extends StatefulWidget {
  const MyHomePager({Key? key, required this.type}) : super(key: key);
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff001427),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("For D.I.Y Enthusiasts"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('urls').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            height: MediaQuery.of(context).size.height * .02),
                        YoutubePlayer(
                          controller: _controller,
                          liveUIColor: Colors.amber,
                        ),
                        Text(_controller.metadata.title),
                      ],
                    ));
                  });
            }));
  }
}
