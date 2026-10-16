import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class DriveSetupScreen extends StatefulWidget {
  const DriveSetupScreen({super.key});

  @override
  State<DriveSetupScreen> createState() => _DriveSetupScreenState();
}

class _DriveSetupScreenState extends State<DriveSetupScreen> {
  bool _isConnecting = false;

  void _handleConnectDrive() async {
    setState(() {
      _isConnecting = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      final appState = AppStateProvider.of(context);
      appState.setDriveConnected(true);
      setState(() {
        _isConnecting = false;
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final user = appState.userProfile;
    final bool isConnected = user.isDriveConnected;

    final initials = user.name.isNotEmpty
        ? user.name.split(' ').map((e) => e[0]).take(2).join()
        : 'MJ';

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const SizedBox(height: 32),

              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_to_drive_rounded,
                    size: 48,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Connect Your Google Drive',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Keep a secure backup of your medical records in your personal Google Drive.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.subtitleText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.primaryLight,
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    color: AppTheme.subtitleText,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(height: 1, color: AppTheme.borderGray),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Drive Status:',
                            style: TextStyle(
                              color: AppTheme.subtitleText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isConnected
                                      ? Icons.check_circle_rounded
                                      : Icons.info_outline_rounded,
                                  size: 14,
                                  color: isConnected
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFE65100),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isConnected ? 'Connected' : 'Not Connected',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isConnected
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFE65100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (isConnected) ...[
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Last Sync:',
                              style: TextStyle(
                                color: AppTheme.subtitleText,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Just now',
                              style: TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Storage Used:',
                              style: TextStyle(
                                color: AppTheme.subtitleText,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '14.2 MB',
                              style: TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const Spacer(),

              if (!isConnected) ...[
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isConnecting ? null : _handleConnectDrive,
                    icon: _isConnecting
                        ? const SizedBox.shrink()
                        : const Icon(Icons.add_to_drive_rounded, size: 20),
                    label: _isConnecting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Connect Google Drive',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _navigateToDashboard,
                  child: const Text(
                    'Skip for Now',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.subtitleText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _navigateToDashboard,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: const Text(
                      'Continue to Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
