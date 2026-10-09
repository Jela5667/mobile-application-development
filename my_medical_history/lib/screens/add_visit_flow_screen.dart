import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/medical_visit.dart';
import '../models/medicine.dart';
import '../models/medical_test.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/medicine_card.dart';
import 'main_navigation_screen.dart';
import 'visit_details_screen.dart';

class AddVisitFlowScreen extends StatefulWidget {
  final Doctor? selectedDoctor;

  const AddVisitFlowScreen({
    super.key,
    this.selectedDoctor,
  });

  @override
  State<AddVisitFlowScreen> createState() => _AddVisitFlowScreenState();
}

class _AddVisitFlowScreenState extends State<AddVisitFlowScreen> {
  int _currentStep = 1;

  // Step 1: Doctor
  bool _useExistingDoctor = true;
  Doctor? _selectedDoctor;
  final _docNameController = TextEditingController();
  final _docSpecController = TextEditingController();
  final _docPhoneController = TextEditingController();
  final _hospitalController = TextEditingController();

  // Step 2: Location
  final _addressController = TextEditingController();

  // Step 3: Visit Information
  DateTime _visitDate = DateTime.now();
  TimeOfDay _visitTime = TimeOfDay.now();
  final _reasonController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _followUpDate;

  // Step 4: Medicines, Tests & Prescription
  final List<Medicine> _medicines = [];
  final List<MedicalTest> _tests = [];
  String? _prescriptionPath;
  String? _prescriptionFileType;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDoctor != null) {
      _selectedDoctor = widget.selectedDoctor;
      _hospitalController.text = widget.selectedDoctor!.hospital;
      _addressController.text = widget.selectedDoctor!.address;
    }
  }

  @override
  void dispose() {
    _docNameController.dispose();
    _docSpecController.dispose();
    _docPhoneController.dispose();
    _hospitalController.dispose();
    _addressController.dispose();
    _reasonController.dispose();
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_useExistingDoctor && _selectedDoctor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an existing doctor or add new doctor.')),
        );
        return;
      }
      if (!_useExistingDoctor && _docNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter the doctor's name.")),
        );
        return;
      }
    } else if (_currentStep == 3) {
      if (_diagnosisController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a diagnosis.')),
        );
        return;
      }
    }

    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _showAddMedicineModal(BuildContext context) {
    final medNameController = TextEditingController();
    final doseController = TextEditingController();
    String frequency = 'Twice daily';
    String duration = '5 Days';
    String mealTiming = 'After Meal';
    final instructionsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Prescribed Medicine',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(modalContext)),
                  ],
                ),
                const Divider(),
                CustomTextField(
                    label: 'Medicine Name',
                    hint: 'e.g. Panadol, Amoxicillin',
                    controller: medNameController),
                const SizedBox(height: 12),
                CustomTextField(
                    label: 'Dosage',
                    hint: 'e.g. 500mg, 1 Tablet',
                    controller: doseController),
                const SizedBox(height: 12),
                const Text('Frequency',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                DropdownButton<String>(
                  value: frequency,
                  isExpanded: true,
                  items: ['Once daily', 'Twice daily', '3 Times daily', '8 Hourly', 'As needed']
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => frequency = val);
                  },
                ),
                const SizedBox(height: 12),
                const Text('Duration',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                DropdownButton<String>(
                  value: duration,
                  isExpanded: true,
                  items: ['3 Days', '5 Days', '7 Days', '10 Days', '14 Days', 'Ongoing']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => duration = val);
                  },
                ),
                const SizedBox(height: 12),
                const Text('Meal Timing',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('After Meal'),
                      selected: mealTiming == 'After Meal',
                      onSelected: (selected) {
                        if (selected) setModalState(() => mealTiming = 'After Meal');
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Before Meal'),
                      selected: mealTiming == 'Before Meal',
                      onSelected: (selected) {
                        if (selected) setModalState(() => mealTiming = 'Before Meal');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomTextField(
                    label: 'Instructions',
                    hint: 'e.g. Take with plenty of water',
                    controller: instructionsController),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (medNameController.text.trim().isNotEmpty) {
                        setState(() {
                          _medicines.add(
                            Medicine(
                              id: 'med_${DateTime.now().millisecondsSinceEpoch}',
                              name: medNameController.text.trim(),
                              dose: doseController.text.trim().isEmpty
                                  ? '500mg'
                                  : doseController.text.trim(),
                              frequency: frequency,
                              duration: duration,
                              mealTiming: mealTiming,
                              instructions: instructionsController.text.trim().isEmpty
                                  ? 'Take as directed'
                                  : instructionsController.text.trim(),
                            ),
                          );
                        });
                        Navigator.pop(modalContext);
                      }
                    },
                    child: const Text('Add Medicine'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveVisitRecord(dynamic appState) {
    Doctor visitDoctor;
    if (_useExistingDoctor && _selectedDoctor != null) {
      visitDoctor = _selectedDoctor!;
    } else {
      visitDoctor = Doctor(
        id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
        name: _docNameController.text.trim().isEmpty
            ? 'Dr. Specialist'
            : _docNameController.text.trim(),
        specialization: _docSpecController.text.trim().isEmpty
            ? 'General Physician'
            : _docSpecController.text.trim(),
        hospital: _hospitalController.text.trim().isEmpty
            ? 'City Care Hospital'
            : _hospitalController.text.trim(),
        phone: _docPhoneController.text.trim().isEmpty
            ? '+1 (555) 123-4567'
            : _docPhoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? 'Healthcare Center'
            : _addressController.text.trim(),
      );
      appState.addDoctor(visitDoctor);
    }

    final newVisit = MedicalVisit(
      id: 'vis_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: visitDoctor.id,
      doctor: visitDoctor,
      visitDate: _visitDate,
      visitTime: _visitTime.format(context),
      reasonForVisit: _reasonController.text.trim().isEmpty
          ? 'Medical Consultation'
          : _reasonController.text.trim(),
      symptoms: _symptomsController.text.trim().isNotEmpty
          ? _symptomsController.text.split(',').map((s) => s.trim()).toList()
          : ['General Symptoms'],
      diagnosis: _diagnosisController.text.trim().isEmpty
          ? 'General Checkup'
          : _diagnosisController.text.trim(),
      doctorNotes: _notesController.text.trim().isEmpty
          ? 'Patient advised to follow prescription carefully.'
          : _notesController.text.trim(),
      followUpDate: _followUpDate,
      hospitalAddress: _addressController.text.trim().isEmpty
          ? visitDoctor.address
          : _addressController.text.trim(),
      medicines: _medicines,
      tests: _tests,
      prescriptionAttachmentPath: _prescriptionPath,
      prescriptionFileType: _prescriptionFileType,
    );

    appState.addVisit(newVisit);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medical visit saved successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VisitDetailsScreen(visit: newVisit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(_currentStep == 5 ? 'Review Before Save' : 'Add Medical Visit'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppTheme.surfaceWhite,
            child: Row(
              children: List.generate(5, (index) {
                final stepNum = index + 1;
                final isCompleted = stepNum < _currentStep;
                final isCurrent = stepNum == _currentStep;

                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent || isCompleted
                              ? AppTheme.primaryBlue
                              : AppTheme.borderGray,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : Text(
                                  '$stepNum',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.white
                                        : AppTheme.subtitleText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                        ),
                      ),
                      if (stepNum < 5)
                        Expanded(
                          child: Container(
                            height: 3,
                            color: isCompleted
                                ? AppTheme.primaryBlue
                                : AppTheme.borderGray,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderGray),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: _buildCurrentStepView(context, appState),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceWhite,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 1) const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep == 5) {
                        _saveVisitRecord(appState);
                      } else {
                        _nextStep();
                      }
                    },
                    child: Text(_currentStep == 5
                        ? 'Save Medical Visit'
                        : (_currentStep == 4 ? 'Review Summary' : 'Next Step')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepView(BuildContext context, dynamic appState) {
    switch (_currentStep) {
      case 1:
        return _buildStep1Doctor(context, appState);
      case 2:
        return _buildStep2Location();
      case 3:
        return _buildStep3VisitInfo(context);
      case 4:
        return _buildStep4MedicinesAndPrescription(context);
      case 5:
        return _buildStep5ReviewSummary();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1Doctor(BuildContext context, dynamic appState) {
    final existingDoctors = appState.doctors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Select or Add Doctor',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose an existing doctor from your list or enter new doctor details.',
          style: TextStyle(fontSize: 13, color: AppTheme.subtitleText),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text('Select Existing Doctor'),
                selected: _useExistingDoctor,
                onSelected: (selected) {
                  if (selected) setState(() => _useExistingDoctor = true);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ChoiceChip(
                label: const Text('Add New Doctor'),
                selected: !_useExistingDoctor,
                onSelected: (selected) {
                  if (selected) setState(() => _useExistingDoctor = false);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        if (_useExistingDoctor) ...[
          const Text('Select Doctor',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          const SizedBox(height: 8),
          ...existingDoctors.map((doc) {
            final isSelected = _selectedDoctor?.id == doc.id;
            return Card(
              color: isSelected ? AppTheme.primaryLight : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.borderGray,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    _selectedDoctor = doc;
                    _hospitalController.text = doc.hospital;
                    _addressController.text = doc.address;
                  });
                },
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryBlue,
                  child: Text(
                    doc.name.replaceFirst('Dr. ', '').substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(doc.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${doc.specialization} • ${doc.hospital}'),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppTheme.primaryBlue)
                    : null,
              ),
            );
          }),
        ] else ...[
          CustomTextField(
              label: 'Doctor Name',
              hint: 'e.g. Dr. Ahmed Khan',
              controller: _docNameController),
          const SizedBox(height: 12),
          CustomTextField(
              label: 'Specialization',
              hint: 'e.g. Cardiologist',
              controller: _docSpecController),
          const SizedBox(height: 12),
          CustomTextField(
              label: 'Hospital / Clinic Name',
              hint: 'e.g. City Medical Hospital',
              controller: _hospitalController),
          const SizedBox(height: 12),
          CustomTextField(
              label: 'Phone Number',
              hint: 'e.g. +1 (555) 234-5678',
              controller: _docPhoneController,
              keyboardType: TextInputType.phone),
        ],
      ],
    );
  }

  Widget _buildStep2Location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 2: Hospital Location',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText),
        ),
        const SizedBox(height: 6),
        const Text(
          'Specify the location of the hospital or clinic where the visit took place.',
          style: TextStyle(fontSize: 13, color: AppTheme.subtitleText),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _addressController.text =
                        'Current Location: 123 Healthcare Blvd, City Center';
                  });
                },
                icon: const Icon(Icons.my_location_rounded, size: 18),
                label: const Text('Use Current Location',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _addressController.text =
                        'Selected on Map: 456 Medical Ave';
                  });
                },
                icon: const Icon(Icons.map_rounded, size: 18),
                label: const Text('Select on Map', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        CustomTextField(
          label: 'Hospital Address',
          hint: 'Enter full hospital address',
          controller: _addressController,
          maxLines: 2,
        ),
        const SizedBox(height: 20),

        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderGray),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _addressController.text.isEmpty
                          ? 'Hospital Location Pin'
                          : _addressController.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3VisitInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 3: Visit Information',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _visitDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _visitDate = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Visit Date',
                    prefixIcon: Icon(Icons.calendar_month),
                  ),
                  child: Text(
                    '${_visitDate.day}/${_visitDate.month}/${_visitDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _visitTime,
                  );
                  if (picked != null) setState(() => _visitTime = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Visit Time',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    _visitTime.format(context),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        CustomTextField(
          label: 'Reason for Visit',
          hint: 'e.g. Fever, body ache, routine follow-up',
          controller: _reasonController,
        ),
        const SizedBox(height: 14),

        CustomTextField(
          label: 'Symptoms (comma separated)',
          hint: 'e.g. Fever, Cough, Headache, Fatigue',
          controller: _symptomsController,
        ),
        const SizedBox(height: 14),

        CustomTextField(
          label: 'Diagnosis',
          hint: 'e.g. Viral Infection, Acute Flu',
          controller: _diagnosisController,
        ),
        const SizedBox(height: 14),

        CustomTextField(
          label: "Doctor's Notes",
          hint: 'Enter special instructions or notes',
          controller: _notesController,
          maxLines: 3,
        ),
        const SizedBox(height: 14),

        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _followUpDate ?? DateTime.now().add(const Duration(days: 7)),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) setState(() => _followUpDate = picked);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Follow-up Date (Optional)',
              prefixIcon: Icon(Icons.event_repeat),
            ),
            child: Text(
              _followUpDate == null
                  ? 'Tap to select follow-up date'
                  : '${_followUpDate!.day}/${_followUpDate!.month}/${_followUpDate!.year}',
              style: TextStyle(
                color: _followUpDate == null
                    ? AppTheme.subtitleText
                    : AppTheme.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4MedicinesAndPrescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 4: Medicines, Tests & Prescription',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Prescribed Medicines',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText)),
            TextButton.icon(
              onPressed: () => _showAddMedicineModal(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Medicine'),
            ),
          ],
        ),
        if (_medicines.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderGray),
            ),
            child: const Center(
              child: Text('No medicines added yet. Tap "+ Add Medicine" above.'),
            ),
          )
        else
          ..._medicines.map((m) => MedicineCard(medicine: m)),

        const SizedBox(height: 24),

        const Text('Prescription Document',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText)),
        const SizedBox(height: 10),

        if (_prescriptionPath == null) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _prescriptionPath = 'scanned_prescription_photo.jpg';
                      _prescriptionFileType = 'Image';
                    });
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Take Photo', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _prescriptionPath = 'prescription_document.pdf';
                      _prescriptionFileType = 'PDF';
                    });
                  },
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('Upload PDF', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ] else ...[
          Card(
            child: ListTile(
              leading: Icon(
                _prescriptionFileType == 'PDF'
                    ? Icons.picture_as_pdf
                    : Icons.image,
                color: AppTheme.primaryBlue,
                size: 32,
              ),
              title: Text('Prescription Attached ($_prescriptionFileType)'),
              subtitle: Text(_prescriptionPath!),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed),
                onPressed: () {
                  setState(() {
                    _prescriptionPath = null;
                    _prescriptionFileType = null;
                  });
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStep5ReviewSummary() {
    final docName = _useExistingDoctor && _selectedDoctor != null
        ? _selectedDoctor!.name
        : (_docNameController.text.isEmpty
            ? 'Dr. Specialist'
            : _docNameController.text);
    final hospital = _useExistingDoctor && _selectedDoctor != null
        ? _selectedDoctor!.hospital
        : (_hospitalController.text.isEmpty
            ? 'Medical Clinic'
            : _hospitalController.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: const [
              Icon(Icons.check_circle_outline,
                  color: AppTheme.primaryBlue, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Review visit summary before saving to your medical records.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildSummaryTile('Doctor Name', docName),
        _buildSummaryTile('Hospital / Clinic', hospital),
        _buildSummaryTile('Hospital Location',
            _addressController.text.isEmpty ? 'Hospital Address' : _addressController.text),
        _buildSummaryTile(
            'Visit Date', '${_visitDate.day}/${_visitDate.month}/${_visitDate.year}'),
        _buildSummaryTile('Diagnosis',
            _diagnosisController.text.isEmpty ? 'General Checkup' : _diagnosisController.text),
        _buildSummaryTile('Reason',
            _reasonController.text.isEmpty ? 'Consultation' : _reasonController.text),
        _buildSummaryTile('Medicines Added', '${_medicines.length} medicines'),
        _buildSummaryTile('Prescription Attached',
            _prescriptionPath != null ? 'Yes ($_prescriptionFileType)' : 'None'),
        _buildSummaryTile('Doctor Notes',
            _notesController.text.isEmpty ? 'None' : _notesController.text),
      ],
    );
  }

  Widget _buildSummaryTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleText,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
