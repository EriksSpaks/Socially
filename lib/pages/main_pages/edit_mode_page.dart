// ignore_for_file: prefer_const_constructors
import 'package:business_card/pages/additional_pages/add_social_media.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../styles/colors.dart';
import '../../styles/size.dart';
import '../../styles/urls.dart';

class EditModePage extends StatefulWidget {
  const EditModePage(
      {super.key, required this.userSocialMedia, this.firstConnection = false});

  final dynamic userSocialMedia;
  final bool firstConnection;

  @override
  State<EditModePage> createState() => _EditModePageState();
}

class _EditModePageState extends State<EditModePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late Map<String, dynamic>? userSocialMedia = widget.userSocialMedia;
  List<String> userSocialMediaAssets = [];
  late bool firstConnection = widget.firstConnection;
  final _scrollController = ScrollController();
  late bool isReorderable;
  late List<Widget> children;

  @override
  void initState() {
    super.initState();
    isReorderable = false;
    setSocialMedia();
  }

  @override
  Widget build(BuildContext context) {
    print(isReorderable);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.03),
              ),
              Center(
                child: Container(
                  height: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.15),
                  width: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.875),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.85),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.05)),
                        child: getProfilePicture(),
                      ),
                      SizedBox(
                        width: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.05),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            top: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.055)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.displayName!,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(
                              height: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.0025),
                            ),
                            Text(
                              user!.email!,
                              style: TextStyle(
                                  color: Color(0x55000000), fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.03),
                      ),
                      Spacer(),
                      if (userSocialMedia!.isNotEmpty)
                        Container(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025),
                                      child: Row(
                                        children: const [
                                          Text("Edit"),
                                          Spacer(),
                                          Icon(Icons.edit)
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isReorderable = true;
                                        });
                                      },
                                    ),
                                  ]),
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.025)),
              getGrid(),
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.01),
              )
            ],
          ),
        ),
      ),
      //  ])),
    );
  }

  /*Widget getGrid() {
    setSocialMedia();
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: RelativeSize(context: context)
                    .getScreenWidthPercentage(0.075)),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return index != userSocialMediaAssets.length
                    ? GestureDetector(
                        onTap: () => goToUserSocialMedia(index),
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.1)),
                              image: DecorationImage(
                                  image:
                                      AssetImage(userSocialMediaAssets[index])),
                            )),
                      )
                    : GestureDetector(
                        onTap: () => addSocialMedia(),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.1))),
                          child: SvgPicture.asset(
                              'assets/images/add_social_media.svg'),
                        ),
                      );
              }, childCount: userSocialMedia!.values.toList().length + 1),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.075),
                  crossAxisSpacing: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.075)),
            ),
          )
        ],
      ),
    );
  }*/

  Widget getGrid() {
    isReorderable ? setEditedChildren() : setChildren();
    return Expanded(
        child: Stack(children: [
      ListView(children: [
        SizedBox(
          height:
              RelativeSize(context: context).getScreenHeightPercentage(0.935),
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
          bottom: 10,
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
                setState(() {
                  isReorderable = false;
                });

                final firestoreDatabase = FirebaseFirestore.instance;

                userSocialMedia!.forEach((key, value) async {
                  await firestoreDatabase
                      .collection("users")
                      .doc(user!.uid)
                      .set({
                    "social_media": {
                      key: {
                        "position":
                            userSocialMedia!.keys.toList().indexOf(key) + 1,
                        "url": value
                      }
                    }
                  }, SetOptions(merge: true));
                });
              },
              child: Text(
                "Save changes",
                style: TextStyle(color: Colouring.colorGrey, fontSize: 20),
              )),
        )
    ]));
  }

  /*
  SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: RelativeSize(context: context)
                    .getScreenWidthPercentage(0.075)),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return index != userSocialMediaAssets.length
                    ? GestureDetector(
                        onTap: () => goToUserSocialMedia(index),
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.1)),
                              image: DecorationImage(
                                  image:
                                      AssetImage(userSocialMediaAssets[index])),
                            )),
                      )
                    : GestureDetector(
                        onTap: () => addSocialMedia(),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.1))),
                          child: SvgPicture.asset(
                              'assets/images/add_social_media.svg'),
                        ),
                      );
              }, childCount: userSocialMedia!.values.toList().length + 1),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.075),
                  crossAxisSpacing: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.075)),
            ),
          )*/

  //set children list(usma)
  void setChildren() {
    children = List.generate(userSocialMediaAssets.length + 1, (index) {
      return index != userSocialMediaAssets.length
          ? GestureDetector(
              key: ValueKey(index),
              onTap: () => goToUserSocialMedia(index),
              child: Container(
                  padding: EdgeInsets.all(5),
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
                padding: EdgeInsets.all(5),
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
