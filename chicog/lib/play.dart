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
    );
  }
}
