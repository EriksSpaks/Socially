// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:business_card/assets/size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../assets/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List bob = [
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "first",
    "second",
    "third",
    "fourth",
    "fifth"
  ];
  List<UserInfo> _userInfo = [];
  List<UserInfo> _displayList = [];
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final TextEditingController _textController = TextEditingController();

  final _scrollController = ScrollController();

  bool isLoading = false;
  String lastItemId = '';

  @override
  void initState() {
    super.initState();

    // retrieveNextPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("bobibobi");
        // retrieveNextPage();
        updateList(_textController.text.toString());
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget getProfilePicture() {
    return FirebaseAuth.instance.currentUser?.photoURL != null
        ? CircleAvatar(
            radius:
                RelativeSize(context: context).getScreenWidthPercentage(0.1),
            backgroundImage: CachedNetworkImageProvider(
                FirebaseAuth.instance.currentUser!.photoURL!),
          )
        : Container();
  }

  int pageSize = 10;
  int currentPage = 0;
  String lastUserKey = '';

// // function to retrieve the next page of data
  // void retrieveNextPage() async {
  //   // calculate the starting index of the next page
  //   final ref = FirebaseDatabase.instance.ref().child("users");
  //   Query query = ref.orderByKey();
  //   // use startAt() and limitToFirst() to retrieve the next page of data
  //   if (lastItemId.isNotEmpty) {
  //     query = query.startAfter(lastItemId);
  //   }

  //   final snapshot = await query.limitToFirst(pageSize).get();

  //   print("${snapshot.exists} bobob"); // Process the data here
  //   if (snapshot.value != null) {
  //     var users = snapshot.value as Map<dynamic, dynamic>;
  //     users.forEach((key, value) {
  //       // do something with each user
  //       print("$key LOOOOOOOOOLL $value");
  //       var usersInfo = value as Map<dynamic, dynamic>;
  //       if (usersInfo["email"].toString() != userEmail) {
  //         _userInfo.add(UserInfo(usersInfo["display_name"], usersInfo["email"],
  //             usersInfo["photoURL"]));
  //         lastItemId = key;
  //       }
  //     });
  //   }
  //   _displayList = List.from(_userInfo);
  // }

  // Future<void> retrieveNextPage() async {
  //   if (isLoading) {
  //     return;
  //   }

  //   isLoading = true;

  //   final ref = FirebaseDatabase.instance.ref();
  //   Query query = ref.child("users").orderByKey();

  //   if (lastItemId.isNotEmpty) {
  //     query = query.startAfter([lastItemId]);
  //   }

  //   query = query.limitToFirst(pageSize);

  //   final snapshot = await query.get();

  //   final users = snapshot.value as Map<dynamic, dynamic>;
  //   if (users != null) {
  //     users.forEach((key, value) {
  //       // do something with each user
  //       print("$key LOOOOOOOOOLL $value");
  //       var usersInfo = value as Map<dynamic, dynamic>;
  //       if (usersInfo["email"].toString() != userEmail) {
  //         _userInfo.add(UserInfo(usersInfo["display_name"], usersInfo["email"],
  //             usersInfo["photoURL"]));
  //       }
  //       lastItemId = key.toString();
  //     });
  //   }

  //   _displayList = List.from(_userInfo);

  //   isLoading = false;
  // }

  void updateList(String value) {
    //function that filters list of users by name
    setState(() {
      _displayList = _userInfo
          .where((element) =>
              element.displayName.toLowerCase().contains(value.toLowerCase()) ||
              element.email.toLowerCase().contains(value.toLowerCase()))
          .toList();
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
              height: 0,
              child: Container(
                child: getProfilePicture(),
              ),
            ),
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
                      suffixIcon: Icon(Icons.search),
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
                      hintStyle: TextStyle(
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
                // child: ListView.builder(
                //   controller: _scrollController,
                //   itemCount: _displayList.length,
                //   itemBuilder: (context, index) => ListTile(
                //     title: Text(_displayList[index].displayName),
                //     subtitle: Text(_displayList[index].email),
                //     leading: _displayList[index].photoURL == "-1"
                //         ? Icon(
                //             Icons.account_circle_outlined,
                //             size: RelativeSize(context: context)
                //                 .getScreenWidthPercentage(0.15),
                //           )
                //         : CircleAvatar(
                //             backgroundImage: CachedNetworkImageProvider(
                //                 _displayList[index].photoURL),
                //             radius: RelativeSize(context: context)
                //                 .getScreenWidthPercentage(0.0625),
                //           ),
                //     contentPadding: EdgeInsets.symmetric(
                //         vertical: RelativeSize(context: context)
                //             .getScreenHeightPercentage(0.01),
                //         horizontal: RelativeSize(context: context)
                //             .getScreenWidthPercentage(0.1)),
                //   ),
                // ),
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
                    final user = UserInfo(
                        data["display_name"], data["email"], data["photoURL"]);
                    if (user.displayName
                            .toLowerCase()
                            .contains(_textController.text.toLowerCase()) ||
                        user.email
                            .toLowerCase()
                            .contains(_textController.text.toLowerCase())) {
                      return ListTile(
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
