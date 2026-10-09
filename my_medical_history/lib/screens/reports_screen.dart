import 'package:flutter/material.dart';
import '../models/report.dart';
import '../theme/app_theme.dart';
import '../widgets/report_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/custom_text_field.dart';
import 'main_navigation_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Blood Tests',
    'X-Ray',
    'MRI',
    'CT Scan',
    'Ultrasound',
    'Other'
  ];

  void _showUploadReportModal(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final titleController = TextEditingController();
    final doctorController = TextEditingController();
    final hospitalController = TextEditingController();
    String category = 'Blood Tests';
    String fileType = 'PDF';

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
                    const Text('Upload Medical Report',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(modalContext)),
                  ],
                ),
                const Divider(),
                CustomTextField(
                  label: 'Report Title',
                  hint: 'e.g. Complete Blood Count (CBC)',
                  controller: titleController,
                ),
                const SizedBox(height: 12),
                const Text('Category',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  items: [
                    'Blood Tests',
                    'X-Ray',
                    'MRI',
                    'CT Scan',
                    'Ultrasound',
                    'Other'
                  ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => category = val);
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Doctor Name',
                  hint: 'e.g. Dr. Ahmed Khan',
                  controller: doctorController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Hospital / Lab Name',
                  hint: 'e.g. City Diagnostic Lab',
                  controller: hospitalController,
                ),
                const SizedBox(height: 12),
                const Text('File Type',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('PDF Document'),
                      selected: fileType == 'PDF',
                      onSelected: (s) {
                        if (s) setModalState(() => fileType = 'PDF');
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Image (JPG/PNG)'),
                      selected: fileType == 'Image',
                      onSelected: (s) {
                        if (s) setModalState(() => fileType = 'Image');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        final newReport = MedicalReport(
                          id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
                          title: titleController.text.trim(),
                          category: category,
                          date: DateTime.now(),
                          doctorName: doctorController.text.trim().isEmpty
                              ? 'Dr. Specialist'
                              : doctorController.text.trim(),
                          hospitalName: hospitalController.text.trim().isEmpty
                              ? 'City Lab'
                              : hospitalController.text.trim(),
                          fileType: fileType,
                          fileSize: '3.5 MB',
                          fileUrl: 'reports/sample_report.pdf',
                        );

                        appState.addReport(newReport);
                        Navigator.pop(modalContext);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Medical report uploaded successfully!'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Upload Report'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReportPreviewModal(BuildContext context, MedicalReport report) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      report.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),

              Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: report.fileType == 'PDF'
                      ? const Color(0xFFFFF1F0)
                      : const Color(0xFFF6FFED),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderGray),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        report.fileType == 'PDF'
                            ? Icons.picture_as_pdf_rounded
                            : Icons.image_rounded,
                        size: 64,
                        color: report.fileType == 'PDF'
                            ? const Color(0xFFC62828)
                            : const Color(0xFF2E7D32),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${report.title} (${report.fileType})',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText),
                      ),
                      Text(
                        '${report.fileSize} • Uploaded ${report.date.day}/${report.date.month}/${report.date.year}',
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.subtitleText),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Simulated Medical Document Preview',
                        style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.subtitleText),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading report file...')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Download'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing report file...')),
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final filteredReports = appState.reports.where((rep) {
      if (_selectedCategory == 'All') return true;
      return rep.category.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Medical Reports'),
        actions: [
          IconButton(
            onPressed: () => _showUploadReportModal(context),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppTheme.primaryBlue),
            ),
            tooltip: 'Upload Report',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.darkText,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: filteredReports.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.assignment_outlined,
                    title: 'No reports found',
                    description:
                        'No medical reports or test documents uploaded in this category.',
                    buttonText: 'Upload Report',
                    onButtonPressed: () =>
                        _showUploadReportModal(context),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final rep = filteredReports[index];
                      return ReportCard(
                        report: rep,
                        onPreview: () =>
                            _showReportPreviewModal(context, rep),
                        onDelete: () {
                          appState.deleteReport(rep.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Report deleted.')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: filteredReports.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showUploadReportModal(context),
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Upload Report',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }
}
