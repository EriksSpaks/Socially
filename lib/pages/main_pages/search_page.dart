// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:business_card/styles/size.dart';
import 'package:business_card/pages/additional_pages/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
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
      backgroundColor: Colouring.colorLightLightGrey,
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
              child: const Text(
                "Find a profile",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colouring.colorGrey,
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
                  onChanged: (value) => setState(() {}),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.search),
                      suffixIconColor: Colouring.colorLightGrey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Name",
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
                decoration: BoxDecoration(
                    color: Colouring.colorAlmostWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)),
                        topRight: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)))),
                width: double.infinity,
                child: FirestorePagination(
                  query: FirebaseFirestore.instance
                      .collection("users")
                      .orderBy("display_name")
                      .where("display_name",
                          isNotEqualTo:
                              FirebaseAuth.instance.currentUser!.displayName),
                  itemBuilder: (context, documentSnapshot, index) {
                    final data =
                        documentSnapshot.data() as Map<dynamic, dynamic>;
                    print(data);
                    final user = UserInfo(
                        data["display_name"], data["email"], data["photoURL"]);
                    if (user.displayName
                            .toLowerCase()
                            .contains(_textController.text.toLowerCase()) ||
                        user.email
                            .toLowerCase()
                            .contains(_textController.text.toLowerCase())) {
                      return GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(_goToProfilePage(user)),
                        child: ListTile(
                          title: Text(user.displayName),
                          subtitle: Text(user.email),
                          leading: user.photoURL == "-1"
                              ? SvgPicture.asset(
                                  'assets/images/icon_profile.svg',
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
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
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
  UserInfo(this.displayName, this.email, this.photoURL);
  late final String displayName;
  late final String email;
  late final String photoURL;
}
