class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final String phone;
  final String address;
  final String avatarUrl;
  final double rating;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.phone,
    required this.address,
    this.avatarUrl = '',
    this.rating = 4.9,
  });

  Doctor copyWith({
    String? id,
    String? name,
    String? specialization,
    String? hospital,
    String? phone,
    String? address,
    String? avatarUrl,
    double? rating,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      hospital: hospital ?? this.hospital,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialization': specialization,
        'hospital': hospital,
        'phone': phone,
        'address': address,
        'avatarUrl': avatarUrl,
        'rating': rating,
      };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        specialization: json['specialization'] ?? '',
        hospital: json['hospital'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        avatarUrl: json['avatarUrl'] ?? '',
        rating: (json['rating'] ?? 4.9).toDouble(),
      );
}
