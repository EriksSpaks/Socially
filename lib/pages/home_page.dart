import 'dart:async';

import 'package:business_card/pages/main_pages/qr_page.dart';
import 'package:business_card/styles/colors.dart';
import 'package:business_card/pages/main_pages/edit_mode_page.dart';
import 'package:business_card/pages/main_pages/search_page.dart';
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
        'assets/images/search_icon.svg',
        width: 33,
        height: 33,
        colorFilter:
            const ColorFilter.mode(Colouring.colorAlmostWhite, BlendMode.srcIn),
        //color: Colors.black,
      ),
    ),
    Tab(
      icon: SvgPicture.asset('assets/images/profile_icon.svg',
          width: 35,
          height: 35,
          colorFilter: const ColorFilter.mode(
              Colouring.colorAlmostWhite, BlendMode.srcIn)),
    ),
    Tab(
      icon: SvgPicture.asset('assets/images/qr_icon.svg',
          width: 34,
          height: 34,
          colorFilter: const ColorFilter.mode(
              Colouring.colorAlmostWhite, BlendMode.srcIn)),
    ),
    Tab(
      icon: SvgPicture.asset('assets/images/saved_users_icon.svg',
          width: 33,
          height: 33,
          colorFilter: const ColorFilter.mode(
              Colouring.colorAlmostWhite, BlendMode.srcIn)),
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

//TODO: GET IMAGES FOR SOCIAL MEDIA FROM DATABASE AND NOT ASSETS FOLDER
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return PopScope(
                canPop: false,
                child: KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              //#FFE8FC; #FFD2F8
                              Colouring.colorBlueGradient1,
                              Colouring.colorBlueGradient2,
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        child: Stack(children: [
                          SafeArea(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabBarController,
                              children: [
                                const SearchPage(
                                  isSavedUsers: false,
                                ),
                                EditModePage(
                                  userSocialMedia: userSocialMedia,
                                  firstConnection: firstConnection,
                                  tabcontroller: _tabBarController,
                                ),
                                const QrPage(),
                                const SearchPage(isSavedUsers: true)
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
                        ])),
                  );
                }),
              );
            }
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colouring.colorBlueGradient1,
                    Colouring.colorBlueGradient2,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            );
          });
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
      } else {
        userSocialMedia = {};
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
        margin: EdgeInsets.only(
            bottom:
                RelativeSize(context: context).getScreenHeightPercentage(0.025),
            right:
                RelativeSize(context: context).getScreenWidthPercentage(0.025),
            left:
                RelativeSize(context: context).getScreenWidthPercentage(0.025)),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(double.infinity),
            topRight: Radius.circular(double.infinity),
          ),
          boxShadow: [
            BoxShadow(
              color: Colouring.colorDarkBlue.withOpacity(0.2),
              blurRadius: 8.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(
              RelativeSize(context: context).getScreenHeightPercentage(0.05))),
          child: Container(
            color: Colouring.colorDarkBlue.withOpacity(0.8),
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
                                .getScreenHeightPercentage(0.06)),
                        child: Divider(
                          color: Colouring.colorAlmostWhite,
                          thickness: 2,
                          indent: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.0275),
                          endIndent: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.0275),
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
