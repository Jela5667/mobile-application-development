class MedicalReport {
  final String id;
  final String title;
  final String category; // Blood Tests, X-Ray, MRI, CT Scan, Ultrasound, Other
  final DateTime date;
  final String doctorName;
  final String hospitalName;
  final String fileType; // PDF, Image
  final String fileSize;
  final String fileUrl;

  MedicalReport({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.doctorName,
    required this.hospitalName,
    required this.fileType,
    required this.fileSize,
    required this.fileUrl,
  });

  MedicalReport copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? date,
    String? doctorName,
    String? hospitalName,
    String? fileType,
    String? fileSize,
    String? fileUrl,
  }) {
    return MedicalReport(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      doctorName: doctorName ?? this.doctorName,
      hospitalName: hospitalName ?? this.hospitalName,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'date': date.toIso8601String(),
        'doctorName': doctorName,
        'hospitalName': hospitalName,
        'fileType': fileType,
        'fileSize': fileSize,
        'fileUrl': fileUrl,
      };

  factory MedicalReport.fromJson(Map<String, dynamic> json) => MedicalReport(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        category: json['category'] ?? '',
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
        doctorName: json['doctorName'] ?? '',
        hospitalName: json['hospitalName'] ?? '',
        fileType: json['fileType'] ?? 'PDF',
        fileSize: json['fileSize'] ?? '1.0 MB',
        fileUrl: json['fileUrl'] ?? '',
      );
}
