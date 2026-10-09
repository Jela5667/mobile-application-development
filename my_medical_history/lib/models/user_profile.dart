class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String bloodGroup;
  final String avatarUrl;
  final bool isDriveConnected;
  final DateTime? lastSyncedAt;
  final String driveStorageUsed;
  final bool autoSyncEnabled;
  final bool appLockEnabled;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    this.avatarUrl = '',
    this.isDriveConnected = true,
    this.lastSyncedAt,
    this.driveStorageUsed = '14.2 MB',
    this.autoSyncEnabled = true,
    this.appLockEnabled = false,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    int? age,
    String? gender,
    String? bloodGroup,
    String? avatarUrl,
    bool? isDriveConnected,
    DateTime? lastSyncedAt,
    String? driveStorageUsed,
    bool? autoSyncEnabled,
    bool? appLockEnabled,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isDriveConnected: isDriveConnected ?? this.isDriveConnected,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      driveStorageUsed: driveStorageUsed ?? this.driveStorageUsed,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    );
  }
}
