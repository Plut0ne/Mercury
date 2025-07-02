import 'package:mercury/Model/misurazione.dart';
import 'package:mercury/Model/database.dart';

final database = DatabaseHelper();

List<String> getRow(Misurazione misurazione)
{
  Map<String, dynamic> dati = misurazione.getData();

  int id = dati["id"];
  double floatTime = dati["float_time"];
  int massima = dati["massima"];
  int minima = dati["minima"];
  int pulsazioni = dati["pulsazioni"];
  int pastiglia = dati["pastiglia"];

  String id_ = id.toString();
  String timestamp = getDateLabel(floatTime);
  String massima_ = massima.toString();
  String minima_ = minima.toString();
  String pulsazioni_ = pulsazioni.toString();
  String pastiglia_ = "";
  if(pastiglia == 0)
  {
    pastiglia_ = "NO";
  }
  else
  {
    pastiglia_ = "SI";
  }

  return [timestamp, massima_, minima_, pulsazioni_, pastiglia_, id_];
}

Future<List<List<String>>> getTableData() async
{
  final List<Misurazione> dati = await database.getAll();

  List<List<String>> tableData = [];
  for(Misurazione misurazione in dati)
  {
    tableData.add(getRow(misurazione));
  }

  return tableData;
}
