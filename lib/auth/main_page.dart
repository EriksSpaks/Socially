import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/additional_pages/bob.dart';
import '../pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!(FirebaseAuth.instance.currentUser != null &&
        (FirebaseAuth.instance.currentUser!.displayName != null ||
            FirebaseAuth.instance.currentUser!.displayName != ""))) {
      FirebaseAuth.instance.signOut();
      return const Scaffold(
        body: BOB(),
      );
    }
    return const Scaffold(body: HomePage());
  }
}
