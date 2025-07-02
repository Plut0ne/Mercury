import 'package:flutter/material.dart';
import 'package:mercury/View/Pages/home.dart';
import 'package:mercury/View/Pages/stats.dart';
import 'package:mercury/View/Pages/settings.dart';
import 'package:mercury/Controller/database_controller.dart';


class BottomNavScreen extends StatefulWidget
{
  final int currentIndex;

  const BottomNavScreen({super.key, required this.currentIndex});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
{
  late int _selectedIndex;

  @override
  void initState()
  {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(BuildContext context, int index)
  {
    if(index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    switch(index)
    {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/stats');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: Theme.of(context).primaryColor,
      items: const <BottomNavigationBarItem>
      [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Impostazioni',
        ),
      ],
      //selectedItemColor: Theme.of(context).primaryColor,
    );
  }
}
