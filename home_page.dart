
import 'package:convertly/auth.dart';
import 'package:flutter/material.dart';
import 'converter_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/history_page.dart';
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentuser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50), // membuat tombol lebih lebar dan tinggi
        ),
        onPressed: signOut,
        child: const Text('Sign Out'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertly'),
        centerTitle: true,
        actions: [
    IconButton(
      icon: const Icon(Icons.history),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryPage(),
          ),
        );
      },
    ),
  ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.0,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildConverterCard(
                    context,
                    'Suhu',
                    Icons.thermostat,
                    ConverterType.temperature,
                  ),
                  _buildConverterCard(
                    context,
                    'Waktu',
                    Icons.access_time,
                    ConverterType.time,
                  ),
                  _buildConverterCard(
                    context,
                    'Berat',
                    Icons.scale,
                    ConverterType.weight,
                  ),
                  _buildConverterCard(
                    context,
                    'Volume',
                    Icons.water_drop,
                    ConverterType.volume,
                  ),
                ],
              ),
            ),
          ),
          _signOutButton(), // Tombol sign out di bagian bawah
        ],
      ),
    );
  }

  Widget _buildConverterCard(
    BuildContext context,
    String title,
    IconData icon,
    ConverterType type,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConverterPage(type: type),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}