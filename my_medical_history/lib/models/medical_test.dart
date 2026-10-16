class MedicalTest {
  final String id;
  final String testName;
  final DateTime testDate;
  final String result;
  final String doctorNotes;
  final String? reportAttachmentPath;
  final String? fileType; // PDF, Image, etc.

  MedicalTest({
    required this.id,
    required this.testName,
    required this.testDate,
    required this.result,
    required this.doctorNotes,
    this.reportAttachmentPath,
    this.fileType,
  });

  MedicalTest copyWith({
    String? id,
    String? testName,
    DateTime? testDate,
    String? result,
    String? doctorNotes,
    String? reportAttachmentPath,
    String? fileType,
  }) {
    return MedicalTest(
      id: id ?? this.id,
      testName: testName ?? this.testName,
      testDate: testDate ?? this.testDate,
      result: result ?? this.result,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      reportAttachmentPath: reportAttachmentPath ?? this.reportAttachmentPath,
      fileType: fileType ?? this.fileType,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'testName': testName,
        'testDate': testDate.toIso8601String(),
        'result': result,
        'doctorNotes': doctorNotes,
        'reportAttachmentPath': reportAttachmentPath,
        'fileType': fileType,
      };

  factory MedicalTest.fromJson(Map<String, dynamic> json) => MedicalTest(
        id: json['id'] ?? '',
        testName: json['testName'] ?? '',
        testDate: json['testDate'] != null
            ? DateTime.parse(json['testDate'])
            : DateTime.now(),
        result: json['result'] ?? '',
        doctorNotes: json['doctorNotes'] ?? '',
        reportAttachmentPath: json['reportAttachmentPath'],
        fileType: json['fileType'],
      );
}
