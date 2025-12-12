import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/data_service.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MSIDCApp());
}

class MSIDCApp extends StatelessWidget {
  const MSIDCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataService(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}
