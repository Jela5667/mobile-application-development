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
}
