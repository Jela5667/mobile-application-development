import 'package:flutter/material.dart';
import '../models/medical_visit.dart';
import '../theme/app_theme.dart';
import '../widgets/medicine_card.dart';
import 'main_navigation_screen.dart';

class VisitDetailsScreen extends StatelessWidget {
  final MedicalVisit visit;

  const VisitDetailsScreen({
    super.key,
    required this.visit,
  });

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    final appState = AppStateProvider.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.errorRed, size: 28),
            SizedBox(width: 10),
            Text('Delete Visit Record?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this visit record with ${visit.doctor.name} on ${_formatDate(visit.visitDate)}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.subtitleText)),
          ),
          ElevatedButton(
            onPressed: () {
              appState.deleteVisit(visit.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Medical visit deleted successfully.'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Visit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.primaryBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing medical visit summary...'),
                ),
              );
            },
            tooltip: 'Share Record',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed),
            onPressed: () => _showDeleteConfirmation(context),
            tooltip: 'Delete Visit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppTheme.primaryLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                side: const BorderSide(color: AppTheme.primaryBlue, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _formatDate(visit.visitDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          visit.visitTime,
                          style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      visit.doctor.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${visit.doctor.specialization} • ${visit.doctor.hospital}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.subtitleText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Diagnosis & Symptoms',
              icon: Icons.healing_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Diagnosis: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.subtitleText,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          visit.diagnosis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Reason for Visit: ${visit.reasonForVisit}',
                    style: const TextStyle(fontSize: 14, color: AppTheme.darkText),
                  ),
                  if (visit.symptoms.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Reported Symptoms:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.subtitleText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: visit.symptoms.map((symptom) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight,
                            border: Border.all(color: AppTheme.borderGray),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            symptom,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.darkText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (visit.medicines.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Prescribed Medicines (${visit.medicines.length})',
                icon: Icons.medication_outlined,
                child: Column(
                  children: visit.medicines
                      .map((med) => MedicineCard(medicine: med))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (visit.tests.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Medical Tests (${visit.tests.length})',
                icon: Icons.science_outlined,
                child: Column(
                  children: visit.tests.map((test) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderGray),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  test.testName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                              ),
                              if (test.fileType != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    test.fileType!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Result: ${test.result}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkText,
                            ),
                          ),
                          if (test.doctorNotes.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Notes: ${test.doctorNotes}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.subtitleText,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (visit.prescriptionAttachmentPath != null ||
                visit.attachments.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Prescription & Attachments',
                icon: Icons.assignment_outlined,
                child: Column(
                  children: [
                    if (visit.prescriptionAttachmentPath != null)
                      ListTile(
                        leading: const Icon(Icons.picture_as_pdf,
                            color: Colors.redAccent, size: 32),
                        title: const Text('Official Prescription Document'),
                        subtitle: Text(
                            '${visit.prescriptionFileType ?? 'PDF'} Document'),
                        trailing: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening prescription document...'),
                              ),
                            );
                          },
                          child: const Text('View'),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            _buildSectionCard(
              title: "Doctor's Notes",
              icon: Icons.note_alt_outlined,
              child: Text(
                visit.doctorNotes,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppTheme.darkText,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Follow-up & Location',
              icon: Icons.event_available_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (visit.followUpDate != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined,
                            size: 18, color: AppTheme.primaryBlue),
                        const SizedBox(width: 8),
                        const Text(
                          'Next Follow-up: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.subtitleText,
                          ),
                        ),
                        Text(
                          _formatDate(visit.followUpDate!),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppTheme.borderGray),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 18, color: AppTheme.primaryBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          visit.hospitalAddress,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              height: 52,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Editing medical visit record...'),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text(
                  'Edit Visit Record',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(height: 1, color: AppTheme.borderGray),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
