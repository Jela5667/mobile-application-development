import 'doctor.dart';
import 'medicine.dart';
import 'medical_test.dart';

class MedicalVisit {
  final String id;
  final String doctorId;
  final Doctor doctor;
  final DateTime visitDate;
  final String visitTime;
  final String reasonForVisit;
  final List<String> symptoms;
  final String diagnosis;
  final String doctorNotes;
  final DateTime? followUpDate;
  final String hospitalAddress;
  final List<Medicine> medicines;
  final List<MedicalTest> tests;
  final String? prescriptionAttachmentPath;
  final String? prescriptionFileType; // PDF, Image
  final List<String> attachments;

  MedicalVisit({
    required this.id,
    required this.doctorId,
    required this.doctor,
    required this.visitDate,
    required this.visitTime,
    required this.reasonForVisit,
    required this.symptoms,
    required this.diagnosis,
    required this.doctorNotes,
    this.followUpDate,
    required this.hospitalAddress,
    this.medicines = const [],
    this.tests = const [],
    this.prescriptionAttachmentPath,
    this.prescriptionFileType,
    this.attachments = const [],
  });

  MedicalVisit copyWith({
    String? id,
    String? doctorId,
    Doctor? doctor,
    DateTime? visitDate,
    String? visitTime,
    String? reasonForVisit,
    List<String>? symptoms,
    String? diagnosis,
    String? doctorNotes,
    DateTime? followUpDate,
    String? hospitalAddress,
    List<Medicine>? medicines,
    List<MedicalTest>? tests,
    String? prescriptionAttachmentPath,
    String? prescriptionFileType,
    List<String>? attachments,
  }) {
    return MedicalVisit(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctor: doctor ?? this.doctor,
      visitDate: visitDate ?? this.visitDate,
      visitTime: visitTime ?? this.visitTime,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      followUpDate: followUpDate ?? this.followUpDate,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      medicines: medicines ?? this.medicines,
      tests: tests ?? this.tests,
      prescriptionAttachmentPath: prescriptionAttachmentPath ?? this.prescriptionAttachmentPath,
      prescriptionFileType: prescriptionFileType ?? this.prescriptionFileType,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'doctor': doctor.toJson(),
        'visitDate': visitDate.toIso8601String(),
        'visitTime': visitTime,
        'reasonForVisit': reasonForVisit,
        'symptoms': symptoms,
        'diagnosis': diagnosis,
        'doctorNotes': doctorNotes,
        'followUpDate': followUpDate?.toIso8601String(),
        'hospitalAddress': hospitalAddress,
        'medicines': medicines.map((m) => m.toJson()).toList(),
        'tests': tests.map((t) => t.toJson()).toList(),
        'prescriptionAttachmentPath': prescriptionAttachmentPath,
        'prescriptionFileType': prescriptionFileType,
        'attachments': attachments,
      };

  factory MedicalVisit.fromJson(Map<String, dynamic> json) => MedicalVisit(
        id: json['id'] ?? '',
        doctorId: json['doctorId'] ?? '',
        doctor: json['doctor'] != null
            ? Doctor.fromJson(json['doctor'])
            : Doctor(id: 'doc_1', name: 'Dr. Ahmed Khan', specialization: 'Cardiologist', hospital: 'City Medical Hospital', phone: '', address: ''),
        visitDate: json['visitDate'] != null
            ? DateTime.parse(json['visitDate'])
            : DateTime.now(),
        visitTime: json['visitTime'] ?? '',
        reasonForVisit: json['reasonForVisit'] ?? '',
        symptoms: json['symptoms'] != null
            ? List<String>.from(json['symptoms'])
            : [],
        diagnosis: json['diagnosis'] ?? '',
        doctorNotes: json['doctorNotes'] ?? '',
        followUpDate: json['followUpDate'] != null
            ? DateTime.tryParse(json['followUpDate'])
            : null,
        hospitalAddress: json['hospitalAddress'] ?? '',
        medicines: json['medicines'] != null
            ? (json['medicines'] as List).map((m) => Medicine.fromJson(m)).toList()
            : [],
        tests: json['tests'] != null
            ? (json['tests'] as List).map((t) => MedicalTest.fromJson(t)).toList()
            : [],
        prescriptionAttachmentPath: json['prescriptionAttachmentPath'],
        prescriptionFileType: json['prescriptionFileType'],
        attachments: json['attachments'] != null
            ? List<String>.from(json['attachments'])
            : [],
      );
}
