import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:bmdxf/models/saved_image.dart';

abstract class ImageDatabaseService {
  Future<int> saveImage(SavedImage image);
  Future<List<SavedImage>> getAllImages();
  Future<SavedImage?> getImageById(int id);
  Future<void> deleteImage(int id);
  Future<void> clearAll();
}


class SqliteImageDatabaseService implements ImageDatabaseService {
  SqliteImageDatabaseService._();
  static final ImageDatabaseService instance = SqliteImageDatabaseService._();

  static const String _dbName = 'exif_reader.db';
  static const String _table = 'saved_images';
  static const int _dbVersion = 1;

  Database? _db;

  Future<Database> get _database async {
    final existing = _db;
    if (existing != null) return existing;
    final created = await _open();
    _db = created;
    return created;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            image_bytes   BLOB    NOT NULL,
            label         TEXT,
            saved_at      TEXT    NOT NULL,
            gps_lat       REAL,
            gps_lng       REAL,
            make          TEXT,
            model         TEXT,
            date_time     TEXT,
            width         TEXT,
            height        TEXT,
            orientation   TEXT,
            flash         TEXT,
            focal_length  TEXT,
            exposure_time TEXT,
            f_number      TEXT,
            iso           TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<int> saveImage(SavedImage image) async {
    final db = await _database;
    final map = image.toMap()..remove('id');
    return db.insert(_table, map);
  }

  @override
  Future<List<SavedImage>> getAllImages() async {
    final db = await _database;
    final rows = await db.query(_table, orderBy: 'saved_at DESC');
    return rows.map(SavedImage.fromMap).toList();
  }

  @override
  Future<SavedImage?> getImageById(int id) async {
    final db = await _database;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return SavedImage.fromMap(rows.first);
  }

  @override
  Future<void> deleteImage(int id) async {
    final db = await _database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> clearAll() async {
    final db = await _database;
    await db.delete(_table);
  }
}
