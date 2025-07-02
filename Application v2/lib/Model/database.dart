import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mercury/Model/misurazione.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

class DatabaseHelper
{
  static Database? _database;

  // Funzione per ottenere il database tramite Singleton
  Future<Database> get database async
  {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'mercury.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return _database!;
  }

  // Funzione per creare la tabella
  Future<void> _onCreate(Database db, int version) async
  {
    await db.execute(
    '''
      CREATE TABLE misurazioni(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        float_time REAL,
        massima INTEGER,
        minima INTEGER,
        pulsazioni INTEGER,
        pastiglia INTEGER
      )
    ''');
  }

  // Funzione per inserire una misurazione
  Future<void> add(Misurazione misurazione) async
  {
    Map<String, dynamic> dati = misurazione.getData();
    double floatTime = dati["float_time"];
    int massima = dati["massima"];
    int minima = dati["minima"];
    int pulsazioni = dati["pulsazioni"];
    int pastiglia = dati["pastiglia"];

    final db = await database;
    await db.insert("misurazioni", {
      'float_time': floatTime,
      'massima': massima,
      'minima': minima,
      'pulsazioni': pulsazioni,
      'pastiglia': pastiglia,
    });
  }

  // Funzione per eliminare una misurazione dall'id
  Future<void> delete(int id) async
  {
    final db = await database;
    await db.delete("misurazioni", where: 'id = ?', whereArgs: [id]);
  }

  // Funzione per eliminare tutte le righe della tabella
  Future<void> clear() async
  {
    final db = await database;
    await db.delete("misurazioni");
  }

  // Funzione per leggere una misurazione dall'id
  Future<Misurazione?> getById(int id) async
  {
    final db = await database;

    List<Map<String, dynamic>> result = await db.query(
      "misurazioni",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if(result.isEmpty)
    {
      return null;
    }

    Map<String, dynamic> first = result.first;
    Misurazione finalResult = Misurazione(first["float_time"], first["massima"], first["minima"], first["pulsazioni"], first["pastiglia"]);
    finalResult.id = id;

    return finalResult;
  }

  // Funzione per leggere tutte le misurazioni
  Future<List<Misurazione>> getAll() async
  {
    final db = await database;

    List<Misurazione> final_result = [];

    List<Map<String, dynamic>> result = await db.query("misurazioni", orderBy: "float_time DESC");
    for(Map<String, dynamic> misurazione in result)
    {
      Misurazione mis = Misurazione(misurazione["float_time"], misurazione["massima"], misurazione["minima"], misurazione["pulsazioni"], misurazione["pastiglia"]);
      mis.id = misurazione["id"];
      final_result.add(mis);
    }

    return final_result;
  }

  // Funzione per aggiornare una misurazione dall'id
  Future<void> update(int id, Misurazione misurazione) async
  {
    Map<String, dynamic> dati = misurazione.getData();
    double floatTime = dati["float_time"];
    int massima = dati["massima"];
    int minima = dati["minima"];
    int pulsazioni = dati["pulsazioni"];
    int pastiglia = dati["pastiglia"];

    final db = await database;
    await db.update(
      "misurazioni",
      {
        "float_time": floatTime,
        "massima": massima,
        "minima": minima,
        "pulsazioni": pulsazioni,
        "pastiglia": pastiglia
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

extension CsvExport on DatabaseHelper
{
  Future<void> exportAndShareCSV() async
  {
    final List<Misurazione> data = await getAll();

    List<List<dynamic>> csvData =
    [
      ["float_time", "massima", "minima", "pulsazioni", "pastiglia"],
      ...data.map((mis) =>
      [
        mis.floatTime,
        mis.massima,
        mis.minima,
        mis.pulsazioni,
        mis.pastiglia
      ])
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/misurazioni.csv";

    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: "Condividi misurazioni.csv");
  }
}
