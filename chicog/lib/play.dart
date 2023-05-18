import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chicoguesser/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int score = 0;
  int currentIndex = 0;
  List<DocumentSnapshot>? images;
  TextEditingController guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void fetchImages() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('photos').get();
    setState(() {
      images = snapshot.docs;
    });
  }

  void checkAnswer() {
    String guess = guessController.text;
    if (images != null && currentIndex < images!.length) {
      String correctAnswer = images![currentIndex]['name'];
      if (guess.toLowerCase() == correctAnswer.toLowerCase()) {
        setState(() {
          score += 100;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Wrong Answer'),
              content: Text('The correct answer is: $correctAnswer'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      setState(() {
        currentIndex++;
      });
    }

    if (currentIndex >= images!.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over!'),
            content: Text('Final Score: $score'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateUserScore(); // Call the function to update the user's score
                },
              ),
            ],
          );
        },
      );
    }

    guessController.clear();
  }

  void _updateUserScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();
      final int userScore = userSnapshot.data()?['score'] ?? 0;

      if (score > userScore) {
        await userDoc.update({'score': score});
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('New High Score!'),
              content: Text('Your new high score: $score'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    guessController.dispose();
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
                    builder: (BuildContext context) => const ProfileScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.person_sharp,
                size: 26.0,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: TextField(
                controller: guessController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Guess',
                ),
                onEditingComplete: checkAnswer,
              ),
            ),
            Expanded(
              flex: 10,
              child: images != null && currentIndex < images!.length
                  ? photoWidget(images![currentIndex])
                  : const CircularProgressIndicator(),
            ),
            BottomAppBar(
              child: Text(
                "Score: $score",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget photoWidget(DocumentSnapshot image) {
  try {
    return Column(
      children: [
        Image.network(image['downloadURL']),
      ],
    );
  } catch (e) {
    return Text('Error: $e');
  }
}
