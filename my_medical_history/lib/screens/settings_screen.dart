import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';
import 'profile_screen.dart';
import 'backup_sync_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final user = appState.userProfile;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('ACCOUNT'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline,
                        color: AppTheme.primaryBlue),
                    title: const Text('Profile Details'),
                    subtitle: Text('${user.name} (${user.email})'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppTheme.borderGray),
                  ListTile(
                    leading: const Icon(Icons.g_mobiledata,
                        color: Colors.redAccent, size: 32),
                    title: const Text('Google Account'),
                    subtitle: Text(user.email),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Linked',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('BACKUP & SYNC'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cloud_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text('Google Drive Backup'),
                    subtitle: Text(user.isDriveConnected
                        ? 'Connected • Last sync 45m ago'
                        : 'Not connected'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BackupSyncScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppTheme.borderGray),
                  SwitchListTile(
                    secondary: const Icon(Icons.sync_rounded,
                        color: AppTheme.primaryBlue),
                    title: const Text('Auto Sync'),
                    subtitle: const Text('Sync medical records automatically'),
                    value: user.autoSyncEnabled,
                    onChanged: (val) => appState.toggleAutoSync(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('SECURITY'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.lock_outline_rounded,
                        color: AppTheme.primaryBlue),
                    title: const Text('App Lock (PIN / Biometric)'),
                    subtitle: const Text('Require authentication to open app'),
                    value: user.appLockEnabled,
                    onChanged: (val) => appState.toggleAppLock(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('DATA'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text('Export Medical History'),
                    subtitle: const Text('Export records as PDF / ZIP archive'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Exporting complete medical history PDF...'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppTheme.borderGray),
                  ListTile(
                    leading: const Icon(Icons.restore_page_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text('Restore Backup'),
                    subtitle: const Text('Restore records from Google Drive backup'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Scanning Google Drive for backups...'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('PROTOTYPE & APP STATES'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.wifi_off_rounded,
                        color: Colors.orangeAccent),
                    title: const Text('Simulate Offline Mode'),
                    subtitle: const Text('Shows offline status banner at top'),
                    value: appState.isOffline,
                    onChanged: (val) => appState.toggleOfflineMode(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('ABOUT'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'My Medical History',
                        applicationVersion: '1.0.0',
                        applicationLegalese:
                            'Your medical data is stored securely and privately.',
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppTheme.borderGray),
                  const ListTile(
                    leading: Icon(Icons.info_outline_rounded,
                        color: AppTheme.primaryBlue),
                    title: Text('App Version'),
                    subtitle: Text('1.0.0 (Build 101)'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.subtitleText,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
