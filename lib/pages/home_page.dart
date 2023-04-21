import 'dart:async';

import 'package:business_card/pages/main_pages/edit_mode_page.dart';
import 'package:business_card/pages/main_pages/profile_page.dart';
import 'package:business_card/pages/main_pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets/size.dart';

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
        color: Colors.black,
      ),
    ),
    Tab(
      icon: SvgPicture.asset(
        'assets/images/edit_mode_icon.svg',
        width: 35,
        height: 35,
        color: Colors.black,
      ),
    ),
    Tab(
      icon: SvgPicture.asset(
        'assets/images/settings_icon.svg',
        width: 32,
        height: 32,
        color: Colors.black,
      ),
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
    print("$firstConnection 1");
    print("$userSocialMedia gogogog");
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                bottomNavigationBar: AnimatedTabBar(
                  tabs: tabs,
                  tabController: _tabBarController,
                ),
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabBarController,
                  children: [
                    ProfilePage(),
                    EditModePage(
                      userSocialMedia: userSocialMedia,
                      firstConnection: firstConnection,
                    ),
                    SettingsPage(),
                  ],
                ),
              ),
            );
          }
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xFFCAE9FB), Color(0xFFE5F4FD)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
          );
        });
  }

  double getScreenWidthPercentage(double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  double getScreenHeightPercentage(double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  Future<void> createUserDatabase() async {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> userSM = {};
    List<String> arr = [];
    final ref = FirebaseDatabase.instance.ref("users");
    //print(user?.uid);
    final event = await ref.get();
    if (user != null) {
      if (event.exists) {
        final ev = await ref.child('${user.uid}/social_media').get();
        if (ev.value != "" && ev.exists) {
          userSM = Map<String, dynamic>.from(ev.value as Map<dynamic, dynamic>);
          List<MapEntry<String, dynamic>> usmList = userSM.entries.toList();
          usmList.sort(
              (a, b) => a.value["position"] < b.value["position"] ? -1 : 1);
          userSocialMedia = Map.fromEntries(
              usmList.map((entry) => MapEntry(entry.key, entry.value["url"])));
          print(userSocialMedia);
        } else {
          userSocialMedia = {"values": "0"};
          await ref.set({user.uid: "social_media"});
        }
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
      setState(() {
        tabIndex = widget.tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
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
    );
  }
}
