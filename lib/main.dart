import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/item_provider.dart';
import 'providers/theme_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/item_repository.dart';
import 'services/local_storage_service.dart';

/// Application entry point
void main() async {
  // Ensure Flutter engine bindings are initialized prior to asynchronous calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local persistence service (SharedPreferences and seed initial sample data)
  final storageService = await LocalStorageService.init();

  // Initialize repository layer
  final itemRepository = ItemRepository(storageService);
  final authRepository = AuthRepository(storageService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider<ItemProvider>(
          create: (_) => ItemProvider(itemRepository),
        ),
      ],
      child: const CampusFindXApp(),
    ),
  );
}
