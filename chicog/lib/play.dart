import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chicoguesser/profile.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
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
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Guess',
                    ),
                  )
                ),
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
