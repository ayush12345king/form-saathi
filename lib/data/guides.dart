/// Step-by-step help for common government tasks.
/// Keep these short, simple and always link the OFFICIAL website.
/// Re-check each guide every few months: portals change.
class GuideStep {
  final String title; // Hindi · English
  final String body;
  const GuideStep(this.title, this.body);
}

class Guide {
  final String id;
  final String titleHi;
  final String titleEn;
  final int minutes;
  final List<GuideStep> steps;
  final String officialUrl;
  final String officialLabel;
  final String? warning;

  const Guide({
    required this.id,
    required this.titleHi,
    required this.titleEn,
    required this.minutes,
    required this.steps,
    required this.officialUrl,
    required this.officialLabel,
    this.warning,
  });
}

const guides = <Guide>[
  Guide(
    id: 'digilocker_otp',
    titleHi: 'DigiLocker में OTP नहीं आ रहा?',
    titleEn: 'DigiLocker OTP not arriving? Try these in order.',
    minutes: 5,
    officialUrl: 'https://www.digilocker.gov.in',
    officialLabel: 'Open official DigiLocker site',
    steps: [
      GuideStep('सही नंबर डालें · Check the number',
          'Use the mobile number linked to your Aadhaar, not a new SIM. Make sure the SIM is in this phone and has signal.'),
      GuideStep('2 मिनट रुकें · Wait 2 minutes',
          'Tapping "Resend" again and again can block OTPs for some time. Wait, then try once.'),
      GuideStep('SMS ब्लॉक तो नहीं? · Check SMS filters',
          'Turn off DND and spam filters for a while, and make sure your SMS inbox is not full.'),
      GuideStep('वेबसाइट से कोशिश करें · Try the website',
          'If the app keeps failing, log in at digilocker.gov.in in Chrome.'),
      GuideStep('टिकट दर्ज करें · Raise a ticket',
          'In DigiLocker go to Help → Contact Us and raise a ticket. Save the ticket number.'),
    ],
  ),
  Guide(
    id: 'dl_renew',
    titleHi: 'ड्राइविंग लाइसेंस रिन्यू कैसे करें',
    titleEn: 'Renew your Driving Licence online',
    minutes: 8,
    officialUrl: 'https://sarathi.parivahan.gov.in',
    officialLabel: 'Open Parivahan Sarathi (official)',
    steps: [
      GuideStep('वेबसाइट खोलें · Open Sarathi',
          'Go to sarathi.parivahan.gov.in and choose your state.'),
      GuideStep('सर्विस चुनें · Choose DL renewal',
          'Under Driving Licence services, choose the renewal option.'),
      GuideStep('DL नंबर डालें · Enter DL number and date of birth',
          'Your details will be fetched. Check your name and address.'),
      GuideStep('डॉक्यूमेंट अपलोड करें · Upload documents',
          'Usually a self-declaration form. If you are 40 or older, a medical certificate (Form 1A) is also needed. Use the Photo tool for the right size.'),
      GuideStep('फीस भरें · Pay the fee',
          'Pay online and save the receipt. Book an RTO slot if your state asks for one.'),
      GuideStep('स्टेटस देखें · Track status',
          'Use "Application Status" on Sarathi with your application number.'),
    ],
  ),
  Guide(
    id: 'echallan',
    titleHi: 'ई-चालान चेक और पेमेंट',
    titleEn: 'Check and pay an e-challan safely',
    minutes: 4,
    officialUrl: 'https://echallan.parivahan.gov.in',
    officialLabel: 'Open official e-Challan site',
    warning:
        'Fake challan SMS with payment links are common. Never pay from a link in an SMS or WhatsApp message. Only use the official site.',
    steps: [
      GuideStep('ऑफिशियल साइट खोलें · Open the official site',
          'Type echallan.parivahan.gov.in yourself in the browser.'),
      GuideStep('डिटेल डालें · Enter details',
          'Search with your vehicle number, challan number or DL number.'),
      GuideStep('चालान देखें · Check the challan',
          'Check the date, place and photo. If it is wrong, you can contest it as shown on the site.'),
      GuideStep('पेमेंट करें · Pay online',
          'Pay only on the official page and download the receipt.'),
    ],
  ),
  Guide(
    id: 'aadhaar_update',
    titleHi: 'आधार में पता या नाम गलत है?',
    titleEn: 'Wrong address or name in Aadhaar',
    minutes: 6,
    officialUrl: 'https://myaadhaar.uidai.gov.in',
    officialLabel: 'Open myAadhaar (official)',
    steps: [
      GuideStep('पता ऑनलाइन बदलें · Address: online',
          'Log in to myAadhaar with your Aadhaar-linked mobile number and choose the address update option.'),
      GuideStep('प्रूफ अपलोड करें · Upload address proof',
          'Use a valid proof in your own name, like a bank passbook or electricity bill. Keep it clear and readable.'),
      GuideStep('URN सेव करें · Save your URN',
          'After paying, save the Update Request Number to track status.'),
      GuideStep('नाम/जन्मतिथि · Name or date of birth',
          'These usually need a visit to an Aadhaar Seva Kendra with original proof. Book an appointment first.'),
    ],
  ),
  Guide(
    id: 'photo_rejected',
    titleHi: 'फॉर्म में फोटो/साइन रिजेक्ट हो रहा है?',
    titleEn: 'Photo or signature rejected on a form?',
    minutes: 3,
    officialUrl: '', // no single official site: the button is hidden
    officialLabel: '',
    steps: [
      GuideStep('KB चेक करें · Check the KB range',
          'Most rejections are size. Use the Photo tool and pick your exam, or type the numbers from your notification.'),
      GuideStep('पिक्सल चेक करें · Check width × height',
          'Some forms want exact pixels (like 200 × 230). The tool sets this for you.'),
      GuideStep('JPG रखें · Use JPG',
          'Most portals accept only JPG/JPEG. The tool always saves JPG.'),
      GuideStep('साफ फोटो लें · Use a clear, recent photo',
          'Plain light background, face clearly visible, no cap or dark glasses.'),
      GuideStep('साइन काली स्याही से · Sign in black ink',
          'Sign on plain white paper, take a photo in good light, then use the Signature tab.'),
    ],
  ),
  Guide(
    id: 'voter_id',
    titleHi: 'वोटर ID बनवाना या सुधार करना',
    titleEn: 'New Voter ID or correction',
    minutes: 6,
    officialUrl: 'https://voters.eci.gov.in',
    officialLabel: 'Open Voters Service Portal (official)',
    steps: [
      GuideStep('पोर्टल खोलें · Open the portal',
          'Go to voters.eci.gov.in and sign up with your mobile number.'),
      GuideStep('सही फॉर्म चुनें · Pick the right form',
          'Form 6 for a new voter ID. Form 8 for corrections, address shift or replacement.'),
      GuideStep('फोटो और प्रूफ · Photo and proofs',
          'Keep age and address proof ready. Use the Photo tool for the right size.'),
      GuideStep('रेफरेंस नंबर · Save the reference number',
          'Use it to track your application on the same portal.'),
    ],
  ),
];
