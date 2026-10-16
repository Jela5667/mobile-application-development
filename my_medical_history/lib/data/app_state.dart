import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doctor.dart';
import '../models/medical_visit.dart';
import '../models/medicine.dart';
import '../models/medical_test.dart';
import '../models/report.dart';
import '../models/user_profile.dart';
import 'sample_data.dart';

class AppState extends ChangeNotifier {
  UserProfile _userProfile = SampleData.defaultProfile;
  final List<Doctor> _doctors = List.from(SampleData.doctors);
  final List<MedicalVisit> _visits = List.from(SampleData.visits);
  final List<MedicalReport> _reports = List.from(SampleData.reports);

  // App UI & System States
  bool _isOffline = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isSyncing = false;
  String _appPin = '1234';

  // Active Filter States
  String? _filterDoctorId;
  String? _filterHospital;
  String? _filterDiagnosis;
  String? _filterMedicine;
  DateTimeRange? _filterDateRange;

  Future<void> initPersistence() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load Profile
      final profileStr = prefs.getString('user_profile');
      if (profileStr != null) {
        var loadedProfile = UserProfile.fromJson(jsonDecode(profileStr));
        if (loadedProfile.email != 'jameelkharal70@gmail.com' ||
            !loadedProfile.isDriveConnected) {
          loadedProfile = loadedProfile.copyWith(
            name: 'M jameel',
            email: 'jameelkharal70@gmail.com',
            phone: '03034086970',
            isDriveConnected: true,
            appLockEnabled: true,
          );
        }
        _userProfile = loadedProfile;
      } else {
        _userProfile = SampleData.defaultProfile;
      }
      await prefs.setString('user_profile', jsonEncode(_userProfile.toJson()));

      // Load Doctors
      final doctorsStr = prefs.getString('doctors_list');
      if (doctorsStr != null) {
        final List decoded = jsonDecode(doctorsStr);
        _doctors.clear();
        _doctors.addAll(decoded.map((e) => Doctor.fromJson(e)));
      } else {
        await prefs.setString(
            'doctors_list', jsonEncode(_doctors.map((d) => d.toJson()).toList()));
      }

      // Load Visits
      final visitsStr = prefs.getString('visits_list');
      if (visitsStr != null) {
        final List decoded = jsonDecode(visitsStr);
        _visits.clear();
        _visits.addAll(decoded.map((e) => MedicalVisit.fromJson(e)));
      } else {
        await prefs.setString(
            'visits_list', jsonEncode(_visits.map((v) => v.toJson()).toList()));
      }

      // Load Reports
      final reportsStr = prefs.getString('reports_list');
      if (reportsStr != null) {
        final List decoded = jsonDecode(reportsStr);
        _reports.clear();
        _reports.addAll(decoded.map((e) => MedicalReport.fromJson(e)));
      } else {
        await prefs.setString(
            'reports_list', jsonEncode(_reports.map((r) => r.toJson()).toList()));
      }

      // Load PIN
      _appPin = prefs.getString('app_pin') ?? '1234';

      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing persistent data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', jsonEncode(_userProfile.toJson()));
      await prefs.setString(
          'doctors_list', jsonEncode(_doctors.map((d) => d.toJson()).toList()));
      await prefs.setString(
          'visits_list', jsonEncode(_visits.map((v) => v.toJson()).toList()));
      await prefs.setString(
          'reports_list', jsonEncode(_reports.map((r) => r.toJson()).toList()));
      await prefs.setString('app_pin', _appPin);
    } catch (e) {
      debugPrint('Error saving persistent data: $e');
    }
  }

  // Getters
  UserProfile get userProfile => _userProfile;
  List<Doctor> get doctors => List.unmodifiable(_doctors);
  List<MedicalVisit> get visits => List.unmodifiable(_visits);
  List<MedicalReport> get reports => List.unmodifiable(_reports);

  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  bool get isSyncing => _isSyncing;
  String get appPin => _appPin;

  String? get filterDoctorId => _filterDoctorId;
  String? get filterHospital => _filterHospital;
  String? get filterDiagnosis => _filterDiagnosis;
  String? get filterMedicine => _filterMedicine;
  DateTimeRange? get filterDateRange => _filterDateRange;

  bool get hasActiveFilters =>
      _filterDoctorId != null ||
      _filterHospital != null ||
      _filterDiagnosis != null ||
      _filterMedicine != null ||
      _filterDateRange != null;

  // Aggregate Stats
  int get totalDoctorsCount => _doctors.length;
  int get totalVisitsCount => _visits.length;
  int get totalMedicinesCount => getAllMedicines().length;
  int get totalReportsCount => _reports.length;

  // Filtered Visits
  List<MedicalVisit> get filteredVisits {
    return _visits.where((visit) {
      if (_filterDoctorId != null && visit.doctorId != _filterDoctorId) {
        return false;
      }
      if (_filterHospital != null &&
          !visit.doctor.hospital
              .toLowerCase()
              .contains(_filterHospital!.toLowerCase())) {
        return false;
      }
      if (_filterDiagnosis != null &&
          !visit.diagnosis
              .toLowerCase()
              .contains(_filterDiagnosis!.toLowerCase())) {
        return false;
      }
      if (_filterMedicine != null) {
        final containsMed = visit.medicines.any((m) =>
            m.name.toLowerCase().contains(_filterMedicine!.toLowerCase()));
        if (!containsMed) return false;
      }
      if (_filterDateRange != null) {
        if (visit.visitDate.isBefore(_filterDateRange!.start) ||
            visit.visitDate
                .isAfter(_filterDateRange!.end.add(const Duration(days: 1)))) {
          return false;
        }
      }
      return true;
    }).toList()
      ..sort((a, b) => b.visitDate.compareTo(a.visitDate));
  }

  // Doctor Specific Visits
  List<MedicalVisit> getVisitsForDoctor(String doctorId) {
    return _visits.where((v) => v.doctorId == doctorId).toList()
      ..sort((a, b) => b.visitDate.compareTo(a.visitDate));
  }

  // Extract all medicines across all visits
  List<Medicine> getAllMedicines() {
    final List<Medicine> allMeds = [];
    for (var visit in _visits) {
      allMeds.addAll(visit.medicines);
    }
    return allMeds;
  }

  // Extract all medical tests across all visits
  List<MedicalTest> getAllTests() {
    final List<MedicalTest> allTests = [];
    for (var visit in _visits) {
      allTests.addAll(visit.tests);
    }
    return allTests;
  }

  // Upcoming follow-up visits
  List<MedicalVisit> getUpcomingFollowUps() {
    final now = DateTime.now();
    return _visits.where((v) {
      if (v.followUpDate == null) return false;
      return v.followUpDate!.isAfter(now.subtract(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a.followUpDate!.compareTo(b.followUpDate!));
  }

  // Search logic across doctors, visits, medicines, reports, diagnoses
  List<dynamic> searchAll(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();

    final List<dynamic> results = [];

    // Search Doctors
    for (var doc in _doctors) {
      if (doc.name.toLowerCase().contains(q) ||
          doc.specialization.toLowerCase().contains(q) ||
          doc.hospital.toLowerCase().contains(q)) {
        results.add(doc);
      }
    }

    // Search Visits & Diagnoses
    for (var visit in _visits) {
      if (visit.diagnosis.toLowerCase().contains(q) ||
          visit.reasonForVisit.toLowerCase().contains(q) ||
          visit.doctor.name.toLowerCase().contains(q) ||
          visit.doctor.hospital.toLowerCase().contains(q) ||
          visit.symptoms.any((s) => s.toLowerCase().contains(q))) {
        if (!results.contains(visit)) {
          results.add(visit);
        }
      }
    }

    // Search Medicines
    for (var visit in _visits) {
      for (var med in visit.medicines) {
        if (med.name.toLowerCase().contains(q) ||
            med.instructions.toLowerCase().contains(q)) {
          if (!results.contains(med)) {
            results.add(med);
          }
        }
      }
    }

    // Search Reports
    for (var rep in _reports) {
      if (rep.title.toLowerCase().contains(q) ||
          rep.category.toLowerCase().contains(q) ||
          rep.doctorName.toLowerCase().contains(q) ||
          rep.hospitalName.toLowerCase().contains(q)) {
        if (!results.contains(rep)) {
          results.add(rep);
        }
      }
    }

    return results;
  }

  // --- ACTIONS & MUTATIONS ---

  Future<void> addDoctor(Doctor doctor) async {
    _doctors.add(doctor);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateDoctor(Doctor updatedDoc) async {
    final index = _doctors.indexWhere((d) => d.id == updatedDoc.id);
    if (index != -1) {
      _doctors[index] = updatedDoc;
      for (int i = 0; i < _visits.length; i++) {
        if (_visits[i].doctorId == updatedDoc.id) {
          _visits[i] = _visits[i].copyWith(doctor: updatedDoc);
        }
      }
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> addVisit(MedicalVisit visit) async {
    _visits.insert(0, visit);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateVisit(MedicalVisit updatedVisit) async {
    final index = _visits.indexWhere((v) => v.id == updatedVisit.id);
    if (index != -1) {
      _visits[index] = updatedVisit;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteVisit(String visitId) async {
    _visits.removeWhere((v) => v.id == visitId);
    await _saveData();
    notifyListeners();
  }

  Future<void> addReport(MedicalReport report) async {
    _reports.insert(0, report);
    await _saveData();
    notifyListeners();
  }

  Future<void> deleteReport(String reportId) async {
    _reports.removeWhere((r) => r.id == reportId);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    _userProfile = profile;
    await _saveData();
    notifyListeners();
  }

  void toggleOfflineMode(bool value) {
    _isOffline = value;
    notifyListeners();
  }

  Future<void> toggleAutoSync(bool value) async {
    _userProfile = _userProfile.copyWith(autoSyncEnabled: value);
    await _saveData();
    notifyListeners();
  }

  Future<void> toggleAppLock(bool value) async {
    _userProfile = _userProfile.copyWith(appLockEnabled: value);
    await _saveData();
    notifyListeners();
  }

  Future<void> setDriveConnected(bool connected) async {
    _userProfile = _userProfile.copyWith(isDriveConnected: connected);
    await _saveData();
    notifyListeners();
  }

  Future<void> updatePin(String newPin) async {
    _appPin = newPin;
    await _saveData();
    notifyListeners();
  }

  Future<void> triggerSync() async {
    _isSyncing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isSyncing = false;
    _userProfile = _userProfile.copyWith(
      lastSyncedAt: DateTime.now(),
    );
    await _saveData();
    notifyListeners();
  }

  void applyFilters({
    String? doctorId,
    String? hospital,
    String? diagnosis,
    String? medicine,
    DateTimeRange? dateRange,
  }) {
    _filterDoctorId = doctorId;
    _filterHospital = hospital;
    _filterDiagnosis = diagnosis;
    _filterMedicine = medicine;
    _filterDateRange = dateRange;
    notifyListeners();
  }

  void clearFilters() {
    _filterDoctorId = null;
    _filterHospital = null;
    _filterDiagnosis = null;
    _filterMedicine = null;
    _filterDateRange = null;
    notifyListeners();
  }

  void setSimulatedError(bool error, {String? message}) {
    _hasError = error;
    _errorMessage = message ?? 'An unexpected error occurred. Please try again.';
    notifyListeners();
  }

  void setSimulatedLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
