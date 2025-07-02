import 'package:flutter/material.dart';
import 'package:mercury/Controller/database_controller.dart';
import 'package:mercury/Controller/table_data.dart';
import 'package:mercury/View/CustomWidget/custom_table_cell.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mercury/View/Pages/edit_measure.dart';
import 'package:mercury/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTable extends StatefulWidget
{
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => CustomTableState();
}

class CustomTableState extends State<CustomTable>
{

  List<List<String>>? tableData;
  final double cellHeight = 45;

  final ScrollController _horizontalScrollController = ScrollController();

  Future<void> refreshTable() async
  {
    final updatedData = await getTableData();
    setState(()
    {
      tableData = updatedData;
    });
  }

  Future<void> init() async
  {
    tableData = await getTableData();
  }

  @override
  void initState()
  {
    super.initState();
    _horizontalScrollController.addListener(_scrollListener);
    init();
  }

  @override
  void dispose()
  {
    _horizontalScrollController.removeListener(_scrollListener);
    _horizontalScrollController.dispose();
    super.dispose();
  }

  bool _canSlideRow = true;

  void _scrollListener()
  {
    if (_horizontalScrollController.position.pixels > 0)
    {
      if(_canSlideRow)
      {
        setState(()
        {
          _canSlideRow = false;
        });
      }
    }
    else
    {
      if(!_canSlideRow)
      {
        setState(()
        {
          _canSlideRow = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    Color evenRowColor = Colors.white;
    Color oddRowColor = Colors.grey.shade300;

    if(isDark)
    {
      evenRowColor = Colors.grey.shade800;
      oddRowColor = Colors.grey.shade900;
    }

    if(tableData == null)
    {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      controller: _horizontalScrollController,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children:
        [
          Row(
            children:
            [
              CustomTableCell("Data e ora", width: 195, alignment: Alignment.center, height: cellHeight, isHeader: true),
              CustomTableCell("Massima", width: 100, alignment: Alignment.center, height: cellHeight, isHeader: true),
              CustomTableCell("Minima", width: 90, alignment: Alignment.center, height: cellHeight, isHeader: true),
              CustomTableCell("Pulsazioni", width: 110, alignment: Alignment.center, height: cellHeight, isHeader: true),
              CustomTableCell("Pastiglia", width: 110, alignment: Alignment.center, height: cellHeight, isHeader: true),
              CustomTableCell("ID", width: 0, alignment: Alignment.center, height: cellHeight, isHeader: true)
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...tableData!.asMap().entries.map((entry)
                  {
                    int rowIndex = entry.key;
                    List<String> row = entry.value;

                    Color rowColor = rowIndex % 2 == 0 ? evenRowColor : oddRowColor;

                    final String uniqueKey = "row_$rowIndex";

                    return Slidable(
                      key: Key(uniqueKey),
                      enabled: _canSlideRow,
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.25,
                        children:
                        [
                          SlidableAction(
                            onPressed: (context)
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditMeasure(row.toList())));
                            },
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            //label: 'Modifica',
                          ),
                          SlidableAction(
                            onPressed: (context)
                            {
                              deleteData(int.parse(row.toList()[5]));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Misurazione eliminata con successo!'),
                                ),
                              );
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            //label: 'Elimina',
                          )
                        ]
                      ),

                      child: Container(
                        color: rowColor,
                        child: Row(
                          children:
                          [
                            CustomTableCell(row[0], width: 195, alignment: Alignment.center, height: cellHeight, backgroundColor: rowColor,), // Data e ora
                            CustomTableCell(row[1], width: 100, alignment: Alignment.center, height: cellHeight, backgroundColor: rowColor,), // Massima
                            CustomTableCell(row[2], width: 90, alignment: Alignment.center, height: cellHeight, backgroundColor: rowColor,), // Minima
                            CustomTableCell(row[3], width: 110, alignment: Alignment.center, height: cellHeight, backgroundColor: rowColor,), // Pulsazioni
                            CustomTableCell(row[4], width: 110, alignment: Alignment.center, height: cellHeight, backgroundColor: rowColor,), // Pastiglia
                            CustomTableCell(row[5], width: 0, alignment: Alignment.center, height: cellHeight, backgroundColor: rowColor,), // ID
                          ],
                        )
                      )
                    );
                  }),
                ]
              )
            )
          )
        ]
      )
    );
  }
}
