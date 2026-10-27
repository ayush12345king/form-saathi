import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/doc_item.dart';

/// Keeps the user's documents on the phone (no server, no login).
/// Screens listen to it, so the Home screen updates when a reminder changes.
class DocStore extends ChangeNotifier {
  DocStore._();
  static final DocStore instance = DocStore._();

  static const _key = 'docs_v1';
  final List<DocItem> _docs = [];

  /// Documents sorted with the soonest expiry first.
  List<DocItem> get docs {
    final list = List<DocItem>.from(_docs);
    list.sort((a, b) => a.expiry.compareTo(b.expiry));
    return list;
  }

  /// Documents expiring within 30 days (or already expired).
  List<DocItem> get expiringSoon =>
      docs.where((d) => d.daysLeft <= 30).toList();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    _docs.clear();
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _docs.addAll(
            list.map((e) => DocItem.fromJson(e as Map<String, dynamic>)));
      } catch (_) {
        // Corrupt data: start fresh instead of crashing.
      }
    }
    notifyListeners();
  }

  Future<void> upsert(DocItem item) async {
    _docs.removeWhere((d) => d.id == item.id);
    _docs.add(item);
    notifyListeners();
    await _save();
  }

  Future<void> remove(String id) async {
    _docs.removeWhere((d) => d.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(_docs.map((d) => d.toJson()).toList()));
  }
}

/// Remembers which checklist items the user has ticked.
class ChecklistProgress {
  static String _key(String checklistId) => 'checklist_$checklistId';

  static Future<Set<int>> load(String checklistId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key(checklistId)) ?? const [];
    return list.map(int.parse).toSet();
  }

  static Future<void> save(String checklistId, Set<int> done) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key(checklistId), done.map((i) => i.toString()).toList());
  }
}
