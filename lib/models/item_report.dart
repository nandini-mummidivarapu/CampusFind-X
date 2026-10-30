/// Item report type: Lost by student or Found by student
enum ItemType {
  lost,
  found;

  String get displayName => this == ItemType.lost ? 'Lost' : 'Found';

  static ItemType fromString(String value) {
    return value.toLowerCase() == 'found' ? ItemType.found : ItemType.lost;
  }
}

/// Status of the report: Open (unresolved) or Resolved (reunited)
enum ItemStatus {
  open,
  resolved;

  String get displayName => this == ItemStatus.open ? 'Open' : 'Resolved';

  static ItemStatus fromString(String value) {
    return value.toLowerCase() == 'resolved'
        ? ItemStatus.resolved
        : ItemStatus.open;
  }
}

/// Core model representing a Lost or Found item report in CampusFind X
class ItemReport {
  final String id;
  final String title;
  final ItemType type;
  final String category;
  final String description;
  final String location;
  final DateTime eventDate;
  final String? imagePath;
  final String? contactInfo;
  final String reporterId;
  final String reporterName;
  final ItemStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemReport({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.description,
    required this.location,
    required this.eventDate,
    this.imagePath,
    this.contactInfo,
    required this.reporterId,
    required this.reporterName,
    this.status = ItemStatus.open,
    required this.createdAt,
    required this.updatedAt,
  });

  /// True if the item is still unresolved
  bool get isOpen => status == ItemStatus.open;

  /// True if the item was reunited/returned
  bool get isResolved => status == ItemStatus.resolved;

  /// True if item is lost
  bool get isLost => type == ItemType.lost;

  /// True if item was found
  bool get isFound => type == ItemType.found;

  /// Convert object to JSON map for local persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'category': category,
      'description': description,
      'location': location,
      'eventDate': eventDate.toIso8601String(),
      'imagePath': imagePath,
      'contactInfo': contactInfo,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create an ItemReport from JSON map
  factory ItemReport.fromJson(Map<String, dynamic> json) {
    return ItemReport(
      id: json['id'] as String,
      title: json['title'] as String,
      type: ItemType.fromString(json['type'] as String? ?? 'lost'),
      category: json['category'] as String? ?? 'others',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      eventDate: json['eventDate'] != null
          ? DateTime.parse(json['eventDate'] as String)
          : DateTime.now(),
      imagePath: json['imagePath'] as String?,
      contactInfo: json['contactInfo'] as String?,
      reporterId: json['reporterId'] as String? ?? 'anonymous',
      reporterName: json['reporterName'] as String? ?? 'Anonymous Student',
      status: ItemStatus.fromString(json['status'] as String? ?? 'open'),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Immutability helper to copy with updated values
  ItemReport copyWith({
    String? id,
    String? title,
    ItemType? type,
    String? category,
    String? description,
    String? location,
    DateTime? eventDate,
    String? imagePath,
    String? contactInfo,
    String? reporterId,
    String? reporterName,
    ItemStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemReport(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      category: category ?? this.category,
      description: description ?? this.description,
      location: location ?? this.location,
      eventDate: eventDate ?? this.eventDate,
      imagePath: imagePath ?? this.imagePath,
      contactInfo: contactInfo ?? this.contactInfo,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
