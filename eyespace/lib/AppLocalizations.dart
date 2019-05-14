import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Eyespace',
      'chat': 'Chat',
      'update_details': 'Update Details',
      'register': 'Register',
      'logout': 'Logout',
      'cameratext': 'Describe Objects in Frame',
      'mictext': 'Speak',
      'micofftext': 'Stop Speaking',
      'nothingdetected': 'Nothing Detected',
      'scenedata': 'The scene contains the following '
    },
    'pt': {
      'title': 'Eyespace',
      'chat': 'Conversar',
      'update_details': 'Actualizar Detalhes',
      'register': 'Registrar',
      'logout': 'Sair',
      'cameratext': 'Descrever Objetos no Quadro',
      'mictext': 'Falar',
      'micofftext': 'Pare de falar',
      'nothingdetected': 'Nada detectado',
      'scenedata': 'A cena contém o seguinte '
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get chat {
    return _localizedValues[locale.languageCode]['chat'];
  }

  String get updateDetails {
    return _localizedValues[locale.languageCode]['update_details'];
  }

  String get register {
    return _localizedValues[locale.languageCode]['register'];
  }

  String get logout {
    return _localizedValues[locale.languageCode]['logout'];
  }

  String get cameratext {
    return _localizedValues[locale.languageCode]['cameratext'];
  }

  String get mictext {
    return _localizedValues[locale.languageCode]['mictext'];
  }

  String get micofftext {
    return _localizedValues[locale.languageCode]['micofftext'];
  }

  String get nothingdetected {
    return _localizedValues[locale.languageCode]['nothingdetected'];
  }

  String get scenedata {
    return _localizedValues[locale.languageCode]['scenedata'];
  }

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
