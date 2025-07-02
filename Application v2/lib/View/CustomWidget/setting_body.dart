import 'package:flutter/material.dart';
import 'package:mercury/Controller/database_controller.dart';

class SettingsBody extends StatelessWidget
{
  const SettingsBody({super.key});

  void _showInfoDialog(BuildContext context)
  {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Informazioni"),
        content: const Text(
          "Mercury è una applicazione open source creata tramite l'utilizzo del framework Flutter.\n\nHa come scopo il tracciamento, la conservazione e l'analisi di dati relativi alla pressione sanguigna.\n\nTutti i dati vengono salvati in un database locale e non sono inviati a nessun server esterno.\n\nIl progetto e il relativo codice lo si può trovare alla seguente repository GitHub: https://github.com/Plut0ne/Mercury",
        ),
        actions:
        [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            child: const Text("Chiudi"),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context)
  {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sei sicuro?"),
        content: const Text("Questa azione cancellerà tutti i dati salvati."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: ()
            {
              Navigator.pop(context);
              deleteAllData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Dati cancellati con successo!"),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            child: const Text("Sì"),
          ),
        ],
      ),
    );
  }

  void _exportCSV()
  {
    final dbHelper = exportAndShareCSV();
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSettingsRow(
          icon: Icons.info_outline,
          label: "Info",
          onTap: () => _showInfoDialog(context),
        ),
        _buildSettingsRow(
          icon: Icons.refresh,
          label: "Resetta i dati",
          onTap: () => _showResetDialog(context),
        ),
        _buildSettingsRow(
          icon: Icons.file_download,
          label: "Esporta in CSV",
          onTap: _exportCSV,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Versione 2.0.0",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
