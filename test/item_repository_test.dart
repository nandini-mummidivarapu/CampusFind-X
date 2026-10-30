import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campusfindx/models/app_user.dart';
import 'package:campusfindx/models/item_report.dart';
import 'package:campusfindx/repositories/auth_repository.dart';
import 'package:campusfindx/repositories/item_repository.dart';
import 'package:campusfindx/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ItemReport Model Tests', () {
    test('JSON serialization and deserialization works correctly', () {
      final now = DateTime.now();
      final report = ItemReport(
        id: 'test_1',
        title: 'Lost Calculator',
        type: ItemType.lost,
        category: 'electronics',
        description: 'Scientific calculator fx-991EX',
        location: 'Lab 3',
        eventDate: now,
        contactInfo: 'Call 9876543210',
        reporterId: 'user_1',
        reporterName: 'Test Student',
        status: ItemStatus.open,
        createdAt: now,
        updatedAt: now,
      );

      final json = report.toJson();
      expect(json['id'], 'test_1');
      expect(json['type'], 'lost');
      expect(json['status'], 'open');

      final deserialized = ItemReport.fromJson(json);
      expect(deserialized.id, report.id);
      expect(deserialized.title, report.title);
      expect(deserialized.type, ItemType.lost);
      expect(deserialized.status, ItemStatus.open);
      expect(deserialized.isOpen, true);
      expect(deserialized.isLost, true);
    });

    test('copyWith updates properties accurately', () {
      final report = ItemReport(
        id: 'test_2',
        title: 'Original Title',
        type: ItemType.lost,
        category: 'keys',
        description: 'Keys',
        location: 'Parking',
        eventDate: DateTime.now(),
        reporterId: 'user_1',
        reporterName: 'Test Student',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updated = report.copyWith(
        title: 'Updated Title',
        status: ItemStatus.resolved,
      );

      expect(updated.title, 'Updated Title');
      expect(updated.status, ItemStatus.resolved);
      expect(updated.isResolved, true);
      expect(updated.category, 'keys');
    });
  });

  group('AppUser Model & Security Tests', () {
    test('Password hashing and verification works', () {
      const plainPassword = 'securePassword123';
      final hash = AppUser.hashPassword(plainPassword);

      final user = AppUser(
        id: 'user_01',
        fullName: 'Jane Doe',
        email: 'jane@college.edu',
        passwordHash: hash,
        joinedAt: DateTime.now(),
      );

      expect(user.verifyPassword(plainPassword), true);
      expect(user.verifyPassword('wrongPassword'), false);
    });
  });

  group('ItemRepository Local Persistence Tests', () {
    late LocalStorageService storageService;
    late ItemRepository itemRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await LocalStorageService.init();
      itemRepository = ItemRepository(storageService);
    });

    test('Initial sample data contains at least 15 items', () async {
      final reports = await itemRepository.getAllReports();
      expect(reports.length, greaterThanOrEqualTo(15));
    });

    test('Add report creates and prepends item', () async {
      final initialCount = (await itemRepository.getAllReports()).length;

      final newReport = ItemReport(
        id: 'custom_01',
        title: 'Lost Umbrella',
        type: ItemType.lost,
        category: 'others',
        description: 'Black umbrella',
        location: 'Canteen',
        eventDate: DateTime.now(),
        reporterId: 'user_99',
        reporterName: 'Sam',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await itemRepository.addReport(newReport);

      final updatedReports = await itemRepository.getAllReports();
      expect(updatedReports.length, initialCount + 1);
      expect(updatedReports.first.id, 'custom_01');
    });

    test('Update report modifies existing item', () async {
      final reports = await itemRepository.getAllReports();
      final target = reports.first;

      final modified = target.copyWith(title: 'Edited Title Test');
      await itemRepository.updateReport(modified);

      final refreshedReports = await itemRepository.getAllReports();
      final found = refreshedReports.firstWhere((r) => r.id == target.id);
      expect(found.title, 'Edited Title Test');
    });

    test('Toggle resolve status changes open to resolved', () async {
      final reports = await itemRepository.getAllReports();
      final openReport = reports.firstWhere((r) => r.isOpen);

      final resolved = await itemRepository.toggleResolveStatus(openReport.id);
      expect(resolved?.status, ItemStatus.resolved);
      expect(resolved?.isResolved, true);
    });

    test('Delete report removes item from repository and favorites', () async {
      final reports = await itemRepository.getAllReports();
      final target = reports.first;

      final currentFavs = await itemRepository.getFavorites();
      if (!currentFavs.contains(target.id)) {
        await itemRepository.toggleFavorite(target.id);
      }
      expect((await itemRepository.getFavorites()).contains(target.id), true);

      await itemRepository.deleteReport(target.id);

      final updatedReports = await itemRepository.getAllReports();
      expect(updatedReports.any((r) => r.id == target.id), false);

      final favorites = await itemRepository.getFavorites();
      expect(favorites.contains(target.id), false);
    });

    test('Favorites toggles on and off correctly', () async {
      const testId = 'sample_02';
      final favs1 = await itemRepository.toggleFavorite(testId);
      final wasAdded = favs1.contains(testId);

      final favs2 = await itemRepository.toggleFavorite(testId);
      expect(favs2.contains(testId), !wasAdded);
    });
  });

  group('AuthRepository Tests', () {
    late LocalStorageService storageService;
    late AuthRepository authRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await LocalStorageService.init();
      authRepository = AuthRepository(storageService);
    });

    test('Quick demo login succeeds with default student', () async {
      final user = await authRepository.quickDemoLogin();
      expect(user.fullName, 'Alex Sharma');
      expect(user.email, 'alex.sharma@college.edu');

      final current = await authRepository.getCurrentUser();
      expect(current?.id, user.id);
    });

    test('Register prevents duplicate emails', () async {
      await authRepository.register(
        fullName: 'Test User',
        email: 'test@college.edu',
        password: 'password123',
      );

      expect(
        () async => await authRepository.register(
          fullName: 'Another User',
          email: 'test@college.edu',
          password: 'password456',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Login with invalid credentials throws exception', () async {
      expect(
        () async =>
            await authRepository.login('nonexistent@college.edu', 'pass'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
