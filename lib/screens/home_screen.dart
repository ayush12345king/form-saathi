import 'package:flutter/material.dart';

import '../data/guides.dart';
import '../l10n/lang.dart';
import '../l10n/strings.dart';
import '../models/doc_item.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'checklists_screen.dart';
import 'guides_screen.dart';

class HomeScreen extends StatelessWidget {
  /// Switches the bottom tab (1 = Photo, 2 = Reminders, 3 = Guides).
  final void Function(int tab) onOpenTab;

  const HomeScreen({super.key, required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.task_outlined, color: AppColors.marigold, size: 20),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Text('Form Saathi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
          const LanguageToggle(),
        ]),
        const SizedBox(height: 18),
        Text(tr(S.homeQuestion), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.2)),
        const SizedBox(height: 2),
        Text(tr(S.homeSub), style: const TextStyle(fontSize: 15, color: AppColors.muted)),
        const SizedBox(height: 16),
        _ExpiryAlert(onTap: () => onOpenTab(2)),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: [
            _Tile(icon: Icons.photo_camera_outlined, title: tr(S.tilePhoto), subtitle: tr(S.tilePhotoSub), dark: true, onTap: () => onOpenTab(1)),
            _Tile(icon: Icons.event_outlined, title: tr(S.tileReminders), subtitle: tr(S.tileRemindersSub), onTap: () => onOpenTab(2)),
            _Tile(icon: Icons.menu_book_outlined, title: tr(S.tileGuides), subtitle: tr(S.tileGuidesSub), onTap: () => onOpenTab(3)),
            _Tile(
              icon: Icons.checklist,
              title: tr(S.tileChecklists),
              subtitle: tr(S.tileChecklistsSub),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChecklistsScreen())),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SectionLabel(tr(S.browseTopics)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in guideCategories)
              ActionChip(
                avatar: Icon(c.icon, size: 18, color: AppColors.ink),
                label: Text(tr(c.name), style: const TextStyle(fontWeight: FontWeight.w600)),
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.line),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GuidesScreen(initialCategory: c.id, standalone: true))),
              ),
          ],
        ),
        const SizedBox(height: 22),
        SectionLabel(tr(S.popular)),
        for (final id in popularGuideIds) GuideTile(guide: guideById(id)),
        const SizedBox(height: 12),
        const Disclaimer(),
      ],
    );
  }
}

class _ExpiryAlert extends StatelessWidget {
  final VoidCallback onTap;
  const _ExpiryAlert({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: DocStore.instance,
      builder: (context, _) {
        final soon = DocStore.instance.expiringSoon;
        if (soon.isEmpty) return const SizedBox.shrink();
        final summary = soon
            .take(2)
            .map((d) => d.daysLeft < 0
                ? '${d.typeName} ${tr(S.expiredWord)}'
                : '${d.typeName}: ${formatDaysLeft(d.daysLeft)}')
            .join(' · ');
        final count = '${soon.length} ${soon.length == 1 ? tr(S.documentWord) : tr(S.documentsWord)} ${tr(S.expiringSoon)}';
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: AppColors.amberBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFF2C46B)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  const Icon(Icons.notifications_active_outlined, color: Color(0xFF8A5A00), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(summary, style: const TextStyle(fontSize: 14, color: AppColors.amberText)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool dark;
  final VoidCallback onTap;

  const _Tile({required this.icon, required this.title, required this.subtitle, required this.onTap, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.ink;
    return Material(
      color: dark ? AppColors.ink : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: dark ? BorderSide.none : const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: dark ? AppColors.marigold : AppColors.ink, size: 28),
            const Spacer(),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: fg)),
            const SizedBox(height: 2),
            Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, height: 1.25, color: dark ? const Color(0xFFC9CEE0) : AppColors.muted)),
          ]),
        ),
      ),
    );
  }
}
