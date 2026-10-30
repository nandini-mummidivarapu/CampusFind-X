import 'package:flutter/material.dart';
import '../models/item_report.dart';
import '../repositories/item_repository.dart';

/// Provider managing lost and found item reports, filtering, searching,
/// statistics, and favorites state.
class ItemProvider extends ChangeNotifier {
  final ItemRepository _itemRepository;

  List<ItemReport> _reports = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = false;

  // Search and Filter State
  String _searchQuery = '';
  ItemType? _typeFilter; // null = all
  ItemStatus? _statusFilter; // null = all
  String? _categoryFilter; // null = all

  ItemProvider(this._itemRepository) {
    loadData();
  }

  // Getters
  List<ItemReport> get reports => List.unmodifiable(_reports);
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  bool get isLoading => _isLoading;

  String get searchQuery => _searchQuery;
  ItemType? get typeFilter => _typeFilter;
  ItemStatus? get statusFilter => _statusFilter;
  String? get categoryFilter => _categoryFilter;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _typeFilter != null ||
      _statusFilter != null ||
      _categoryFilter != null;

  /// Load reports and favorites from local storage
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _reports = await _itemRepository.getAllReports();
    final favList = await _itemRepository.getFavorites();
    _favoriteIds = favList.toSet();

    _isLoading = false;
    notifyListeners();
  }

  /// Reset to original 16 sample items
  Future<void> resetToSampleData() async {
    _isLoading = true;
    notifyListeners();

    await _itemRepository.resetToSampleData();
    await loadData();
  }

  // ==================== DASHBOARD STATISTICS ====================
  // Computed dynamically from actual saved items; never hardcoded!
  int get totalCount => _reports.length;
  int get lostCount => _reports.where((r) => r.isLost).length;
  int get foundCount => _reports.where((r) => r.isFound).length;
  int get resolvedCount => _reports.where((r) => r.isResolved).length;
  int get openCount => _reports.where((r) => r.isOpen).length;

  /// 5 most recently reported items
  List<ItemReport> get recentReports {
    final sorted = List<ItemReport>.from(_reports);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(6).toList();
  }

  /// Reports created by the specified user
  List<ItemReport> getUserReports(String userId) {
    return _reports.where((r) => r.reporterId == userId).toList();
  }

  /// List of items marked as favorites
  List<ItemReport> get favoriteReports {
    return _reports.where((r) => _favoriteIds.contains(r.id)).toList();
  }

  /// Main filtered list used by the All Reports screen
  List<ItemReport> get filteredReports {
    return _reports.where((item) {
      // 1. Text search matching title, description, or campus location
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = item.title.toLowerCase().contains(q);
        final matchesDesc = item.description.toLowerCase().contains(q);
        final matchesLoc = item.location.toLowerCase().contains(q);
        if (!matchesTitle && !matchesDesc && !matchesLoc) {
          return false;
        }
      }

      // 2. Type filter (Lost / Found)
      if (_typeFilter != null && item.type != _typeFilter) {
        return false;
      }

      // 3. Status filter (Open / Resolved)
      if (_statusFilter != null && item.status != _statusFilter) {
        return false;
      }

      // 4. Category filter
      if (_categoryFilter != null &&
          item.category.toLowerCase() != _categoryFilter!.toLowerCase()) {
        return false;
      }

      return true;
    }).toList();
  }

  // ==================== FILTER ACTIONS ====================

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setTypeFilter(ItemType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void setStatusFilter(ItemStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _typeFilter = null;
    _statusFilter = null;
    _categoryFilter = null;
    notifyListeners();
  }

  // ==================== CRUD OPERATIONS ====================

  /// Add new report
  Future<ItemReport> addReport(ItemReport report) async {
    final created = await _itemRepository.addReport(report);
    _reports.insert(0, created);
    notifyListeners();
    return created;
  }

  /// Edit existing report
  Future<ItemReport> updateReport(ItemReport report) async {
    final updated = await _itemRepository.updateReport(report);
    final index = _reports.indexWhere((r) => r.id == report.id);
    if (index != -1) {
      _reports[index] = updated;
      notifyListeners();
    }
    return updated;
  }

  /// Delete a report
  Future<void> deleteReport(String id) async {
    await _itemRepository.deleteReport(id);
    _reports.removeWhere((r) => r.id == id);
    _favoriteIds.remove(id);
    notifyListeners();
  }

  /// Toggle resolution status (Open <-> Resolved)
  Future<void> toggleResolveReport(String id) async {
    final updated = await _itemRepository.toggleResolveStatus(id);
    if (updated != null) {
      final index = _reports.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reports[index] = updated;
        notifyListeners();
      }
    }
  }

  /// Check if item is favorited
  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final updatedFavorites = await _itemRepository.toggleFavorite(id);
    _favoriteIds = updatedFavorites.toSet();
    notifyListeners();
  }
}
