import 'package:flutter_test/flutter_test.dart';
import 'package:form_saathi/models/doc_item.dart';

// Run with:  flutter test
void main() {
  test('days-left text', () {
    expect(formatDaysLeft(-2), 'Expired');
    expect(formatDaysLeft(0), 'Today');
    expect(formatDaysLeft(6), '6 days');
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
}
