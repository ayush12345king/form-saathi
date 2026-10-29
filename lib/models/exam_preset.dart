import '../l10n/lang.dart';

/// Size rules for one upload (a photo or a signature).
class SizeSpec {
  final int width; // pixels
  final int height; // pixels
  final int minKb;
  final int maxKb;

  const SizeSpec({
    required this.width,
    required this.height,
    required this.minKb,
    required this.maxKb,
  });

  SizeSpec copyWith({int? width, int? height, int? minKb, int? maxKb}) =>
      SizeSpec(
        width: width ?? this.width,
        height: height ?? this.height,
        minKb: minKb ?? this.minKb,
        maxKb: maxKb ?? this.maxKb,
      );
}

/// A form/exam with its usual photo and signature rules.
class ExamPreset {
  final String id;
  final L name;
  final SizeSpec photo;
  final SizeSpec signature;

  /// Some forms (e.g. UPSC) want your name and the photo date printed
  /// at the bottom of the photo.
  final bool nameDateOnPhoto;

  const ExamPreset({
    required this.id,
    required this.name,
    required this.photo,
    required this.signature,
    this.nameDateOnPhoto = false,
  });
}

/// IMPORTANT: these are the commonly published sizes, but every
/// notification can change them. The app always lets the user edit the
/// numbers, and tells them to check their official notification.
/// Update this list as new notifications come out.
const examPresets = <ExamPreset>[
  ExamPreset(
    id: 'ssc',
    name: L('SSC', 'SSC'),
    photo: SizeSpec(width: 350, height: 450, minKb: 20, maxKb: 50),
    signature: SizeSpec(width: 400, height: 200, minKb: 10, maxKb: 20),
  ),
  ExamPreset(
    id: 'ibps',
    name: L('IBPS', 'IBPS'),
    photo: SizeSpec(width: 200, height: 230, minKb: 20, maxKb: 50),
    signature: SizeSpec(width: 140, height: 60, minKb: 10, maxKb: 20),
  ),
  ExamPreset(
    id: 'sbi',
    name: L('SBI', 'SBI'),
    photo: SizeSpec(width: 200, height: 230, minKb: 20, maxKb: 50),
    signature: SizeSpec(width: 140, height: 60, minKb: 10, maxKb: 20),
  ),
  ExamPreset(
    id: 'upsc',
    name: L('UPSC', 'UPSC'),
    photo: SizeSpec(width: 400, height: 500, minKb: 20, maxKb: 200),
    signature: SizeSpec(width: 700, height: 350, minKb: 20, maxKb: 100),
    nameDateOnPhoto: true,
  ),
  ExamPreset(
    id: 'neet',
    name: L('NEET', 'NEET'),
    photo: SizeSpec(width: 413, height: 531, minKb: 10, maxKb: 200),
    signature: SizeSpec(width: 400, height: 160, minKb: 4, maxKb: 30),
  ),
  // US visa: square photo, 600x600 to 1200x1200 px, JPEG, max 240 KB.
  ExamPreset(
    id: 'us_visa',
    name: L('US Visa', 'US वीज़ा'),
    photo: SizeSpec(width: 600, height: 600, minKb: 20, maxKb: 240),
    signature: SizeSpec(width: 300, height: 120, minKb: 10, maxKb: 20),
  ),
  ExamPreset(
    id: 'custom',
    name: L('Other / Custom', 'अन्य / अपना साइज़'),
    photo: SizeSpec(width: 300, height: 400, minKb: 20, maxKb: 50),
    signature: SizeSpec(width: 300, height: 120, minKb: 10, maxKb: 20),
  ),
];
