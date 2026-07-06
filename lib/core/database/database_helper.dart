import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ecomerceapp/core/constants/app_constants.dart';

/// Single shared sqflite database for the whole app.
///
/// Both the cart and orders datasources must use this instead of opening
/// their own separate Database instances — sqflite only runs [onCreate]
/// once per (file, version), so if two different classes each try to
/// open the same file independently, whichever one runs first "wins"
/// and the other's tables never get created.
class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);
    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${AppConstants.cartTable}(
            productId INTEGER PRIMARY KEY,
            productName TEXT,
            price REAL,
            productImage TEXT,
            quantity INTEGER,
            originalPrice REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${AppConstants.ordersTable}(
            order_id TEXT PRIMARY KEY,
            products TEXT,
            total_amount REAL,
            order_date TEXT,
            order_status TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Adds the "was" price so the cart can show a strike-through
          // price and a discount badge, matching the product listing.
          await db.execute(
            'ALTER TABLE ${AppConstants.cartTable} ADD COLUMN originalPrice REAL',
          );
        }
      },
    );
  }
}