import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/user_model.dart';

class SQLiteHelper {
  static final SQLiteHelper _instance = SQLiteHelper._internal();
  factory SQLiteHelper() => _instance;
  SQLiteHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_users.db');
    return await openDatabase(
      path,
      version: 2, // نسخه رو 2 کردیم چون ستون جدید اضافه شده
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            resetToken TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // افزودن ستون resetToken بدون حذف داده‌های قبلی
          await db.execute('ALTER TABLE users ADD COLUMN resetToken TEXT');
        }
      },
    );
  }

  // ثبت نام کاربر
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // بررسی ایمیل و رمز عبور برای ورود
  Future<User?> getUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  // بررسی وجود ایمیل
  Future<bool> checkEmailExists(String email) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty;
  }

 
  // قابلیت فراموشی رمز عبور
 

  
  Future<int> setResetToken(String email, String token) async {
    final db = await database;
    return await db.update(
      'users',
      {'resetToken': token},
      where: 'email = ?',
      whereArgs: [email],
    );
  }


  Future<User?> getUserByResetToken(String token) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'resetToken = ?',
      whereArgs: [token],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }


  Future<int> resetPassword(String token, String newPassword) async {
    final db = await database;
    return await db.update(
      'users',
      {
        'password': newPassword,
        'resetToken': null, 
      },
      where: 'resetToken = ?',
      whereArgs: [token],
    );
  }
}
