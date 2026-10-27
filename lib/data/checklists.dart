/// "What do I need to carry?" lists. Rules can change; each list links the
/// official site so users can confirm.
class ChecklistItem {
  final String title;
  final String note;
  const ChecklistItem(this.title, this.note);
}

class Checklist {
  final String id;
  final String titleHi;
  final String titleEn;
  final String subtitle;
  final List<ChecklistItem> items;
  final String officialSite;

  const Checklist({
    required this.id,
    required this.titleHi,
    required this.titleEn,
    required this.subtitle,
    required this.items,
    required this.officialSite,
  });
}

const checklists = <Checklist>[
  Checklist(
    id: 'passport',
    titleHi: 'नया पासपोर्ट',
    titleEn: 'New Passport',
    subtitle: 'Carry originals + 1 photocopy set to the Passport Seva Kendra',
    officialSite: 'passportindia.gov.in',
    items: [
      ChecklistItem('Appointment receipt', 'Printout or SMS with your ARN'),
      ChecklistItem('Aadhaar card', 'Proof of address and identity'),
      ChecklistItem('Date of birth proof', 'Birth certificate, PAN or 10th marksheet'),
      ChecklistItem('Address proof (if not Aadhaar)', 'Bank passbook, electricity bill, etc.'),
      ChecklistItem('Old passport', 'Only for re-issue'),
      ChecklistItem('Self-attested photocopies', 'One set of every document above'),
    ],
  ),
  Checklist(
    id: 'learner_dl',
    titleHi: 'लर्निंग लाइसेंस',
    titleEn: "Learner's Licence",
    subtitle: 'Apply on Sarathi, then give the online or RTO test',
    officialSite: 'sarathi.parivahan.gov.in',
    items: [
      ChecklistItem('Aadhaar card', 'Used for identity and address'),
      ChecklistItem('Age proof', 'If Aadhaar is not accepted for age in your state'),
      ChecklistItem('Passport-size photo', 'Use the Photo tool for the right size'),
      ChecklistItem('Signature image', 'Black ink on white paper, use the Signature tab'),
      ChecklistItem('Medical certificate (Form 1A)', 'Only if age 40+ or for transport vehicles'),
      ChecklistItem('Fee payment', 'UPI, card or net banking'),
    ],
  ),
  Checklist(
    id: 'exam_form',
    titleHi: 'सरकारी परीक्षा फॉर्म',
    titleEn: 'Government exam form',
    subtitle: 'Keep everything ready before you start, forms can time out',
    officialSite: 'your exam notification',
    items: [
      ChecklistItem('Photo in the right size', 'Use the Photo tool with your exam'),
      ChecklistItem('Signature in the right size', 'Use the Signature tab'),
      ChecklistItem('Working email and mobile', 'OTPs and admit card updates come here'),
      ChecklistItem('ID proof number', 'Aadhaar, PAN or Voter ID'),
      ChecklistItem('Marksheets and certificates', 'Exact marks, roll numbers and passing years'),
      ChecklistItem('Category / EWS certificate', 'Only if you claim a category'),
      ChecklistItem('Fee payment method', 'UPI, card or net banking'),
    ],
  ),
  Checklist(
    id: 'bank_account',
    titleHi: 'बैंक खाता खोलना',
    titleEn: 'Open a bank account',
    subtitle: 'KYC documents most banks ask for',
    officialSite: "your bank's website",
    items: [
      ChecklistItem('Aadhaar card', 'For e-KYC or as address proof'),
      ChecklistItem('PAN card', 'Or Form 60 if you do not have PAN'),
      ChecklistItem('Passport-size photos', 'Usually 1 or 2'),
      ChecklistItem('Mobile number', 'Linked to Aadhaar for OTP'),
      ChecklistItem('Initial deposit', 'Zero-balance accounts may not need this'),
    ],
  ),
];
