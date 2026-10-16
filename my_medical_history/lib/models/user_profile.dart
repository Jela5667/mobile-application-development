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
    this.appLockEnabled = true,
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'age': age,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'avatarUrl': avatarUrl,
        'isDriveConnected': isDriveConnected,
        'lastSyncedAt': lastSyncedAt?.toIso8601String(),
        'driveStorageUsed': driveStorageUsed,
        'autoSyncEnabled': autoSyncEnabled,
        'appLockEnabled': appLockEnabled,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] ?? 'usr_001',
        name: json['name'] ?? 'M jameel',
        email: json['email'] ?? 'jameelkharal70@gmail.com',
        phone: json['phone'] ?? '03034086970',
        age: json['age'] ?? 34,
        gender: json['gender'] ?? 'Male',
        bloodGroup: json['bloodGroup'] ?? 'O+',
        avatarUrl: json['avatarUrl'] ?? '',
        isDriveConnected: json['isDriveConnected'] ?? true,
        lastSyncedAt: json['lastSyncedAt'] != null
            ? DateTime.tryParse(json['lastSyncedAt'])
            : null,
        driveStorageUsed: json['driveStorageUsed'] ?? '14.2 MB',
        autoSyncEnabled: json['autoSyncEnabled'] ?? true,
        appLockEnabled: json['appLockEnabled'] ?? true,
      );
}
