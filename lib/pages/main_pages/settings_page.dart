// ignore_for_file: use_build_context_synchronously

import 'dart:io' show File, Platform;

import 'package:business_card/language_constants.dart';
import 'package:business_card/pages/additional_pages/bob.dart';
import 'package:business_card/pages/additional_pages/edit_profile_name.dart';
import 'package:business_card/pages/additional_pages/switch_language.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../styles/colors.dart';
import '../../styles/size.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imageURL;
  File? file;

  @override
  void initState() {
    super.initState();

    imageURL = user!.photoURL;
  }

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.015)),
                  child: Container(
                    width: RelativeSize(context: context)
                            .getScreenWidthPercentage(1) -
                        RelativeSize(context: context)
                            .getScreenHeightPercentage(0.03),
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.275),
                    decoration: BoxDecoration(
                        color: Colouring.colorDarkBlue,
                        borderRadius: BorderRadius.all(Radius.circular(
                            RelativeSize(context: context)
                                .getScreenHeightPercentage(0.03)))),
                    alignment: Alignment.center,
                    child: Column(children: [
                      SizedBox(
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.025),
                      ),
                      Container(
                        child: getProfilePicture(),
                      ),
                      SizedBox(
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.01),
                      ),
                      Text(
                        user!.displayName!,
                        style: const TextStyle(
                            fontSize: 18, color: Colouring.colorAlmostWhite),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.025),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(_goToLanguagePage());
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colouring.colorDarkBlue),
                      fixedSize: MaterialStateProperty.all(Size(
                          double.infinity,
                          RelativeSize(context: context)
                              .getScreenHeightPercentage(0.06))),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No rounded borders
                          // Border color with opacity
                        ),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.025),
                        right: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.075)),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icon_earth.svg',
                          colorFilter: const ColorFilter.mode(
                              Colouring.colorAlmostWhite, BlendMode.srcIn),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.0725)),
                          child: Text(
                            translatedText(context).language,
                            style: const TextStyle(
                                color: Colouring.colorAlmostWhite,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(_goToEditProfileNamePage())
                        .then((value) => setState(() {
                              user = FirebaseAuth.instance.currentUser!;
                            }));
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colouring.colorDarkBlue),
                      fixedSize: MaterialStateProperty.all(Size(
                          double.infinity,
                          RelativeSize(context: context)
                              .getScreenHeightPercentage(0.06))),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No rounded borders
                          // Border color with opacity
                        ),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.025),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icon_edit_profile.svg',
                          colorFilter: const ColorFilter.mode(
                              Colouring.colorAlmostWhite, BlendMode.srcIn),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.0825)),
                          child: Text(
                            translatedText(context).edit_profile_name,
                            style: const TextStyle(
                                color: Colouring.colorAlmostWhite,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                /*ElevatedButton(
                  onPressed: () {
                    //TODO: switch to light theme
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colouring.colorDarkBlue),
                      fixedSize: MaterialStateProperty.all(Size(
                          double.infinity,
                          RelativeSize(context: context)
                              .getScreenHeightPercentage(0.06))),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No rounded borders
                          // Border color with opacity
                        ),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.02),
                        right: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.075)),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icon_switch_to_light.svg',
                          colorFilter: const ColorFilter.mode(
                              Colouring.colorAlmostWhite, BlendMode.srcIn),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.075)),
                          child: Text(
                            "Switch to light theme",
                            style: TextStyle(
                                color: Colouring.colorAlmostWhite,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),*/
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(_goToLoginPage());
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colouring.colorDarkBlue),
                      fixedSize: MaterialStateProperty.all(Size(
                          double.infinity,
                          RelativeSize(context: context)
                              .getScreenHeightPercentage(0.06))),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No rounded borders
                          // Border color with opacity
                        ),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.0325),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icon_log_out.svg',
                          colorFilter: const ColorFilter.mode(
                              Colouring.colorAlmostWhite, BlendMode.srcIn),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.06)),
                          child: Text(
                            translatedText(context).log_out,
                            style: const TextStyle(
                                color: Colouring.colorAlmostWhite,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  getProfilePicture() {
    if (user!.providerData[0].providerId.toLowerCase().contains('google') ||
        user!.providerData[0].providerId.toLowerCase().contains('facebook')) {
      return CircleAvatar(
        radius: RelativeSize(context: context).getScreenWidthPercentage(0.185),
        backgroundImage: CachedNetworkImageProvider(user!.photoURL!),
      );
    } else {
      return imageURL != null
          ? GestureDetector(
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: CircleAvatar(
                      radius: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.185),
                      backgroundImage: file != null
                          ? FileImage(file!) as ImageProvider
                          : CachedNetworkImageProvider(imageURL!,
                              cacheManager: DefaultCacheManager()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.05),
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)),
                    child: Icon(
                      Icons.add_a_photo,
                      size: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.075),
                    ),
                  )
                ],
              ),
              onTap: () {
                setProfilePicture();
              },
            )
          : GestureDetector(
              child: Stack(
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.37),
                    color: Colors.white.withOpacity(0.25),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.05),
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.12)),
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colouring.colorAlmostWhite,
                      size: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.06),
                    ),
                  )
                ],
              ),
              onTap: () => setState(() {
                    setProfilePicture();
                  }));
    }
  }

  void setProfilePicture() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () async {
                        BuildContext? dialogContext;
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child("profilePictures")
                            .child("${user!.uid}.jpg");
                        if (!mounted) return;
                        Navigator.of(context).pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              dialogContext = context;
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                        try {
                          await ref.getDownloadURL();
                          ref.delete();
                        } finally {
                          await ref.putFile(File(image!.path));
                          await ref.getDownloadURL().then((value) {
                            setState(() {
                              imageURL = value;
                            });
                          });
                          file = File(image.path);
                          await user
                              ?.updatePhotoURL(await ref.getDownloadURL());
                          Navigator.pop(dialogContext!);
                        }
                      },
                      child: Text(
                          translatedText(context).change_profile_pic_camera)),
                  CupertinoActionSheetAction(
                      onPressed: () async {
                        BuildContext? dialogContext;
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child("profilePictures")
                            .child("${user!.uid}.jpg");
                        if (!mounted) return;
                        Navigator.of(context).pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              dialogContext = context;
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                        try {
                          await ref.getDownloadURL();
                          ref.delete();
                        } finally {
                          await ref.putFile(File(image!.path));
                          await ref.getDownloadURL().then((value) {
                            setState(() {
                              imageURL = value;
                            });
                          });
                          file = File(image.path);
                          await user
                              ?.updatePhotoURL(await ref.getDownloadURL());
                          Navigator.pop(dialogContext!);
                        }
                      },
                      child: Text(
                          translatedText(context).change_profile_pic_gallery)),
                ],
              ));
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) => SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.185),
                child: ListView(
                  children: [
                    ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(
                            top: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.01)),
                        child: const Icon(Icons.camera_alt),
                      ),
                      title: Text(
                          translatedText(context).change_profile_pic_camera),
                      visualDensity: const VisualDensity(
                          vertical: VisualDensity.maximumDensity),
                      onTap: () async {
                        BuildContext? dialogContext;
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child("profilePictures")
                            .child("${user!.uid}.jpg");
                        if (!mounted) return;
                        Navigator.of(context).pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              dialogContext = context;
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                        try {
                          await ref.getDownloadURL();
                          ref.delete();
                        } finally {
                          await ref.putFile(File(image!.path));
                          await ref.getDownloadURL().then((value) {
                            imageURL = value;
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(user!.uid)
                                .update({"photoURL": value});
                          });
                          file = File(image.path);
                          await user
                              ?.updatePhotoURL(await ref.getDownloadURL());
                          setState(() {});
                          Navigator.pop(dialogContext!);
                        }
                      },
                    ),
                    ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(
                            top: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.01)),
                        child: const Icon(Icons.photo_album),
                      ),
                      title: Text(
                          translatedText(context).change_profile_pic_gallery),
                      visualDensity: const VisualDensity(
                          vertical: VisualDensity.maximumDensity),
                      onTap: () async {
                        BuildContext? dialogContext;
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child("profilePictures")
                            .child("${user!.uid}.jpg");
                        if (!mounted) return;
                        Navigator.of(context).pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              dialogContext = context;
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                        try {
                          await ref.getDownloadURL();
                          ref.delete();
                        } finally {
                          await ref.putFile(File(image!.path));
                          await ref.getDownloadURL().then((value) {
                            imageURL = value;
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(user!.uid)
                                .update({"photoURL": value});
                          });
                          file = File(image.path);
                          await user
                              ?.updatePhotoURL(await ref.getDownloadURL());
                          setState(() {});
                          Navigator.pop(dialogContext!);
                        }
                      },
                    ),
                  ],
                ),
              ));
    }
  }

  Route<Object> goToLoginPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const BOB(),
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
      },
    );
  }

  Route<Object> _goToLanguagePage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LanguageScreen(),
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

  Route<Object?> _goToLoginPage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const BOB(),
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
  }

  Route<Object?> _goToEditProfileNamePage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const EditProfileNamePage(),
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
}
