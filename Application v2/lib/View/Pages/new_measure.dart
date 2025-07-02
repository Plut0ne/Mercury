import 'package:flutter/material.dart';
import 'package:mercury/View/CustomWidget/form_new_measure.dart';

class NewMeasure extends StatelessWidget
{
  const NewMeasure({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: appBar(context),
      body: MeasurementFormBody(),
    );
  }

  AppBar appBar(BuildContext context)
  {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: Text("Aggiungi Misurazione"),
      centerTitle: true,
      elevation: 8.0,
    );
  }
}
