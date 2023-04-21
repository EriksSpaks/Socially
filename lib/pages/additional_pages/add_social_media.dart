import 'package:business_card/assets/urls.dart';
import 'package:flutter/material.dart';
import '../../assets/size.dart';
import 'finish_social_media.dart';

class AddSocialMediaPage extends StatefulWidget {
  const AddSocialMediaPage(
      {super.key,
      required this.userSocialMedia,
      required this.userSocialMediaAssets});

  final dynamic userSocialMedia, userSocialMediaAssets;

  @override
  State<AddSocialMediaPage> createState() => _AddSocialMediaPageState();
}

class _AddSocialMediaPageState extends State<AddSocialMediaPage> {
  late final Map<String, dynamic> userSocialMedia = widget.userSocialMedia;
  late final List userSocialMediaAssets = widget.userSocialMediaAssets;
  List additionalSocialMedia = [];
  List additionalSocialMediaNames = [];

  @override
  void initState() {
    super.initState();
    if (userSocialMedia.keys.contains("Values")) {
      userSocialMedia.clear();
    }
    for (var element in URLS.socialMediaUrls.values.toList()) {
      print(userSocialMedia.values);
      if (!userSocialMediaAssets.contains(element)) {
        additionalSocialMedia.add(element);
      }
    }
    for (var element in URLS.socialMediaUrls.keys.toList()) {
      if (!userSocialMedia.keys.contains(element)) {
        additionalSocialMediaNames.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFDDDDDD),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.035),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.075),
                    right: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.15)),
                child: const Text(
                  "What social media do you want to add?",
                  style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF707070),
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.035),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.1)),
                          topRight: Radius.circular(
                              RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.1)))),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.075)),
                        sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate((context,
                                index) {
                              return GestureDetector(
                                onTap: () => addSocialMedia(
                                    additionalSocialMediaNames[index]),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          RelativeSize(context: context)
                                              .getScreenWidthPercentage(0.1)),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              additionalSocialMedia[index]))),
                                ),
                              );
                            }, childCount: additionalSocialMedia.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing:
                                        RelativeSize(context: context)
                                            .getScreenWidthPercentage(0.075),
                                    crossAxisSpacing:
                                        RelativeSize(context: context)
                                            .getScreenWidthPercentage(0.075))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addSocialMedia(String socialMediaName) {
    Route route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FinishSocialMedia(
                socialMediaName: socialMediaName,
                userSocialMediaLength:
                    userSocialMedia.values.toList().contains(0)
                        ? 0
                        : userSocialMedia.length),
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
    Navigator.of(context).push(route);
  }
}
