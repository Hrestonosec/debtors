import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;

  static Database? _database;

  LocalStorage._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'debt_manager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE debtors (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            debt REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions (
            id TEXT,
            date TEXT NOT NULL,
            amount REAL NOT NULL,
            FOREIGN KEY (id) REFERENCES debtors (id)
          )
        ''');
      },
    );
  }

  Future<void> insertDebtor(Map<String, dynamic> debtor) async {
    final db = await database;
    await db.insert('debtors', debtor);
  }

  Future<void> insertAndManageTransactions(
      Map<String, dynamic> transaction) async {
    final db = await database;

    // Додаємо нову транзакцію
    await db.insert(
      'transactions',
      transaction,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Видаляємо найстарішу транзакцію, якщо більше 10
    final oldestTransactions = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [transaction['id']],
      orderBy: 'date ASC',
    );

    if (oldestTransactions.length > 10) {
      final transactionToDelete = oldestTransactions.first;
      await db.delete(
        'transactions',
        where: 'id = ? AND date = ?',
        whereArgs: [transactionToDelete['id'], transactionToDelete['date']],
      );
    }
  }

  Future<void> updateDebt(String debtorId, double amount) async {
    final db = await database;

    // Оновлюємо загальний борг боржника
    await db.rawUpdate(
      'UPDATE debtors SET debt = debt + ? WHERE id = ?',
      [amount, debtorId],
    );
  }

  Future<void> deleteDebtor(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('transactions',
          where: 'id = ?', whereArgs: [id]); // Видаляємо транзакції
      await txn.delete('debtors',
          where: 'id = ?', whereArgs: [id]); // Видаляємо боржника
    });
  }

  Future<List<Map<String, dynamic>>> getDebtors() async {
    final db = await database;
    return await db.query(
      'debtors',
      orderBy: 'name COLLATE NOCASE ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getTransactions(String debtorId) async {
    final db = await database;
    return await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [debtorId],
      orderBy: 'date DESC',
    );
  }
}
