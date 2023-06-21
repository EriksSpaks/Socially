import 'package:business_card/pages/main_pages/search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rive/rive.dart' as rive;
import 'package:url_launcher/url_launcher.dart';

import '../../assets/colors.dart';
import '../../assets/size.dart';
import '../../assets/urls.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userInfo});

  final UserInfo userInfo;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final _userInfo = widget.userInfo;
  late final future;
  Map<String, dynamic> _userSocialMedia = {};

  List _userSocialMediaAssets = [];
  rive.Artboard? _riveArtboard;
  rive.SMITrigger? _trigger;

  Future<String> _getUID() async {
    final query = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: _userInfo.email)
        .get();
    print(query.docs[0].id);
    return query.docs[0].id;
  }

  Widget getProfilePicture() {
    return _userInfo.photoURL != "-1"
        ? CircleAvatar(
            radius:
                RelativeSize(context: context).getScreenWidthPercentage(0.1),
            backgroundImage: CachedNetworkImageProvider(_userInfo.photoURL,
                cacheManager: DefaultCacheManager()),
          )
        : Icon(Icons.account_circle_outlined,
            size:
                RelativeSize(context: context).getScreenWidthPercentage(0.20));
  }

  //set a list of users social media assets
  void setSocialMedia() {
    final imageKeys = URLS.socialMediaUrls.keys.toList();
    if (_userSocialMedia != null) {
      final userSocialMediaKeys = _userSocialMedia.keys.toList();
      for (int i = 0; i < userSocialMediaKeys.length; i++) {
        for (int j = 0; j < imageKeys.length; j++) {
          if (imageKeys[j].contains(userSocialMediaKeys[i])) {
            _userSocialMediaAssets.add(URLS.socialMediaUrls.values.toList()[j]);
          }
        }
      }
    }
  }

  Future<void> loadSocialMedia() async {
    String uid = await _getUID();
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data()!["social_media"];
    if (data.isNotEmpty) {
      final userSM = Map<String, dynamic>.from(data);
      List<MapEntry<String, dynamic>> usmList = userSM.entries.toList();
      usmList
          .sort((a, b) => a.value["position"] < b.value["position"] ? -1 : 1);
      _userSocialMedia = Map.fromEntries(
          usmList.map((entry) => MapEntry(entry.key, entry.value["url"])));
    } else {
      _userSocialMedia = {"values": "0"};
    }
    setSocialMedia();
  }

  List<Widget> _setChildren() {
    final children = List.generate(_userSocialMediaAssets.length, (index) {
      return GestureDetector(
        onTap: () => goToUserSocialMedia(index),
        child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  RelativeSize(context: context).getScreenWidthPercentage(0.1)),
              image: DecorationImage(
                  image: AssetImage(_userSocialMediaAssets[index])),
            )),
      );
    });
    return children;
  }

  Future<void> goToUserSocialMedia(int index) async {
    final url = !_userSocialMedia.values.toList()[index].contains('https://')
        ? Uri.parse("https://${_userSocialMedia.values.toList()[index]}")
        : Uri.parse(_userSocialMedia.values.toList()[index]);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();

    future = loadSocialMedia();

    rootBundle.load('assets/anim/bookmark_1.riv').then((value) async {
      final file = rive.RiveFile.import(value);
      final riveArtboard = file.mainArtboard;
      var controller =
          rive.StateMachineController.fromArtboard(riveArtboard, 'State');
      if (controller != null) {
        riveArtboard.addController(controller);
        _trigger = controller.findSMI('add_remove_trigger');

        _trigger = controller.inputs.first as rive.SMITrigger;
      }
      setState(() => _riveArtboard = riveArtboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: future,
        builder: (context, snapshot) {
          print(_userSocialMedia);
          print(_userSocialMediaAssets);
          return Scaffold(
              body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colouring.colorGradient1, Colouring.colorGradient2],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
              child: Column(children: [
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
                      color: Colors.white,
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
                              SizedBox(
                                width: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.35),
                                height: RelativeSize(context: context)
                                    .getScreenHeightPercentage(0.025),
                                child: Text(
                                  _userInfo.displayName,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: RelativeSize(context: context)
                                    .getScreenHeightPercentage(0.01),
                              ),
                              Text(
                                _userInfo.email,
                                style: const TextStyle(
                                    color: Color(0x55000000), fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.03),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.02),
                              right: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.01)),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: _riveArtboard == null
                                ? null
                                : GestureDetector(
                                    onTap: () => _trigger!.fire(),
                                    child: rive.Rive(artboard: _riveArtboard!)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.025)),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.075),
                  crossAxisSpacing: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.075),
                  padding: EdgeInsets.symmetric(
                      horizontal: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.075)),
                  children: _setChildren(),
                )
              ]),
            ),
          ));
        });
  }
}
