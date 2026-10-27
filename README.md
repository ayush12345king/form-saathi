# Form Saathi — Setup Guide (for beginners)

Form Saathi helps people get government paperwork right the first time:

- **Photo & Signature tool**: resizes and compresses photos/signatures to the exact pixels and KB a form needs (SSC, IBPS, SBI, UPSC, NEET, or custom). Works offline.
- **Expiry reminders**: DL, RC, PUC, insurance, passport. Shows what is expiring and can add a reminder to the phone's Google Calendar.
- **Guides**: step-by-step fixes in Hindi + English, each linking the official website.
- **Checklists**: what documents to carry (passport, licence, exam form, bank account).

---

## Part 1 — Install the tools (one time, about 1 hour)

You need a Windows/Mac/Linux computer with about 10 GB free space.

1. **Install Flutter**: open https://docs.flutter.dev/get-started/install, choose your computer type, then choose **Android** as the app type. Follow every step on that page.
2. **Install Android Studio** (the same page links it). Open it once, let it download the Android SDK, and accept the licences.
3. **Install VS Code** (https://code.visualstudio.com) and add the **Flutter** extension. This is where you'll edit code.
4. Open a terminal (Windows: "Command Prompt") and run:
   ```
   flutter doctor
   ```
   Fix anything with a red ✗ (it tells you how). Yellow warnings about Chrome or Visual Studio don't matter for Android.

## Part 2 — Create the project and add my code

1. In the terminal, go to the folder where you keep projects, then run:
   ```
   flutter create --org com.formsaathi form_saathi
   ```
   This makes a new folder called `form_saathi`.
2. Unzip the files I gave you. Copy them **into** that new `form_saathi` folder and **replace** files when asked:
   - `pubspec.yaml`
   - the whole `lib` folder (delete the old `lib/main.dart` first)
   - `test/widget_test.dart`
   - `android/app/src/main/AndroidManifest.xml`
3. In the terminal:
   ```
   cd form_saathi
   flutter pub get
   ```

## Part 3 — Run it on your phone

1. On your Android phone: **Settings › About phone**, tap **Build number** 7 times. Then **Settings › Developer options** → turn on **USB debugging**.
2. Connect the phone with a USB cable and tap **Allow** on the phone.
3. Run:
   ```
   flutter run
   ```
   The first build takes 5–10 minutes. After that, the app opens on your phone.
4. While it runs, after you change code press **r** in the terminal to see changes instantly.

**If you see an error**, copy the full red error text and paste it to Claude. Most first-time errors are small (a version number or a missing setting).

## Part 4 — Before you publish (important)

- **Check every exam size** in `lib/models/exam_preset.dart` against the latest official notification. These change. Users can edit the numbers in the app, but wrong defaults will cost you ratings.
- **Re-check each guide** in `lib/data/guides.dart` against the official site.
- Test on 2–3 different phones (one cheap/older phone).
- Never use a government logo, emblem or a name that sounds official. The app already shows "not a government app" on every guidance screen; keep that.

## Part 5 — Publish on Google Play

1. Create a **Google Play Console** developer account (one-time fee, about US$25): https://play.google.com/console
2. Follow Flutter's release guide to create your signing key and build the release file: https://docs.flutter.dev/deployment/android
   ```
   flutter build appbundle
   ```
   The file to upload is `build/app/outputs/bundle/release/app-release.aab`.
3. New personal developer accounts must first run a **closed test** with a group of testers for a couple of weeks before going public. Check the current tester count and duration in Play Console when you start. Ask friends, family and exam-prep groups to join.
4. You need a **privacy policy** web page. Simple version: "Form Saathi does not collect personal data. Photos and documents stay on your phone."
5. Store listing: in the description, write clearly **"Not affiliated with any government entity"** and list the official sources your guides link to. Google Play requires this for apps that give government-related information.

## What each file does

| File | What it does |
|---|---|
| `lib/main.dart` | Starts the app, bottom tabs |
| `lib/theme.dart` | Colours and button styles |
| `lib/screens/home_screen.dart` | Home: expiry alert, 4 tool tiles, popular fixes |
| `lib/screens/photo_tool_screen.dart` | Photo & Signature tool screen |
| `lib/services/image_processor.dart` | The real work: crop, resize, clean signature, compress to KB range |
| `lib/models/exam_preset.dart` | Exam sizes (edit these!) |
| `lib/screens/reminders_screen.dart` | Documents list, add/edit, calendar reminder |
| `lib/services/storage.dart` | Saves documents and checklist ticks on the phone |
| `lib/screens/guides_screen.dart` | Guides list and guide page |
| `lib/data/guides.dart` | Guide text (add new guides here) |
| `lib/screens/checklists_screen.dart` | Checklists list and checklist page |
| `lib/data/checklists.dart` | Checklist text |
| `lib/widgets/common.dart` | Disclaimer, small labels, link opener |

## Next versions (plan)

- **v1.1**: in-app notifications for expiry (without needing the calendar), Hindi/English language switch, more exams (RRB, state PSCs, CTET).
- **v1.2**: manual crop for photos, PDF compressor ("under 200 KB"), A4 print layout for passport photos.
- **Money**: one small banner ad (never full-screen) + a ₹49–99 one-time "Pro" unlock (no ads, unlimited documents, batch photos).
