
import 'package:flutter/material.dart';
import '../models/conversion_history.dart';
import '../services/history_service.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Konversi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Semua History'),
                  content: const Text('Anda yakin ingin menghapus semua history?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        _historyService.clearAllHistory();
                        Navigator.pop(context);
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ConversionHistory>>(
        stream: _historyService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final histories = snapshot.data!;

          if (histories.isEmpty) {
            return const Center(child: Text('Belum ada history konversi'));
          }

          return ListView.builder(
            itemCount: histories.length,
            itemBuilder: (context, index) {
              final history = histories[index];
              return Dismissible(
                key: Key(history.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _historyService.deleteHistory(history.id);
                },
                child: ListTile(
                  title: Text(
                    '${history.inputValue} ${history.fromUnit} = ${history.result} ${history.toUnit}',
                  ),
                  subtitle: Text(
                    '${history.type} • ${_formatDate(history.timestamp)}',
                  ),
                  leading: _getIconForType(history.type),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  Widget _getIconForType(String type) {
    IconData iconData;
    switch (type.toLowerCase()) {
      case 'temperature':
        iconData = Icons.thermostat;
        break;
      case 'time':
        iconData = Icons.access_time;
        break;
      case 'weight':
        iconData = Icons.scale;
        break;
      case 'volume':
        iconData = Icons.water_drop;
        break;
      default:
        iconData = Icons.change_circle;
    }
    return Icon(iconData);
  }
}