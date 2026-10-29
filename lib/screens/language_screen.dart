import 'package:flutter/material.dart';

import '../l10n/lang.dart';
import '../theme.dart';

/// Shown on first launch. Text is in both languages because the user
/// hasn't chosen yet.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.task_outlined, color: AppColors.marigold, size: 40),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Form Saathi',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 28),
              const Text('अपनी भाषा चुनें', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const Text('Choose your language', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.muted)),
              const SizedBox(height: 24),
              _LangButton(
                title: 'हिंदी',
                subtitle: 'पूरा ऐप हिंदी में',
                onTap: () => LangController.instance.set(AppLang.hi),
              ),
              const SizedBox(height: 12),
              _LangButton(
                title: 'English',
                subtitle: 'Full app in English',
                onTap: () => LangController.instance.set(AppLang.en),
              ),
              const Spacer(flex: 2),
              const Text(
                'आप इसे बाद में बदल सकते हैं  ·  You can change this later',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LangButton({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.line, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.muted)),
              ]),
            ),
            const Icon(Icons.arrow_forward, color: AppColors.ink),
          ]),
        ),
      ),
    );
  }
}
