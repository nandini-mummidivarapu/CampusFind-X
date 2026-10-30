import '../models/item_report.dart';
import '../utils/app_constants.dart';

/// Pre-populated realistic sample data for college lab demonstration.
/// Contains 16 diverse reports covering both Lost and Found items.
///
/// NOTE:
/// These records are marked with 'is_sample: true' or sample IDs and seeded
/// only once upon initial app launch (tracked by SharedPreferences).
class SampleData {
  static List<ItemReport> getInitialReports() {
    final now = DateTime.now();

    return [
      // 1. Lost College ID Card (by Demo User so they have an item in My Reports)
      ItemReport(
        id: 'sample_01',
        title: 'College ID Card - Computer Science Dept',
        type: ItemType.lost,
        category: 'idCard',
        description:
            'Lost my white student identity card with blue lanyard bearing Roll No CS2024-042. Might have fallen while studying at the library.',
        location: 'Central Library - 2nd Floor Reading Room',
        eventDate: now.subtract(const Duration(hours: 4)),
        contactInfo: 'Alex Sharma • Call / WhatsApp: +91 98765 43210',
        reporterId: AppConstants.demoUserId,
        reporterName: AppConstants.demoUserName,
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ),

      // 2. Found Notebook
      ItemReport(
        id: 'sample_02',
        title: 'Data Structures & Algorithms Classmate Notebook',
        type: ItemType.found,
        category: 'books',
        description:
            'Found a spiral-bound 200-page notebook with detailed handwritten DSA graphs and binary tree notes. Left on System #18 table.',
        location: 'Computer Science Lab 3',
        eventDate: now.subtract(const Duration(hours: 6)),
        contactInfo: 'Priya Nair (3rd Year CSE) • Contact Lab Assistant Desk',
        reporterId: 'student_102',
        reporterName: 'Priya Nair',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),

      // 3. Lost Water Bottle
      ItemReport(
        id: 'sample_03',
        title: 'Milton Stainless Steel Water Bottle (Matte Blue)',
        type: ItemType.lost,
        category: 'bottles',
        description:
            '750ml insulated blue bottle with a slight scratch on the steel lid and a "Code & Coffee" sticker on the side.',
        location: 'Student Canteen / Cafeteria',
        eventDate: now.subtract(const Duration(hours: 12)),
        contactInfo: 'Karan Gupta • Call: 98123 45678',
        reporterId: 'student_103',
        reporterName: 'Karan Gupta',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),

      // 4. Found Keys
      ItemReport(
        id: 'sample_04',
        title: 'Set of 3 Keys with Captain America Shield Keychain',
        type: ItemType.found,
        category: 'keys',
        description:
            'Found a bunch of three keys (two bike ignition keys and one Godrej lock key) attached to a circular metal Captain America keychain.',
        location: 'Two-Wheeler Parking Lot',
        eventDate: now.subtract(const Duration(days: 1, hours: 2)),
        contactInfo:
            'Security Desk Gate 1 • Submit vehicle registration card to claim',
        reporterId: 'student_104',
        reporterName: 'Rohan Mehta',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),

      // 5. Lost Earphones (by Demo User)
      ItemReport(
        id: 'sample_05',
        title: 'boAt Airdopes 141 Case (Carbon Black)',
        type: ItemType.lost,
        category: 'electronics',
        description:
            'Black charging case without the right earbud inside. Left it behind after the afternoon Microprocessor lecture.',
        location: 'Main Academic Block - 1st Floor Corridor',
        eventDate: now.subtract(const Duration(days: 1, hours: 5)),
        contactInfo: 'Alex Sharma • Call: 98765 43210',
        reporterId: AppConstants.demoUserId,
        reporterName: AppConstants.demoUserName,
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 1, hours: 5)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 5)),
      ),

      // 6. Found Scientific Calculator
      ItemReport(
        id: 'sample_06',
        title: 'Casio fx-991EX ClassWiz Scientific Calculator',
        type: ItemType.found,
        category: 'electronics',
        description:
            'Black and white scientific calculator with black sliding cover. Found under seat row 4 after the mid-term test.',
        location: 'Seminar Hall B',
        eventDate: now.subtract(const Duration(days: 2)),
        contactInfo: 'Sneha Reddy • Email: sneha.reddy@college.edu',
        reporterId: 'student_105',
        reporterName: 'Sneha Reddy',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      // 7. Lost Mobile Phone
      ItemReport(
        id: 'sample_07',
        title: 'Samsung Galaxy M32 (Light Blue)',
        type: ItemType.lost,
        category: 'phones',
        description:
            'Phone has a transparent TPU back cover with a hostel mess receipt folded inside. Lockscreen displays wallpaper of mountains.',
        location: 'Sports Complex / Basketball Court',
        eventDate: now.subtract(const Duration(days: 2, hours: 3)),
        contactInfo: 'Deepak Rao • Alternate contact: 99450 11223',
        reporterId: 'student_106',
        reporterName: 'Deepak Rao',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 3)),
      ),

      // 8. Found Backpack
      ItemReport(
        id: 'sample_08',
        title: 'Grey Wildcraft College Backpack',
        type: ItemType.found,
        category: 'bags',
        description:
            'Bag contains engineering mathematics textbook, blue geometry box, and an empty steel tiffin box. Handed over to security.',
        location: 'Main Auditorium',
        eventDate: now.subtract(const Duration(days: 2, hours: 8)),
        contactInfo: 'Campus Security Office • Ext 204',
        reporterId: 'student_107',
        reporterName: 'Rahul Verma',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 2, hours: 8)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 8)),
      ),

      // 9. Lost Wristwatch
      ItemReport(
        id: 'sample_09',
        title: 'Fastrack Analog Watch with Black Silicone Strap',
        type: ItemType.lost,
        category: 'watches',
        description:
            'Water-resistant sports watch with red second hand. Lost near the locker area or badminton courts during practice.',
        location: 'Sports Complex / Basketball Court',
        eventDate: now.subtract(const Duration(days: 3)),
        contactInfo: 'Ananya Patel • Contact: ananya.p@college.edu',
        reporterId: 'student_108',
        reporterName: 'Ananya Patel',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),

      // 10. Found Metro Smart Card
      ItemReport(
        id: 'sample_10',
        title: 'City Metro Travel Smart Card',
        type: ItemType.found,
        category: 'documents',
        description:
            'Metro commuter recharge card with serial ending in ...7821. Found on the concrete bench at the bus stop.',
        location: 'College Bus Stop & Main Gate',
        eventDate: now.subtract(const Duration(days: 3, hours: 4)),
        contactInfo: 'Security Gate 2 • Show ID to claim',
        reporterId: 'student_109',
        reporterName: 'Vikram Joshi',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 3, hours: 4)),
        updatedAt: now.subtract(const Duration(days: 3, hours: 4)),
      ),

      // 11. Lost Engineering Drawing Box (Resolved)
      ItemReport(
        id: 'sample_11',
        title: 'Camlin Engineering Mini-Drafter & Instrument Box',
        type: ItemType.lost,
        category: 'others',
        description:
            'Black cloth carry case containing metallic mini drafter, T-scale, set squares, and compass set for Engineering Graphics.',
        location: 'Mechanical Workshop Building',
        eventDate: now.subtract(const Duration(days: 4)),
        contactInfo: 'Alex Sharma • Call: 98765 43210',
        reporterId: AppConstants.demoUserId,
        reporterName: AppConstants.demoUserName,
        status: ItemStatus.resolved,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // 12. Found Reading Glasses (Resolved)
      ItemReport(
        id: 'sample_12',
        title: 'Matte Brown Rectangular Spectacles in Hard Case',
        type: ItemType.found,
        category: 'others',
        description:
            'Found on desk 14 in the quiet study zone. Power around -2.0. Safely claimed by student.',
        location: 'Central Library - Ground Floor',
        eventDate: now.subtract(const Duration(days: 4, hours: 6)),
        contactInfo: 'Library Helpdesk',
        reporterId: 'student_110',
        reporterName: 'Meera Iyer',
        status: ItemStatus.resolved,
        createdAt: now.subtract(const Duration(days: 4, hours: 6)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      // 13. Lost Leather Wallet
      ItemReport(
        id: 'sample_13',
        title: 'Dark Brown Leather Trifold Wallet',
        type: ItemType.lost,
        category: 'others',
        description:
            'Contains driver license, college cafeteria debit card, and some cash. Urgent - needed for weekend travel!',
        location: 'Student Canteen / Cafeteria',
        eventDate: now.subtract(const Duration(days: 5)),
        contactInfo: 'Aditya K. • Phone: 98234 56789',
        reporterId: 'student_111',
        reporterName: 'Aditya Kulkarni',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),

      // 14. Found USB-C Charger
      ItemReport(
        id: 'sample_14',
        title: '65W Fast USB-C Charging Adapter & Braided White Cable',
        type: ItemType.found,
        category: 'electronics',
        description:
            'White PD adapter left plugged into the wall extension board on work table 2.',
        location: 'Computer Science Lab 1',
        eventDate: now.subtract(const Duration(days: 5, hours: 3)),
        contactInfo: 'Lab Incharge Mr. Kumar',
        reporterId: 'student_112',
        reporterName: 'Arjun Das',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 5, hours: 3)),
        updatedAt: now.subtract(const Duration(days: 5, hours: 3)),
      ),

      // 15. Lost Foldable Umbrella
      ItemReport(
        id: 'sample_15',
        title: 'Automatic Compact Black Umbrella',
        type: ItemType.lost,
        category: 'others',
        description:
            '3-fold push-button umbrella with curved wooden handle. Left in umbrella rack during heavy morning rain.',
        location: 'Admin Block & Principal Office Reception',
        eventDate: now.subtract(const Duration(days: 6)),
        contactInfo: 'Pooja Bhat • Call: 97312 34567',
        reporterId: 'student_113',
        reporterName: 'Pooja Bhat',
        status: ItemStatus.open,
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),

      // 16. Found White Lab Coat
      ItemReport(
        id: 'sample_16',
        title: 'White Full-Sleeve Chemistry Lab Coat (Size 38)',
        type: ItemType.found,
        category: 'others',
        description:
            'Clean lab coat with embroidered initials "R.K." on left chest pocket. Found on hanger behind door.',
        location: 'Main Academic Block - Ground Floor',
        eventDate: now.subtract(const Duration(days: 7)),
        contactInfo: 'Chemistry Department Store Room',
        reporterId: 'student_114',
        reporterName: 'Kavita Sen',
        status: ItemStatus.resolved,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}
