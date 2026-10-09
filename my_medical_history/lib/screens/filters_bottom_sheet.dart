import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({super.key});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  String? _selectedDoctorId;
  String? _selectedHospital;
  String? _selectedDiagnosis;
  String? _selectedMedicine;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = AppStateProvider.of(context);
      setState(() {
        _selectedDoctorId = appState.filterDoctorId;
        _selectedHospital = appState.filterHospital;
        _selectedDiagnosis = appState.filterDiagnosis;
        _selectedMedicine = appState.filterMedicine;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final doctors = appState.doctors;

    final hospitals = appState.visits
        .map((v) => v.doctor.hospital)
        .toSet()
        .toList();
    final diagnoses = appState.visits
        .map((v) => v.diagnosis)
        .toSet()
        .toList();
    final medicines = appState
        .getAllMedicines()
        .map((m) => m.name)
        .toSet()
        .toList();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: AppTheme.borderGray),
            const SizedBox(height: 12),

            const Text(
              'Doctor',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: doctors.map((doc) {
                final isSelected = _selectedDoctorId == doc.id;
                return FilterChip(
                  label: Text(doc.name),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.darkText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedDoctorId = selected ? doc.id : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            const Text(
              'Hospital / Clinic',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hospitals.map((hosp) {
                final isSelected = _selectedHospital == hosp;
                return FilterChip(
                  label: Text(hosp),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.darkText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedHospital = selected ? hosp : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            const Text(
              'Diagnosis',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: diagnoses.map((diag) {
                final isSelected = _selectedDiagnosis == diag;
                return FilterChip(
                  label: Text(diag),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.darkText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedDiagnosis = selected ? diag : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            const Text(
              'Prescribed Medicine',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: medicines.map((med) {
                final isSelected = _selectedMedicine == med;
                return FilterChip(
                  label: Text(med),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.darkText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedMedicine = selected ? med : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      appState.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      appState.applyFilters(
                        doctorId: _selectedDoctorId,
                        hospital: _selectedHospital,
                        diagnosis: _selectedDiagnosis,
                        medicine: _selectedMedicine,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
