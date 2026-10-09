import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class BackupSyncScreen extends StatefulWidget {
  const BackupSyncScreen({super.key});

  @override
  State<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends State<BackupSyncScreen> {
  bool _simulateError = false;

  String _formatTime(DateTime? date) {
    if (date == null) return 'Never';
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    return 'Today, $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final user = appState.userProfile;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Backup & Sync'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_to_drive_rounded,
                            color: Color(0xFF2E7D32),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Google Drive Storage',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.subtitleText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: user.isDriveConnected
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.isDriveConnected ? 'Connected' : 'Disconnected',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: user.isDriveConnected
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFE65100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(height: 1, color: AppTheme.borderGray),
                    ),

                    if (appState.isSyncing) ...[
                      Row(
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Syncing medical records with Google Drive...',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ] else if (_simulateError) ...[
                      Row(
                        children: const [
                          Icon(Icons.error_outline_rounded,
                              color: AppTheme.errorRed, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sync failed. Please check network connection.',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.errorRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: const [
                          Icon(Icons.check_circle_rounded,
                              color: Color(0xFF2E7D32), size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Everything is up to date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Last Sync Time:',
                            style: TextStyle(
                                color: AppTheme.subtitleText, fontSize: 13)),
                        Text(
                          _formatTime(user.lastSyncedAt),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                              fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Drive Backup Size:',
                            style: TextStyle(
                                color: AppTheme.subtitleText, fontSize: 13)),
                        Text(
                          user.driveStorageUsed,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: appState.isSyncing
                    ? null
                    : () async {
                        if (_simulateError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Sync failed due to simulated network error.'),
                              backgroundColor: AppTheme.errorRed,
                            ),
                          );
                        } else {
                          await appState.triggerSync();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Backup & Sync completed successfully!'),
                                backgroundColor: AppTheme.successGreen,
                              ),
                            );
                          }
                        }
                      },
                icon: const Icon(Icons.sync_rounded),
                label: Text(
                    appState.isSyncing ? 'Syncing Records...' : 'Sync Now'),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Auto Sync'),
                    subtitle: const Text('Automatically sync when connected to Wi-Fi'),
                    value: user.autoSyncEnabled,
                    onChanged: (val) => appState.toggleAutoSync(val),
                  ),
                  const Divider(height: 1, color: AppTheme.borderGray),
                  SwitchListTile(
                    title: const Text('Simulate Sync Error State'),
                    subtitle:
                        const Text('Toggle to demonstrate failed sync state UI'),
                    value: _simulateError,
                    onChanged: (val) {
                      setState(() {
                        _simulateError = val;
                      });
                    },
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
