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
}
