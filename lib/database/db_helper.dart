// db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../components/notification/spoilage_notifier.dart'; // Adjust the import path as necessary

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incremented version for migration
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // Handle upgrades
    );
  }

  // Create initial database tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE record (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        detectedClass TEXT,
        quality TEXT,
        freshnessRate REAL,
        weight REAL,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE collection (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        detectedClass TEXT,
        quality TEXT,
        freshnessRate REAL,
        weight REAL,
        imagePath TEXT,
        temperatureCondition TEXT,
        status TEXT DEFAULT 'Unspoiled'
      )
    ''');
  }

  // Handle database upgrade for adding new columns
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the new 'status' column if upgrading from version 1 to 2
      await db.execute('''
        ALTER TABLE collection ADD COLUMN status TEXT DEFAULT 'Unspoiled';
      ''');
    }
  }

  // Update the status of a collection item
  Future<void> updateStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'collection',
      {'status': status}, // Update the status column
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert result into the record table
  Future<void> insertResult({
    required String date,
    required String time,
    required String detectedClass,
    required String quality,
    required double freshnessRate,
    required double weight,
    required String imagePath,
  }) async {
    final db = await database;
    await db.insert(
      'record',
      {
        'date': date,
        'time': time,
        'detectedClass': detectedClass,
        'quality': quality,
        'freshnessRate': freshnessRate,
        'weight': weight,
        'imagePath': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert result into the collection table and schedule notifications
  Future<void> insertCollection({
    required String date,
    required String time,
    required String detectedClass,
    required String quality,
    required double freshnessRate,
    required double weight,
    required String imagePath,
    required String temperatureCondition,
    String status = 'Unspoiled', // Set default value for status
  }) async {
    final db = await database;

    // Insert the new collection item into the database
    int id = await db.insert(
      'collection',
      {
        'date': date,
        'time': time,
        'detectedClass': detectedClass,
        'quality': quality,
        'freshnessRate': freshnessRate,
        'weight': weight,
        'imagePath': imagePath,
        'temperatureCondition': temperatureCondition,
        'status': status, // Insert status
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Schedule notifications
    SpoilageNotifier spoilageNotifier = SpoilageNotifier();
    await spoilageNotifier.scheduleSpoilageNotifications(
      collectionId: id,
      date: date,
      time: time,
      detectedClass: detectedClass,
      quality: quality,
      storage: temperatureCondition,
    );
  }

  // Delete a collection item and cancel notifications
  Future<void> deleteCollectionItem(int id) async {
    final db = await database;
    await db.delete(
      'collection',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Cancel scheduled notifications
    SpoilageNotifier spoilageNotifier = SpoilageNotifier();
    await spoilageNotifier.cancelSpoilageNotifications(id);
  }

  // Delete a record from the record table
  Future<void> deleteRecord(int id) async {
    final db = await database;
    await db.delete(
      'record',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fetch all records for the history screen
  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final db = await database;
    return await db.query('record', orderBy: 'id DESC');
  }

  // Fetch all collection items
  Future<List<Map<String, dynamic>>> fetchCollection() async {
    final db = await database;
    return await db.query('collection', orderBy: 'id DESC');
  }

  // Fetch all records, ordered by the most recent date
  Future<List<Map<String, dynamic>>> fetchAllRecords() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM record
      ORDER BY date DESC
    ''');
  }

  // Fetch a single record by ID
  Future<Map<String, dynamic>?> fetchRecord(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'record',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first; // Return the first matching result
    } else {
      return null; // No record found
    }
  }

  // Fetch a single collection record by ID
  Future<Map<String, dynamic>?> fetchCollectionRecord(int collectionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'collection',
      where: 'id = ?',
      whereArgs: [collectionId],
    );

    if (maps.isNotEmpty) {
      return maps.first; // Return the first record found
    }

    return null; // Return null if no records found
  }
}
