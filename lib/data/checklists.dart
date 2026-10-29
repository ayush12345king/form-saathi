import '../l10n/lang.dart';

/// "What do I need to carry?" lists. Rules can change; each list names the
/// official site so users can confirm.
class ChecklistItem {
  final L title;
  final L note;
  const ChecklistItem(this.title, this.note);
}

class Checklist {
  final String id;
  final L title;
  final L subtitle;
  final List<ChecklistItem> items;
  final L officialSite;

  const Checklist({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.officialSite,
  });
}

const checklists = <Checklist>[
  Checklist(
    id: 'passport',
    title: L('New passport', 'नया पासपोर्ट'),
    subtitle: L('Carry originals + 1 set of self-attested copies to the PSK', 'PSK पर असली दस्तावेज़ + 1 सेट स्व-प्रमाणित कॉपी ले जाएं'),
    officialSite: L('passportindia.gov.in', 'passportindia.gov.in'),
    items: [
      ChecklistItem(L('Appointment receipt', 'अपॉइंटमेंट रसीद'), L('Printout or SMS with your ARN', 'प्रिंट या ARN वाला SMS')),
      ChecklistItem(L('Aadhaar card', 'आधार कार्ड'), L('Proof of address and identity', 'पता और पहचान का प्रमाण')),
      ChecklistItem(L('Date of birth proof', 'जन्मतिथि प्रमाण'), L('Birth certificate, PAN or 10th marksheet', 'जन्म प्रमाणपत्र, PAN या 10वीं मार्कशीट')),
      ChecklistItem(L('10th marksheet (for non-ECR)', '10वीं मार्कशीट (non-ECR के लिए)'), L('Avoids the ECR mark on your passport', 'पासपोर्ट पर ECR लगने से बचाती है')),
      ChecklistItem(L('Address proof (if not Aadhaar)', 'पता प्रमाण (अगर आधार नहीं)'), L('Bank passbook, electricity bill, rent agreement', 'बैंक पासबुक, बिजली बिल, किराया एग्रीमेंट')),
      ChecklistItem(L('Self-attested photocopies', 'स्व-प्रमाणित फोटोकॉपी'), L('One set of every document above', 'ऊपर के हर दस्तावेज़ की एक सेट')),
    ],
  ),
  Checklist(
    id: 'tatkal',
    title: L('Tatkal passport', 'तत्काल पासपोर्ट'),
    subtitle: L('Extra ID proofs are needed for Tatkal', 'तत्काल में अतिरिक्त पहचान पत्र चाहिए'),
    officialSite: L('passportindia.gov.in', 'passportindia.gov.in'),
    items: [
      ChecklistItem(L('Appointment receipt', 'अपॉइंटमेंट रसीद'), L('With Tatkal fee paid', 'तत्काल फीस भरी हुई')),
      ChecklistItem(L('Aadhaar card', 'आधार कार्ड'), L('Original + copy', 'असली + कॉपी')),
      ChecklistItem(L('Second photo ID', 'दूसरा फोटो पहचान पत्र'), L('PAN, Voter ID, DL, etc. as per the Tatkal list', 'तत्काल लिस्ट के अनुसार PAN, वोटर ID, DL आदि')),
      ChecklistItem(L('Date of birth proof', 'जन्मतिथि प्रमाण'), L('Birth certificate or 10th marksheet', 'जन्म प्रमाणपत्र या 10वीं मार्कशीट')),
      ChecklistItem(L('Old passport (if reissue)', 'पुराना पासपोर्ट (रिन्यू में)'), L('With copies of first and last pages', 'पहले और आखिरी पेज की कॉपी के साथ')),
    ],
  ),
  Checklist(
    id: 'schengen',
    title: L('Schengen visa', 'शेंगेन वीज़ा'),
    subtitle: L('Typical list for a tourist visit; check your embassy’s list', 'टूरिस्ट यात्रा की आम लिस्ट; अपने दूतावास की लिस्ट देखें'),
    officialSite: L('the embassy or VFS website of your main destination', 'मुख्य देश के दूतावास या VFS की वेबसाइट'),
    items: [
      ChecklistItem(L('Passport', 'पासपोर्ट'), L('Issued in the last 10 years, valid 3+ months after return, 2 blank pages', 'पिछले 10 साल में बना, वापसी के बाद 3+ महीने वैध, 2 खाली पेज')),
      ChecklistItem(L('Old passports', 'पुराने पासपोर्ट'), L('Shows your travel history', 'यात्रा का इतिहास दिखाते हैं')),
      ChecklistItem(L('Application form', 'आवेदन फॉर्म'), L('Signed', 'साइन किया हुआ')),
      ChecklistItem(L('2 photos (35×45 mm)', '2 फोटो (35×45 mm)'), L('White background, recent', 'सफेद बैकग्राउंड, नई')),
      ChecklistItem(L('Flight and hotel plan', 'फ्लाइट और होटल प्लान'), L('Refundable bookings are fine', 'रिफंडेबल बुकिंग चलेगी')),
      ChecklistItem(L('Travel insurance', 'ट्रैवल इंश्योरेंस'), L('At least €30,000 for all travel dates', 'सारी यात्रा तारीखों के लिए कम से कम €30,000')),
      ChecklistItem(L('Bank statements', 'बैंक स्टेटमेंट'), L('Last 3–6 months, stamped', 'पिछले 3–6 महीने, बैंक की मुहर के साथ')),
      ChecklistItem(L('ITR (last 2–3 years)', 'ITR (पिछले 2–3 साल)'), L('Shows stable income', 'स्थिर आय दिखाता है')),
      ChecklistItem(L('Job or business proof', 'नौकरी या बिज़नेस प्रमाण'), L('Leave letter, salary slips, GST or company papers', 'छुट्टी पत्र, सैलरी स्लिप, GST या कंपनी के कागज़')),
      ChecklistItem(L('Cover letter', 'कवर लेटर'), L('Purpose, dates, who pays, why you’ll return', 'मकसद, तारीखें, खर्च कौन देगा, वापस क्यों आएंगे')),
    ],
  ),
  Checklist(
    id: 'us_interview',
    title: L('US visa interview day', 'अमेरिकी वीज़ा इंटरव्यू का दिन'),
    subtitle: L('Carry these; the officer may ask for any of them', 'ये साथ रखें; अधिकारी इनमें से कुछ भी मांग सकते हैं'),
    officialSite: L('in.usembassy.gov', 'in.usembassy.gov'),
    items: [
      ChecklistItem(L('Passport', 'पासपोर्ट'), L('Plus all old passports', 'साथ में सभी पुराने पासपोर्ट')),
      ChecklistItem(L('DS-160 confirmation page', 'DS-160 कन्फर्मेशन पेज'), L('With the barcode', 'बारकोड के साथ')),
      ChecklistItem(L('Appointment letter', 'अपॉइंटमेंट लेटर'), L('Printed', 'छपा हुआ')),
      ChecklistItem(L('Proof of income', 'आय का प्रमाण'), L('Salary slips, ITR, bank statements', 'सैलरी स्लिप, ITR, बैंक स्टेटमेंट')),
      ChecklistItem(L('Proof of ties to India', 'भारत से जुड़ाव का प्रमाण'), L('Job letter, property, family details', 'नौकरी का पत्र, प्रॉपर्टी, परिवार की जानकारी')),
      ChecklistItem(L('Trip details', 'यात्रा की जानकारी'), L('Where you’ll stay, invitation if visiting family', 'कहां रुकेंगे, परिवार से मिलने जा रहे हैं तो निमंत्रण')),
    ],
  ),
  Checklist(
    id: 'learner_dl',
    title: L('Learner’s licence', 'लर्निंग लाइसेंस'),
    subtitle: L('Apply on Sarathi, then take the test', 'सारथी पर आवेदन करें, फिर टेस्ट दें'),
    officialSite: L('sarathi.parivahan.gov.in', 'sarathi.parivahan.gov.in'),
    items: [
      ChecklistItem(L('Aadhaar card', 'आधार कार्ड'), L('For identity and address', 'पहचान और पते के लिए')),
      ChecklistItem(L('Age proof', 'उम्र का प्रमाण'), L('If your state asks for one besides Aadhaar', 'अगर राज्य आधार के अलावा मांगे')),
      ChecklistItem(L('Photo', 'फोटो'), L('Use the Photo tool', 'फोटो टूल इस्तेमाल करें')),
      ChecklistItem(L('Signature image', 'साइन की फोटो'), L('Black ink on white paper', 'सफेद कागज़ पर काली स्याही')),
      ChecklistItem(L('Medical certificate (Form 1A)', 'मेडिकल सर्टिफिकेट (फॉर्म 1A)'), L('Only if 40+ or for transport vehicles', 'सिर्फ 40+ उम्र या कमर्शियल वाहन के लिए')),
      ChecklistItem(L('Fee payment', 'फीस भुगतान'), L('UPI, card or net banking', 'UPI, कार्ड या नेट बैंकिंग')),
    ],
  ),
  Checklist(
    id: 'exam_form',
    title: L('Government exam form', 'सरकारी परीक्षा फॉर्म'),
    subtitle: L('Keep everything ready before you start; forms can time out', 'शुरू करने से पहले सब तैयार रखें; फॉर्म टाइम आउट हो सकता है'),
    officialSite: L('your exam notification', 'आपकी परीक्षा का नोटिफिकेशन'),
    items: [
      ChecklistItem(L('Photo in the right size', 'सही साइज़ की फोटो'), L('Use the Photo tool with your exam', 'फोटो टूल में अपनी परीक्षा चुनें')),
      ChecklistItem(L('Signature in the right size', 'सही साइज़ का साइन'), L('Use the Signature tab', 'साइन टैब इस्तेमाल करें')),
      ChecklistItem(L('Email and mobile', 'ईमेल और मोबाइल'), L('One you’ll keep for a year', 'जो एक साल तक रहे')),
      ChecklistItem(L('ID proof number', 'पहचान पत्र नंबर'), L('Aadhaar, PAN or Voter ID', 'आधार, PAN या वोटर ID')),
      ChecklistItem(L('Marksheets and certificates', 'मार्कशीट और प्रमाणपत्र'), L('Exact marks, roll numbers and passing years', 'सटीक अंक, रोल नंबर और पास होने का साल')),
      ChecklistItem(L('Category / EWS certificate', 'श्रेणी / EWS प्रमाणपत्र'), L('In the format the notification asks for', 'नोटिफिकेशन में बताए फॉर्मेट में')),
      ChecklistItem(L('Fee payment method', 'फीस भरने का तरीका'), L('UPI, card or net banking', 'UPI, कार्ड या नेट बैंकिंग')),
    ],
  ),
  Checklist(
    id: 'bank_account',
    title: L('Open a bank account', 'बैंक खाता खोलें'),
    subtitle: L('KYC documents most banks ask for', 'ज़्यादातर बैंक जो KYC दस्तावेज़ मांगते हैं'),
    officialSite: L("your bank's website", 'आपके बैंक की वेबसाइट'),
    items: [
      ChecklistItem(L('Aadhaar card', 'आधार कार्ड'), L('For e-KYC or address proof', 'e-KYC या पता प्रमाण के लिए')),
      ChecklistItem(L('PAN card', 'PAN कार्ड'), L('Or Form 60 if you don’t have PAN', 'PAN नहीं है तो फॉर्म 60')),
      ChecklistItem(L('Passport-size photos', 'पासपोर्ट साइज़ फोटो'), L('Usually 1 or 2', 'आमतौर पर 1 या 2')),
      ChecklistItem(L('Mobile number', 'मोबाइल नंबर'), L('Linked to Aadhaar for OTP', 'OTP के लिए आधार से जुड़ा')),
      ChecklistItem(L('Initial deposit', 'शुरुआती जमा'), L('Zero-balance accounts may not need this', 'ज़ीरो-बैलेंस खाते में ज़रूरी नहीं')),
    ],
  ),
];
