import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chicoguesser/profile.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late List<String> _imageUrls= [];
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _getImageUrls();
  }

  void _getImageUrls() async {
    ListResult result = await storage.ref().listAll();
    List<String> urls = [];
    for (Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      urls.add(url);
    }
    setState(() {
      _imageUrls = urls;
    });
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
      body: _imageUrls.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Image.network(
                        _imageUrls[index],
                        width: 300,
                        height: 300,
                      ),
                      const SizedBox(height: 10),
                      Text(_imageUrls[index]),
                    ],
                  ),
                );
              },
            ),
    );
  }
}