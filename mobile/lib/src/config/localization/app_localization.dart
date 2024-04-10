import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:landvext/src/core/constants/imports.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;
  Map<String, Map<String, String>> localizedStrings = {};

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  Future<String> _loadAssets(String languageCode) async {
    try {
      return await rootBundle.loadString('assets/lang/$languageCode.json');
    } on Exception catch (_) {
      return rootBundle.loadString('assets/lang/en.json');
    }
  }

  // This is a helper method that will load local specific strings from file
  // present in lang folder
  Future<bool> load() async {
    try {
      String jsonString = await _loadAssets(locale.languageCode);
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      localizedStrings = jsonMap.map((key, _) {
        Map<String, dynamic> items = jsonMap[key];
        return MapEntry(
          key,
          items.map(
            (k, text) => MapEntry(
              k,
              text.toString().replaceAll(r"\'", "'").replaceAll(r'\t', ' '),
            ),
          ),
        );
      });

      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  //check for errors when called in each widget, // This method will be called from every widget which needs a localized text
  String translate(String key, [Map<String, String>? options]) {
    List<String> keys = key.split(':');

    if (keys.length != 2) {
      throw ArgumentError(
        "Invalid key format: $key. Keys should be in the format 'category:key'.",
      );
    }

    String? text = localizedStrings[keys[0]]?[keys[1]];
    if (text == null || text.isEmpty) {
      throw ArgumentError('Localized string not found for key: $key');
    }

    if (options == null || options.isEmpty) {
      return text;
    }

    return _replace(text, options);
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations
// object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  // ignore: avoid_field_initializers_in_const_classes
  final String tAG = 'AppLocalizations';

  @override
  bool isSupported(Locale locale) =>
      kMaterialSupportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

String _replace(String text, Map<String, String?>? options) {
  if (options == null || options.isEmpty) {
    return text;
  }

  final RegExp exp = RegExp(r'\{{(.*?)\}}');
  return text.replaceAllMapped(
    exp,
    (m) => options[m.group(1)] ?? m.group(0) ?? '',
  );
}

Locale getLocate(Map<String, dynamic>? configs) {
  if (configs == null) {
    return const Locale('en', 'US');
  }

  if (configs['scriptCode'] != null) {
    return Locale.fromSubtags(
      languageCode: configs['languageCode'],
      scriptCode: configs['scriptCode'],
      countryCode: configs['countryCode'],
    );
  }
  return Locale(configs['languageCode'], configs['countryCode'] ?? '');
}
