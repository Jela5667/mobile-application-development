import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/medical_visit.dart';
import '../models/medicine.dart';
import '../models/report.dart';
import '../theme/app_theme.dart';
import '../widgets/doctor_card.dart';
import '../widgets/visit_card.dart';
import '../widgets/medicine_card.dart';
import '../widgets/report_card.dart';
import 'main_navigation_screen.dart';
import 'doctor_profile_screen.dart';
import 'visit_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final results = appState.searchAll(_query);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (val) {
            setState(() {
              _query = val;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search doctors, medicines, diagnosis, tests...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _query = '';
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _query.trim().isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search_rounded,
                      size: 64, color: AppTheme.subtitleText),
                  SizedBox(height: 12),
                  Text(
                    'Search your medical records',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Type a doctor name, medicine, symptom, or diagnosis.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.subtitleText,
                    ),
                  ),
                ],
              ),
            )
          : results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off_rounded,
                          size: 64, color: AppTheme.subtitleText),
                      const SizedBox(height: 12),
                      Text(
                        'No results for "$_query"',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Check your spelling or search for another keyword.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.subtitleText,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];

                    if (item is Doctor) {
                      return DoctorCard(
                        doctor: item,
                        visitCount: appState.getVisitsForDoctor(item.id).length,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorProfileScreen(doctor: item),
                            ),
                          );
                        },
                      );
                    } else if (item is MedicalVisit) {
                      return VisitCard(
                        visit: item,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisitDetailsScreen(visit: item),
                            ),
                          );
                        },
                      );
                    } else if (item is Medicine) {
                      return MedicineCard(medicine: item);
                    } else if (item is MedicalReport) {
                      return ReportCard(
                        report: item,
                        onPreview: () {},
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
    );
  }
}
