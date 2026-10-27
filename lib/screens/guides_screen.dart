import 'package:flutter/material.dart';

import '../data/guides.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'checklists_screen.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const Text('Guides', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const Text('आसान गाइड · step by step', style: TextStyle(fontSize: 14, color: AppColors.muted)),
        const SizedBox(height: 14),
        Card(
          color: AppColors.ink,
          child: ListTile(
            leading: const Icon(Icons.checklist, color: AppColors.marigold),
            title: const Text('Document checklists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            subtitle: const Text('Passport, licence, exam form, bank', style: TextStyle(color: Color(0xFFC9CEE0))),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChecklistsScreen())),
          ),
        ),
        const SizedBox(height: 12),
        for (final g in guides)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                title: Text(g.titleHi, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                subtitle: Text(g.titleEn),
                trailing: Pill('${g.minutes} min'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GuideDetailScreen(guide: g))),
              ),
            ),
          ),
        const SizedBox(height: 8),
        const Disclaimer(),
      ],
    );
  }
}

class GuideDetailScreen extends StatefulWidget {
  final Guide guide;
  const GuideDetailScreen({super.key, required this.guide});

  @override
  State<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  final Set<int> _done = {};

  @override
  Widget build(BuildContext context) {
    final g = widget.guide;
    return Scaffold(
      appBar: AppBar(title: const Text('Guide')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(g.titleHi, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 2),
          Text(g.titleEn, style: const TextStyle(fontSize: 15, color: AppColors.muted)),
          const SizedBox(height: 8),
          Row(children: [Pill('${g.minutes} min')]),
          if (g.warning != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.orangeBg, borderRadius: BorderRadius.circular(12)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.orangeText),
                const SizedBox(width: 10),
                Expanded(child: Text(g.warning!, style: const TextStyle(color: AppColors.orangeText, height: 1.35))),
              ]),
            ),
          ],
          const SizedBox(height: 16),
          for (var i = 0; i < g.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => _done.contains(i) ? _done.remove(i) : _done.add(i)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: _done.contains(i) ? AppColors.green : AppColors.ink,
                        child: _done.contains(i)
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(g.steps[i].title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _done.contains(i) ? AppColors.greenText : AppColors.ink,
                              )),
                          const SizedBox(height: 2),
                          Text(g.steps[i].body, style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.35)),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          if (g.officialUrl.isNotEmpty) ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => openLink(context, g.officialUrl),
              icon: const Icon(Icons.open_in_new),
              label: Text(g.officialLabel),
            ),
          ],
          const SizedBox(height: 14),
          const Disclaimer(),
        ],
      ),
    );
  }
}
