import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLang { en, hi }

/// A piece of text in both languages.
class L {
  final String en;
  final String hi;
  const L(this.en, this.hi);

  String get text => LangController.instance.isHindi ? hi : en;
}

/// Short helper: tr(S.home) gives the text in the chosen language.
String tr(L text) => text.text;

/// Remembers the user's language. null means "not chosen yet", which
/// shows the language picker on first launch.
class LangController extends ChangeNotifier {
  LangController._();
  static final LangController instance = LangController._();

  static const _key = 'app_lang';
  AppLang? _lang;

  AppLang? get lang => _lang;
  bool get isChosen => _lang != null;
  bool get isHindi => _lang == AppLang.hi;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    _lang = saved == 'hi'
        ? AppLang.hi
        : saved == 'en'
            ? AppLang.en
            : null;
  }

  Future<void> set(AppLang lang) async {
    _lang = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, lang == AppLang.hi ? 'hi' : 'en');
  }
}
