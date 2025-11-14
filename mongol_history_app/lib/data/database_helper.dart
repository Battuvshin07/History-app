import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/person.dart';
import '../models/event.dart';
import '../models/map_data.dart';
import '../models/quiz.dart';
import '../models/media.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mongol_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER';

    // Persons хүснэгт
    await db.execute('''
      CREATE TABLE persons (
        person_id $idType,
        name $textType,
        birth_date $textTypeNullable,
        death_date $textTypeNullable,
        description $textType,
        image_url $textTypeNullable
      )
    ''');

    // Events хүснэгт
    await db.execute('''
      CREATE TABLE events (
        event_id $idType,
        title $textType,
        date $textType,
        description $textType,
        person_id $intType,
        FOREIGN KEY (person_id) REFERENCES persons (person_id)
      )
    ''');

    // Maps хүснэгт
    await db.execute('''
      CREATE TABLE maps (
        map_id $idType,
        title $textType,
        coordinates $textType,
        event_id $intType,
        FOREIGN KEY (event_id) REFERENCES events (event_id)
      )
    ''');

    // Quizzes хүснэгт
    await db.execute('''
      CREATE TABLE quizzes (
        quiz_id $idType,
        question $textType,
        answers $textType,
        correct_answer $intType
      )
    ''');

    // Media хүснэгт
    await db.execute('''
      CREATE TABLE media (
        media_id $idType,
        type $textType,
        url $textType,
        related_id $intType
      )
    ''');

    // Индекс үүсгэх
    await db.execute('CREATE INDEX idx_person_id ON events(person_id)');
    await db.execute('CREATE INDEX idx_event_id ON maps(event_id)');
  }

  // ========== PERSON CRUD ==========
  Future<int> createPerson(Person person) async {
    final db = await instance.database;
    return await db.insert('persons', person.toMap());
  }

  Future<Person?> readPerson(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'persons',
      where: 'person_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Person.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Person>> readAllPersons() async {
    final db = await instance.database;
    final result = await db.query('persons');
    return result.map((json) => Person.fromMap(json)).toList();
  }

  Future<int> updatePerson(Person person) async {
    final db = await instance.database;
    return db.update(
      'persons',
      person.toMap(),
      where: 'person_id = ?',
      whereArgs: [person.personId],
    );
  }

  Future<int> deletePerson(int id) async {
    final db = await instance.database;
    return await db.delete(
      'persons',
      where: 'person_id = ?',
      whereArgs: [id],
    );
  }

  // ========== EVENT CRUD ==========
  Future<int> createEvent(Event event) async {
    final db = await instance.database;
    return await db.insert('events', event.toMap());
  }

  Future<Event?> readEvent(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'events',
      where: 'event_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;
    final result = await db.query('events', orderBy: 'date');
    return result.map((json) => Event.fromMap(json)).toList();
  }

  Future<int> updateEvent(Event event) async {
    final db = await instance.database;
    return db.update(
      'events',
      event.toMap(),
      where: 'event_id = ?',
      whereArgs: [event.eventId],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'events',
      where: 'event_id = ?',
      whereArgs: [id],
    );
  }

  // ========== MAP CRUD ==========
  Future<int> createMap(MapData mapData) async {
    final db = await instance.database;
    return await db.insert('maps', mapData.toMap());
  }

  Future<List<MapData>> readAllMaps() async {
    final db = await instance.database;
    final result = await db.query('maps');
    return result.map((json) => MapData.fromMap(json)).toList();
  }

  // ========== QUIZ CRUD ==========
  Future<int> createQuiz(Quiz quiz) async {
    final db = await instance.database;
    return await db.insert('quizzes', quiz.toMap());
  }

  Future<List<Quiz>> readAllQuizzes() async {
    final db = await instance.database;
    final result = await db.query('quizzes');
    return result.map((json) => Quiz.fromMap(json)).toList();
  }

  // ========== MEDIA CRUD ==========
  Future<int> createMedia(Media media) async {
    final db = await instance.database;
    return await db.insert('media', media.toMap());
  }

  Future<List<Media>> readAllMedia() async {
    final db = await instance.database;
    final result = await db.query('media');
    return result.map((json) => Media.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
