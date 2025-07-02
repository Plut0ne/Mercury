import 'package:flutter/cupertino.dart';
import 'package:mercury/Model/database.dart';
import 'package:mercury/Model/misurazione.dart';
import 'package:mercury/View/CustomWidget/custom_table.dart';

DatabaseHelper database = DatabaseHelper();
final GlobalKey<CustomTableState> tableKey = GlobalKey<CustomTableState>();

void refreshTable()
{
  tableKey.currentState?.refreshTable();
}

Future<void> addData(Misurazione misurazione) async
{
  database.add(misurazione);
  refreshTable();
}

Future<void> deleteData(int id) async
{
  database.delete(id);
  refreshTable();
}

Future<void> updateData(int id, Misurazione misurazione) async
{
  database.update(id, misurazione);
  refreshTable();
}

Future<void> deleteAllData() async
{
  database.clear();
  refreshTable();
}

Future<void> exportAndShareCSV() async
{
  final file = await database.exportAndShareCSV();
}
