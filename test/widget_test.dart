import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campusfindx/app.dart';
import 'package:campusfindx/models/item_report.dart';
import 'package:campusfindx/providers/auth_provider.dart';
import 'package:campusfindx/providers/item_provider.dart';
import 'package:campusfindx/providers/theme_provider.dart';
import 'package:campusfindx/repositories/auth_repository.dart';
import 'package:campusfindx/repositories/item_repository.dart';
import 'package:campusfindx/services/local_storage_service.dart';
import 'package:campusfindx/utils/app_constants.dart';
import 'package:campusfindx/widgets/item_card.dart';
import 'package:campusfindx/widgets/stat_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CampusFindXApp loads and displays Splash branding', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await LocalStorageService.init();
    final itemRepo = ItemRepository(storageService);
    final authRepo = AuthRepository(storageService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(storageService),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(authRepo),
          ),
          ChangeNotifierProvider<ItemProvider>(
            create: (_) => ItemProvider(itemRepo),
          ),
        ],
        child: const CampusFindXApp(),
      ),
    );

    // Verify app brand is rendered
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);

    // Let the splash navigation timer elapse and settle
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('StatCard displays title, count and responds to taps', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatCard(
            title: 'Lost Items',
            count: 7,
            icon: Icons.search_off_rounded,
            color: Colors.red,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Lost Items'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);

    await tester.tap(find.byType(StatCard));
    expect(tapped, true);
  });

  testWidgets('ItemCard renders title, location and badges correctly', (
    WidgetTester tester,
  ) async {
    final sampleReport = ItemReport(
      id: 'card_test',
      title: 'Titan Fastrack Watch',
      type: ItemType.lost,
      category: 'watches',
      description: 'Black strap sports watch',
      location: 'Basketball Court',
      eventDate: DateTime.now(),
      reporterId: 'user_1',
      reporterName: 'John',
      status: ItemStatus.open,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemCard(
            report: sampleReport,
            isFavorite: false,
            onTap: () {},
            onFavoriteToggle: () {},
          ),
        ),
      ),
    );

    expect(find.text('Titan Fastrack Watch'), findsOneWidget);
    expect(find.text('Basketball Court'), findsOneWidget);
    expect(find.text('Lost'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
  });
}
