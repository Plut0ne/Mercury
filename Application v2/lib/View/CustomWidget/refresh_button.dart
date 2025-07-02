import 'package:flutter/material.dart';
import 'package:mercury/Controller/database_controller.dart';

class RefreshButton extends StatefulWidget
{
  const RefreshButton({super.key});

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton>
{
  @override
  Widget build(BuildContext context)
  {
    return IconButton(
      icon: Icon(Icons.update),
      onPressed:()
      {
        refreshTable();
      },
    );
  }
}
