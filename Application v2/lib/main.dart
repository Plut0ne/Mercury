import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mercury/View/Theme/theme_provider.dart';
import 'package:mercury/View/Pages/home.dart';
import 'package:mercury/View/Theme/app_theme.dart';
import 'package:mercury/View/Pages/stats.dart';
import 'package:mercury/View/Pages/settings.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const Mercury(),
    )
  );
}

class Mercury extends StatelessWidget
{
  const Mercury({super.key});

  @override
  Widget build(BuildContext context)
  {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "Mercury",
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: '/',
      routes:
      {
        '/': (context) => HomePage(),
        '/stats': (context) => StatsPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
