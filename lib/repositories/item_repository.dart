import '../models/item_report.dart';
import '../services/local_storage_service.dart';

/// Repository handling item reports and favorites persistence.
/// Encapsulates local data access so a remote REST/GraphQL API could be swapped in seamlessly.
class ItemRepository {
  final LocalStorageService _storageService;

  ItemRepository(this._storageService);

  /// Fetch all stored reports
  Future<List<ItemReport>> getAllReports() async {
    return _storageService.loadReports();
  }

  /// Create and persist a new report
  Future<ItemReport> addReport(ItemReport report) async {
    final currentList = _storageService.loadReports();
    // Prepend new report to show at top of recent list
    final updatedList = [report, ...currentList];
    await _storageService.saveReports(updatedList);
    return report;
  }

  /// Update an existing report
  Future<ItemReport> updateReport(ItemReport updatedReport) async {
    final currentList = _storageService.loadReports();
    final index = currentList.indexWhere((r) => r.id == updatedReport.id);
    if (index == -1) {
      throw Exception('Report with ID ${updatedReport.id} not found.');
    }
    currentList[index] = updatedReport.copyWith(updatedAt: DateTime.now());
    await _storageService.saveReports(currentList);
    return currentList[index];
  }

  /// Delete a report by ID
  Future<bool> deleteReport(String id) async {
    final currentList = _storageService.loadReports();
    final updatedList = currentList.where((r) => r.id != id).toList();
    final success = await _storageService.saveReports(updatedList);

    // Also remove from favorites if present
    final currentFavorites = _storageService.loadFavorites();
    if (currentFavorites.contains(id)) {
      currentFavorites.remove(id);
      await _storageService.saveFavorites(currentFavorites);
    }

    return success;
  }

  /// Toggle report resolution status between Open and Resolved
  Future<ItemReport?> toggleResolveStatus(String id) async {
    final currentList = _storageService.loadReports();
    final index = currentList.indexWhere((r) => r.id == id);
    if (index == -1) return null;

    final currentReport = currentList[index];
    final newStatus = currentReport.status == ItemStatus.open
        ? ItemStatus.resolved
        : ItemStatus.open;

    final updatedReport = currentReport.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    currentList[index] = updatedReport;
    await _storageService.saveReports(currentList);
    return updatedReport;
  }

  /// Get list of favorite IDs
  Future<List<String>> getFavorites() async {
    return _storageService.loadFavorites();
  }

  /// Add or remove a report ID from favorites
  Future<List<String>> toggleFavorite(String id) async {
    final favorites = List<String>.from(_storageService.loadFavorites());
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await _storageService.saveFavorites(favorites);
    return favorites;
  }

  /// Reset data to initial sample dataset (for lab demonstrations)
  Future<void> resetToSampleData() async {
    await _storageService.resetToSampleData();
  }
}
