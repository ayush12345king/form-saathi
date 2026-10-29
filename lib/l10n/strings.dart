import 'lang.dart';

/// Every fixed piece of app text, in English and Hindi.
class S {
  // Language picker
  static const chooseLanguage = L('Choose your language', 'अपनी भाषा चुनें');
  static const changeLaterHint = L('You can change this later from the Home screen.',
      'आप इसे बाद में होम स्क्रीन से बदल सकते हैं।');
  static const language = L('Language', 'भाषा');

  // Tabs
  static const tabHome = L('Home', 'होम');
  static const tabPhoto = L('Photo', 'फोटो');
  static const tabReminders = L('Reminders', 'रिमाइंडर');
  static const tabGuides = L('Guides', 'गाइड');

  // Home
  static const homeQuestion = L('What paperwork can we help with today?', 'आज कौन सा काम है?');
  static const homeSub = L('Forms, passports, visas, ID cards: step by step.',
      'फॉर्म, पासपोर्ट, वीज़ा, पहचान पत्र: कदम दर कदम।');
  static const tilePhoto = L('Photo & Sign', 'फोटो और साइन');
  static const tilePhotoSub = L('Exact KB for any form', 'हर फॉर्म के लिए सही KB');
  static const tileReminders = L('Reminders', 'रिमाइंडर');
  static const tileRemindersSub = L('DL, RC, PUC, passport', 'DL, RC, PUC, पासपोर्ट');
  static const tileGuides = L('Guides', 'गाइड');
  static const tileGuidesSub = L('Passport, visa, ID & more', 'पासपोर्ट, वीज़ा, ID और भी');
  static const tileChecklists = L('Checklists', 'चेकलिस्ट');
  static const tileChecklistsSub = L('Know what to carry', 'क्या ले जाना है');
  static const popular = L('POPULAR', 'लोकप्रिय');
  static const browseTopics = L('BROWSE BY TOPIC', 'विषय के अनुसार देखें');
  static const expiringSoon = L('expiring soon', 'जल्द खत्म हो रहे हैं');
  static const documentWord = L('document', 'दस्तावेज़');
  static const documentsWord = L('documents', 'दस्तावेज़');
  static const expiredWord = L('expired', 'खत्म हो चुका');
  static const inWord = L('in', 'बाकी');

  // Photo tool
  static const photoTitle = L('Photo & Signature', 'फोटो और साइन');
  static const photoSub = L('Right size for any form', 'हर फॉर्म के लिए सही साइज़');
  static const segPhoto = L('Photo', 'फोटो');
  static const segSign = L('Signature', 'साइन');
  static const chooseForm = L('1. Choose your form', '1. अपना फॉर्म चुनें');
  static const addPhoto = L('2. Add your photo', '2. अपनी फोटो डालें');
  static const sizesNote = L(
      'These are common sizes. Always match the numbers in your official notification. You can edit them above.',
      'ये आम साइज़ हैं। हमेशा अपने ऑफिशियल नोटिफिकेशन से मिलाएं। आप ऊपर नंबर बदल सकते हैं।');
  static const widthPx = L('Width px', 'चौड़ाई px');
  static const heightPx = L('Height px', 'ऊंचाई px');
  static const minKb = L('Min KB', 'न्यूनतम KB');
  static const maxKb = L('Max KB', 'अधिकतम KB');
  static const nameDateTitle = L('Name & date on photo', 'फोटो पर नाम और तारीख');
  static const nameDateSub = L('Some forms (like UPSC) ask for this', 'कुछ फॉर्म (जैसे UPSC) यह मांगते हैं');
  static const yourName = L('Your name', 'आपका नाम');
  static const gallery = L('Gallery', 'गैलरी');
  static const camera = L('Camera', 'कैमरा');
  static const needs = L('needs', 'के लिए चाहिए');
  static const addPhotoToStart = L('Add a photo to start', 'शुरू करने के लिए फोटो डालें');
  static const yourFile = L('Your file', 'आपकी फाइल');
  static const fits = L('fits', 'सही है');
  static const outside = L('outside', 'सीमा से बाहर');
  static const saveGallery = L('Save to Gallery', 'गैलरी में सेव करें');
  static const share = L('Share (WhatsApp, Drive…)', 'शेयर करें (WhatsApp, Drive…)');
  static const staysOnPhone = L('Stays on your phone. Nothing is uploaded.',
      'सब आपके फोन में रहता है। कुछ भी अपलोड नहीं होता।');
  static const savedGallery = L('Saved to Gallery › Form Saathi', 'गैलरी › Form Saathi में सेव हो गया');
  static const saveFailed = L('Could not save. Allow photo access in Settings.',
      'सेव नहीं हुआ। सेटिंग्स में फोटो की अनुमति दें।');
  static const openFailed = L('Could not open the photo. Please try again.',
      'फोटो नहीं खुली। फिर से कोशिश करें।');
  static const readFailed = L('Could not read this image. Try a JPG or PNG.',
      'यह फोटो पढ़ी नहीं जा सकी। JPG या PNG आज़माएं।');
  static const tooBig = L('Could not get under the max KB at this size. Check the numbers.',
      'इस साइज़ पर अधिकतम KB से कम नहीं हो पाया। नंबर जांचें।');

  // Reminders
  static const myDocs = L('My Documents', 'मेरे दस्तावेज़');
  static const myDocsSub = L('Expiry reminders', 'समाप्ति रिमाइंडर');
  static const addDocument = L('Add document', 'दस्तावेज़ जोड़ें');
  static const editDocument = L('Edit document', 'दस्तावेज़ बदलें');
  static const urgent = L('Urgent (≤7 days)', 'ज़रूरी (≤7 दिन)');
  static const thisMonth = L('This month', 'इस महीने');
  static const allGood = L('All good', 'सब ठीक');
  static const noDocs = L(
      'No documents yet.\nTap "Add document" and add your DL, PUC, insurance or passport expiry date.',
      'अभी कोई दस्तावेज़ नहीं है।\n"दस्तावेज़ जोड़ें" दबाएं और अपने DL, PUC, बीमा या पासपोर्ट की समाप्ति तारीख डालें।');
  static const calendarTip = L(
      'Tip: tap ⋮ › "Add to Calendar" on a document. Your phone calendar will then remind you even if this app is closed.',
      'सुझाव: किसी दस्तावेज़ पर ⋮ › "कैलेंडर में जोड़ें" दबाएं। ऐप बंद होने पर भी फोन का कैलेंडर याद दिलाएगा।');
  static const addToCalendar = L('Add to Calendar', 'कैलेंडर में जोड़ें');
  static const delete = L('Delete', 'हटाएं');
  static const more = L('More', 'और');
  static const expires = L('expires', 'समाप्ति');
  static const docField = L('Document', 'दस्तावेज़');
  static const noteField = L('Note (optional)', 'नोट (वैकल्पिक)');
  static const noteHint = L("e.g. HR06AB1234 or Papa's DL", 'जैसे HR06AB1234 या पापा का DL');
  static const chooseExpiry = L('Choose expiry date', 'समाप्ति तारीख चुनें');
  static const expiryDate = L('Expiry date', 'समाप्ति तारीख');
  static const pleaseExpiry = L('Please choose the expiry date', 'कृपया समाप्ति तारीख चुनें');
  static const save = L('Save', 'सेव करें');
  static const calendarEventTitle = L('Renew', 'रिन्यू करें');

  // Guides
  static const guidesTitle = L('Guides', 'गाइड');
  static const guidesSub = L('Step by step, with tips you won’t find easily',
      'कदम दर कदम, ऐसे सुझावों के साथ जो आसानी से नहीं मिलते');
  static const search = L('Search: passport, visa, PAN…', 'खोजें: पासपोर्ट, वीज़ा, PAN…');
  static const all = L('All', 'सभी');
  static const noResults = L('Nothing found. Try another word.', 'कुछ नहीं मिला। दूसरा शब्द आज़माएं।');
  static const guide = L('Guide', 'गाइड');
  static const steps = L('STEPS', 'कदम');
  static const proTips = L('PRO TIPS', 'खास सुझाव');
  static const mistakes = L('COMMON MISTAKES', 'आम गलतियां');
  static const minWord = L('min', 'मिनट');
  static const lastChecked = L('Last checked', 'आखिरी बार जांचा');
  static const checklistsCard = L('Document checklists', 'दस्तावेज़ चेकलिस्ट');
  static const checklistsCardSub = L('Passport, visa, licence, exam, bank', 'पासपोर्ट, वीज़ा, लाइसेंस, परीक्षा, बैंक');

  // Checklists
  static const checklistsTitle = L('Checklists', 'चेकलिस्ट');
  static const itemsWord = L('items', 'चीज़ें');
  static const ready = L('Ready', 'तैयार');
  static const ofWord = L('of', '/');
  static const rulesChange = L('Rules can change. Confirm on the official site before you go:',
      'नियम बदल सकते हैं। जाने से पहले ऑफिशियल साइट पर जांचें:');

  // Common
  static const disclaimer = L(
      'Form Saathi is not a government app and is not affiliated with any government body. Always confirm on the official website.',
      'Form Saathi सरकारी ऐप नहीं है और किसी सरकारी संस्था से जुड़ा नहीं है। हमेशा ऑफिशियल वेबसाइट पर पुष्टि करें।');
  static const couldNotOpen = L('Could not open', 'नहीं खुल सका');
}
