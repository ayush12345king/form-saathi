import 'package:flutter/material.dart';

import '../l10n/lang.dart';

class GuideStep {
  final L title;
  final L body;
  const GuideStep(this.title, this.body);
}

class GuideCategory {
  final String id;
  final L name;
  final IconData icon;
  const GuideCategory(this.id, this.name, this.icon);
}

class Guide {
  final String id;
  final String category;
  final L title;
  final L summary;
  final int minutes;
  final List<GuideStep> steps;
  final List<L> tips; // "Pro tips": things people don't easily find
  final List<L> mistakes; // common reasons for rejection or delay
  final L? warning; // scam or high-risk alert shown at the top
  final String officialUrl; // '' hides the button
  final L officialLabel;
  final String lastChecked; // when the facts were last verified

  /// Extra words that help search (English and Hindi).
  final String keywords;

  const Guide({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.minutes,
    required this.steps,
    this.tips = const [],
    this.mistakes = const [],
    this.warning,
    required this.officialUrl,
    this.officialLabel = const L('Open official website', 'ऑफिशियल वेबसाइट खोलें'),
    this.lastChecked = 'Oct 2026',
    this.keywords = '',
  });

  /// True if the search text appears anywhere useful, in either language.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final hay = [
      title.en, title.hi, summary.en, summary.hi, keywords,
      ...steps.expand((s) => [s.title.en, s.title.hi]),
    ].join(' ').toLowerCase();
    return q.split(RegExp(r'\s+')).every(hay.contains);
  }
}
