import 'package:chicoguesser/profile.dart';
import 'package:flutter/material.dart';
import 'package:chicoguesser/leaderboard.dart';
import 'package:chicoguesser/play.dart';
import 'package:chicoguesser/upload.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Text('ChicoGuesser'),
        centerTitle: true,
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: const AssetImage('assets/main.jpg'),
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5), BlendMode.modulate),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
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
