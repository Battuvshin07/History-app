import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/person.dart';
import 'person_detail_screen.dart';

class PersonsScreen extends StatefulWidget {
  const PersonsScreen({super.key});

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  List<Person> _persons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersons();
  }

  Future<void> _loadPersons() async {
    setState(() => _isLoading = true);
    final persons = await DatabaseHelper.instance.readAllPersons();
    setState(() {
      _persons = persons;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_persons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Түүхэн хүмүүс олдсонгүй',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Өгөгдлийн сангаа шинэчилнэ үү',
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
      onRefresh: _loadPersons,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _persons.length,
        itemBuilder: (context, index) {
          final person = _persons[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  person.name.isNotEmpty ? person.name[0] : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                person.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${person.birthDate ?? '?'} - ${person.deathDate ?? '?'}',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetailScreen(person: person),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadSampleData() async {
    // Туршилтын өгөгдөл нэмэх
    final samplePersons = [
      Person(
        name: 'Чингис хаан',
        birthDate: '1162',
        deathDate: '1227',
        description:
            'Монголын эзэнт гүрнийг байгуулагч, дэлхийн түүхэнд хамгийн том газар нутгийг эзэмшсэн эзэнт гүрний байгуулагч.',
        imageUrl: null,
      ),
      Person(
        name: 'Өгөдэй хаан',
        birthDate: '1186',
        deathDate: '1241',
        description:
            'Чингис хааны гурав дахь хүү, Монголын эзэнт гүрний хоёр дахь хаан. Түүний үед эзэнт гүрэн цаашид өргөжин тэлэв.',
        imageUrl: null,
      ),
      Person(
        name: 'Хубилай хаан',
        birthDate: '1215',
        deathDate: '1294',
        description:
            'Юань улсын анхны хаан, Монголын эзэнт гүрний тав дахь хаан. Хятадыг бүрэн эзлэн авсан.',
        imageUrl: null,
      ),
    ];

    for (var person in samplePersons) {
      await DatabaseHelper.instance.createPerson(person);
    }

    await _loadPersons();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Туршилтын өгөгдөл нэмэгдлээ')),
      );
    }
  }
}
