import 'dart:async';
import 'dart:collection';

import 'package:business_card/auth/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() async {
    await createUserDatabase();
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => MainPage(
                  userSocialMedia: userSocialMedia,
                )));
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userSocialMedia;

  Future<void> createUserDatabase() async {
    final firestoreDatabase = FirebaseFirestore.instance.collection("users");
    //print(user?.uid);
    if (user != null) {
      final data = await firestoreDatabase.doc(user!.uid).get();
      print(data.data() as Map<dynamic, dynamic>);
      final socialMedia = data.data()!["social_media"] as Map<dynamic, dynamic>;
      print('Not error 1 ');
      if (socialMedia.isNotEmpty) {
        print('Not error 2 ');
        userSocialMedia = Map<String, dynamic>.from(socialMedia);
      }
    }
  }

  ListResult? socialMediaList;
  List allSocialMediaNames = [];
  List userSocialMediaKeys = [];
  List userSocialMediaIconsUrl = [];
  final List<String> userSocialMediaAssets = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset('assets/images/splash.png').image)),
    );
  }
}

/*
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read;
      allow write;
    }
  }
}
 */
