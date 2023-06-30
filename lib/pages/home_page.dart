import 'dart:async';

import 'package:business_card/styles/colors.dart';
import 'package:business_card/pages/main_pages/edit_mode_page.dart';
import 'package:business_card/pages/main_pages/search_page.dart';
import 'package:business_card/pages/main_pages/settings_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/size.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.userSocialMedia,
    this.firstConnection = false,
  });
  final dynamic userSocialMedia;
  final bool firstConnection;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic>? userSocialMedia = widget.userSocialMedia;
  late bool firstConnection = widget.firstConnection;
  late Future myFuture;

  User? user = FirebaseAuth.instance.currentUser;
  String email = "";

  static List<Tab> tabs = <Tab>[
    Tab(
      icon: SvgPicture.asset(
        'assets/images/profile_icon.svg',
        width: 30,
        height: 30,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        //color: Colors.black,
      ),
    ),
    Tab(
      icon: SvgPicture.asset('assets/images/edit_mode_icon.svg',
          width: 35,
          height: 35,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
    ),
    Tab(
      icon: SvgPicture.asset('assets/images/settings_icon.svg',
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
    ),
  ];

  late TabController _tabBarController;

  @override
  void initState() {
    super.initState();
    _tabBarController =
        TabController(length: tabs.length, vsync: this, initialIndex: 1);
    myFuture = createUserDatabase();
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WillPopScope(
              onWillPop: () async => false,
              child: KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.pink.shade50,
                            Colors.pink.shade100,
                            Colors.pink.shade200,
                            Colors.pink.shade100,
                            Colors.pink.shade50,
                          ],
                          stops: [0.0, 0.2, 0.4, 0.6, 1.0],
                        ),
                      ),
                      child: Stack(children: [
                        Positioned.fill(
                          child: ShaderMask(
                            blendMode: BlendMode.dstIn,
                            shaderCallback: (bounds) {
                              return RadialGradient(
                                center: Alignment.center,
                                radius: 0.9,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.6),
                                ],
                                stops: [0.2, 1.0],
                              ).createShader(bounds);
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Positioned(
                          left: -100,
                          top: -100,
                          child: ShaderMask(
                            blendMode: BlendMode.dstIn,
                            shaderCallback: (bounds) {
                              return RadialGradient(
                                center: Alignment.center,
                                radius: 0.6,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.4),
                                ],
                                stops: [0.2, 1.0],
                              ).createShader(bounds);
                            },
                            child: Container(
                              width: 400,
                              height: 400,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -150,
                          bottom: -150,
                          child: ShaderMask(
                            blendMode: BlendMode.dstIn,
                            shaderCallback: (bounds) {
                              return RadialGradient(
                                center: Alignment.center,
                                radius: 0.8,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.5),
                                ],
                                stops: [0.2, 1.0],
                              ).createShader(bounds);
                            },
                          ),
                        ),
                        Stack(
                          children: [
                            SafeArea(
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _tabBarController,
                                children: [
                                  const SearchPage(),
                                  EditModePage(
                                    userSocialMedia: userSocialMedia,
                                    firstConnection: firstConnection,
                                  ),
                                  const SettingsPage(),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Visibility(
                                visible: !isKeyboardVisible,
                                maintainState: true,
                                child: Builder(builder: (context) {
                                  return AnimatedTabBar(
                                    tabs: tabs,
                                    tabController: _tabBarController,
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ])),
                );
              }),
            );
          }
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colouring.colorGradient1, Colouring.colorGradient2],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
          );
        });
  }

  Future<void> createUserDatabase() async {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> userSM = {};
    final firestoreDatabase = FirebaseFirestore.instance;
    if (user != null) {
      final bob =
          await firestoreDatabase.collection("users").doc(user.uid).get();
      final data = bob.data()!["social_media"] as Map<dynamic, dynamic>;
      if (data.isNotEmpty) {
        userSM = Map<String, dynamic>.from(data);
        List<MapEntry<String, dynamic>> usmList = userSM.entries.toList();
        usmList
            .sort((a, b) => a.value["position"] < b.value["position"] ? -1 : 1);
        userSocialMedia = Map.fromEntries(
            usmList.map((entry) => MapEntry(entry.key, entry.value["url"])));
        print(userSocialMedia);
      } else {
        userSocialMedia = {"values": "0"};
      }
    }
  }
}

class AnimatedTabBar extends StatefulWidget {
  const AnimatedTabBar(
      {super.key, required this.tabs, required this.tabController});
  final List<Tab> tabs;
  final TabController tabController;

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar> {
  final animationDuration = const Duration(milliseconds: 300);
  final animationCurve = Curves.easeInOut;
  int tabIndex = 1;
  late final tabHeight =
      RelativeSize(context: context).getScreenHeightPercentage(0.085);
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (!mounted) return;
      setState(() {
        tabIndex = widget.tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(
              RelativeSize(context: context).getScreenHeightPercentage(0.05))),
          child: Container(
            color: Colors.white.withOpacity(0.8),
            height: tabHeight,
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: animationDuration,
                  curve: animationCurve,
                  alignment: FractionalOffset(
                      1 / (widget.tabController.length - 1) * tabIndex, 0),
                  child: Container(
                    height: tabHeight,
                    color: Colors.transparent,
                    child: FractionallySizedBox(
                      widthFactor: 1 / widget.tabs.length,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.05)),
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
                          indent: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.04),
                          endIndent: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.04),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: widget.tabs.asMap().entries.map((entry) {
                    final i = entry.key;
                    final tab = entry.value;
                    final isActiveTab = i == tabIndex;
                    return Expanded(
                        child: GestureDetector(
                      onTap: () => widget.tabController.animateTo(i),
                      child: AnimatedOpacity(
                        duration: animationDuration,
                        curve: animationCurve,
                        opacity: isActiveTab ? 1 : 0.3,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.020)),
                          alignment: Alignment.topCenter,
                          height: tabHeight,
                          color: Colors.transparent,
                          child: tab.icon!,
                        ),
                      ),
                    ));
                  }).toList(),
                ),
              ],
            ),
          ),
        ));
  }
}
