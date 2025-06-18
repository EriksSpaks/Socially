// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:business_card/language_constants.dart';
import 'package:business_card/main.dart';
import 'package:business_card/styles/colors.dart';
import 'package:business_card/styles/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final TextEditingController _textController = TextEditingController();
  static const List<String> languageList = ["English", "Latviešu", "Русский"];
  static late List<String> translatedLanguageLst;
  static final HashMap<String, String> languageMap = HashMap.of({
    "English": "en",
    "Latviešu": "lv",
    "Русский": "ru",
  });

  @override
  void initState() {
    super.initState();
    /*translatedLanguageLst = [
      AppLocalizations.of(context)!.english,
      AppLocalizations.of(context)!.german,
      AppLocalizations.of(context)!.latvian,
      AppLocalizations.of(context)!.russian,
    ];*/
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    translatedLanguageLst = [
      translatedText(context).english,
      translatedText(context).latvian,
      translatedText(context).russian,
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colouring.colorDarkBlue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.07),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.1)),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/icon_earth.svg',
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.135),
                    colorFilter: const ColorFilter.mode(
                        Colouring.colorAlmostWhite, BlendMode.srcIn),
                  ),
                  SizedBox(
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.03),
                  ),
                  Text(
                    translatedText(context).language,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colouring.colorAlmostWhite,
                        fontSize: 26),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.07),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Colouring.colorBlueGradient3,
                      Colouring.colorBlueGradient2
                    ], stops: [
                      0.0,
                      1.0
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)),
                        topRight: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)))),
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.03)),
                  child: ListView.builder(
                      itemCount: languageList.length,
                      itemBuilder: (_, index) {
                        return ElevatedButton(
                          onPressed: () async {
                            Locale locale = await setLocale(
                                languageMap[languageList[index]]!);
                            // ignore: use_build_context_synchronously
                            MyApp.setLocale(context, locale);
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor: MaterialStateProperty.all(
                                  Colouring.colorDarkBlue),
                              fixedSize: MaterialStateProperty.all(Size(
                                  double.infinity,
                                  RelativeSize(context: context)
                                      .getScreenHeightPercentage(0.075))),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.zero, // No rounded borders
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
                                Localizations.localeOf(context) ==
                                        Locale(
                                            languageMap[languageList[index]]!)
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: const [
                                          Icon(
                                            Icons.circle,
                                            color: Colouring.colorAlmostWhite,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Colouring.colorDarkGrey,
                                            size: 15,
                                          ),
                                        ],
                                      )
                                    : Icon(
                                        Icons.circle,
                                        color: Colouring.colorAlmostWhite,
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: RelativeSize(context: context)
                                          .getScreenWidthPercentage(0.0725)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        languageList[index],
                                        style: TextStyle(
                                            color: Colouring.colorAlmostWhite,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        translatedLanguageLst[index],
                                        //"sdf",
                                        style: TextStyle(
                                            color: Colouring.colorLightGrey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
