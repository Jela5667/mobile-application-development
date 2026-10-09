import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/medicine_card.dart';
import '../widgets/empty_state_widget.dart';
import 'main_navigation_screen.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final allMeds = appState.getAllMedicines().where((m) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return m.name.toLowerCase().contains(q) ||
          m.instructions.toLowerCase().contains(q) ||
          (m.doctorName != null && m.doctorName!.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Medicines'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: allMeds.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.medication_liquid_outlined,
                    title: 'No medicines found',
                    description:
                        'Prescribed medicines from your doctor visits will appear here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: allMeds.length,
                    itemBuilder: (context, index) {
                      final med = allMeds[index];
                      return MedicineCard(
                        medicine: med,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(med.name),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dose: ${med.dose}'),
                                  Text('Frequency: ${med.frequency}'),
                                  Text('Duration: ${med.duration}'),
                                  Text('Meal Timing: ${med.mealTiming}'),
                                  Text('Instructions: ${med.instructions}'),
                                  if (med.doctorName != null)
                                    Text('Prescribed by: ${med.doctorName}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
