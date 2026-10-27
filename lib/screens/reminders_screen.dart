import 'package:flutter/material.dart';

import '../models/doc_item.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        onPressed: () => showDocEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Add document'),
      ),
      body: ListenableBuilder(
        listenable: DocStore.instance,
        builder: (context, _) {
          final docs = DocStore.instance.docs;
          final urgent = docs.where((d) => d.status == DocStatus.urgent).length;
          final soon = docs.where((d) => d.status == DocStatus.soon).length;
          final ok = docs.length - urgent - soon;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              const Text('My Documents', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const Text('मेरे कागज़ · expiry reminders', style: TextStyle(fontSize: 14, color: AppColors.muted)),
              const SizedBox(height: 14),
              Row(children: [
                _Count('$urgent', 'Urgent (≤7 days)', AppColors.orangeBg, AppColors.orangeText),
                const SizedBox(width: 8),
                _Count('$soon', 'This month', AppColors.amberBg, AppColors.amberText),
                const SizedBox(width: 8),
                _Count('$ok', 'All good', AppColors.greenBg, AppColors.greenText),
              ]),
              const SizedBox(height: 14),
              if (docs.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No documents yet.\nTap "Add document" and add your DL, PUC, insurance or passport expiry date.',
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ),
              for (final d in docs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DocTile(doc: d),
                ),
              const SizedBox(height: 6),
              const Text(
                'Tip: tap ⋮ › "Add to Calendar" on a document. Your phone calendar will then '
                'remind you even if this app is closed.',
                style: TextStyle(fontSize: 13, color: AppColors.muted, height: 1.4),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Count extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color fg;
  const _Count(this.value, this.label, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: fg)),
          Text(label, style: TextStyle(fontSize: 12, color: fg)),
        ]),
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  final DocItem doc;
  const _DocTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    final (Color dot, Color bg, Color fg) = switch (doc.status) {
      DocStatus.urgent => (AppColors.orange, AppColors.orangeBg, AppColors.orangeText),
      DocStatus.soon => (const Color(0xFFD99A1E), AppColors.amberBg, AppColors.amberText),
      DocStatus.ok => (AppColors.green, AppColors.greenBg, AppColors.greenText),
    };
    final detail = [
      if (doc.label.isNotEmpty) doc.label,
      '${doc.daysLeft < 0 ? 'expired' : 'expires'} ${formatDate(doc.expiry)}',
    ].join(' · ');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showDocEditor(context, existing: doc),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
          child: Row(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(doc.type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text(detail, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
              ]),
            ),
            Pill(formatDaysLeft(doc.daysLeft), background: bg, foreground: fg),
            PopupMenuButton<String>(
              tooltip: 'More',
              onSelected: (v) async {
                if (v == 'calendar') {
                  await openLink(context, calendarLink(doc));
                } else if (v == 'delete') {
                  await DocStore.instance.remove(doc.id);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'calendar', child: Text('Add to Calendar')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

/// Google Calendar "add event" link. The event is placed 7 days before
/// expiry (or today if that has passed), so there is time to renew.
String calendarLink(DocItem doc) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  var day = DateTime(doc.expiry.year, doc.expiry.month, doc.expiry.day)
      .subtract(const Duration(days: 7));
  if (day.isBefore(today)) day = today;
  final next = day.add(const Duration(days: 1));
  String f(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
  final title = 'Renew ${doc.type}${doc.label.isEmpty ? '' : ' (${doc.label})'}';
  final details = '${doc.type} expires on ${formatDate(doc.expiry)}. Reminder from Form Saathi.';
  return Uri.https('calendar.google.com', '/calendar/render', {
    'action': 'TEMPLATE',
    'text': title,
    'dates': '${f(day)}/${f(next)}',
    'details': details,
  }).toString();
}

/// Bottom sheet to add a new document or edit an existing one.
Future<void> showDocEditor(BuildContext context, {DocItem? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _DocEditor(existing: existing),
  );
}

class _DocEditor extends StatefulWidget {
  final DocItem? existing;
  const _DocEditor({this.existing});

  @override
  State<_DocEditor> createState() => _DocEditorState();
}

class _DocEditorState extends State<_DocEditor> {
  late String _type = widget.existing?.type ?? docTypes.first;
  late final _labelCtrl = TextEditingController(text: widget.existing?.label ?? '');
  late DateTime? _expiry = widget.existing?.expiry;

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiry ?? now.add(const Duration(days: 30)),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 30),
      helpText: 'Expiry date',
    );
    if (picked != null) setState(() => _expiry = picked);
  }

  Future<void> _save() async {
    final expiry = _expiry;
    if (expiry == null) {
      showMessage(context, 'Please choose the expiry date');
      return;
    }
    await DocStore.instance.upsert(DocItem(
      id: widget.existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      label: _labelCtrl.text.trim(),
      expiry: expiry,
    ));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.existing == null ? 'Add document' : 'Edit document',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: docTypes.contains(_type) ? _type : docTypes.last,
            decoration: const InputDecoration(labelText: 'Document', border: OutlineInputBorder()),
            items: [for (final t in docTypes) DropdownMenuItem(value: t, child: Text(t))],
            onChanged: (v) => setState(() => _type = v ?? _type),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _labelCtrl,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              hintText: 'e.g. HR06AB1234 or Papa\'s DL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.event),
            label: Text(_expiry == null ? 'Choose expiry date' : 'Expires ${formatDate(_expiry!)}'),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
