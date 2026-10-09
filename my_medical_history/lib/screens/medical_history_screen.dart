import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/visit_card.dart';
import '../widgets/empty_state_widget.dart';
import 'main_navigation_screen.dart';
import 'filters_bottom_sheet.dart';
import 'visit_details_screen.dart';
import 'add_visit_flow_screen.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const FiltersBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final filteredVisits = appState.filteredVisits.where((visit) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return visit.diagnosis.toLowerCase().contains(q) ||
          visit.doctor.name.toLowerCase().contains(q) ||
          visit.doctor.hospital.toLowerCase().contains(q) ||
          visit.symptoms.any((s) => s.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Medical History'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddVisitFlowScreen(),
                ),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppTheme.primaryBlue),
            ),
            tooltip: 'Add Visit',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search history by diagnosis or doctor...',
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
                const SizedBox(width: 10),
                InkWell(
                  onTap: _openFilterBottomSheet,
                  borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: appState.hasActiveFilters
                          ? AppTheme.primaryBlue
                          : AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      border: Border.all(
                        color: appState.hasActiveFilters
                            ? AppTheme.primaryBlue
                            : AppTheme.borderGray,
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: appState.hasActiveFilters
                          ? Colors.white
                          : AppTheme.darkText,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (appState.hasActiveFilters)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              color: AppTheme.primaryLight.withValues(alpha: 0.5),
              child: Row(
                children: [
                  const Icon(Icons.filter_list_alt,
                      size: 16, color: AppTheme.primaryBlue),
                  const SizedBox(width: 6),
                  const Text(
                    'Active Filters',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => appState.clearFilters(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: filteredVisits.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.assignment_outlined,
                    title: 'No medical visits found',
                    description:
                        'Your medical history will appear here once you record doctor visits.',
                    buttonText: 'Add Medical Visit',
                    onButtonPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddVisitFlowScreen(),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: filteredVisits.length,
                    itemBuilder: (context, index) {
                      final visit = filteredVisits[index];
                      return VisitCard(
                        visit: visit,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VisitDetailsScreen(visit: visit),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: filteredVisits.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddVisitFlowScreen(),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Visit',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }
}
