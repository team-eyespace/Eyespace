import 'dart:async';
 
import 'package:flutter/material.dart';
 
import 'localizations.dart';
 
class MainLocalizationsDelegate extends LocalizationsDelegate<localizations> {
  const MainLocalizationsDelegate();
 
  @override
  bool isSupported(Locale locale) => ['pt', 'en'].contains(locale.languageCode);
 
  @override
  Future<localizations> load(Locale locale) => localizations.load(locale);
 
  @override
  bool shouldReload(LocalizationsDelegate<localizations> old) => false;
}