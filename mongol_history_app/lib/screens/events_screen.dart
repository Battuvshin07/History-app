import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    final events = await DatabaseHelper.instance.readAllEvents();
    setState(() {
      _events = events;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_note, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Үйл явдал олдсонгүй',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSampleData,
              icon: const Icon(Icons.add),
              label: const Text('Туршилтын өгөгдөл нэмэх'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          event.date,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadSampleData() async {
    final sampleEvents = [
      Event(
        title: 'Монголын эзэнт гүрэн байгуулагдсан',
        date: '1206',
        description:
            'Чингис хаан бүх Монголын аймгуудыг нэгтгэж, Монголын эзэнт гүрнийг байгуулав.',
      ),
      Event(
        title: 'Хорезмын аян дайн эхэлсэн',
        date: '1219-1221',
        description:
            'Монголын цэргүүд Хорезмын эзэнт гүрнийг довтолж, Төв Азийн бүс нутгийг эзлэв.',
      ),
      Event(
        title: 'Чингис хаан нас барсан',
        date: '1227',
        description: 'Их хаан Чингис Тангутын аян дайны үеэр нас барсан.',
      ),
    ];

    for (var event in sampleEvents) {
      await DatabaseHelper.instance.createEvent(event);
    }

    await _loadEvents();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Туршилтын өгөгдөл нэмэгдлээ')),
      );
    }
  }
}
