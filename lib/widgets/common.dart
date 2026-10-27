import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

/// Shown on every screen that gives guidance. Required so users (and
/// Google Play) know this is not a government app.
class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Form Saathi is not a government app and is not affiliated with any '
      'government body. Always confirm on the official website.',
      style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.muted),
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
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(999)),
      child: Text(text,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: foreground)),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $url')),
    );
  }
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
