import 'package:flutter/material.dart';
import 'data/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyMedicalHistoryApp());
}

class MyMedicalHistoryApp extends StatefulWidget {
  const MyMedicalHistoryApp({super.key});

  @override
  State<MyMedicalHistoryApp> createState() => _MyMedicalHistoryAppState();
}

class _MyMedicalHistoryAppState extends State<MyMedicalHistoryApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      appState: _appState,
      child: MaterialApp(
        title: 'My Medical History',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
