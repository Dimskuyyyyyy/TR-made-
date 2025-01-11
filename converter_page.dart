import 'package:flutter/material.dart';
import '../services/history_service.dart';

enum ConverterType { temperature, time, weight, volume }

class ConverterPage extends StatefulWidget {
  final ConverterType type;

  const ConverterPage({super.key, required this.type});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = '';
  String _toUnit = '';
  String _result = '';
  final HistoryService _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    _initializeUnits();
    print("HistoryService initialized: $_historyService");
  }

  void _initializeUnits() {
    switch (widget.type) {
      case ConverterType.temperature:
        _fromUnit = 'Celsius';
        _toUnit = 'Fahrenheit';
        break;
      case ConverterType.time:
        _fromUnit = 'Jam';
        _toUnit = 'Menit';
        break;
      case ConverterType.weight:
        _fromUnit = 'Kilogram';
        _toUnit = 'Gram';
        break;
      case ConverterType.volume:
        _fromUnit = 'Liter';
        _toUnit = 'Mililiter';
        break;
    }
  }

  List<String> _getUnits() {
    switch (widget.type) {
      case ConverterType.temperature:
        return ['Celsius', 'Fahrenheit', 'Kelvin'];
      case ConverterType.time:
        return ['Jam', 'Menit', 'Detik'];
      case ConverterType.weight:
        return ['Kilogram', 'Gram', 'Miligram'];
      case ConverterType.volume:
        return ['Liter', 'Mililiter', 'Centiliter'];
    }
  }

  Future<void> _convert() async {
  if (_inputController.text.isEmpty) return;

  try {
    double input = double.parse(_inputController.text);
    double result = 0;

    switch (widget.type) {
      case ConverterType.temperature:
        result = _convertTemperature(input);
        break;
      case ConverterType.time:
        result = _convertTime(input);
        break;
      case ConverterType.weight:
        result = _convertWeight(input);
        break;
      case ConverterType.volume:
        result = _convertVolume(input);
        break;
    }

    print("Mencoba menambahkan riwayat..."); 
    
    await _historyService.addHistory(
      widget.type.toString().split('.').last,
      _fromUnit,
      _toUnit,
      input,
      result,
    );
    
    print("Riwayat berhasil ditambahkan");
    
    setState(() {
      _result = result.toStringAsFixed(2);
    });

  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Riwayat konversi berhasil disimpan')),
    );

  } catch (error) {
    print("Error dalam konversi atau penyimpanan: $error");
  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  }
}

  double _convertTemperature(double value) {
    if (_fromUnit == _toUnit) return value;

    if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
      return (value * 9 / 5) + 32;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
      return (value - 32) * 5 / 9;
    } else if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') {
      return value + 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') {
      return value - 273.15;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') {
      return (value - 32) * 5 / 9 + 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') {
      return (value - 273.15) * 9 / 5 + 32;
    }
    return value;
  }

  double _convertTime(double value) {
    if (_fromUnit == _toUnit) return value;

    if (_fromUnit == 'Jam' && _toUnit == 'Menit') {
      return value * 60;
    } else if (_fromUnit == 'Menit' && _toUnit == 'Jam') {
      return value / 60;
    } else if (_fromUnit == 'Menit' && _toUnit == 'Detik') {
      return value * 60;
    } else if (_fromUnit == 'Detik' && _toUnit == 'Menit') {
      return value / 60;
    } else if (_fromUnit == 'Jam' && _toUnit == 'Detik') {
      return value * 3600;
    } else if (_fromUnit == 'Detik' && _toUnit == 'Jam') {
      return value / 3600;
    }
    return value;
  }

  double _convertWeight(double value) {
    if (_fromUnit == _toUnit) return value;

    if (_fromUnit == 'Kilogram' && _toUnit == 'Gram') {
      return value * 1000;
    } else if (_fromUnit == 'Gram' && _toUnit == 'Kilogram') {
      return value / 1000;
    } else if (_fromUnit == 'Gram' && _toUnit == 'Miligram') {
      return value * 1000;
    } else if (_fromUnit == 'Miligram' && _toUnit == 'Gram') {
      return value / 1000;
    } else if (_fromUnit == 'Kilogram' && _toUnit == 'Miligram') {
      return value * 1000000;
    } else if (_fromUnit == 'Miligram' && _toUnit == 'Kilogram') {
      return value / 1000000;
    }
    return value;
  }

  double _convertVolume(double value) {
    if (_fromUnit == _toUnit) return value;

    if (_fromUnit == 'Liter' && _toUnit == 'Mililiter') {
      return value * 1000;
    } else if (_fromUnit == 'Mililiter' && _toUnit == 'Liter') {
      return value / 1000;
    } else if (_fromUnit == 'Liter' && _toUnit == 'Centiliter') {
      return value * 100;
    } else if (_fromUnit == 'Centiliter' && _toUnit == 'Liter') {
      return value / 100;
    } else if (_fromUnit == 'Mililiter' && _toUnit == 'Centiliter') {
      return value / 10;
    } else if (_fromUnit == 'Centiliter' && _toUnit == 'Mililiter') {
      return value * 10;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi ${widget.type.name}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Masukkan nilai',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromUnit,
                    isExpanded: true,
                    items: _getUnits()
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _fromUnit = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButton<String>(
                    value: _toUnit,
                    isExpanded: true,
                    items: _getUnits()
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _toUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Konversi'),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Text(
                'Hasil: $_result $_toUnit',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
