import 'package:business_card/language_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../styles/colors.dart';
import '../../styles/size.dart';
import '../home_page.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class FinishSocialMedia extends StatefulWidget {
  const FinishSocialMedia(
      {super.key,
      required this.socialMediaName,
      required this.userSocialMediaLength});

  final String socialMediaName;
  final int userSocialMediaLength;

  @override
  State<FinishSocialMedia> createState() => _FinishStateSocialMedia();
}

class _FinishStateSocialMedia extends State<FinishSocialMedia> {
  final _formKey = GlobalKey<FormState>();
  late final String socialMediaName = widget.socialMediaName;
  late final int socialMediaLength = widget.userSocialMediaLength;
  final linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(color: Colouring.colorDarkBlue),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          SizedBox(
            height:
                RelativeSize(context: context).getScreenHeightPercentage(0.05),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                left: RelativeSize(context: context)
                    .getScreenWidthPercentage(0.1)),
            child: Text(
              socialMediaName.capitalize(),
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colouring.colorAlmostWhite),
            ),
          ),
          SizedBox(
            height:
                RelativeSize(context: context).getScreenHeightPercentage(0.05),
          ),
          Form(
            key: _formKey,
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFF033D5E),
                      Colouring.colorBlueGradient2
                    ], stops: [
                      0,
                      1
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)),
                        topRight: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)))),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(RelativeSize(context: context)
                        .getScreenWidthPercentage(0.075)),
                    child: Text(translatedText(context).finish_sm_screen_text,
                        style: const TextStyle(
                            color: Colouring.colorAlmostWhite, fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.05)),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.025),
                              0,
                              RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.025),
                              RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.025)),
                          height: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.065),
                          width: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.9),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.08))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.05)),
                          child: TextFormField(
                            cursorColor: Colouring.colorGrey,
                            controller: linkController,
                            textAlignVertical: TextAlignVertical.center,
                            //style: TextStyle(color: Colors.green),
                            validator: MultiValidator([
                              PatternValidator(
                                  r'(([\w]+:)?//)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,63}(:[\d]+)?(/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?',
                                  errorText: translatedText(context)
                                      .finish_sm_screen_error_invalid_link),
                              RequiredValidator(
                                  errorText: translatedText(context)
                                      .finish_sm_screen_error_required_field)
                            ]).call,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                                errorStyle: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600),
                                isDense: false,
                                border: InputBorder.none,
                                hintText: translatedText(context)
                                    .finish_sm_screen_hintText),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.45),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFFAFAFA)),
                            overlayColor: MaterialStateProperty.all(
                                Colouring.colorLightGrey),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            fixedSize: MaterialStateProperty.all(Size(
                                RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.35),
                                RelativeSize(context: context)
                                    .getScreenHeightPercentage(0.045))),
                          ),
                          onPressed: () {
                            backToPreviousPage();
                          },
                          child: Align(
                            child: Text(
                              translatedText(context)
                                  .finish_sm_screen_button_back,
                              style: const TextStyle(
                                color: Colouring.colorDarkDarkBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colouring.colorDarkBlue),
                            overlayColor: MaterialStateProperty.all(
                                Colouring.colorDarkDarkBlue),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            fixedSize: MaterialStateProperty.all(Size(
                                RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.35),
                                RelativeSize(context: context)
                                    .getScreenHeightPercentage(0.045))),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              setSocialMedia();
                            }
                          },
                          child: Align(
                            child: Text(
                              translatedText(context)
                                  .finish_sm_screen_button_done,
                              style: const TextStyle(
                                color: Colouring.colorWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                    ],
                  ),
                ]),
              ),
            ),
          )
        ]),
      )),
    );
  }

  void setSocialMedia() async {
    User? user = FirebaseAuth.instance.currentUser;

    final firestoreDatabase = FirebaseFirestore.instance;
    firestoreDatabase.collection("users").doc(user!.uid).set({
      "social_media": {
        socialMediaName: {
          "url": linkController.text.toString(),
          "position": socialMediaLength == 0 ? 1 : socialMediaLength + 1
        }
      }
    }, SetOptions(merge: true));

    getToHomePage();
  }

  void backToPreviousPage() {
    Navigator.pop(context);
  }

  void getToHomePage() {
    Navigator.of(context).push(goToHomePage());
  }

  Route<Object> goToHomePage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(
              firstConnection: true,
            ),
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
