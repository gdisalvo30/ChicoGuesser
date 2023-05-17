import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chicoguesser/profile.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int points = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ProfileScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.person_sharp,
                    size: 26.0,
                  )),
            )
          ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                    flex: 0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Guess',
                      ),
                    )),
                Expanded(
                  flex: 10,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('photos')
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  Random random;
                                  random = Random();
                                  index = random
                                      .nextInt(snapshot.data!.docs.length);
                                  return photoWidget(snapshot, index);
                                },
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                BottomAppBar(
                  child: Text(
                    "Score: $points",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ]),
        ));
  }
}

List<Widget> curImage() {
  return <Widget>[
    StreamBuilder(
      stream: FirebaseFirestore.instance.collection('photos').snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    Random random;
                    random = Random();
                    index = random.nextInt(snapshot.data!.docs.length);
                    return photoWidget(snapshot, index);
                  },
                ),
              );
            }
        }
      },
    )
  ];
}

Widget photoWidget(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
  try {
    return Column(
      children: [
        Image.network(snapshot.data!.docs[index]['downloadURL']),
      ],
    );
  } catch (e) {
    return Text('Error: $e');
  }
}
