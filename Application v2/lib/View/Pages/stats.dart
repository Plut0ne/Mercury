import 'package:flutter/material.dart';
import 'package:mercury/View/CustomWidget/bottom_navigation_bar.dart';
import 'package:mercury/View/CustomWidget/theme_button.dart';

class StatsPage extends StatelessWidget
{
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: appBar(context),
      body: Center(child: Text('La pagina statistiche non è ancora disponibile in questa versione.', textAlign: TextAlign.center, style: TextStyle(fontSize: 20))),
      bottomNavigationBar: BottomNavScreen(currentIndex: 1),
    );
  }

  AppBar appBar(BuildContext context)
  {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: Text("Statistiche"),
      centerTitle: true,
      elevation: 8.0,
      actions: [ThemeButton()],
    );
  }
}
