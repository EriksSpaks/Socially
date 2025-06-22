// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:business_card/language_constants.dart';
import 'package:business_card/pages/additional_pages/add_social_media.dart';
import 'package:business_card/pages/main_pages/settings_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../styles/colors.dart';
import '../../styles/size.dart';
import '../../styles/urls.dart';

class EditModePage extends StatefulWidget {
  const EditModePage({
    super.key,
    required this.userSocialMedia,
    this.firstConnection = false,
    required this.tabcontroller,
  });

  final dynamic userSocialMedia;
  final bool firstConnection;
  final TabController tabcontroller;

  @override
  State<EditModePage> createState() => _EditModePageState();
}

class _EditModePageState extends State<EditModePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isListenerActive = false;
  late TabController tabController = widget.tabcontroller;
  User? user = FirebaseAuth.instance.currentUser;
  late Map<String, dynamic>? userSocialMedia = widget.userSocialMedia;
  List<String> userSocialMediaAssets = [];
  late bool firstConnection = widget.firstConnection;
  final _scrollController = ScrollController();
  late bool isReorderable;
  late List<Widget> children;
  late double containerHeight =
      RelativeSize(context: context).getScreenHeightPercentage(0.15);
  Color fadingColor = Colors.transparent;
  Color profileTabColor = Colouring.colorDarkBlue.withOpacity(0.85);
  bool isProfileTabOpened = false;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    isReorderable = false;
    setSocialMedia();
    tabController.addListener(() {
      if (isListenerActive && isReorderable) {
        isListenerActive = false;
        startTimer();
      }
      if (tabController.index != 1) {
        // Reactivate listener when switching away from index 1
        isListenerActive = true;
      }
    });
  }

  Timer? timer;

  void startTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer(Duration(seconds: 5), () {
      if (tabController.index != 1) {
        saveChanges();
      }
      isListenerActive = false; // Reset the flag after timer completes
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                      height: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.125) +
                          RelativeSize(context: context)
                              .getScreenHeightPercentage(0.15)),
                  getGrid(),
                  SizedBox(
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.01),
                  )
                ],
              ),
              Visibility(
                visible: isProfileTabOpened,
                child: GestureDetector(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    color: fadingColor,
                    curve: Curves.easeInOut,
                  ),
                  onTap: () {
                    setState(() {
                      isProfileTabOpened = false;
                      isVisible = false;
                      containerHeight = RelativeSize(context: context)
                          .getScreenHeightPercentage(0.15);
                      fadingColor = Colors.transparent;
                      profileTabColor =
                          Colouring.colorDarkBlue.withOpacity(0.85);
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.0625)),
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    if (!isReorderable) {
                      setState(() {
                        isProfileTabOpened = true;
                        containerHeight = RelativeSize(context: context)
                            .getScreenHeightPercentage(0.6);
                        fadingColor = Colors.black.withOpacity(0.25);
                        profileTabColor = Colouring.colorDarkBlue;
                      });
                    }
                  },
                  child: AnimatedContainer(
                    onEnd: () {
                      setState(() {
                        if (isProfileTabOpened) isVisible = true;
                      });
                    },
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOutCirc,
                    height: containerHeight,
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.875),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: profileTabColor,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(
                                  left: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.05),
                                  top: RelativeSize(context: context)
                                      .getScreenHeightPercentage(0.021)),
                              child: getProfilePicture(),
                            ),
                            SizedBox(
                              width: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.05),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(
                                  top: RelativeSize(context: context)
                                      .getScreenHeightPercentage(0.0225)),
                              child: Text(
                                user!.displayName!,
                                style: TextStyle(
                                    color: Colouring.colorAlmostWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.03),
                            ),
                            Spacer(),
                            if (userSocialMedia!.isNotEmpty &&
                                !isReorderable &&
                                !isProfileTabOpened)
                              Container(
                                alignment: Alignment.topRight,
                                child: PopupMenuButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colouring.colorAlmostWhite,
                                    ),
                                    itemBuilder: (context) => [
                                          PopupMenuItem<int>(
                                            value: 0,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.025),
                                            child: Row(
                                              children: [
                                                Text(translatedText(context)
                                                    .profile_screen_edit),
                                                Spacer(),
                                                Icon(Icons.edit)
                                              ],
                                            ),
                                            onTap: () async {
                                              setState(() {
                                                isReorderable = true;
                                              });
                                              isListenerActive = true;
                                            },
                                          ),
                                        ]),
                              )
                          ],
                        ),
                        Visibility(
                          visible: isVisible,
                          child: SizedBox(
                            height: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.03),
                          ),
                        ),
                        Visibility(
                          visible: isVisible,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(_goToSettingsPage())
                                  .then((value) => setState(() {
                                        user =
                                            FirebaseAuth.instance.currentUser!;
                                      }));
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 0, 19, 31)),
                                fixedSize: MaterialStateProperty.all(Size(
                                    double.infinity,
                                    RelativeSize(context: context)
                                        .getScreenHeightPercentage(0.06))),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.zero, // No rounded borders
                                    // Border color with opacity
                                  ),
                                )),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.0325),
                                  right: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.075)),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/settings_icon.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colouring.colorAlmostWhite,
                                        BlendMode.srcIn),
                                  ),
                                  Expanded(
                                      child: Text(
                                    translatedText(context)
                                        .profile_screen_settings,
                                    style: TextStyle(
                                        color: Colouring.colorAlmostWhite,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isVisible,
                          child: Expanded(
                            child: Center(
                              child: SizedBox(
                                  height: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.6),
                                  width: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.6),
                                  child: PrettyQrView.data(
                                    decoration: const PrettyQrDecoration(
                                        shape: PrettyQrSmoothSymbol(
                                            color: Colouring.colorAlmostWhite)),
                                    data: user!.uid,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getGrid() {
    isReorderable ? setEditedChildren() : setChildren();
    return Expanded(
        child: Stack(children: [
      ListView(children: [
        SizedBox(
          //formula to calculate height of the listview
          height: (RelativeSize(context: context)
                      .getScreenWidthPercentage(0.425) *
                  ((children.length + 1) / 2).ceil()) +
              (RelativeSize(context: context).getScreenWidthPercentage(0.075) *
                  ((children.length - 1) / 4).floor()),
          child: ReorderableGridView.count(
            dragEnabled: isReorderable,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                String old = userSocialMediaAssets.removeAt(oldIndex);
                userSocialMediaAssets.insert(newIndex, old);
                String keyToMove = userSocialMedia!.keys.elementAt(oldIndex);
                String valueToMove = userSocialMedia!.remove(keyToMove);
                List<MapEntry<String, dynamic>> smList =
                    userSocialMedia!.entries.toList();
                smList.insert(newIndex, MapEntry(keyToMove, valueToMove));
                userSocialMedia = Map.fromEntries(smList);
              });
            },
            dragWidgetBuilder: (index, child) {
              return GestureDetector(
                key: ValueKey(index),
                onTap: () => goToUserSocialMedia(index),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          RelativeSize(context: context)
                              .getScreenWidthPercentage(0.1)),
                      image: DecorationImage(
                          image: AssetImage(userSocialMediaAssets[index])),
                    )),
              );
            },
            padding: EdgeInsets.symmetric(
                horizontal: RelativeSize(context: context)
                    .getScreenWidthPercentage(0.075)),
            controller: _scrollController,
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: !isReorderable
                ? RelativeSize(context: context).getScreenWidthPercentage(0.075)
                : 0,
            crossAxisSpacing: !isReorderable
                ? RelativeSize(context: context).getScreenWidthPercentage(0.075)
                : 0,
            children: children,
          ),
        ),
      ]),
      if (isReorderable)
        Positioned(
          bottom:
              RelativeSize(context: context).getScreenHeightPercentage(0.125),
          left: 20,
          right: 20,
          height:
              RelativeSize(context: context).getScreenHeightPercentage(0.06),
          child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  overlayColor: MaterialStatePropertyAll(Color(0xFFDFDFDF))),
              onPressed: () async {
                saveChanges();
              },
              child: Text(
                translatedText(context).profile_screen_save_changes,
                style: TextStyle(color: Colouring.colorGrey, fontSize: 20),
              )),
        )
    ]));
  }

  //set children list(usma)
  void setChildren() {
    children = List.generate(userSocialMediaAssets.length + 1, (index) {
      return index != userSocialMediaAssets.length
          ? GestureDetector(
              key: ValueKey(index),
              onTap: () => goToUserSocialMedia(index),
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)),
                    image: DecorationImage(
                        image: AssetImage(userSocialMediaAssets[index])),
                  )),
            )
          : GestureDetector(
              key: ValueKey(index),
              onTap: () => addSocialMedia(),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1))),
                child: SvgPicture.asset('assets/images/add_social_media.svg'),
              ),
            );
    });
  }

  Route<Object> _goToSettingsPage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsPage(),
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

//saved made changes when reordering and/or deleting widgets
  void saveChanges() async {
    setState(() {
      isReorderable = false;
    });

    final firestoreDatabase = FirebaseFirestore.instance;
    Map<String, Map<String, dynamic>> obj = {};
    for (int i = 0; i < userSocialMedia!.keys.toList().length; i++) {
      String key = userSocialMedia!.keys.toList()[i];
      obj.addAll({
        key: {
          "position": userSocialMedia!.keys.toList().indexOf(key) + 1,
          "url": userSocialMedia!.values.toList()[i]
        }
      });
    }
    await firestoreDatabase
        .collection("users")
        .doc(user!.uid)
        .update({"social_media": obj});
    /*for (int i = 0; i < userSocialMedia!.keys.toList().length; i++) {
      String key = userSocialMedia!.keys.toList()[i];
      await firestoreDatabase.collection("users").doc(user!.uid).update(i != 0
          ? {
              "social_media": {
                key: {
                  "position": userSocialMedia!.keys.toList().indexOf(key) + 1,
                  "url": userSocialMedia!.values.toList()[i]
                }
              }
            }
          : {"social_media": {}});
    }*/
  }

  //set children list(usma) with a delete button
  void setEditedChildren() {
    children = List.generate(userSocialMediaAssets.length, (index) {
      return Container(
        key: ValueKey(index),
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Stack(children: [
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    RelativeSize(context: context)
                        .getScreenWidthPercentage(0.1)),
                image: DecorationImage(
                    image: AssetImage(userSocialMediaAssets[index])),
              )),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                padding: EdgeInsets.only(left: 15, bottom: 15),
                onPressed: () {
                  setState(() {
                    userSocialMediaAssets.removeAt(index);
                    String keyToRemove = userSocialMedia!.keys.toList()[index];
                    userSocialMedia!.remove(keyToRemove);
                  });
                },
                icon: SvgPicture.asset('assets/images/icon_remove_item.svg')),
          ),
        ]),
      );
    });
  }

  //set a list of users social media assets
  void setSocialMedia() {
    final imageKeys = URLS.socialMediaUrls.keys.toList();
    if (userSocialMedia != null) {
      final userSocialMediaKeys = userSocialMedia!.keys.toList();
      for (int i = 0; i < userSocialMediaKeys.length; i++) {
        for (int j = 0; j < imageKeys.length; j++) {
          if (imageKeys[j].contains(userSocialMediaKeys[i])) {
            userSocialMediaAssets.add(URLS.socialMediaUrls.values.toList()[j]);
          }
        }
      }
    }
  }

  Widget getProfilePicture() {
    return user?.photoURL != null
        ? CircleAvatar(
            radius:
                RelativeSize(context: context).getScreenWidthPercentage(0.1),
            backgroundImage: CachedNetworkImageProvider(user!.photoURL!),
          )
        : Icon(Icons.account_circle_outlined,
            color: Colouring.colorAlmostWhite,
            size:
                RelativeSize(context: context).getScreenWidthPercentage(0.20));
  }

  Future<void> goToUserSocialMedia(int index) async {
    final url = !userSocialMedia!.values.toList()[index].contains('https://')
        ? Uri.parse("https://${userSocialMedia!.values.toList()[index]}")
        : Uri.parse(userSocialMedia!.values.toList()[index]);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void addSocialMedia() {
    userSocialMedia ??= {"Values": "0"};
    Route route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddSocialMediaPage(
                userSocialMedia: userSocialMedia,
                userSocialMediaAssets: userSocialMediaAssets),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
    Navigator.of(context).push(route);
  }
}
