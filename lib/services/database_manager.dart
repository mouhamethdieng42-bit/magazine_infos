import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modele/redacteur.dart';

class DatabaseManager {
  // Instance unique (Singleton) pour éviter d'ouvrir plusieurs connexions à la fois
  static final DatabaseManager _instance = DatabaseManager._internal();
  static Database? _database;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  // Getter asynchrone pour récupérer l'instance de la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initialisationDB();
    return _database!;
  }

  // Initialisation et ouverture de la base de données
  Future<Database> _initialisationDB() async {
    // Récupère le chemin d'accès par défaut des bases de données sur l'appareil
    String cheminBase = await getDatabasesPath();
    String path = join(cheminBase, 'redacteurs.db');

    // Ouvre la base de données et crée la table lors du premier lancement
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE redacteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  // --- OPÉRATIONS CRUD ---

  // 1. Ajouter un rédacteur (CREATE)
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    // On utilise la méthode toMap() créée à l'étape précédente
    return await db.insert(
      'redacteurs',
      redacteur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Évite les conflits d'ID
    );
  }

  // 2. Récupérer tous les rédacteurs (READ)
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    // Récupère toutes les lignes de la table sous forme de List<Map>
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');

    // Convertit la List<Map> en List<Redacteur> grâce au constructeur fromMap
    return List.generate(maps.length, (i) {
      return Redacteur.fromMap(maps[i]);
    });
  }

  // 3. Modifier les informations d'un rédacteur (UPDATE)
  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // 4. Supprimer un rédacteur (DELETE)
  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return await db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}