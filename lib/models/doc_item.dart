import '../l10n/lang.dart';

/// One document the user wants to be reminded about (DL, PUC, passport...).
class DocItem {
  final String id;
  final String type; // stored key, always English, e.g. "PUC Certificate"
  final String label; // optional, e.g. vehicle number "HR06AB1234"
  final DateTime expiry;

  const DocItem({
    required this.id,
    required this.type,
    required this.label,
    required this.expiry,
  });

  /// Days from today until expiry. Negative means already expired.
  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(expiry.year, expiry.month, expiry.day);
    return end.difference(today).inDays;
  }

  /// urgent = 7 days or less, soon = within 30 days, ok = later.
  DocStatus get status {
    final d = daysLeft;
    if (d <= 7) return DocStatus.urgent;
    if (d <= 30) return DocStatus.soon;
    return DocStatus.ok;
  }

  /// The document name in the chosen language.
  String get typeName => docTypeName(type);

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'label': label,
        'expiry': expiry.toIso8601String(),
      };

  factory DocItem.fromJson(Map<String, dynamic> j) => DocItem(
        id: j['id'] as String,
        type: j['type'] as String,
        label: (j['label'] as String?) ?? '',
        expiry: DateTime.parse(j['expiry'] as String),
      );
}

enum DocStatus { urgent, soon, ok }

/// Stored keys (English) and their display names.
const docTypeNames = <String, L>{
  'Driving Licence': L('Driving Licence', 'ड्राइविंग लाइसेंस'),
  'Vehicle RC': L('Vehicle RC', 'वाहन RC'),
  'PUC Certificate': L('PUC Certificate', 'PUC प्रमाणपत्र'),
  'Vehicle Insurance': L('Vehicle Insurance', 'वाहन बीमा'),
  'Passport': L('Passport', 'पासपोर्ट'),
  'Visa': L('Visa', 'वीज़ा'),
  'FASTag KYC': L('FASTag KYC', 'FASTag KYC'),
  'Health Insurance': L('Health Insurance', 'स्वास्थ्य बीमा'),
  'Other': L('Other', 'अन्य'),
};

List<String> get docTypes => docTypeNames.keys.toList();

String docTypeName(String key) => docTypeNames[key]?.text ?? key;

/// "31 Oct 2026" / "31 अक्टू 2026"
String formatDate(DateTime d) {
  const en = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const hi = ['जन', 'फर', 'मार्च', 'अप्रै', 'मई', 'जून', 'जुला', 'अग', 'सितं', 'अक्टू', 'नवं', 'दिसं'];
  final m = LangController.instance.isHindi ? hi : en;
  return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
}

/// "6 days", "3 months", "2.4 yrs" (or the Hindi version).
String formatDaysLeft(int days) {
  final hi = LangController.instance.isHindi;
  if (days < 0) return hi ? 'खत्म' : 'Expired';
  if (days == 0) return hi ? 'आज' : 'Today';
  if (days == 1) return hi ? '1 दिन' : '1 day';
  if (days < 60) return hi ? '$days दिन' : '$days days';
  if (days < 365) {
    final m = (days / 30).round();
    return hi ? '$m महीने' : '$m months';
  }
  final y = (days / 365).toStringAsFixed(1);
  return hi ? '$y साल' : '$y yrs';
}
