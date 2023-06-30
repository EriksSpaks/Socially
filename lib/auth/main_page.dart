import 'package:business_card/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.userSocialMedia,
  });
  final dynamic userSocialMedia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return HomePage(userSocialMedia: userSocialMedia);
              if (snapshot.data != null) {
                snapshot.data!.reload();
                return StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      if (user != null && user.displayName != null) {
                        return HomePage(userSocialMedia: userSocialMedia);
                      } else {
                        return LoginPage(userSocialMedia: userSocialMedia);
                      }
                    });
              }
            }
            return LoginPage(userSocialMedia: userSocialMedia);
          }),
    );
  }
}
