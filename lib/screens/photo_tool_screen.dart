import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/exam_preset.dart';
import '../services/image_processor.dart';
import '../theme.dart';
import '../widgets/common.dart';

class PhotoToolScreen extends StatefulWidget {
  const PhotoToolScreen({super.key});

  @override
  State<PhotoToolScreen> createState() => _PhotoToolScreenState();
}

class _PhotoToolScreenState extends State<PhotoToolScreen> {
  bool _isSignature = false;
  ExamPreset _preset = examPresets.first;
  late SizeSpec _spec = _preset.photo;

  bool _addStamp = false;
  final _nameCtrl = TextEditingController();
  DateTime _photoDate = DateTime.now();

  Uint8List? _original; // what the user picked
  ProcessResult? _result; // the finished file
  bool _busy = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  // ---------- choosing options ----------

  void _selectTab(bool signature) {
    setState(() {
      _isSignature = signature;
      _spec = signature ? _preset.signature : _preset.photo;
    });
    _reprocess();
  }

  void _selectPreset(ExamPreset p) {
    setState(() {
      _preset = p;
      _spec = _isSignature ? p.signature : p.photo;
      _addStamp = !_isSignature && p.nameDateOnPhoto;
    });
    _reprocess();
  }

  // ---------- picking and processing ----------

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(source: source, imageQuality: 100);
      if (file == null) return; // user cancelled
      _original = await file.readAsBytes();
      await _reprocess();
    } catch (e) {
      if (mounted) showMessage(context, 'Could not open the photo. Please try again.');
    }
  }

  String get _stampText {
    final d = _photoDate;
    final date = '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
    return '${_nameCtrl.text.trim()}  $date';
  }

  Future<void> _reprocess() async {
    final original = _original;
    if (original == null) return;
    setState(() => _busy = true);
    final result = await processImage(
      input: original,
      spec: _spec,
      isSignature: _isSignature,
      stampText: (!_isSignature && _addStamp && _nameCtrl.text.trim().isNotEmpty) ? _stampText : null,
    );
    if (!mounted) return;
    setState(() {
      _result = result;
      _busy = false;
    });
  }

  // ---------- saving ----------

  Future<File> _writeTempFile(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final kind = _isSignature ? 'signature' : 'photo';
    final name = '${kind}_${_preset.id}_${(bytes.length / 1024).ceil()}kb.jpg';
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _saveToGallery() async {
    final bytes = _result?.bytes;
    if (bytes == null) return;
    try {
      if (!await Gal.hasAccess(toAlbum: true)) {
        await Gal.requestAccess(toAlbum: true);
      }
      final file = await _writeTempFile(bytes);
      await Gal.putImage(file.path, album: 'Form Saathi');
      if (mounted) showMessage(context, 'Saved to Gallery › Form Saathi');
    } catch (e) {
      if (mounted) showMessage(context, 'Could not save. Allow photo access in Settings.');
    }
  }

  Future<void> _share() async {
    final bytes = _result?.bytes;
    if (bytes == null) return;
    final file = await _writeTempFile(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Made with Form Saathi');
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const Text('Photo & Signature', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const Text('फोटो और साइन सही साइज़ में', style: TextStyle(fontSize: 14, color: AppColors.muted)),
        const SizedBox(height: 14),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Photo · फोटो'), icon: Icon(Icons.person_outline)),
            ButtonSegment(value: true, label: Text('Sign · साइन'), icon: Icon(Icons.draw_outlined)),
          ],
          selected: {_isSignature},
          onSelectionChanged: (s) => _selectTab(s.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 16),
        const Text('1. Choose your form · फॉर्म चुनें',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.muted)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final p in examPresets)
              ChoiceChip(
                label: Text(p.name),
                selected: p.id == _preset.id,
                onSelected: (_) => _selectPreset(p),
                selectedColor: AppColors.ink,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: p.id == _preset.id ? Colors.white : AppColors.ink,
                ),
                showCheckmark: false,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _SpecEditor(
          spec: _spec,
          onChanged: (s) {
            setState(() => _spec = s);
            _reprocess();
          },
        ),
        const SizedBox(height: 6),
        const Text(
          'These are common sizes. Always match the numbers in your official notification. You can edit them above.',
          style: TextStyle(fontSize: 12, color: AppColors.muted),
        ),
        if (!_isSignature) ...[
          const SizedBox(height: 12),
          _StampOptions(
            enabled: _addStamp,
            nameCtrl: _nameCtrl,
            date: _photoDate,
            onToggle: (v) {
              setState(() => _addStamp = v);
              _reprocess();
            },
            onDateChanged: (d) {
              setState(() => _photoDate = d);
              _reprocess();
            },
            onNameDone: _reprocess,
          ),
        ],
        const SizedBox(height: 16),
        const Text('2. Add your photo · फोटो डालें',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.muted)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _busy ? null : () => _pick(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Gallery'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _busy ? null : () => _pick(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Camera'),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        _ResultCard(result: _result, busy: _busy, spec: _spec, examName: _preset.name),
        if (_result?.bytes != null) ...[
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _busy ? null : _saveToGallery,
            icon: const Icon(Icons.download),
            label: const Text('Save to Gallery'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _busy ? null : _share,
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share (WhatsApp, Drive…)'),
          ),
        ],
        const SizedBox(height: 14),
        const Row(children: [
          Icon(Icons.lock_outline, size: 18, color: AppColors.ink),
          SizedBox(width: 8),
          Expanded(child: Text('Stays on your phone. Nothing is uploaded.', style: TextStyle(fontSize: 14))),
        ]),
      ],
    );
  }
}

/// Four small number boxes: width, height, min KB, max KB.
class _SpecEditor extends StatelessWidget {
  final SizeSpec spec;
  final ValueChanged<SizeSpec> onChanged;

  const _SpecEditor({required this.spec, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget box(String label, int value, SizeSpec Function(int v) update) {
      return Expanded(
        child: TextFormField(
          // Key forces the box to refresh when a new exam is chosen.
          key: ValueKey('$label-$value'),
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onFieldSubmitted: (text) {
            final v = int.tryParse(text);
            if (v != null && v > 0) onChanged(update(v));
          },
        ),
      );
    }

    return Row(children: [
      box('Width px', spec.width, (v) => spec.copyWith(width: v.clamp(20, 3000).toInt())),
      const SizedBox(width: 6),
      box('Height px', spec.height, (v) => spec.copyWith(height: v.clamp(20, 3000).toInt())),
      const SizedBox(width: 6),
      box('Min KB', spec.minKb, (v) => spec.copyWith(minKb: v < spec.maxKb ? v : spec.minKb)),
      const SizedBox(width: 6),
      box('Max KB', spec.maxKb, (v) => spec.copyWith(maxKb: v > spec.minKb ? v : spec.maxKb)),
    ]);
  }
}

class _StampOptions extends StatelessWidget {
  final bool enabled;
  final TextEditingController nameCtrl;
  final DateTime date;
  final ValueChanged<bool> onToggle;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onNameDone;

  const _StampOptions({
    required this.enabled,
    required this.nameCtrl,
    required this.date,
    required this.onToggle,
    required this.onDateChanged,
    required this.onNameDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 8, 12),
        child: Column(children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Name & date on photo', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Some forms (like UPSC) ask for this'),
            value: enabled,
            onChanged: onToggle,
          ),
          if (enabled)
            Row(children: [
              Expanded(
                child: TextField(
                  controller: nameCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Your name', isDense: true),
                  onSubmitted: (_) => onNameDone(),
                  onEditingComplete: onNameDone,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text('${date.day}/${date.month}/${date.year}'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) onDateChanged(picked);
                },
              ),
            ]),
        ]),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ProcessResult? result;
  final bool busy;
  final SizeSpec spec;
  final String examName;

  const _ResultCard({required this.result, required this.busy, required this.spec, required this.examName});

  @override
  Widget build(BuildContext context) {
    final r = result;
    Widget preview;
    if (busy) {
      preview = const SizedBox(width: 110, height: 130, child: Center(child: CircularProgressIndicator()));
    } else if (r?.bytes != null) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(r!.bytes!, width: 110, height: 130, fit: BoxFit.contain),
      );
    } else {
      preview = Container(
        width: 110,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF0F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFB8BDCC), width: 2),
        ),
        child: const Icon(Icons.person_outline, size: 48, color: Color(0xFF8C92A6)),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          preview,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$examName needs', style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                Text('${spec.width} × ${spec.height} px',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text('${spec.minKb} – ${spec.maxKb} KB',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (r != null)
                  Pill(
                    r.fits ? 'Your file: ${r.message}' : r.message,
                    background: r.fits ? AppColors.greenBg : AppColors.orangeBg,
                    foreground: r.fits ? AppColors.greenText : AppColors.orangeText,
                  )
                else
                  const Text('Add a photo to start', style: TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
