<<<<<<< HEAD
# CampusFind X — Flutter Campus Lost & Found Mobile App

**CampusFind X** is a modern, student-centric mobile application engineered with **Flutter**, **Dart**, **Material 3**, and the **Provider** state management pattern. It provides an intuitive, reliable, and offline-capable platform for college students to report lost belongings, post found items, search campus reports, contact reporters, and mark items as resolved.

---

## 1. Project Objective & Overview

Misplacing personal belongings (College ID cards, notebooks, keys, earphones, water bottles, calculators, backpacks) is a frequent and stressful problem in colleges. Traditional manual notices or unorganized group chats lead to missed reports, cluttered communication, and unreturned items.

**CampusFind X** solves this by offering:
- **Fast Reporting**: Publish lost or found notices in under 30 seconds with campus locations, timestamps, categories, and optional photos.
- **Search & Intelligent Filtering**: Instantly search by title, location, or description, and filter by status (`Open` / `Resolved`), type (`Lost` / `Found`), and item category.
- **Local Persistence**: Works offline and local-first without requiring cloud credentials or backend servers.
- **Student Ownership & Lifecycle**: Students can track their own reports, update details, mark items as resolved when recovered, or delete records.
- **Bookmark / Favorites**: Save important reports to track updates.

---

## 2. Key Features

| Category | Feature | Description |
| :--- | :--- | :--- |
| **Branding & Launch** | **Splash Screen** | Animated logo with brand icon, app title, tagline, and automatic route dispatching. |
| **User Guidance** | **Onboarding Tour** | 3-step feature walkthrough explaining Lost, Found, and Search with persistent completion. |
| **Dashboard** | **Dynamic Overview** | Live statistical summary cards (Total, Lost, Found, Resolved) calculated from actual records. |
| **Reporting** | **Report Lost Belongings** | Structured form with title, category dropdown, campus location chips, date picker, photo picker, and contact info. |
| **Good Citizenship** | **Report Found Belongings** | Allows students who discover items to report details and custody location (e.g. Security Desk / Lab incharge). |
| **Exploration** | **Search & Multi-Filters** | Real-time text search with category chips and bottom sheet filters for combined queries. |
| **Report Details** | **Detailed View & Actions** | Complete report information, photo display, copyable reporter contact information, and favorite toggle. |
| **My Reports** | **Report Management** | Tabbed views (`All`, `Open`, `Resolved`) for reports created by the current student with Edit, Delete, and Resolve toggles. |
| **Personalization** | **Favorites / Saved** | Locally saved bookmarks for quick retrieval. |
| **Security & Auth** | **Local Demo Auth** | Secure local demo accounts with SHA-256 password hashing, validation, duplicate prevention, and one-click quick login. |
| **Theming** | **Material 3 Light / Dark** | Dynamic switching between deep navy light theme and high-contrast dark theme. |
| **Lab Utilities** | **Sample Data Reset** | Pre-populated with 16 realistic campus scenarios and a one-click reset button for lab evaluations. |

---

## 3. Technology Stack

- **Framework**: [Flutter](https://flutter.dev) (v3.44.6, Channel stable)
- **Language**: [Dart](https://dart.dev) (v3.12.2, Null-Safe)
- **UI Guidelines**: Flutter Material 3 Design
- **State Management**: [Provider](https://pub.dev/packages/provider) (`ChangeNotifierProvider`, `Consumer`, `context.watch`, `context.read`)
- **Local Persistence**: [SharedPreferences](https://pub.dev/packages/shared_preferences) with JSON serialization
- **Image Handling**: [image_picker](https://pub.dev/packages/image_picker) for device gallery photo selection with graceful fallback
- **Formatting**: [intl](https://pub.dev/packages/intl) for date and time formatting
- **Hashing**: [crypto](https://pub.dev/packages/crypto) for SHA-256 demo password hashing

---

## 4. Architecture & Folder Structure

The project implements a clean **Repository Pattern** and **Layered Architecture**:

```
tinkeringlab/
│
├── android/                   # Native Android host configuration (AndroidManifest, Gradle, Kotlin)
├── web/                       # Web platform host files
│
├── lib/
│   ├── main.dart              # Application entry point, async service initialization & MultiProvider
│   ├── app.dart               # MaterialApp, Material 3 Light/Dark theme configuration & named routes
│   │
│   ├── models/                # Strongly-typed Dart data models with JSON serialization
│   │   ├── item_report.dart   # ItemReport model with ItemType and ItemStatus enums
│   │   └── app_user.dart      # AppUser model with SHA-256 hashing and verifyPassword
│   │
│   ├── services/              # Low-level data access and seeding services
│   │   ├── local_storage_service.dart  # SharedPreferences abstraction for reports, users, favs, themes
│   │   └── sample_data.dart   # 16 realistic college campus demonstration records
│   │
│   ├── repositories/          # Repository abstraction isolating storage from UI
│   │   ├── item_repository.dart  # CRUD operations for reports & favorites
│   │   └── auth_repository.dart  # Local demo login, registration, and session management
│   │
│   ├── providers/             # ChangeNotifier state providers for reactive UI
│   │   ├── auth_provider.dart    # Manages user session, demo login, and auth errors
│   │   ├── item_provider.dart    # Manages reports, search, filters, statistics, favorites
│   │   └── theme_provider.dart   # Manages Light / Dark theme mode preference
│   │
│   ├── utils/                 # Design constants, color palettes, and validators
│   │   ├── app_colors.dart    # Primary navy, bright blue accent, and status colors
│   │   ├── app_constants.dart # App metadata, campus locations list, and category metadata
│   │   └── validators.dart    # Reusable form validators (email, password, required fields)
│   │
│   ├── widgets/               # Focused, reusable UI components
│   │   ├── app_bottom_navigation.dart # 5-tab Material 3 NavigationBar
│   │   ├── category_filter.dart       # Horizontal scrollable category filter chips
│   │   ├── custom_text_field.dart     # Styled Material 3 text inputs
│   │   ├── empty_state_widget.dart    # Contextual empty & error states with action buttons
│   │   ├── item_card.dart             # Primary card with thumbnail, badges, location, date, and bookmark
│   │   ├── primary_button.dart        # Elevated and outlined action buttons with loading indicators
│   │   ├── search_bar_widget.dart     # Search field with instant updates, clear, and filter trigger
│   │   ├── stat_card.dart             # Dashboard metric card with count and category icon
│   │   └── status_chip.dart           # Type chips (Lost/Found) and Status chips (Open/Resolved)
│   │
│   └── screens/               # Complete application screens
│       ├── splash_screen.dart           # Branded animation & navigation dispatch
│       ├── onboarding_screen.dart       # 3-step feature walkthrough
│       ├── main_navigation_screen.dart  # Scaffold housing bottom navigation & quick report speed dial
│       ├── home_screen.dart             # Dashboard overview, stat cards, quick actions & recent reports
│       ├── reports_screen.dart          # All reports with search bar, category chips, and filter modal
│       ├── report_lost_screen.dart      # Form to post a lost item with location chips and photo picker
│       ├── report_found_screen.dart     # Form to post a found item with contact/custody instructions
│       ├── item_details_screen.dart     # Detailed item view, contact dialog, favorite, edit & resolve
│       ├── my_reports_screen.dart       # Filtered view of current student's items with owner actions
│       ├── edit_report_screen.dart      # Pre-populated edit form for owner modifications
│       ├── favorites_screen.dart        # Saved items list with instant navigation
│       ├── profile_screen.dart          # Student profile, theme toggle, lab sample data reset, about
│       ├── login_screen.dart            # Email/password form with quick demo student login
│       └── register_screen.dart         # Local account creation form with validation
│
├── test/
│   ├── item_repository_test.dart        # 12 Unit tests for models, repositories, and persistence
│   └── widget_test.dart                 # 3 Widget tests for Splash, StatCard, and ItemCard
│
├── pubspec.yaml               # Package dependencies and asset configuration
└── README.md                  # Comprehensive documentation and lab viva guide
```

---

## 5. Core Data Model (`ItemReport`)

Each lost or found notice is modeled by `ItemReport`:

```dart
class ItemReport {
  final String id;
  final String title;
  final ItemType type;            // ItemType.lost | ItemType.found
  final String category;          // 'idCard', 'books', 'electronics', 'keys', etc.
  final String description;
  final String location;          // e.g., 'Central Library - 2nd Floor Reading Room'
  final DateTime eventDate;       // Date and time item was lost or found
  final String? imagePath;        // Optional device file path
  final String? contactInfo;      // Optional phone/email/handover desk
  final String reporterId;        // User ID of student who created notice
  final String reporterName;      // Name of reporter
  final ItemStatus status;        // ItemStatus.open | ItemStatus.resolved
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

---

## 6. State Management with Provider

State management is handled using **Provider**:
1. **`ItemProvider`**:
   - Holds the master list of reports and favorite IDs.
   - Computes live dashboard metrics: `totalCount`, `lostCount`, `foundCount`, `resolvedCount`, and `openCount`.
   - Filters reports dynamically based on `searchQuery`, `typeFilter`, `statusFilter`, and `categoryFilter`.
   - Provides methods for creating, updating, resolving, deleting, and favoriting reports.
2. **`AuthProvider`**:
   - Maintains the active `AppUser` session.
   - Provides methods for `login()`, `register()`, `quickDemoLogin()`, and `logout()`.
   - Tracks onboarding completion status.
3. **`ThemeProvider`**:
   - Tracks light/dark mode and persists the preference across restarts.

---

## 7. Local Persistence & Offline Demonstration

- **No Backend or API Keys Needed**: All data is persisted locally in `SharedPreferences` as serialized JSON strings.
- **Data Preservation**: Reports, edits, deletions, favorites, theme preferences, and demo login sessions persist across app restarts.
- **Initial Seeding**: The app seeds 16 realistic campus reports on first launch. A dedicated flag (`_keyIsSeeded`) guarantees that sample data is never repeatedly reinserted or used to overwrite real student records.
- **Reset Sample Data**: A button in the Profile screen allows lab evaluators to reset the dataset to initial conditions at any time.

---

## 8. Installation & Execution Guide

### Prerequisites
- Flutter SDK (v3.19 or higher, tested on 3.44.6)
- Dart SDK (v3.0 or higher, tested on 3.12.2)
- Android Studio / Android SDK (or an Android phone with USB Debugging enabled) or Google Chrome

### Step-by-Step Setup

1. **Verify Flutter Environment**:
   ```bash
   flutter doctor
   ```

2. **Navigate to the Project Directory**:
   ```bash
   cd "c:\Users\NAGA NANDINI\OneDrive\Desktop\tinkeringlab"
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run Static Code Analysis**:
   ```bash
   flutter analyze
   ```
   *(Expected output: `No issues found!`)*

5. **Run Automated Unit & Widget Tests**:
   ```bash
   flutter test
   ```
   *(Expected output: `All tests passed!`)*

6. **Run the Application**:
   - **On Connected Android Phone / Emulator**:
     ```bash
     flutter run
     ```
   - **On Google Chrome (for Instant Lab Browser Demo)**:
     ```bash
     flutter run -d chrome
     ```

---

## 9. Limitations of Local Demo Authentication

> [!NOTE]
> **Academic Evaluation Notice**:
> For the college laboratory demonstration, authentication is designed to work completely offline without cloud infrastructure.
> 
> 1. Passwords are never stored in plaintext (they are hashed locally via SHA-256).
> 2. Because data resides on the client device in `SharedPreferences`, this demo authentication does not provide production-grade cryptographic security against local device tampering.
> 3. In a real-world enterprise deployment, authentication would use an external identity provider (OAuth 2.0, Firebase Auth, or JWT via HTTPS API).

---

## 10. Demonstration Sequence for the Lab Examiner

Follow this 5-minute demonstration script during your college lab viva:

1. **Launch & Onboarding**:
   - Launch the app to showcase the branded **Splash Screen**.
   - Show the 3-page **Onboarding Tour** highlighting Lost, Found, and Search capabilities.
   - Tap **"Get Started"** to reach the main dashboard.

2. **Dashboard & Dynamic Statistics**:
   - Point out the **Overview Summary Cards**: Total Reports (16), Lost Items, Found Items, and Resolved Items.
   - Highlight that these numbers are computed dynamically from actual records and are never hardcoded.

3. **Browse & Search / Filter**:
   - Switch to the **Reports Tab**.
   - Type `"Library"` in the search bar to demonstrate instant real-time filtering across titles, descriptions, and campus locations.
   - Tap category chips (e.g., **"Keys & Keychains"** or **"Mobile Phones"**).
   - Open the **Filter Modal** and filter for `Found Items Only` with `Open Status`. Tap **Apply**.
   - Tap **"Clear All Filters"** to show instant reset.

4. **Item Details & Contact**:
   - Tap any card to open the **Item Details Screen**.
   - Tap the **Bookmark Icon** to add the report to **Favorites**.
   - Tap **"Contact Reporter"** to reveal the contact dialogue and copy phone/email information to the clipboard.

5. **Quick Demo Login & Reporting**:
   - Tap the **Floating Action Button (+)** and select **"Report Lost Item"**.
   - When prompted for login, select **"Sign In / Demo"** and tap **"Quick Demo Login (Alex Sharma)"**.
   - Fill out the form:
     - Title: `Lost Black Parker Pen`
     - Category: `Other Belongings`
     - Campus Location: Select chip `Central Library - 2nd Floor Reading Room`
     - Description: `Metal clip engraved with initials`
   - Tap **"Publish Lost Item Report"**.
   - Show that the item appears immediately at the top of the **Home** and **Reports** lists, and the total count increments automatically.

6. **My Reports, Edit & Resolve**:
   - Go to the **My Reports** tab.
   - Tap **"Resolve"** on your report to toggle its status from `Open` to `Resolved`.
   - Edit the report title to `Recovered Black Parker Pen`.
   - Verify that the card displays the updated purple `Resolved` chip.
   - Delete a report and show the confirmation dialog.

7. **Theme Switching & Sample Data Reset**:
   - Go to the **Profile Tab**.
   - Toggle **Dark Mode Theme** to demonstrate full Material 3 dark styling.
   - Tap **"Reset Sample Data"** to demonstrate that all 16 initial records can be reloaded on demand.

---

## 11. Top 15 Flutter Lab Viva Questions & Short Answers

### Q1: What is Flutter and how does it differ from React Native?
**Answer:** Flutter is an open-source UI software development kit created by Google that compiles Dart code directly into native ARM/x86 machine code via its own rendering engine (Impeller/Skia). Unlike React Native, Flutter does not rely on a JavaScript bridge, resulting in smoother animations and consistent 60/120 FPS performance.

### Q2: Why did we choose Provider for state management in CampusFind X?
**Answer:** `Provider` is the officially recommended, beginner-friendly state management solution in Flutter. It is a wrapper around `InheritedWidget` that minimizes boilerplate code, separates business logic from UI widgets, and prevents unnecessary widget rebuilds using `context.watch()` and `Consumer`.

### Q3: What is the difference between `StatelessWidget` and `StatefulWidget`?
**Answer:** A `StatelessWidget` is immutable; its appearance depends solely on configuration information passed in its constructor and cannot change dynamically at runtime (e.g., `StatCard`). A `StatefulWidget` maintains mutable state in a separate `State` object across frames and can trigger UI rebuilds via `setState()` (e.g., `ReportLostScreen`, `SearchBarWidget`).

### Q4: Explain the difference between `context.watch<T>()` and `context.read<T>()`.
**Answer:** 
- `context.watch<T>()`: Listens to changes in the provider. Whenever `notifyListeners()` is called, the widget calling `watch` is rebuilt. Use inside `build()` methods.
- `context.read<T>()`: Reads the value of the provider once without subscribing to updates. Use inside callbacks like `onPressed` to avoid unnecessary widget rebuilds.

### Q5: How does data persist in CampusFind X without a backend?
**Answer:** Data is persisted using the `shared_preferences` package, which stores key-value pairs locally on the device (using Android `SharedPreferences` or browser `localStorage`). The Dart objects are converted to JSON maps via `toJson()`, encoded into strings using `jsonEncode()`, and deserialized on launch using `jsonDecode()` and `ItemReport.fromJson()`.

### Q6: What is the purpose of the Repository Pattern?
**Answer:** The repository pattern creates an abstraction layer between the domain logic (Providers) and data sources (local storage, SQLite, or future REST APIs). If we replace `SharedPreferences` with Firebase or PostgreSQL in the future, only the repository code changes; the UI screens and providers remain untouched.

### Q7: What is the role of `WidgetsFlutterBinding.ensureInitialized()` in `main()`?
**Answer:** It ensures that the Flutter engine's binary communication channels between the framework and the host platform are initialized before running any asynchronous platform channel operations (such as initializing `SharedPreferences` before `runApp()`).

### Q8: What is null safety in Dart and why is it important?
**Answer:** Sound null safety guarantees that variables cannot contain `null` unless explicitly declared as nullable (using `?`). This prevents the dreaded "Null Pointer Exception" or "NoSuchMethodError on null" at runtime by catching null errors during compile time.

### Q9: How does the search and filter mechanism work in `ItemProvider`?
**Answer:** `ItemProvider` maintains a master list `_reports` and a computed getter `filteredReports`. `filteredReports` runs Dart's `.where()` method on each item, checking whether the search keyword is contained in `title`, `description`, or `location`, and cross-checking `typeFilter`, `statusFilter`, and `categoryFilter`.

### Q10: How are passwords handled in this demonstration application?
**Answer:** Even though this is an offline demo, plain-text passwords are never stored. The user's input is hashed using the SHA-256 algorithm via Dart's `crypto` package: `sha256.convert(utf8.encode(password))`. During login, the newly entered password is hashed and compared to the stored hash.

### Q11: What is the purpose of `IndexedStack` in `MainNavigationScreen`?
**Answer:** `IndexedStack` maintains the state of multiple child screens simultaneously. When the student switches tabs between Home, Reports, Favorites, and Profile, the pages do not get disposed and rebuilt, preserving scroll positions and form inputs.

### Q12: Why do we use `dispose()` in `StatefulWidget`?
**Answer:** When a widget is removed from the widget tree permanently, `dispose()` must be overridden to release system resources such as `TextEditingController`, `AnimationController`, and `TabController` to prevent memory leaks.

### Q13: What is Material 3 and what are its key visual features?
**Answer:** Material 3 (Material You) is Google's modern design system. Its features include dynamic color schemes generated from seed colors (`ColorScheme.fromSeed`), pill-shaped chips (`FilterChip`, `ChoiceChip`), modern rounded cards with subtle borders, and modern navigation bars (`NavigationBar`).

### Q14: How are image selections handled if the user does not select a photo?
**Answer:** Image selection is completely optional. If no photo is selected (or if a local file is no longer available on disk), the UI gracefully falls back to an attractive category-specific Material icon enclosed in a tinted rounded container with no runtime errors.

### Q15: How can remote cloud synchronization be added in the future?
**Answer:** By implementing a remote data source inside `ItemRepository` (e.g., using `http` package for REST APIs or Firebase Firestore SDK) and syncing local `SharedPreferences` with remote server endpoints when an internet connection is detected.

---

## 12. Explanation of Key Dart Classes

| Class Name | File Location | Responsibility |
| :--- | :--- | :--- |
| `ItemReport` | `lib/models/item_report.dart` | Immutable domain model for lost/found items with `toJson()` and `fromJson()` for JSON serialization. |
| `AppUser` | `lib/models/app_user.dart` | Student account model featuring client-side SHA-256 password hashing. |
| `LocalStorageService` | `lib/services/local_storage_service.dart` | Direct interface to `SharedPreferences` managing disk I/O for reports, demo accounts, and preferences. |
| `SampleData` | `lib/services/sample_data.dart` | Provides 16 realistic college demonstration records covering diverse campus locations. |
| `ItemRepository` | `lib/repositories/item_repository.dart` | Single source of truth for items; performs CRUD operations and delegates persistence to `LocalStorageService`. |
| `AuthRepository` | `lib/repositories/auth_repository.dart` | Handles local login validation, duplicate account prevention, quick demo access, and session management. |
| `ItemProvider` | `lib/providers/item_provider.dart` | Reactive state provider managing reports, search queries, active filter combinations, and live statistics. |
| `AuthProvider` | `lib/providers/auth_provider.dart` | Reactive state provider holding the current authenticated student and handling login/register actions. |
| `ThemeProvider` | `lib/providers/theme_provider.dart` | Manages theme mode switching (Light / Dark) and saves user selection. |
| `ItemCard` | `lib/widgets/item_card.dart` | Reusable card displaying item thumbnail/icon, title, status badges, location, date, and favorite action. |
| `StatCard` | `lib/widgets/stat_card.dart` | Dashboard widget displaying total counts and category icons with tap navigation. |

---

## 13. Future Enhancements

- **Push Notifications**: Notify students when an item matching their lost item's category and location is posted.
- **Campus Map Integration**: Interactive campus floor map highlighting lost and found locations.
- **In-App Student Chat**: Direct messaging between the owner and the finder without sharing phone numbers.
- **Cloud Backend Synchronization**: Backend REST API using PostgreSQL or Firebase for multi-device live synchronization.
- **AI Image Matching**: Automatic matching of photos between lost and found reports using computer vision.

---

*Developed for College Flutter Mobile Development Laboratory.*
=======
# CampusFind-X
A Flutter-based campus lost and found application
>>>>>>> f80cd42f80fef587b27595052e0f448ca8cabdda
