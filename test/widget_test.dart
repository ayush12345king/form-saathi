import 'package:flutter_test/flutter_test.dart';
import 'package:form_saathi/data/checklists.dart';
import 'package:form_saathi/data/guides.dart';
import 'package:form_saathi/l10n/lang.dart';
import 'package:form_saathi/models/doc_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Run with:  flutter test
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('days-left text in both languages', () async {
    await LangController.instance.set(AppLang.en);
    expect(formatDaysLeft(-2), 'Expired');
    expect(formatDaysLeft(6), '6 days');
    await LangController.instance.set(AppLang.hi);
    expect(formatDaysLeft(6), '6 दिन');
  });

  test('expiry status', () {
    final soon = DocItem(
      id: '1',
      type: 'PUC Certificate',
      label: '',
      expiry: DateTime.now().add(const Duration(days: 5)),
    );
    expect(soon.status, DocStatus.urgent);
  });

  test('every guide is complete in both languages', () {
    final ids = <String>{};
    for (final g in guides) {
      expect(ids.add(g.id), isTrue, reason: 'duplicate id ${g.id}');
      expect(guideCategories.any((c) => c.id == g.category), isTrue, reason: g.id);
      for (final t in [g.title, g.summary, ...g.steps.expand((s) => [s.title, s.body]), ...g.tips, ...g.mistakes]) {
        expect(t.en.trim(), isNotEmpty, reason: g.id);
        expect(t.hi.trim(), isNotEmpty, reason: g.id);
      }
      expect(g.steps, isNotEmpty, reason: g.id);
    }
    for (final id in popularGuideIds) {
      expect(ids.contains(id), isTrue, reason: 'popular $id missing');
    }
  });

  test('every checklist is complete in both languages', () {
    for (final c in checklists) {
      expect(c.items, isNotEmpty);
      for (final i in c.items) {
        expect(i.title.hi, isNotEmpty);
        expect(i.note.en, isNotEmpty);
      }
    }
  });
}
