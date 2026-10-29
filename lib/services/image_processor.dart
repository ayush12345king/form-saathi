import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../models/exam_preset.dart';

enum ProcessError { unreadable, tooBig }

class ProcessResult {
  final Uint8List? bytes; // the final JPG, null if something failed
  final bool fits; // true if size is inside the KB range
  final ProcessError? error; // why it failed, if it failed

  const ProcessResult({this.bytes, required this.fits, this.error});

  int get sizeKb => bytes == null ? 0 : (bytes!.length / 1024).ceil();
}

/// Turns any photo into an upload-ready JPG with the exact pixel size and
/// a file size inside [spec.minKb]..[spec.maxKb].
///
/// Runs in a background isolate so the app never freezes.
/// [stampText] (e.g. "RAHUL KUMAR 25.10.2026") is printed under the photo
/// when the form asks for name and date on the photo.
Future<ProcessResult> processImage({
  required Uint8List input,
  required SizeSpec spec,
  required bool isSignature,
  String? stampText,
}) {
  return Isolate.run(() => _process(input, spec, isSignature, stampText));
}

ProcessResult _process(
    Uint8List input, SizeSpec spec, bool isSignature, String? stampText) {
  final decoded = img.decodeImage(input);
  if (decoded == null) {
    return const ProcessResult(fits: false, error: ProcessError.unreadable);
  }

  // 1. Fix phone rotation and shrink huge camera photos (faster, same result).
  var src = img.bakeOrientation(decoded);
  if (src.width > 2000 || src.height > 2000) {
    src = src.width >= src.height
        ? img.copyResize(src, width: 2000, interpolation: img.Interpolation.average)
        : img.copyResize(src, height: 2000, interpolation: img.Interpolation.average);
  }

  // 2. Put it on a white background (handles transparent PNG signatures).
  final flat = img.Image(width: src.width, height: src.height);
  img.fill(flat, color: img.ColorRgb8(255, 255, 255));
  img.compositeImage(flat, src);

  final w = spec.width;
  final h = spec.height;
  final canvas = img.Image(width: w, height: h);
  img.fill(canvas, color: img.ColorRgb8(255, 255, 255));

  if (isSignature) {
    _placeSignature(flat, canvas);
  } else {
    _placePhoto(flat, canvas, stampText);
  }

  return _compressToRange(canvas, spec);
}

/// Signature: clean paper to pure white, darken the ink, cut away empty
/// paper around it, then fit it in the middle (never cropping the ink).
void _placeSignature(img.Image flat, img.Image canvas) {
  for (final p in flat) {
    final lum = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
    if (lum > 150) {
      p.r = 255;
      p.g = 255;
      p.b = 255;
    } else {
      final v = lum * 0.4; // make the ink darker and sharper
      p.r = v;
      p.g = v;
      p.b = v;
    }
  }

  var sig = img.trim(flat, mode: img.TrimMode.topLeftColor);
  if (sig.width < 5 || sig.height < 5) sig = flat; // nothing found to trim

  final scaleW = canvas.width * 0.9 / sig.width;
  final scaleH = canvas.height * 0.9 / sig.height;
  final scale = scaleW < scaleH ? scaleW : scaleH;
  final newW = (sig.width * scale).round().clamp(1, canvas.width).toInt();
  final newH = (sig.height * scale).round().clamp(1, canvas.height).toInt();
  final resized = img.copyResize(sig,
      width: newW, height: newH, interpolation: img.Interpolation.average);

  img.compositeImage(canvas, resized,
      dstX: (canvas.width - newW) ~/ 2, dstY: (canvas.height - newH) ~/ 2);
}

/// Photo: crop to the right shape (keeping the face area, which is usually
/// in the upper part), resize, and optionally print name + date below.
void _placePhoto(img.Image flat, img.Image canvas, String? stampText) {
  final stamp = stampText?.trim() ?? '';
  final hasStamp = stamp.isNotEmpty;
  final int stripH =
      hasStamp ? (canvas.height * 0.16).round().clamp(18, 120).toInt() : 0;
  final photoH = canvas.height - stripH;
  final targetRatio = canvas.width / photoH;

  // Crop the source to the same shape as the target.
  int cropW, cropH;
  if (flat.width / flat.height > targetRatio) {
    cropH = flat.height;
    cropW = (flat.height * targetRatio).round();
  } else {
    cropW = flat.width;
    cropH = (flat.width / targetRatio).round();
  }
  final x = (flat.width - cropW) ~/ 2;
  final y = ((flat.height - cropH) * 0.35).round(); // bias towards the top
  final cropped = img.copyCrop(flat, x: x, y: y, width: cropW, height: cropH);
  final resized = img.copyResize(cropped,
      width: canvas.width,
      height: photoH,
      interpolation: img.Interpolation.average);
  img.compositeImage(canvas, resized, dstX: 0, dstY: 0);

  if (hasStamp) {
    final font = canvas.width >= 320 ? img.arial24 : img.arial14;
    final int textY =
        photoH + ((stripH - font.lineHeight) ~/ 2).clamp(0, stripH).toInt();
    img.drawString(canvas, stamp.toUpperCase(),
        font: font, x: 4, y: textY, color: img.ColorRgb8(0, 0, 0));
  }
}

/// Finds the best JPG quality that stays under the maximum size.
/// If the file is still smaller than the minimum (very small/simple images),
/// it adds harmless padding inside the JPG so portals accept it.
ProcessResult _compressToRange(img.Image canvas, SizeSpec spec) {
  // Use 1000 bytes for max and 1024 for min, so it is safe on every portal.
  final maxBytes = spec.maxKb * 1000;
  final minBytes = spec.minKb * 1024;

  Uint8List? best;
  var lo = 10, hi = 95;
  while (lo <= hi) {
    final mid = (lo + hi) ~/ 2;
    final bytes = img.encodeJpg(canvas, quality: mid);
    if (bytes.length <= maxBytes) {
      best = bytes;
      lo = mid + 1; // try better quality
    } else {
      hi = mid - 1;
    }
  }

  if (best == null) {
    final smallest = img.encodeJpg(canvas, quality: 5);
    if (smallest.length <= maxBytes) best = smallest;
  }
  if (best == null) {
    return const ProcessResult(fits: false, error: ProcessError.tooBig);
  }

  if (best.length < minBytes) {
    best = _padJpeg(best, minBytes);
  }

  final ok = best.length <= maxBytes && best.length >= minBytes;
  return ProcessResult(bytes: best, fits: ok);
}

/// Adds a JPG "comment" block right after the file header. Image viewers
/// ignore it; it only makes the file bigger.
Uint8List _padJpeg(Uint8List jpg, int targetBytes) {
  final out = BytesBuilder();
  out.add(jpg.sublist(0, 2)); // FF D8 (start of image)
  var missing = targetBytes - jpg.length + 64;
  while (missing > 0) {
    final chunk = missing > 60000 ? 60000 : missing;
    final segLen = chunk + 2; // length field counts itself
    out.add([0xFF, 0xFE, (segLen >> 8) & 0xFF, segLen & 0xFF]);
    out.add(Uint8List(chunk)); // zeros
    missing -= chunk + 4;
  }
  out.add(jpg.sublist(2));
  return out.toBytes();
}
