// ignore_for_file: use_build_context_synchronously

import 'dart:io' show File, Platform;

import 'package:business_card/pages/additional_pages/saved_users.dart';
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
import '../login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imageURL;
  File? file;

  Route<Object> _goToSavedUsersPage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SavedUsers(),
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
  void initState() {
    super.initState();

    imageURL = user!.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colouring.colorAlmostWhite,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height:
                RelativeSize(context: context).getScreenHeightPercentage(0.275),
            decoration: const BoxDecoration(
              color: Colouring.colorLightLightGrey,
            ),
            alignment: Alignment.center,
            child: Column(children: [
              Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                          PopupMenuItem<int>(
                            value: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.025),
                            child: Row(
                              children: const [
                                Text("Log out"),
                                Spacer(),
                                Icon(Icons.logout_rounded)
                              ],
                            ),
                            onTap: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(goToLoginPage());
                            },
                          ),
                        ]),
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
                style:
                    const TextStyle(fontSize: 18, color: Colouring.colorGrey),
              ),
              Text(
                user!.email!,
                style: const TextStyle(color: Colouring.colorGrey),
              )
            ]),
          ),
          SizedBox(
            height:
                RelativeSize(context: context).getScreenHeightPercentage(0.01),
          ),
          ListTile(
            title: const Text(
              'Language',
              style: TextStyle(
                  color: Colouring.colorGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            leading: SvgPicture.asset(
              'assets/images/icon_earth.svg',
            ),
          ),
          ListTile(
            title: const Text(
              'Saved Users',
              style: TextStyle(
                  color: Colouring.colorGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            leading: SvgPicture.asset('assets/images/bookmark.svg'),
            onTap: () => Navigator.of(context).push(_goToSavedUsersPage()),
          )
        ],
      ),
    ));
  }

  getProfilePicture() {
    if (user!.providerData[0].providerId.toLowerCase().contains('google') ||
        user!.providerData[0].providerId.toLowerCase().contains('facebook')) {
      return CircleAvatar(
        radius: RelativeSize(context: context).getScreenWidthPercentage(0.15),
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
                          .getScreenWidthPercentage(0.15),
                      backgroundImage: file != null
                          ? FileImage(file!) as ImageProvider
                          : CachedNetworkImageProvider(imageURL!,
                              cacheManager: DefaultCacheManager()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.03),
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.055)),
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
                        .getScreenWidthPercentage(0.30),
                    color: Colors.black.withOpacity(0.25),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.04),
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.09)),
                    child: Icon(
                      Icons.add_a_photo,
                      size: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.05),
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
                      child: const Text("Camera")),
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
                      child: const Text("Gallery")),
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
                      title: const Text("Camera"),
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
                      title: const Text("Gallery"),
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
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginPage(),
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
}
