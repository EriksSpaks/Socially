// ignore_for_file: constant_identifier_names

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LANGUAGE_CODE = 'languageCode';

const String ENGLISH = 'en';
//const String GERMAN = 'de';
const String LATVIAN = 'lv';
const String RUSSIAN = 'ru';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return Locale(languageCode);
}

AppLocalizations translatedText(BuildContext context) {
  return AppLocalizations.of(context)!;
}
