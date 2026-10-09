import 'package:flutter/material.dart';
import '../models/medical_visit.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/visit_card.dart';
import '../widgets/doctor_card.dart';
import 'main_navigation_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'doctor_profile_screen.dart';
import 'visit_details_screen.dart';
import 'add_visit_flow_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const HomeDashboardScreen({
    super.key,
    required this.onNavigateToTab,
  });

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final user = appState.userProfile;
    final recentVisits = appState.visits.take(3).toList();
    final recentDoctors = appState.doctors.take(3).toList();
    final upcomingFollowUps = appState.getUpcomingFollowUps();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await appState.triggerSync();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.primaryLight,
                        child: Text(
                          user.name.split(' ').map((e) => e[0]).join(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning,',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.subtitleText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Follow-up appointment with Dr. Ahmed Khan on Jan 03, 2027.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.borderGray),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppTheme.darkText,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                      border: Border.all(color: AppTheme.borderGray),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: AppTheme.subtitleText, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Search your medical history...',
                          style: TextStyle(
                            color: AppTheme.subtitleText,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.tune_rounded,
                            color: AppTheme.primaryBlue, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddVisitFlowScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_rounded, size: 22),
                    label: const Text(
                      'Add Medical Visit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Doctors',
                        count: '${appState.totalDoctorsCount}',
                        icon: Icons.people_alt_outlined,
                        iconBgColor: AppTheme.primaryLight,
                        iconColor: AppTheme.primaryBlue,
                        onTap: () => onNavigateToTab(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Visits',
                        count: '${appState.totalVisitsCount}',
                        icon: Icons.history_edu_outlined,
                        iconBgColor: const Color(0xFFE1F5FE),
                        iconColor: const Color(0xFF0288D1),
                        onTap: () => onNavigateToTab(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Medicines',
                        count: '${appState.totalMedicinesCount}',
                        icon: Icons.medication_liquid_outlined,
                        iconBgColor: const Color(0xFFE8F5E9),
                        iconColor: const Color(0xFF2E7D32),
                        onTap: () => onNavigateToTab(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Reports',
                        count: '${appState.totalReportsCount}',
                        icon: Icons.assignment_outlined,
                        iconBgColor: const Color(0xFFFFF3E0),
                        iconColor: const Color(0xFFE65100),
                        onTap: () => onNavigateToTab(3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                if (upcomingFollowUps.isNotEmpty) ...[
                  const Text(
                    'Upcoming Follow-up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildUpcomingCard(context, upcomingFollowUps.first),
                  const SizedBox(height: 28),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Visits',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateToTab(2),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (recentVisits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No medical visits recorded yet.'),
                  )
                else
                  ...recentVisits.map(
                    (visit) => VisitCard(
                      visit: visit,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VisitDetailsScreen(visit: visit),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Doctors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateToTab(1),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...recentDoctors.map(
                  (doc) => DoctorCard(
                    doctor: doc,
                    visitCount: appState.getVisitsForDoctor(doc.id).length,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DoctorProfileScreen(doctor: doc),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, MedicalVisit visit) {
    return Card(
      color: AppTheme.primaryLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        side: const BorderSide(color: AppTheme.primaryBlue, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_available_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Follow-up Visit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(visit.followUpDate!),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    visit.doctor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                  Text(
                    '${visit.doctor.specialization} • ${visit.doctor.hospital}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.subtitleText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
