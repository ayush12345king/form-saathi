import 'package:flutter/material.dart';

import '../data/guides.dart';
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
        const _Header(),
        const SizedBox(height: 18),
        const Text('आज कौन सा काम है?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.2)),
        const Text('What paperwork can we help with today?',
            style: TextStyle(fontSize: 15, color: AppColors.muted)),
        const SizedBox(height: 16),

        // Expiry alert, updates live when reminders change.
        ListenableBuilder(
          listenable: DocStore.instance,
          builder: (context, _) {
            final soon = DocStore.instance.expiringSoon;
            if (soon.isEmpty) return const SizedBox.shrink();
            final summary = soon
                .take(2)
                .map((d) => '${d.type} ${d.daysLeft < 0 ? 'expired' : 'in ${formatDaysLeft(d.daysLeft)}'}')
                .join(' · ');
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
                  onTap: () => onOpenTab(2),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      const Icon(Icons.notifications_active_outlined, color: Color(0xFF8A5A00), size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${soon.length} document${soon.length == 1 ? '' : 's'} expiring soon',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            Text(summary,
                                style: const TextStyle(fontSize: 14, color: AppColors.amberText)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.15,
          children: [
            _Tile(
              icon: Icons.photo_camera_outlined,
              title: 'Photo & Sign\nफोटो-साइन',
              subtitle: 'Exact KB for any form',
              dark: true,
              onTap: () => onOpenTab(1),
            ),
            _Tile(
              icon: Icons.event_outlined,
              title: 'Reminders\nरिमाइंडर',
              subtitle: 'DL, RC, PUC, passport',
              onTap: () => onOpenTab(2),
            ),
            _Tile(
              icon: Icons.menu_book_outlined,
              title: 'Guides\nआसान गाइड',
              subtitle: 'Step by step, in Hindi',
              onTap: () => onOpenTab(3),
            ),
            _Tile(
              icon: Icons.checklist,
              title: 'Checklists\nज़रूरी कागज़',
              subtitle: 'Know what to carry',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ChecklistsScreen())),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('POPULAR FIXES',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.6)),
        const SizedBox(height: 8),
        for (final g in guides.take(3))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                title: Text(g.titleHi, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Text('${g.minutes} min', style: const TextStyle(color: AppColors.muted)),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GuideDetailScreen(guide: g))),
              ),
            ),
          ),
        const SizedBox(height: 12),
        const Disclaimer(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.task_outlined, color: AppColors.marigold, size: 20),
      ),
      const SizedBox(width: 10),
      const Text('Form Saathi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
    ]);
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool dark;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.dark = false,
  });

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: dark ? AppColors.marigold : AppColors.ink, size: 28),
              const Spacer(),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.2, color: fg)),
              const SizedBox(height: 2),
              Text(subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: dark ? const Color(0xFFC9CEE0) : AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
