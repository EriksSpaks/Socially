import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../assets/colors.dart';
import '../../assets/size.dart';
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(color: Colouring.colorLightLightGrey),
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
                  color: Colouring.colorGrey),
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
                    color: Colouring.colorAlmostWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)),
                        topRight: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)))),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(RelativeSize(context: context)
                        .getScreenWidthPercentage(0.075)),
                    child: const Text(
                        "Provide the link to your account to a selected social media:",
                        style: TextStyle(
                            color: Colouring.colorGrey, fontSize: 20)),
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
                            controller: linkController,
                            textAlignVertical: TextAlignVertical.center,
                            validator: MultiValidator([
                              PatternValidator(
                                  r'(([\w]+:)?//)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,63}(:[\d]+)?(/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?',
                                  errorText: "Provided link is invalid"),
                              RequiredValidator(
                                  errorText: "This field is required")
                            ]),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                                isDense: false,
                                border: InputBorder.none,
                                hintText: "Link to your account"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colouring.colorWhite),
                            overlayColor:
                                MaterialStateProperty.all(Colouring.colorWhite),
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
                          child: const Align(
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: Colouring.colorButtonBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colouring.colorButtonBlue),
                            overlayColor: MaterialStateProperty.all(
                                Colouring.colorButtonPressedBlue),
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
                          child: const Align(
                            child: Text(
                              "Done",
                              style: TextStyle(
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
    final ref = FirebaseDatabase.instance
        .ref("users")
        .child(user!.uid)
        .child("social_media");
    await ref.update({
      socialMediaName: {
        "url": linkController.text.toString(),
        "position": socialMediaLength + 1
      }
    });
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
