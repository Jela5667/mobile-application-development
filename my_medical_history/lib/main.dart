import 'package:flutter/material.dart';
import 'data/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.initPersistence();
  runApp(MyMedicalHistoryApp(appState: appState));
}

class MyMedicalHistoryApp extends StatefulWidget {
  final AppState? appState;
  const MyMedicalHistoryApp({super.key, this.appState});

  @override
  State<MyMedicalHistoryApp> createState() => _MyMedicalHistoryAppState();
}

class _MyMedicalHistoryAppState extends State<MyMedicalHistoryApp> {
  late final AppState _appState = widget.appState ?? AppState();

  @override
  void dispose() {
    if (widget.appState == null) {
      _appState.dispose();
    }
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
