import 'package:flutter/material.dart';

import '../data/guides.dart';
import '../l10n/lang.dart';
import '../l10n/strings.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'checklists_screen.dart';

/// List of all guides with search and topic filters.
/// [standalone] = opened from Home (has its own back bar).
class GuidesScreen extends StatefulWidget {
  final String? initialCategory;
  final bool standalone;

  const GuidesScreen({super.key, this.initialCategory, this.standalone = false});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  late String? _category = widget.initialCategory;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final list = guides
        .where((g) => _category == null || g.category == _category)
        .where((g) => g.matches(_query))
        .toList();

    final body = ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        if (!widget.standalone) ...[
          Text(tr(S.guidesTitle), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          Text(tr(S.guidesSub), style: const TextStyle(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 14),
        ],
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: tr(S.search),
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.line)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.line)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _chip(tr(S.all), _category == null, () => setState(() => _category = null)),
              for (final c in guideCategories) _chip(tr(c.name), _category == c.id, () => setState(() => _category = c.id)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_category == null && _query.isEmpty) ...[
          Card(
            color: AppColors.ink,
            child: ListTile(
              leading: const Icon(Icons.checklist, color: AppColors.marigold),
              title: Text(tr(S.checklistsCard), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              subtitle: Text(tr(S.checklistsCardSub), style: const TextStyle(color: Color(0xFFC9CEE0))),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChecklistsScreen())),
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(tr(S.noResults), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          ),
        for (final g in list) GuideTile(guide: g),
        const SizedBox(height: 8),
        const Disclaimer(),
      ],
    );

    if (!widget.standalone) return body;
    final title = _category == null ? tr(S.guidesTitle) : tr(categoryById(_category!).name);
    return Scaffold(appBar: AppBar(title: Text(title)), body: body);
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.ink,
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.line),
        labelStyle: TextStyle(fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.ink),
      ),
    );
  }
}

/// One guide row, used on Home and in lists.
class GuideTile extends StatelessWidget {
  final Guide guide;
  const GuideTile({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final cat = categoryById(guide.category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFEFEBDF),
            child: Icon(cat.icon, color: AppColors.ink, size: 20),
          ),
          title: Text(tr(guide.title), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          subtitle: Text(tr(guide.summary), maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: guide.warning != null
              ? const Icon(Icons.warning_amber_rounded, color: AppColors.orange, size: 20)
              : const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GuideDetailScreen(guide: guide))),
        ),
      ),
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
      appBar: AppBar(title: Text(tr(categoryById(g.category).name))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Text(tr(g.title), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 4),
          Text(tr(g.summary), style: const TextStyle(fontSize: 15, color: AppColors.muted)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 6, children: [
            Pill('${g.minutes} ${tr(S.minWord)}'),
            Pill('${tr(S.lastChecked)}: ${g.lastChecked}', background: AppColors.greenBg, foreground: AppColors.greenText),
          ]),
          if (g.warning != null) ...[
            const SizedBox(height: 14),
            _Callout(icon: Icons.warning_amber_rounded, text: tr(g.warning!), bg: AppColors.orangeBg, fg: AppColors.orangeText),
          ],
          const SizedBox(height: 18),
          SectionLabel(tr(S.steps)),
          for (var i = 0; i < g.steps.length; i++) _stepCard(i, g.steps[i]),
          if (g.tips.isNotEmpty) ...[
            const SizedBox(height: 14),
            SectionLabel(tr(S.proTips)),
            for (final t in g.tips)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Callout(icon: Icons.lightbulb_outline, text: tr(t), bg: AppColors.amberBg, fg: AppColors.amberText),
              ),
          ],
          if (g.mistakes.isNotEmpty) ...[
            const SizedBox(height: 14),
            SectionLabel(tr(S.mistakes)),
            for (final m in g.mistakes)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Callout(icon: Icons.close_rounded, text: tr(m), bg: Colors.white, fg: AppColors.ink, iconColor: AppColors.orange),
              ),
          ],
          if (g.officialUrl.isNotEmpty) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => openLink(context, g.officialUrl),
              icon: const Icon(Icons.open_in_new),
              label: Text(tr(g.officialLabel)),
            ),
          ],
          const SizedBox(height: 16),
          const Disclaimer(),
        ],
      ),
    );
  }

  Widget _stepCard(int i, GuideStep step) {
    final done = _done.contains(i);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => done ? _done.remove(i) : _done.add(i)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: done ? AppColors.green : AppColors.ink,
                child: done
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tr(step.title),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: done ? AppColors.greenText : AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(tr(step.body), style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.4)),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color bg;
  final Color fg;
  final Color? iconColor;

  const _Callout({required this.icon, required this.text, required this.bg, required this.fg, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: bg == Colors.white ? Border.all(color: AppColors.line) : null,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: iconColor ?? fg, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(color: fg, fontSize: 14, height: 1.4))),
      ]),
    );
  }
}
