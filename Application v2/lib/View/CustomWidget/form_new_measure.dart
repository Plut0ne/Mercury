import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mercury/Model/misurazione.dart';
import 'package:mercury/Controller/database_controller.dart';
import 'package:mercury/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MeasurementFormBody extends StatefulWidget
{
  final bool inEditMod;
  Misurazione? misurazione_da_editare;

  MeasurementFormBody({super.key}) : inEditMod = false;
  MeasurementFormBody.edit(this.misurazione_da_editare, {super.key}) : inEditMod = true;

  @override
  State<MeasurementFormBody> createState() => _MeasurementFormBodyState();
}

class _MeasurementFormBodyState extends State<MeasurementFormBody>
{
  double floatTime = 0;
  int massima = 0;
  int minima = 0;
  int pulsazioni = 0;
  int pastiglia = 0;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _maxPressureController = TextEditingController();
  final TextEditingController _minPressureController = TextEditingController();
  final TextEditingController _pulseController = TextEditingController();

  bool _tookPill = false;

  DateTime? _selectedDateTime;

  String savedButtomText = "SALVA";

  @override
  void initState()
  {
    if (widget.inEditMod)
    {
      super.initState();
      _selectedDateTime = parseDateTimeToDateTime(getDateLabel(widget.misurazione_da_editare!.floatTime));
      _dateTimeController.text = getDateLabel(widget.misurazione_da_editare!.floatTime);
      _maxPressureController.text = widget.misurazione_da_editare!.massima.toString();
      _minPressureController.text = widget.misurazione_da_editare!.minima.toString();
      _pulseController.text = widget.misurazione_da_editare!.pulsazioni.toString();
      _tookPill = widget.misurazione_da_editare!.pastiglia == 1;

      savedButtomText = "MODIFICA";
    }
    else
    {
        super.initState();
        _selectedDateTime = DateTime.now();
        _dateTimeController.text = DateFormat('dd/MM/yyyy - HH:mm').format(_selectedDateTime!);
    }
  }

  Future<void> _selectDateTime(BuildContext context) async
  {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1942),
      lastDate: DateTime(2142),
      builder: (context, child)
      {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null)
    {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
        builder: (context, child)
        {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null)
      {
        setState(()
        {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateTimeController.text = DateFormat('dd/MM/yyyy - HH:mm').format(_selectedDateTime!);
        });
      }
    }
  }

  @override
  void dispose()
  {
    _dateTimeController.dispose();
    _maxPressureController.dispose();
    _minPressureController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _saveForm()
  {
    if (_formKey.currentState!.validate())
    {
      List<int> data = parseDateTime(_dateTimeController.text);
      floatTime = getFloatTime(data[0], data[1], data[2], data[3], data[4]);
      massima = int.parse(_maxPressureController.text);
      minima = int.parse(_minPressureController.text);
      pulsazioni = int.parse(_pulseController.text);
      pastiglia = _tookPill ? 1 : 0;

      String messaggioFinale;

      Misurazione misurazione = Misurazione(floatTime, massima, minima, pulsazioni, pastiglia);
      if(widget.inEditMod)
      {
        updateData(widget.misurazione_da_editare!.id, misurazione);
        messaggioFinale = "Misurazione modificata con successo!";
      }
      else
      {
        addData(misurazione);
        messaggioFinale = "Misurazione salvata con successo!";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messaggioFinale),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>
          [
            const SizedBox(height: 8),

            // --- CAMPO DATA E ORA ---
            TextFormField(
              controller: _dateTimeController,
              cursorColor: Theme.of(context).primaryColor,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Seleziona data e ora',
                prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  )
                ),
                filled: true,
                fillColor: Theme.of(context).drawerTheme.backgroundColor,
              ),

              onTap: () => _selectDateTime(context),
              validator: (value)
              {
                if (value == null || value.isEmpty)
                {
                  return 'Per favore, seleziona data e ora';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // --- CAMPO PRESSIONE MASSIMA ---
            _buildNumericTextField(
              controller: _maxPressureController,
              label: 'Pressione Massima (mmHg)',
              icon: Icons.trending_up,
            ),

            const SizedBox(height: 20),

            // --- CAMPO PRESSIONE MINIMA ---
            _buildNumericTextField(
              controller: _minPressureController,
              label: 'Pressione Minima (mmHg)',
              icon: Icons.trending_down,
            ),

            const SizedBox(height: 20),

            // --- CAMPO PULSAZIONI ---
            _buildNumericTextField(
              controller: _pulseController,
              label: 'Pulsazioni (bpm)',
              icon: Icons.favorite_border,
            ),

            const SizedBox(height: 24),

            // --- CHECKBOX PASTIGLIA ---
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>
                  [
                    Text(
                      'Pastiglia Assunta?',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: _tookPill,
                        onChanged: (bool? value)
                        {
                          setState(()
                          {
                            _tookPill = value ?? false;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- PULSANTE SALVA ---
            ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                savedButtomText,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericTextField(
  {
    required TextEditingController controller,
    required String label,
    required IconData icon,
  })
  {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          )
        ),
        filled: true,
        fillColor: Theme.of(context).drawerTheme.backgroundColor,
      ),
      validator: (value)
      {
        if (value == null || value.isEmpty)
        {
          return 'Per favore, inserisci $label';
        }
        final number = int.tryParse(value);
        if (number == null || number <= 0)
        {
          return 'Inserisci un valore numerico valido';
        }
        return null;
      },
    );
  }
}
