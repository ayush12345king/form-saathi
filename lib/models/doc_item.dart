/// One document the user wants to be reminded about (DL, PUC, passport...).
class DocItem {
  final String id;
  final String type; // e.g. "PUC Certificate"
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

const docTypes = <String>[
  'Driving Licence',
  'Vehicle RC',
  'PUC Certificate',
  'Vehicle Insurance',
  'Passport',
  'FASTag KYC',
  'Health Insurance',
  'Other',
];

/// "31 Oct 2026"
String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
}

/// "6 days", "3 months", "2.4 yrs", "Expired 3 days ago"
String formatDaysLeft(int days) {
  if (days < 0) return 'Expired';
  if (days == 0) return 'Today';
  if (days == 1) return '1 day';
  if (days < 60) return '$days days';
  if (days < 365) return '${(days / 30).round()} months';
  return '${(days / 365).toStringAsFixed(1)} yrs';
}
