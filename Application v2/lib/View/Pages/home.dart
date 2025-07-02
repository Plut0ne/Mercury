import 'package:flutter/material.dart';
import 'package:mercury/View/CustomWidget/custom_table.dart';
import 'package:provider/provider.dart';
import 'package:mercury/View/Theme/theme_provider.dart';
import 'package:mercury/View/CustomWidget/theme_button.dart';
import 'package:mercury/View/CustomWidget/add_measurement_button.dart';
import 'package:mercury/Controller/database_controller.dart';
import 'package:mercury/View/CustomWidget/refresh_button.dart';
import 'package:mercury/View/CustomWidget/bottom_navigation_bar.dart';
import 'package:mercury/Controller/database_controller.dart';

class HomePage extends StatelessWidget
{
  const HomePage({super.key});

  void _onPageLoad(BuildContext context)
  {
    refreshTable();
  }

  @override
  Widget build(BuildContext context)
  {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onPageLoad(context));

    return Scaffold(
      appBar: appBar(context),
      body: Align(alignment: Alignment.topCenter, child: CustomTable(key: tableKey,)),
      bottomNavigationBar: BottomNavScreen(currentIndex: 0,),
      floatingActionButton: AddMeasurementButton(),
    );
  }

  AppBar appBar(BuildContext context)
  {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: Text("Misurazioni"),
      centerTitle: true,
      elevation: 8.0,
      actions: [ThemeButton()],
      leading: RefreshButton(),
    );
  }

  BottomNavigationBar bottomNavigationBar(BuildContext context)
  {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      items: const
      [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Ricerca',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profilo',
        ),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
    );
  }
}
