import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/doctor.dart';
import '../theme/app_theme.dart';
import '../widgets/doctor_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/custom_text_field.dart';
import 'main_navigation_screen.dart';
import 'doctor_profile_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDoctorDialog(BuildContext context, AppState appState) {
    final nameController = TextEditingController();
    final specController = TextEditingController();
    final hospitalController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        title: const Row(
          children: [
            Icon(Icons.person_add_outlined, color: AppTheme.primaryBlue),
            SizedBox(width: 10),
            Text('Add New Doctor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Doctor Name',
                  hint: 'e.g. Dr. Ahmed Khan',
                  controller: nameController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Specialization',
                  hint: 'e.g. Cardiologist',
                  controller: specController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Hospital / Clinic',
                  hint: 'e.g. City Medical Hospital',
                  controller: hospitalController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Phone Number',
                  hint: 'e.g. +1 (555) 234-5678',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Address',
                  hint: 'e.g. 123 Healthcare Blvd',
                  controller: addressController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.subtitleText)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newDoctor = Doctor(
                  id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  specialization: specController.text.trim(),
                  hospital: hospitalController.text.trim(),
                  phone: phoneController.text.trim().isEmpty
                      ? '+1 (555) 000-0000'
                      : phoneController.text.trim(),
                  address: addressController.text.trim().isEmpty
                      ? 'Medical Center'
                      : addressController.text.trim(),
                );

                appState.addDoctor(newDoctor);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${newDoctor.name} added successfully.'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Add Doctor'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final doctors = appState.doctors.where((doc) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return doc.name.toLowerCase().contains(q) ||
          doc.specialization.toLowerCase().contains(q) ||
          doc.hospital.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Doctors'),
        actions: [
          IconButton(
            onPressed: () => _showAddDoctorDialog(context, appState),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppTheme.primaryBlue),
            ),
            tooltip: 'Add Doctor',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search doctors by name or specialty...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // List or Empty State
          Expanded(
            child: doctors.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.people_outline_rounded,
                    title: 'No doctors added yet',
                    description:
                        'Keep track of your physicians, specialists and clinics.',
                    buttonText: 'Add Doctor',
                    onButtonPressed: () => _showAddDoctorDialog(context, appState),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doc = doctors[index];
                      final visitsCount =
                          appState.getVisitsForDoctor(doc.id).length;

                      return DoctorCard(
                        doctor: doc,
                        visitCount: visitsCount,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorProfileScreen(doctor: doc),
                            ),
                          );
                        },
                        onCallTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calling ${doc.name} (${doc.phone})...'),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: doctors.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDoctorDialog(context, appState),
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Add Doctor',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }
}
