import 'package:flutter/material.dart';
import 'package:mercury/View/Pages/new_measure.dart';

class AddMeasurementButton extends StatefulWidget
{
  const AddMeasurementButton({super.key});

  @override
  State<AddMeasurementButton> createState() => _AddMeasurementButtonState();
}

class _AddMeasurementButtonState extends State<AddMeasurementButton>
{
  @override
  Widget build(BuildContext context)
  {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add, color: Colors.black, size:30),
      onPressed:()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewMeasure()));
      },
    );
  }
}
