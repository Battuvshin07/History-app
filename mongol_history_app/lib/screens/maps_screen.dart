import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/map_data.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  List<MapData> _maps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaps();
  }

  Future<void> _loadMaps() async {
    setState(() => _isLoading = true);
    final maps = await DatabaseHelper.instance.readAllMaps();
    setState(() {
      _maps = maps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_maps.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Газрын зураг олдсонгүй',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Интерактив газрын зургийг удахгүй нэмнэ',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _maps.length,
      itemBuilder: (context, index) {
        final mapData = _maps[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: Text(
              mapData.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Координат: ${mapData.coordinates}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Дэлгэрэнгүй газрын зураг харуулах
              _showMapDetail(mapData);
            },
          ),
        );
      },
    );
  }

  void _showMapDetail(MapData mapData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(mapData.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Координат: ${mapData.coordinates}'),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 60, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Интерактив зураг',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Хаах'),
          ),
        ],
      ),
    );
  }
}
