import 'package:intl/intl.dart';

DateTime timeStartingPoint = DateTime(1900, 1, 1);

double getCurrentFloatTime()
{
  DateTime now = DateTime.now();
  Duration diff = now.difference(timeStartingPoint);
  double floatTime = diff.inMinutes / 1440;
  floatTime = double.parse(floatTime.toStringAsFixed(5));

  return floatTime;
}

double getFloatTime(int year, int month, int day, int hour, int minute)
{
  DateTime date = DateTime(year, month, day, hour, minute);
  Duration diff = date.difference(timeStartingPoint);
  double floatTime = diff.inMinutes / 1440;
  floatTime = double.parse(floatTime.toStringAsFixed(5));

  return floatTime;
}

String getDateLabel(double floatTime)
{
  int fullDays = floatTime.floor();
  double fractionalDays = floatTime - fullDays;

  int totalMinutes = (fractionalDays * 24 * 60).round();
  DateTime date = timeStartingPoint.add(Duration(days: fullDays, minutes: totalMinutes));

  String dateLabel = DateFormat('dd/MM/yyyy - HH:mm').format(date);
  return dateLabel;
}

List<int> parseDateTime(String dateTimeString)
{
  try
  {
    final dateTime = DateFormat('dd/MM/yyyy - HH:mm').parseStrict(dateTimeString);
    return [dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute];
  }
  catch (e)
  {
    throw FormatException('Formato data non valido. Usa "dd/MM/yyyy - HH:mm"');
  }
}

DateTime parseDateTimeToDateTime(String dateTimeString)
{
  final format = DateFormat('dd/MM/yyyy - HH:mm');
  return format.parse(dateTimeString);
}

class Misurazione
{
  int id = -1;
  double floatTime;
  int massima;
  int minima;
  int pulsazioni;
  int pastiglia;

  Misurazione(this.floatTime, this.massima, this.minima, this.pulsazioni, this.pastiglia)
    : assert(massima >= 0, "La pressione massima non può essere negativa."),
      assert(minima >= 0, "La pressione minima non può essere negativa."),
      assert(pulsazioni >= 0, "Le pulsazioni non possono essere negative."),
      assert(pastiglia == 0 || pastiglia == 1, "Il valore <pastiglia> deve essere 0 o 1.");

  Map<String, dynamic> getData()
  {
    Map<String, dynamic> data = {"id": id, "float_time": floatTime, "massima": massima, "minima": minima, "pulsazioni": pulsazioni, "pastiglia": pastiglia};
    return data;
  }

  void setData(double newFloatTime, int newMassima, int newMinima, int newPulsazioni, int newPastiglia)
  {
    floatTime = newFloatTime;
    massima = newMassima;
    minima = newMinima;
    pulsazioni = newPulsazioni;
    pastiglia = newPastiglia;
  }

  void printData()
  {
    print("Id: $id");
    print("Data e ora: ${getDateLabel(floatTime)}");
    print("Massima: $massima");
    print("Minima: $minima");
    print("Pulsazioni: $pulsazioni");
    print("Pastiglia: $pastiglia");
  }
}
