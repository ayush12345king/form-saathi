import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/lang.dart';
import '../l10n/strings.dart';
import '../theme.dart';

/// Shown on every screen that gives guidance. Required so users (and
/// Google Play) know this is not a government app.
class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      tr(S.disclaimer),
      style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.muted),
    );
  }
}

/// Small rounded label, e.g. "5 min" or "6 days".
class Pill extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;

  const Pill(this.text,
      {super.key,
      this.background = const Color(0xFFE9E5D9),
      this.foreground = AppColors.ink});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: foreground)),
    );
  }
}

/// Small grey uppercase heading above a group.
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.6)),
    );
  }
}

/// Round "हिं / EN" button that switches the app language.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final hi = LangController.instance.isHindi;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 44),
        backgroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      onPressed: () => LangController.instance.set(hi ? AppLang.en : AppLang.hi),
      child: Text(hi ? 'English' : 'हिंदी', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}

/// Opens a website outside the app. Shows a message if it fails.
Future<void> openLink(BuildContext context, String url) async {
  var ok = false;
  try {
    ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {
    ok = false;
  }
  if (!ok && context.mounted) {
    showMessage(context, '${tr(S.couldNotOpen)}: $url');
  }
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
