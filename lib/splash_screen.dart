import 'dart:async';
import 'dart:collection';

import 'package:business_card/auth/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    final ref = FirebaseDatabase.instance.ref("users");

    final event = await ref.get();
    if (user != null) {
      if (event.exists) {
        final ev = await ref.child('${user!.uid}/social_media').get();
        if (ev.value != "" && ev.exists) {
          userSocialMedia =
              Map<String, dynamic>.from(ev.value as Map<dynamic, dynamic>);
        } else {
          await ref.update({user!.uid: "social_media"});
        }
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
