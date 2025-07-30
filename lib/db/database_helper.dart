import 'package:sqflite/sqflite.dart';
import '../models/receta.dart';
import 'dart:async';
import 'package:path/path.dart' show join;


// Base de datos helper
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recetas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recetas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        ingredientes TEXT NOT NULL,
        instrucciones TEXT NOT NULL,
        categoria TEXT NOT NULL,
        tiempoPreparacion INTEGER NOT NULL,
        dificultad TEXT NOT NULL,
        imagen TEXT NOT NULL,
        esFavorita INTEGER NOT NULL DEFAULT 0,
        likes INTEGER NOT NULL DEFAULT 0,
        fechaCreacion INTEGER NOT NULL
      )
    ''');

    // Insertar datos de ejemplo
    await _insertarDatosEjemplo(db);
  }

  Future<void> _insertarDatosEjemplo(Database db) async {
    List<Receta> recetasEjemplo = [
      Receta(
        nombre: 'Pasta Carbonara',
        descripcion: 'Deliciosa pasta italiana con huevo, queso y panceta',
        ingredientes: '400g pasta, 200g panceta, 4 huevos, 100g queso parmesano, pimienta negra, sal',
        instrucciones: '1. Hervir la pasta\n2. Freír la panceta\n3. Batir huevos con queso\n4. Mezclar todo fuera del fuego',
        categoria: 'Pasta',
        tiempoPreparacion: 25,
        dificultad: 'Medio',
        imagen: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=500',
        likes: 15,
      ),
      Receta(
        nombre: 'Tacos al Pastor',
        descripcion: 'Auténticos tacos mexicanos con carne marinada',
        ingredientes: '1kg cerdo, achiote, piña, cebolla, cilantro, tortillas, salsa verde',
        instrucciones: '1. Marinar la carne\n2. Asar en trompo\n3. Cortar finamente\n4. Servir en tortillas calientes',
        categoria: 'Mexicana',
        tiempoPreparacion: 45,
        dificultad: 'Difícil',
        imagen: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500',
        likes: 22,
      ),
      Receta(
        nombre: 'Ensalada César',
        descripcion: 'Fresca ensalada con aderezo cremoso y crutones',
        ingredientes: 'Lechuga romana, pollo a la plancha, queso parmesano, crutones, aderezo césar',
        instrucciones: '1. Lavar y cortar lechuga\n2. Preparar pollo a la plancha\n3. Hacer crutones\n4. Mezclar con aderezo',
        categoria: 'Ensaladas',
        tiempoPreparacion: 20,
        dificultad: 'Fácil',
        imagen: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500',
        likes: 8,
      ),
      Receta(
        nombre: 'Sushi Rolls',
        descripcion: 'Deliciosos rollos de sushi caseros',
        ingredientes: 'Arroz para sushi, nori, salmón, pepino, palta, wasabi, jengibre',
        instrucciones: '1. Preparar arroz de sushi\n2. Extender nori\n3. Agregar relleno\n4. Enrollar y cortar',
        categoria: 'Japonesa',
        tiempoPreparacion: 40,
        dificultad: 'Difícil',
        imagen: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=500',
        likes: 31,
      ),
      Receta(
        nombre: 'Pizza Margherita',
        descripcion: 'Clásica pizza italiana con albahaca fresca',
        ingredientes: 'Masa de pizza, salsa de tomate, mozzarella, albahaca fresca, aceite de oliva',
        instrucciones: '1. Extender la masa\n2. Aplicar salsa\n3. Agregar queso\n4. Hornear 12 minutos\n5. Decorar con albahaca',
        categoria: 'Italiana',
        tiempoPreparacion: 30,
        dificultad: 'Medio',
        imagen: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
        likes: 18,
      ),
    ];

    for (Receta receta in recetasEjemplo) {
      await db.insert('recetas', receta.toMap());
    }
  }

  Future<int> insertarReceta(Receta receta) async {
    final db = await database;
    return await db.insert('recetas', receta.toMap());
  }

  Future<List<Receta>> obtenerRecetas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recetas');
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<List<Receta>> obtenerRecetasPorCategoria(String categoria) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recetas',
      where: 'categoria = ?',
      whereArgs: [categoria],
    );
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<List<Receta>> obtenerFavoritas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recetas',
      where: 'esFavorita = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<List<Receta>> buscarRecetas(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recetas',
      where: 'nombre LIKE ? OR ingredientes LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<int> actualizarReceta(Receta receta) async {
    final db = await database;
    return await db.update(
      'recetas',
      receta.toMap(),
      where: 'id = ?',
      whereArgs: [receta.id],
    );
  }

  Future<int> eliminarReceta(int id) async {
    final db = await database;
    return await db.delete(
      'recetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}