import 'package:flutter/material.dart';
import 'package:mercury/Model/misurazione.dart';
import 'package:mercury/View/CustomWidget/form_new_measure.dart';

class EditMeasure extends StatelessWidget
{
  final List<String> row;

  const EditMeasure(this.row, {super.key});

  @override
  Widget build(BuildContext context)
  {
    List<int> data = parseDateTime(row[0]);
    double floatTime = getFloatTime(data[0], data[1], data[2], data[3], data[4]);

    int pastiglia = 0;
    if(row[4] == "SI")
    {
      pastiglia = 1;
    }

    Misurazione misurazione_da_editare = Misurazione(
      floatTime,
      int.parse(row[1]),
      int.parse(row[2]),
      int.parse(row[3]),
      pastiglia,
    );
    misurazione_da_editare.id = int.parse(row[5]);

    return Scaffold(
      appBar: appBar(context),
      body: MeasurementFormBody.edit(misurazione_da_editare),
    );
  }

  AppBar appBar(BuildContext context)
  {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: Text("Modifica Misurazione"),
      centerTitle: true,
      elevation: 8.0,
    );
  }
}
