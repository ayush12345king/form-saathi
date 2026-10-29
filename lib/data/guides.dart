import 'package:flutter/material.dart';

import '../l10n/lang.dart';
import 'guide_model.dart';
import 'guides_other.dart';
import 'guides_passport_visa.dart';

export 'guide_model.dart';

const guideCategories = <GuideCategory>[
  GuideCategory('passport', L('Passport', 'पासपोर्ट'), Icons.menu_book),
  GuideCategory('visa', L('Visa & abroad', 'वीज़ा और विदेश'), Icons.flight_takeoff),
  GuideCategory('id', L('ID cards', 'पहचान पत्र'), Icons.badge_outlined),
  GuideCategory('vehicle', L('Vehicle & DL', 'वाहन और DL'), Icons.two_wheeler),
  GuideCategory('certificates', L('Certificates', 'प्रमाणपत्र'), Icons.workspace_premium_outlined),
  GuideCategory('money', L('PF & benefits', 'PF और योजनाएं'), Icons.account_balance_outlined),
  GuideCategory('exams', L('Exams & jobs', 'परीक्षा और नौकरी'), Icons.school_outlined),
  GuideCategory('scams', L('Scam alerts', 'धोखे से बचें'), Icons.shield_outlined),
];

const guides = <Guide>[...passportVisaGuides, ...otherGuides];

/// Shown on the Home screen.
const popularGuideIds = ['passport_fresh', 'visa_basics', 'pan_aadhaar', 'scams'];

Guide guideById(String id) => guides.firstWhere((g) => g.id == id);

GuideCategory categoryById(String id) => guideCategories.firstWhere((c) => c.id == id);
