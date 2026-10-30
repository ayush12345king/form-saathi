import 'package:flutter/material.dart';

import 'l10n/lang.dart';
import 'l10n/strings.dart';
import 'screens/guides_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_screen.dart';
import 'screens/photo_tool_screen.dart';
import 'screens/reminders_screen.dart';
import 'services/notifications.dart';
import 'services/storage.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LangController.instance.load(); // saved language (or none yet)
  await DocStore.instance.load(); // saved documents

  // Phone notifications before documents expire. Re-planned whenever a
  // document or the language changes.
  await ExpiryNotifications.instance.init();
  void reschedule() => ExpiryNotifications.instance
      .rescheduleAll(DocStore.instance.docs, hindi: LangController.instance.isHindi);
  DocStore.instance.addListener(reschedule);
  LangController.instance.addListener(reschedule);
  reschedule();

  runApp(const FormSaathiApp());
}

class FormSaathiApp extends StatelessWidget {
  const FormSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild the whole app when the language changes.
    return ListenableBuilder(
      listenable: LangController.instance,
      builder: (context, _) {
        final lang = LangController.instance.lang;
        return MaterialApp(
          // A new key forces every screen to redraw in the new language.
          key: ValueKey(lang),
          title: 'Form Saathi',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          home: lang == null ? const LanguageScreen() : const RootShell(),
        );
      },
    );
  }
}

/// The 4 bottom tabs: Home, Photo, Reminders, Guides.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _tab = 0;

  void _openTab(int index) => setState(() => _tab = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenTab: _openTab),
      const PhotoToolScreen(),
      const RemindersScreen(),
      const GuidesScreen(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _openTab,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.marigold.withValues(alpha: 0.35),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr(S.tabHome)),
          NavigationDestination(icon: const Icon(Icons.photo_camera_outlined), selectedIcon: const Icon(Icons.photo_camera), label: tr(S.tabPhoto)),
          NavigationDestination(icon: const Icon(Icons.notifications_outlined), selectedIcon: const Icon(Icons.notifications), label: tr(S.tabReminders)),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), selectedIcon: const Icon(Icons.menu_book), label: tr(S.tabGuides)),
        ],
      ),
    );
  }
}
