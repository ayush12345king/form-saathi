import 'package:flutter/material.dart';

import '../data/checklists.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ChecklistsScreen extends StatelessWidget {
  const ChecklistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checklists · ज़रूरी कागज़')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          for (final c in checklists)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  title: Text('${c.titleHi} · ${c.titleEn}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${c.items.length} items'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ChecklistDetailScreen(checklist: c))),
                ),
              ),
            ),
          const SizedBox(height: 8),
          const Disclaimer(),
        ],
      ),
    );
  }
}

class ChecklistDetailScreen extends StatefulWidget {
  final Checklist checklist;
  const ChecklistDetailScreen({super.key, required this.checklist});

  @override
  State<ChecklistDetailScreen> createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  Set<int> _done = {};

  @override
  void initState() {
    super.initState();
    ChecklistProgress.load(widget.checklist.id).then((saved) {
      if (mounted) setState(() => _done = saved);
    });
  }

  void _toggle(int i) {
    setState(() => _done.contains(i) ? _done.remove(i) : _done.add(i));
    ChecklistProgress.save(widget.checklist.id, _done);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.checklist;
    final total = c.items.length;
    final ready = _done.length;

    return Scaffold(
      appBar: AppBar(title: Text(c.titleEn)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text('${c.titleHi} · ${c.titleEn}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(c.subtitle, style: const TextStyle(fontSize: 15, color: AppColors.muted)),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                Row(children: [
                  const Expanded(child: Text('Ready', style: TextStyle(fontWeight: FontWeight.w700))),
                  Text('$ready of $total', style: const TextStyle(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : ready / total,
                    minHeight: 10,
                    color: AppColors.green,
                    backgroundColor: const Color(0xFFE9E5D9),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < c.items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: CheckboxListTile(
                  value: _done.contains(i),
                  onChanged: (_) => _toggle(i),
                  activeColor: AppColors.green,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(c.items[i].title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        decoration: _done.contains(i) ? TextDecoration.lineThrough : null,
                        color: _done.contains(i) ? AppColors.greenText : AppColors.ink,
                      )),
                  subtitle: Text(c.items[i].note),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text('Rules can change. Confirm on ${c.officialSite} before you go.',
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}
