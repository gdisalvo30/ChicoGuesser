import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chicoguesser/profile.dart';
import 'package:location/location.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late File _image;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _takePhotoAndUpload() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      _promptForNameAndUpload();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _promptForNameAndUpload() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter the name of the location'),
          content: SingleChildScrollView(
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadImageToFirestore();
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImageToFirestore() async {
    if (_image == null) {
      print('No image selected.');
      return;
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = _nameController.text.trim();
    Reference ref = storage.ref().child("photos/$fileName.jpg");
    UploadTask uploadTask = ref.putFile(_image);

    await uploadTask.whenComplete(() async {
      String downloadURL = await ref.getDownloadURL();

      // Get current location
      Location location = Location();
      LocationData? currentLocation;
      try {
        currentLocation = await location.getLocation();
      } catch (e) {
        print('Error getting current location: $e');
      }

      if (currentLocation != null) {
        double latitude = currentLocation.latitude!;
        double longitude = currentLocation.longitude!;

        FirebaseFirestore.instance.collection('photos').add({
          'downloadURL': downloadURL,
          'name': fileName,
          'latitude': latitude,
          'longitude': longitude,
        });
      } else {
        print('Unable to get current location.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _image = File('');
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
    body: Container(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[// Adjust the height as needed
            Center(
              child: _image == null || _image.path == ''
                  ? const Text('No image selected.')
                  : Image.file(_image),
            ),
            ElevatedButton(
              onPressed: _takePhotoAndUpload,
              child: const Text('Take a Photo and Upload'),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    ),
  );
}
}
