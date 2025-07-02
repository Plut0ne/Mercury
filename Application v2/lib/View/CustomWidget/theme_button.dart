import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mercury/View/Theme/theme_provider.dart';

class ThemeButton extends StatefulWidget
{
  const ThemeButton({super.key});

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton>
{
  @override
  Widget build(BuildContext context)
  {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return IconButton(
      icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay),
      onPressed:()
      {
        themeProvider.toggleTheme();
      },
    );
  }
}
