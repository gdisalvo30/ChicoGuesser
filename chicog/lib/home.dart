import 'package:flutter/material.dart';
import 'package:chicoguesser/leaderboard.dart';
import 'package:chicoguesser/play.dart';
import 'package:chicoguesser/upload.dart';
import 'package:chicoguesser/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: const Text('ChicoGuesser'),
          ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: const AssetImage('images/main.jpg'),
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5), BlendMode.modulate),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 150.0,
              height: 300.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            const Text(
              'ChicoGuesser!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const PlayScreen()),
                );
              },
              child: const Text('Play'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const UploadScreen()),
                );
              },
              child: const Text('Upload'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const LeaderboardScreen()),
                );
              },
              child: const Text('Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}
