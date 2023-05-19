import 'dart:math';

import 'package:chicoguesser/home.dart';
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
  DocumentSnapshot? currentImage;
  TextEditingController guessController = TextEditingController();
  double multiplier = 1.0;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  void fetchImage() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('photos').get();
    final List<DocumentSnapshot> allImages = snapshot.docs;
    final int totalImages = allImages.length;

    final random = Random();
    final int randomIndex = random.nextInt(totalImages);
    final DocumentSnapshot randomImage = allImages[randomIndex];

    setState(() {
      currentImage = randomImage;
    });
  }

  void checkAnswer(String guess, String correctAnswer) {
    if (guess.toLowerCase() == correctAnswer.toLowerCase()) {
      setState(() {
        score += (100 * multiplier).toInt();
        multiplier += 0.5;
      });
    } else {
      setState(() {
        multiplier = 1.0;
      });
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

    if (currentIndex >= 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Final Score: $score'),
                _buildHighScoreMessage(),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _updateUserScore();
                },
              ),
            ],
          );
        },
      );
    } else {
      fetchImage();
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
        if (mounted) {
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const HomeScreen()),
                      );
                      _updateUserScore();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()),
          );
        }
      }
    }
  }

  Widget _buildHighScoreMessage() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SizedBox();
    }

    final userScore = score;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    return FutureBuilder<DocumentSnapshot>(
      future: userDoc.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final int currentHighScore = snapshot.data?['score'] ?? 0;
          if (userScore > currentHighScore) {
            return const Text('New High Score!');
          }
        }
        return const SizedBox();
      },
    );
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
        centerTitle: true, // Center the title
        title: const Text(
          'Play',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            currentImage != null
                ? photoWidget(
                    context,
                    currentImage!,
                    guessController,
                    checkAnswer,
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(
              "Score: $score",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget photoWidget(
  BuildContext context,
  DocumentSnapshot image,
  TextEditingController guessController,
  void Function(String, String) checkAnswer,
) {
  final String correctAnswer = image['name'];

  return Center(
    child: Card(
      elevation: 20.0,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Make a Guess'),
                content: TextField(
                  controller: guessController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Guess',
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      checkAnswer(guessController.text, correctAnswer);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Column(
          children: [
            Image.network(image['downloadURL']),
          ],
        ),
      ),
    ),
  );
}