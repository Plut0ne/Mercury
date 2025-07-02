import 'package:flutter/material.dart';
import 'package:mercury/View/CustomWidget/bottom_navigation_bar.dart';
import 'package:mercury/View/CustomWidget/theme_button.dart';
import 'package:mercury/View/CustomWidget/setting_body.dart';

class SettingsPage extends StatelessWidget
{
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: appBar(context),
      body: SettingsBody(),
      bottomNavigationBar: BottomNavScreen(currentIndex: 2),
    );
  }

  AppBar appBar(BuildContext context)
  {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: Text("Impostazioni"),
      centerTitle: true,
      elevation: 8.0,
      actions: [ThemeButton()],
    );
  }
}
