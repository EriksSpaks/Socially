// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:business_card/language_constants.dart';
import 'package:business_card/styles/size.dart';
import 'package:business_card/pages/additional_pages/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.isSavedUsers});

  final bool isSavedUsers;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final TextEditingController _textController = TextEditingController();
  late final bool isSavedUsers = widget.isSavedUsers;
  List savedUsers = [];
  bool isKeyboardOpen = false;

  Future<void> _getSavedUsers() async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = query.data() as Map<String, dynamic>;
    if (data['savedUsers'] != null) {
      savedUsers = data['savedUsers'] as List;
    }
  }

  late StreamSubscription<bool> keyboardSubscription;
  @override
  void initState() {
    super.initState();
    if (isSavedUsers) {
      _getSavedUsers().whenComplete(() => setState(
            () {},
          ));
    }
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardOpen = visible;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }

  Route<Object> _goToProfilePage(UserInfo userInfo) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfilePage(userInfo: userInfo),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colouring.colorDarkBlue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.07),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.1)),
              child: Text(
                isSavedUsers
                    ? translatedText(context).search_screen_saved_users
                    : translatedText(context).search_screen_find_profile,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colouring.colorAlmostWhite,
                    fontSize: 26),
              ),
            ),
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.02),
            ),
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.055),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.05)),
                child: TextField(
                  controller: _textController,
                  onChanged: (_) => setState(() {}),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.search),
                      suffixIconColor: Colouring.colorLightGrey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                      hintText:
                          translatedText(context).search_screen_hintText_name,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.01),
                          horizontal: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.05)),
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colouring.colorLightGrey,
                      ),
                      isDense: true),
                ),
              ),
            ),
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.05),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    top: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.03),
                    bottom: isKeyboardOpen
                        ? 0
                        : RelativeSize(context: context)
                            .getScreenHeightPercentage(0.12)),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Colouring.colorBlueGradient3,
                      Colouring.colorBlueGradient2
                    ], stops: [
                      0.0,
                      1.0
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)),
                        topRight: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)))),
                width: double.infinity,
                child: FirestorePagination(
                  isLive: true,
                  query: FirebaseFirestore.instance
                      .collection("users")
                      .orderBy("display_name")
                      .where("display_name",
                          isNotEqualTo:
                              FirebaseAuth.instance.currentUser!.displayName),
                  itemBuilder: (context, documentSnapshot, index) {
                    final data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    if (isSavedUsers) {
                      if (!savedUsers.contains(documentSnapshot.id)) {
                        return const SizedBox(
                          height: 0,
                          width: 0,
                        );
                      }
                    } else {
                      if (_textController.text.isEmpty) {
                        return const SizedBox();
                      }
                    }
                    final user = UserInfo(data["display_name"],
                        documentSnapshot.id, data["photoURL"]);
                    if (user.displayName
                        .toLowerCase()
                        .contains(_textController.text.toLowerCase())) {
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.of(context)
                              .push(_goToProfilePage(user))
                              .then((_) {
                            _getSavedUsers().whenComplete(() => setState(
                                  () {},
                                ));
                          });
                        },
                        child: ListTile(
                          title: Text(
                            user.displayName,
                            style: const TextStyle(
                                color: Colouring.colorAlmostWhite),
                          ),
                          leading: user.photoURL == "-1"
                              ? SvgPicture.asset(
                                  'assets/images/icon_profile.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colouring.colorAlmostWhite,
                                      BlendMode.srcIn),
                                  width: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.125),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(user.photoURL),
                                  radius: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.0625),
                                ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.01),
                              horizontal: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.1)),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserInfo {
  UserInfo(this.displayName, this.uid, this.photoURL);
  late final String displayName;
  late final String uid;
  late final String photoURL;
}
