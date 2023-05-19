import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: Text(
          'Global Leaderboard',
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
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final leaderboardData = snapshot.data!.docs;
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              for (int i = 0; i < leaderboardData.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0,
                  ),
                  child: _buildLeaderboardCard(
                    leaderboardData[i],
                    i + 1,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardCard(DocumentSnapshot document, int position) {
    final data = document.data() as Map<String, dynamic>;
    final name = data['id'];
    final score = data['score'];

    Color? cardColor;
    switch (position) {
      case 1:
        cardColor = Colors.amber;
        break;
      case 2:
        cardColor = Colors.grey[400];
        break;
      case 3:
        cardColor = Colors.brown[300];
        break;
      default:
        cardColor = null; 
        break;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        color: cardColor,
        child: ListTile(
          title: Text(name),
          trailing: Text(score.toString()),
        ),
      ),
    );
  }
}