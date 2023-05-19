import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chicoguesser/profile.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final mycontrol = TextEditingController();
  int points = 0;
  String imagename = '';

  void validateguess() {
    String guess = mycontrol.text.toLowerCase();
    String imagecorrect = imagename.toLowerCase();
    StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error retrieving user data');
          }
          if (guess == imagecorrect) {
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
            userData['score']+=100;
          }
          return const Text('');
        });
    
  }

  @override
  void dispose() {
    mycontrol.dispose();
    super.dispose();
  }

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
                Expanded(
                  flex: 0,
                  child: TextFormField(
                    controller: mycontrol,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.accessible_outlined),
                      hintText: 'What do you see?',
                      labelText: 'Guess',
                    ),
                    validator: (String? value) {
                      return (value == null) ? 'no blank allowed' : null;
                    },
                  ),
                ),
                FloatingActionButton(onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                      content: Text('${mycontrol.text} $imagename'),
                      );
                    },
                  );
                }),
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
                                  imagename =
                                      (snapshot.data!.docs[index]['name']);
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
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Error retrieving user data');
                          }
                          Map<String, dynamic> userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          points = userData['score'];
                          return Text(
                            '$points',
                            style: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }))
              ]),
        ));
  }
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
