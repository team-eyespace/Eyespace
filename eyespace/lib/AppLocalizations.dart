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
      'update_details': 'Update Details',
      'register': 'Register',
      'logout': 'Logout',
      'cameratext': 'Describe Objects in Frame',
      'terraindetecttext': 'Describe Terrain',
      'mictext': 'Speak',
      'micofftext': 'Stop Speaking',
      'nothingdetected': 'Nothing Detected',
      'scenedata': 'The scene contains the following ',
      'edit': 'Edit',
      'cancel': 'Cancel',
      'roadclear': 'The road ahead looks good!',
      'roadnotclear': 'There appears to be some obstruction ahead'
    },
    'pt': {
      'title': 'Eyespace',
      'update_details': 'Actualizar Detalhes',
      'register': 'Registrar',
      'logout': 'Sair',
      'cameratext': 'Descrever Objetos no Quadro',
      'terraindetecttext': 'Descrever Terreno',
      'mictext': 'Falar',
      'micofftext': 'Pare de falar',
      'nothingdetected': 'Nada detectado',
      'scenedata': 'A cena contém o seguinte ',
      'edit': 'Editar',
      'cancel': 'Cancelar',
      'roadclear': 'A estrada à frente parece boa!',
      'roadnotclear': 'Parece haver alguma obstrução à frente'
    },
  };

  String get roadclear {
    return _localizedValues[locale.languageCode]['roadclear'];
  }

  String get roadnotclear {
    return _localizedValues[locale.languageCode]['roadnotclear'];
  }

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

  String get edit {
    return _localizedValues[locale.languageCode]['edit'];
  }

  String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  String get terraindetecttext {
    return _localizedValues[locale.languageCode]['terraindetecttext'];
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
